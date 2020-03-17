setup:
	# Creates the virtual environment
	# run `source ~/.devops/bin/activate` to activate the environment
	python3 -m venv ~/.devops

install-dev:
	# This will install development dependecies
	source ~/.devops/bin/activate &&\
		pip install --upgrade pip &&\
		pip install -r requirements-dev.txt 

install:
	# This should be run from inside a virtualenv
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test-api:
	# Performs the API testing 
	python -m pytest -vv --cov=api api/*_test.py

lint:
	# This is linter for Dockerfiles
	hadolint Dockerfile frontend/Dockerfile
	# This is a linter for Python source code linter: https://www.pylint.org/
	pylint --disable=R,C,W1202 api/*.py frontend/*.py

all: install lint test
