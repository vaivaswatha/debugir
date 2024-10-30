# DebugIR: Debugging LLVM-IR Files

This utility [revives](https://lists.llvm.org/pipermail/llvm-dev/2018-March/122013.html)
the debug-ir pass in LLVM, but as a standalone tool. I found the idea of
having a separate utility simpler after knowing that
[this earlier patch](https://reviews.llvm.org/D40778) to revive it as a
pass inside LLVM didn't go through.

## Instructions
Let us assume that the LLVM-IR to be debugged is named `hello.ll`.
Such a file can be dynamically generated, or using clang as

```sh
  clang -emit-llvm -o hello.ll -S hello.c
```

<details><summary>hello.c</summary>

```C
  #include <stdio.h>
  #include <string.h>

  int main(int argc, char *argv[])
  {
    if (!strcmp(argv[0], "hello")) {
      printf("Hello World\n");
    } else {
      printf("No hello\n");
    }
    return 0;
  } 
```
</details>

### Clone and build
This tool requires LLVM-18 to be installed.

```sh
  git clone https://github.com/vaivaswatha/debugir.git debugir
  cd debugir; mkdir build; cd build
  cmake -DCMAKE_BUILD_TYPE=Release ../
  cmake --build .
```

If you have LLVM installed in a non-standard path, you may provide the
additional `CMake` argument `-DLLVM_DIR=/path/to/llvm`.

If you would like to link debugir to the relevant static LLVM components, use
```
-DLINK_LLVM_SHARED=OFF
```
during the cmake command. 

### Run
You should now have an executable file `debugir` in the build directory.

```sh
  ./debugir hello.ll
```

This produces a file `hello.dbg.ll`. **NOTE** The utility also overwrites
the input LLVM-IR file (if you have comments in it, they will be lost).
The new file `hello.dbg.ll` is semantically the same as the input file,
but with debug information referring to the input file.

If you now debug `hello.dbg.ll` (instead of debugging `hello.ll`), the
debugger can pickup and display `hello.ll` as the execution proceeds.

Note: LLVM values that don't have an explicit name cannot have their
names (and hence values) seen in GDB. To workaround this, provide
explicit names yourself or run the instruction namer pass by providing
the `-instnamer` flag to `debugir`.

Following on the example [here](https://llvm.org/docs/DebuggingJITedCode.html)
let us try and debug `hello.dbg.ll`.

```sh
  gdb --args lli -jit-kind=mcjit hello.dbg.ll
  (gdb) break hello.ll:15 # set breakpoint at line 15 in hello.ll
  (gdb) run
```

```sh
  lldb lli -- -jit-kind=mcjit hello.dbg.ll
  (lldb) break set -y hello.ll:15 # set breakpoint at line 15 in hello.ll
  (lldb) run
```

You should now hit the program at line 15 in `hello.ll`, assuming that
line 15 is a valid line number in the LLVM source. Change this line number
to an appropriate value or to a function name. Note: Since `lli`, at the
time of invocation from gdb will not have, yet, loaded the object file for
`hello`, you will need to set `set breakpoint pending on` in `gdb`.
