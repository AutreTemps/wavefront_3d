import sys
import os.path
import re

name_to_module = {}
name_to_deps = {}

modules = list(set(sys.argv[1:]))
for module in modules:
    module_path = os.path.dirname(__file__) + '/modules/' + module + '.cmake'
    if not os.path.exists(module_path):
        print('Module', module, 'witn path', os.path.normpath(module_path), 'does not exist', file=sys.stderr)
        sys.exit(1)
    
    with open(os.path.normpath(module_path), 'r') as cmake_module:
        data = cmake_module.read()
        target_internals_list = re.findall(r'target_create\((.*?)\)', data, re.S)
        if len(target_internals_list) == 0:
            print('Requested module does not contain target_create()', file=sys.stderr)
            sys.exit(1)
        target_internals = target_internals_list[0]

        name = re.findall(r'NAME\s+?\b(.+?)\b', target_internals)[0]
        if name == name.upper():
            print('Full-upper module name', module, 'is not accepted', file=sys.stderr)
            sys.exit(1)
        name_to_module[name] = module

        deps_str = re.findall(r'LINK_TARGETS\s+?\b(.+?)(?:(?:\b[A-Z_\d]+\b)|\Z)', target_internals, re.S)
        name_to_deps[name] = deps_str[0].split() if len(deps_str) != 0 else []

sorted_names = []

while len(name_to_deps) > 0:
    leaves = [key for key in name_to_deps if len(name_to_deps[key]) == 0]
    if len(leaves) == 0:
        print('Found cycled dependencies', file=sys.stderr)
        sys.exit(1)
    sorted_names.extend(leaves)

    for key in name_to_deps:
        for leaf in leaves:
            if leaf in name_to_deps[key]:
                name_to_deps[key].remove(leaf)

    for leaf in leaves:
        del name_to_deps[leaf]

print(';'.join([name_to_module[name] for name in sorted_names]), end='')
