import sys
import os.path

for module in sys.argv[1:]:
    module_path = os.path.dirname(__file__) + '/modules/' + module + '.cmake'
    with open(os.path.normpath(module_path), 'r') as cmake_module:
        data = cmake_module.read()
        print(data)
