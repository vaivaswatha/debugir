; The debug info must survive code generation. A record that verifies as IR can
; still be dropped by the backend, so this goes all the way to DWARF and asks
; for the variables by name.

; REQUIRES: clang

; RUN: cp "%s" "%t.ll"
; RUN: %debugir "%t.ll"
; RUN: clang -c -O0 -Wno-override-module "%t.dbg.ll" -o "%t.o"
; RUN: llvm-dwarfdump --verify "%t.o" | FileCheck --check-prefix=VERIFY "%s"
; RUN: llvm-dwarfdump --name=inv "%t.o" | FileCheck --check-prefix=INV "%s"
; RUN: llvm-dwarfdump --name=sum "%t.o" | FileCheck --check-prefix=SUM "%s"

; VERIFY: No errors.

declare i32 @may_throw()
declare void @use(i32)
declare i32 @__gxx_personality_v0(...)

define i32 @f(i32 %x) personality ptr @__gxx_personality_v0 {
entry:
  %inv = invoke i32 @may_throw() to label %cont unwind label %lpad

cont:
  %sum = add i32 %inv, %x
  call void @use(i32 %sum)
  ret i32 %sum

lpad:
  %lp = landingpad { ptr, i32 } cleanup
  resume { ptr, i32 } %lp
}

; The result of an invoke reaches DWARF with somewhere to read it from.
; INV:      DW_TAG_variable
; INV-NEXT:   DW_AT_location
; INV:        DW_AT_name ("inv")
; INV:        DW_AT_type {{.*}}"i32"

; SUM:      DW_TAG_variable
; SUM-NEXT:   DW_AT_location
; SUM:        DW_AT_name ("sum")
