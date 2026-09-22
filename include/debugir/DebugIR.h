//===- debugir/DebugIR.h - Interface ---------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the interface of the debugir library.
//
//===----------------------------------------------------------------------===//

#ifndef DEBUG_IR_H
#define DEBUG_IR_H

#include "llvm/IR/Module.h"
#include <memory>
#include <string>

namespace debugir {

// Attaches debug info to M, assuming it is parsed from Directory/Filename.
// Returns a module for display in debugger devoid of any debug info.
std::unique_ptr<llvm::Module>
createDebugInfo(llvm::Module &M, std::string Directory, std::string Filename);

} // namespace debugir

#endif // DEBUG_IR_H
