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

#include "llvm/Analysis/CGSCCPassManager.h"
#include "llvm/Analysis/LoopAnalysisManager.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/InstructionNamer.h"

#include <debugir/DebugIR.h>

using namespace llvm;

namespace {

// Command line arguments parsed using LLVM's command line parser.
cl::opt<std::string> InputFile(cl::Positional, cl::desc("<Input file>"),
                               cl::Required);
cl::opt<bool>
    RunInstNamer("instnamer",
                 cl::desc("Run instnamer on input, prior to processing it"));

void versionPrinter(llvm::raw_ostream &OS) { OS << "debugir: v0.1.0\n"; }

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

  if (RunInstNamer) {
    // Create the analysis managers.
    // These must be declared in this order so that they are destroyed in the
    // correct order due to inter-analysis-manager references.
    LoopAnalysisManager LAM;
    FunctionAnalysisManager FAM;
    CGSCCAnalysisManager CGAM;
    ModuleAnalysisManager MAM;

    // Create the new pass manager builder.
    // Take a look at the PassBuilder constructor parameters for more
    // customization, e.g. specifying a TargetMachine or various debugging
    // options.
    PassBuilder PB;

    // Register all the basic analyses with the managers.
    PB.registerModuleAnalyses(MAM);
    PB.registerCGSCCAnalyses(CGAM);
    PB.registerFunctionAnalyses(FAM);
    PB.registerLoopAnalyses(LAM);
    PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

    PB.registerPipelineStartEPCallback([&](ModulePassManager &MPM,
                                           OptimizationLevel Level) {
      MPM.addPass(createModuleToFunctionPassAdaptor(InstructionNamerPass()));
    });

    ModulePassManager MPM =
        PB.buildPerModuleDefaultPipeline(OptimizationLevel::O1);
    MPM.run(*M, MAM);
  }

  auto DisplayM = debugir::createDebugInfo(*M.get(), Directory.str(), Filename.str());
  std::error_code EC;

  // Update InputFile in-place so that line numbers match with DebugFile.
  raw_fd_ostream OS_disp(InputFile, EC, sys::fs::OF_Text);
  DisplayM->print(OS_disp, nullptr);

  // Output the display file
  raw_fd_ostream OS_dbg(DebugFile, EC, sys::fs::OF_Text);
  M->print(OS_dbg, nullptr);

  return EXIT_SUCCESS;
}
