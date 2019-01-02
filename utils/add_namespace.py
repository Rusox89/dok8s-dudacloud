#!/usr/bin/env python
import yaml
import re
import json
import sys
import getopt


def main(command_line_args):
    input_filename = ""
    output_filename = ""
    namespace = ""
    try:
        opts, args = getopt.getopt(command_line_args, "i:o:n:")
        if not opts:
            raise getopt.GetoptError("All are required")
    except getopt.GetoptError:
        print("add_namespace.py -i <file> -o <file> -n <namespace>")
        sys.exit(1)

    for opt, arg in opts:
        if opt == "-i":
            input_filename = arg
        elif opt == "-o":
            output_filename = arg
        elif opt == "-n":
            namespace = arg
    yaml_input_array = get_yaml_content_from_file(input_filename)
    yaml_def = []
    yaml_output_array = []
    for yaml_element in yaml_input_array:
        yaml_dict = yaml.load(yaml_element)
        if yaml_dict is not None:
            yaml_def.append(yaml_dict)
    for yaml_dict in yaml_def:
        yaml_dict['metadata']['namespace'] = namespace
        print(json.dumps(yaml_dict, indent=4))
        yaml_output_array.append(yaml.dump(yaml_dict))
    write_yaml_content_to_file(output_filename, yaml_output_array)


def get_yaml_content_from_file(filename):
    fd = open(filename)
    yaml_input = fd.read()
    fd.close()
    yaml_input_array = re.split("---", yaml_input)  # --- is sugar syntax
    return yaml_input_array


def write_yaml_content_to_file(filename, yaml_output_array):
    fd = open(filename, "w")
    fd.write("---\n".join(yaml_output_array))
    fd.close()


if __name__ == "__main__":
    main(sys.argv[1:])
