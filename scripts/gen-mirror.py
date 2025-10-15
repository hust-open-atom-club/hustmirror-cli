#!/usr/bin/env python3
import os
import re
import sys

file = sys.argv[1]
dirname = os.path.dirname(file)
mirrorname = os.path.splitext(os.path.basename(file))[0]
output = sys.stdout

def replace_function_name(str):
    exp = r'^(.+)\s*\(\)\s*\{\s*$'
    matches = re.match(exp, str)
    if matches:
        function_name = matches.group(1)
        if function_name in ['check', 'install', 'is_deployed', 'can_recover', 'uninstall']:
            return f'_{mirrorname.replace("-", "_").replace(".", "_")}_{function_name}() {{\n'
        else:
            return str
    return str

with open(file, 'r') as f:
    lines = f.readlines()
    for line in lines:
        line = replace_function_name(line)
        output.write(line)
