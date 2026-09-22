; Straight-line code: each named value is described immediately after the
; instruction that computes it, and each line number points back at the
; instruction in the display file.

; RUN: cp "%s" "%t.ll"
; RUN: %debugir "%t.ll"
; RUN: opt -passes=verify -disable-output "%t.dbg.ll"
; RUN: %check-lines "%t.ll" "%t.dbg.ll"
; RUN: FileCheck --input-file="%t.dbg.ll" "%s"

%struct.point = type { i32, float }

; The arguments are copied to allocas, which the display file does not have.
; CHECK:      define i32 @straight(i32 %a, ptr %p) !dbg ![[SP:[0-9]+]] {
; CHECK-NEXT: entry:
; CHECK-NEXT:   %a1 = alloca i32
; CHECK-NEXT:   store i32 %a, ptr %a1
; CHECK-NEXT:   %p2 = alloca ptr
; CHECK-NEXT:   store ptr %p, ptr %p2

define i32 @straight(i32 %a, ptr %p) {
entry:
; CHECK-NEXT:   %sum = add i32 %a, 1, !dbg
; CHECK-NEXT:   #dbg_value(i32 %sum, ![[SUM:[0-9]+]], !DIExpression(), !
  %sum = add i32 %a, 1

; CHECK-NEXT:   %conv = sitofp i32 %sum to float, !dbg
; CHECK-NEXT:   #dbg_value(float %conv, ![[CONV:[0-9]+]], !DIExpression(), !
  %conv = sitofp i32 %sum to float

; CHECK-NEXT:   %addr = getelementptr %struct.point, ptr %p, i32 0, i32 1, !dbg
; CHECK-NEXT:   #dbg_value(ptr %addr, ![[ADDR:[0-9]+]], !DIExpression(), !
  %addr = getelementptr %struct.point, ptr %p, i32 0, i32 1

; CHECK-NEXT:   %arr = alloca [4 x i32], align 4, !dbg
; CHECK-NEXT:   #dbg_value(ptr %arr, ![[ARR:[0-9]+]], !DIExpression(), !
  %arr = alloca [4 x i32]

; An unnamed result has no name to show, so it gets a location on its own.
; CHECK-NEXT:   store i32 %sum, ptr %arr, align 4, !dbg
  store i32 %sum, ptr %arr

; The arguments are described last, at the terminator.
; CHECK-NEXT:   #dbg_declare(ptr %a1, !{{[0-9]+}}, !DIExpression(), !
; CHECK-NEXT:   #dbg_declare(ptr %p2, !{{[0-9]+}}, !DIExpression(), !
; CHECK-NEXT:   ret i32 %sum, !dbg
  ret i32 %sum
}

; A value with no name has nothing to call the variable, so it is not described.
; CHECK:      define float @unnamed(i32 %a)
; CHECK:        %0 = sitofp i32 %a to float, !dbg
; CHECK-NOT:    #dbg_value
; CHECK:        ret float

define float @unnamed(i32 %a) {
entry:
  %0 = sitofp i32 %a to float
  ret float %0
}

; Each variable is named after the value and is typed after it too.
; CHECK-DAG: ![[SUM]] = !DILocalVariable(name: "sum", {{.*}}type: ![[I32:[0-9]+]])
; CHECK-DAG: ![[CONV]] = !DILocalVariable(name: "conv", {{.*}}type: ![[FLOAT:[0-9]+]])
; CHECK-DAG: ![[ADDR]] = !DILocalVariable(name: "addr", {{.*}}type: ![[PTR:[0-9]+]])
; CHECK-DAG: ![[ARR]] = !DILocalVariable(name: "arr", {{.*}}type: ![[PTR]])
; CHECK-DAG: ![[I32]] = !DIBasicType(name: "i32", size: 32, encoding: DW_ATE_unsigned)
; CHECK-DAG: ![[FLOAT]] = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
; CHECK-DAG: ![[PTR]] = !DIDerivedType(tag: DW_TAG_pointer_type, name: "ptr"
