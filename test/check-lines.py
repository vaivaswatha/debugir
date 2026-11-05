#!/usr/bin/env python3
"""Checks the line numbers that debugir puts into the debug info.

Takes a rewritten display file and its .dbg.ll file.
Each DILocation must match the instruction line in the display file.
For an instruction on multiple lines, it uses the last line number.

Usage: check-lines.py <display.ll> <file.dbg.ll>
"""

import re
import sys


# Up to LLVM 18 a description is a call to an llvm.dbg.* intrinsic. After that
# it is a debug record. Either way it is not an instruction of the program, and
# the display file does not hold it.
DEBUG_CALL = re.compile(r'^(?:\w+ )*call void @llvm\.dbg\.')


def is_description(text):
    """Tells whether a line describes a value, rather than computing one."""
    return text.startswith('#dbg_') or DEBUG_CALL.match(text) is not None


def parse_instructions(path):
    """Returns {last line number: text of the instruction that ends there}.

    Instructions are indented by two spaces. A line indented deeper continues
    the instruction above it, unless it is a description.
    """
    instructions = {}
    start = None
    text = []
    for number, line in enumerate(open(path), start=1):
        line = line.rstrip('\n')
        stripped = line.strip()
        described = is_description(stripped)
        is_continuation = line.startswith('   ') and not described
        if is_continuation and start is not None:
            text.append(stripped)
            instructions.pop(number - 1, None)
            instructions[number] = ' '.join(text)
            continue
        if described or not line.startswith('  ') or not stripped:
            start = None
            text = []
            continue
        start = number
        text = [stripped]
        instructions[number] = stripped
    return instructions


def normalize(text):
    """Drops what debugir adds to an instruction, so the two files compare."""
    text = re.sub(r'(?:,\s*!\w[\w.]* !\d+)+\s*$', '', text)
    # Declaring the llvm.dbg.* intrinsics adds an attribute group, which moves
    # the number of each group after it.
    text = re.sub(r'\s+#\d+$', '', text)
    return re.sub(r'\s+', ' ', text).strip()


def main():
    display_path, debug_path = sys.argv[1], sys.argv[2]
    display = parse_instructions(display_path)
    debug = parse_instructions(debug_path)

    lines = {}
    for line in open(debug_path):
        match = re.match(r'^!(\d+) = !DILocation\(line: (\d+),', line)
        if match:
            lines[int(match.group(1))] = int(match.group(2))

    checked = 0
    failures = []
    for number, text in sorted(debug.items()):
        match = re.search(r'!dbg !(\d+)', text)
        if not match or int(match.group(1)) not in lines:
            continue
        checked += 1
        wanted = lines[int(match.group(1))]
        found = display.get(wanted)
        if found is None or normalize(found) != normalize(text):
            failures.append((number, wanted, normalize(text),
                             normalize(found) if found else None))

    for number, wanted, text, found in failures:
        print(f'{debug_path}:{number}: points at {display_path}:{wanted}')
        print(f'  instruction:    {text}')
        print(f'  line holds:     {found if found else "<no instruction ends here>"}')

    if not checked:
        print(f'error: no instruction in {debug_path} has a DILocation')
        return 1
    print(f'checked {checked} locations, {len(failures)} wrong')
    return 1 if failures else 0


if __name__ == '__main__':
    sys.exit(main())
