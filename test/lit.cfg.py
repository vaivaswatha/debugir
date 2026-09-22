import os
import shutil
import subprocess
import sys
import tempfile

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


def writes_debug_records():
    """Tells how the LLVM in use writes the description of a value.

    Up to LLVM 18 a description is a call to llvm.dbg.value. After that it is a
    debug record. Run the tool to find out.
    """
    directory = tempfile.mkdtemp()
    try:
        source = os.path.join(directory, 'probe.ll')
        with open(source, 'w') as probe:
            probe.write('define i32 @f(i32 %a) {\n'
                        '  %r = add i32 %a, 1\n'
                        '  ret i32 %r\n'
                        '}\n')
        if subprocess.call([config.debugir_exe, source],
                           stdout=subprocess.DEVNULL,
                           stderr=subprocess.DEVNULL) != 0:
            return False
        with open(os.path.join(directory, 'probe.dbg.ll')) as result:
            return '#dbg_value' in result.read()
    except OSError:
        return False
    finally:
        shutil.rmtree(directory, ignore_errors=True)


if writes_debug_records():
    config.available_features.add('dbg-records')
