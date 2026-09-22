#!/usr/bin/env python3
"""Checks that the variables in a binary can all be read by a debugger.

Takes the JSON output of `llvm-dwarfdump --statistics`.
All DWARF variables must have locations, and at least one variable must exist.

Usage: check-coverage.py <statistics.json>
"""

import json
import sys


def main():
    stats = json.load(open(sys.argv[1]))
    variables = stats['#source variables']
    located = stats['#source variables with location']
    parameters = stats['#params']
    parameters_located = stats['#params with binary location']

    print(f'variables: {located} of {variables} have a location')
    print(f'parameters: {parameters_located} of {parameters} have a location')

    if not variables:
        print('error: no variable reached the debug info')
        return 1
    if located != variables:
        print(f'error: {variables - located} variables have no location')
        return 1
    if parameters_located != parameters:
        print(f'error: {parameters - parameters_located} parameters have no '
              'location')
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
