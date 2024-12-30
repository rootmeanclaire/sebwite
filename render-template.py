#!/usr/bin/env python3
import __main__
from sys import argv, stderr
from jinja2 import Environment, FileSystemLoader

env = Environment(
	loader=FileSystemLoader("templates")
)

if len(argv) < 2:
	print("Not enough arguments", file=stderr)
	print(f"\t{argv[0]} <template file>", file=stderr)
	print(f"\t{argv[0]} <template file> <variable file>", file=stderr)
	exit(1)
elif len(argv) > 3:
	print("You gave some extra arguments, ignoring those", file=stderr)

template_fname = argv[1]
variable_fname =  argv[2] if len(argv) > 2 else None
variables = None

if variable_fname != None:
	if variable_fname[-4:] == ".yml" or variable_fname[-5:] == ".yaml":
		import yaml
		with open(variable_fname) as fin:
			variables = yaml.safe_load(fin)
	elif variable_fname[-5:] == ".json":
		import json
		with open(variable_fname) as fin:
			variables = json.load(fin)
	else:
		print(f"Unknown file format for variable file {variable_fname}", file=stderr)
		exit(1)

print(env.get_template(template_fname).render(variables if variables != None else {}))
