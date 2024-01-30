#!/usr/bin/env python3
import sys, os, re, glob

output = sys.stdout;

def replace_include(str):
    exp = r'''@include\s+(.*)''';
    matches = re.match(exp, str)
    if matches:
        with open(dirname + '/' + matches.group(1), 'r') as f:
            return f.read()
    else:
        return str

def replace_var(str):
    exp = r'@var\s*\(\s*(.+)\s*\)'
    matches = re.finditer(exp, str)
    for match in matches:
        shell_code = match.group(1)
        output = os.popen(shell_code).read()
        if output.endswith('\n'):
            output = output[:-1]
        str = str.replace(match.group(0), output)
    return str

def replace_mirrors(str):
    if str.strip() == '@mirrors':
        files = glob.glob('output/mirrors/*')
        str = '# BEGIN MIRRORS\n'
        for file in files:
            with open(file, 'r') as f:
                str += f.read()
                str += '\n'
        str += '# END MIRRORS\n'
    return str

file = sys.argv[1]
dirname = os.path.dirname(file)

with open(file, 'r') as f:
    lines = f.readlines()
    for line in lines:
        line = replace_include(line)
        line = replace_var(line)
        line = replace_mirrors(line)
        output.write(line)
