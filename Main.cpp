/*
 * Copyright (C) 2020 Vaivaswatha N
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <cstdlib>
#include <iostream>

#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"

#include "DebugIR.h"

using namespace llvm;

namespace {

// Command line arguments parsed using LLVM's command line parser.
cl::opt<std::string> InputFile(cl::Positional, cl::desc("<Input file>"),
                               cl::Required);

void versionPrinter(llvm::raw_ostream &OS) { OS << "debugir: v0.1.0\n"; }

ExitOnError ExitOnErr;

} // end of anonymous namespace

int main(int argc, char *argv[]) {
  cl::SetVersionPrinter(versionPrinter);
  cl::ParseCommandLineOptions(argc, argv);

  SmallVector<char, 16> DBF(InputFile.begin(), InputFile.end());
  sys::path::replace_extension(DBF, ".dbg.ll");
  std::string DebugFile(DBF.begin(), DBF.end());

  // The directory/filename that debug info should refer to.
  auto Directory = sys::path::parent_path(InputFile);
  auto Filename = sys::path::filename(InputFile);

  auto Ctx = std::make_unique<LLVMContext>();
  SMDiagnostic Smd;
  auto M = parseIRFile(InputFile, Smd, *Ctx);
  if (!M) {
    std::string ErrMsg;
    raw_string_ostream OS(ErrMsg);
    Smd.print(argv[0], OS);
    std::cerr << OS.str();
    return EXIT_FAILURE;
  }

  auto DisplayM = createDebugInfo(*M.get(), Directory, Filename);
  std::error_code EC;

  // Update InputFile in-place so that line numbers match with DebugFile.
  raw_fd_ostream OS_disp(InputFile, EC, sys::fs::F_Text);
  DisplayM->print(OS_disp, nullptr);

  // Output the display file
  raw_fd_ostream OS_dbg(DebugFile, EC, sys::fs::F_Text);
  M->print(OS_dbg, nullptr);

  return EXIT_SUCCESS;
}
