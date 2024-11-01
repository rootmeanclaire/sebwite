#!/usr/bin/env python3
from sys import argv
from jinja2 import Environment, FileSystemLoader

env = Environment(
	loader=FileSystemLoader("templates")
)

if len(argv) < 2:
	print("Not enough arguments")
	print(f"./{__file__} <template file> <variable file>")
	exit(1)
elif len(argv) > 3:
	print("You gave some extra arguments, ignoring those")

template_fname = argv[1]
variable_fname = argv[2]
variables = None

if variable_fname[-4:] == ".yml" or variable_fname[-5:] == ".yaml":
	import yaml
	with open(variable_fname) as fin:
		variables = yaml.safe_load(fin)
elif variable_fname[-5:] == ".json":
	import json
	with open(variable_fname) as fin:
		variables = json.load(fin)
else:
	print(f"Unknown file format for variable file {variable_fname}")
	exit(1)

print(env.get_template(template_fname).render(variables if variables != None else {}))
