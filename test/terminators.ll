; Tests descriptions for unusual defining instructions.
; - PHI nodes must stay together.
; - An invoke defines its value in the normal destination.
; - A callbr defines its value in multiple successors.

; REQUIRES: dbg-records

; RUN: cp "%s" "%t.ll"
; RUN: %debugir "%t.ll"
; RUN: opt -passes=verify -disable-output "%t.dbg.ll"
; RUN: %check-lines "%t.ll" "%t.dbg.ll"
; RUN: FileCheck --input-file="%t.dbg.ll" "%s"

declare i32 @may_throw()
declare i32 @__gxx_personality_v0(...)

; CHECK: define i32 @invoke_and_phi(i1 %c) {{.*}} !dbg ![[SP:[0-9]+]] {

define i32 @invoke_and_phi(i1 %c) personality ptr @__gxx_personality_v0 {
entry:
; The invoke defines %inv on the edge to %cont. Its description goes at the
; start of %cont, not after the invoke.
; CHECK:      %inv = invoke i32 @may_throw()
; CHECK-NEXT:   to label %cont unwind label %lpad, !dbg
; CHECK:      cont:
; CHECK-NEXT:   #dbg_value(i32 %inv, ![[INV:[0-9]+]], !DIExpression(), ![[INVLOC:[0-9]+]])
  %inv = invoke i32 @may_throw() to label %cont unwind label %lpad

cont:
  br i1 %c, label %a, label %b

; A landing pad is not a terminator. Its description stays in its block and
; keeps the lexical block scope.
; CHECK:      %lp = landingpad { ptr, i32 }
; CHECK-NEXT:   cleanup, !dbg
; CHECK-NEXT:   #dbg_value({ ptr, i32 } %lp, ![[LP:[0-9]+]], !DIExpression(), !
lpad:
  %lp = landingpad { ptr, i32 } cleanup
  br label %b

a:
  %adda = add i32 %inv, 1
  br label %join

; Describe a PHI node after the last PHI node in its block.
; CHECK:      %ph = phi i32 [ 0, %lpad ], [ 2, %cont ], !dbg
; CHECK-NEXT:   #dbg_value(i32 %ph, !{{[0-9]+}}, !DIExpression(), !
b:
  %ph = phi i32 [ 0, %lpad ], [ 2, %cont ]
  br label %join

join:
  %res = phi i32 [ %adda, %a ], [ %ph, %b ]
  ret i32 %res
}

; A callbr defines its value in every destination. No single definition point
; dominates all uses, so the value has no description.
; CHECK:      define i32 @callbr_result()
; CHECK:        %cb = callbr i32 asm "", "=r,!i"()
; CHECK-NEXT:     to label %normal [label %other], !dbg
; CHECK-NOT:    #dbg_value(i32 %cb
; CHECK:      !{{[0-9]+}} = !DIBasicType

define i32 @callbr_result() {
entry:
  %cb = callbr i32 asm "", "=r,!i"() to label %normal [label %other]

normal:
  ret i32 %cb

other:
  ret i32 0
}

; The invoke result description is outside the invoke's lexical block. The
; variable and its location must use the function scope. A lexical block scope
; makes the debugger drop the variable.
; CHECK-DAG: ![[INV]] = !DILocalVariable(name: "inv", scope: ![[SP]],
; CHECK-DAG: ![[INVLOC]] = !DILocation({{.*}}scope: ![[SP]])

; The landing pad keeps its narrower scope.
; CHECK-DAG: ![[LP]] = !DILocalVariable(name: "lp", scope: ![[LB:[0-9]+]],
; CHECK-DAG: ![[LB]] = distinct !DILexicalBlock(scope: ![[SP]],
