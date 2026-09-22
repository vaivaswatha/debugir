import os
import sys

import lit.formats

config.name = 'debugir'
config.test_format = lit.formats.ShTest()
config.suffixes = ['.ll', '.test']
config.test_source_root = os.path.dirname(__file__)
config.test_exec_root = os.path.join(config.debugir_obj_root, 'test')

# Let the tests call the LLVM tools by their plain names.
config.environment['PATH'] = os.path.pathsep.join(
    [config.llvm_tools_dir, config.environment['PATH']])

# These already expand to quoted paths. Do not quote them again in a RUN line.
config.substitutions.append(('%debugir', '"%s"' % config.debugir_exe))
config.substitutions.append(
    ('%check-lines', '"%s" "%s"' % (sys.executable,
                                    os.path.join(config.test_source_root,
                                                 'check-lines.py'))))
config.substitutions.append(
    ('%check-coverage', '"%s" "%s"' % (sys.executable,
                                       os.path.join(config.test_source_root,
                                                    'check-coverage.py'))))
config.substitutions.append(
    ('%hello-c', '"%s"' % os.path.join(config.debugir_src_root, 'test-files',
                                       'hello.c')))

# Only the tests that go all the way to DWARF need a compiler.
if os.path.exists(os.path.join(config.llvm_tools_dir, 'clang')):
    config.available_features.add('clang')
