# Makefile macros (or variables) are defined a little bit differently than traditional bash,
# keep in mind that in the Makefile there's top-level Makefile-only syntax, and everything else is bash script syntax.

############# Macros ########################
VENV_NAME = .venv
VENV_ACTIVATE= . ./$(VENV_NAME)/bin/activate
PIP_CMD ?= pip3
PYTHON ?= python3
############# Macros ########################
SHELL := bash
PYTHONVERSION = $(${SHELL} python -V |  grep ^Python | sed 's/^.* //g')

.DEFAULT_GOAL = help

help:
	@echo "---------------Help---------------"
	@echo "make [test-bdd | test-unit | test-all]"
	@echo "make run"
	@echo "make setup-venv - install the venv and the requirments"
	@echo "make docker-build"
	@echo "----------------------------------"


.SILENT:
.ONESHELL:
run-direct-puller:  # Setup virtualenv & install
	$(VENV_ACTIVATE) || (echo "No VENV" && exit 1)
	cd src
	${PYTHON} -m samples.direct.server-puller

.SILENT:
.ONESHELL:
send-direct-task:  # Setup virtualenv & install
	$(VENV_ACTIVATE) || (echo "No VENV" && exit 1)
	echo "** Send task to direct queue **"
	cd src
	${PYTHON} -m samples.direct.client-send-task

# Topic - event bus
.SILENT:
.ONESHELL:
run-topic-puller: 
	$(VENV_ACTIVATE) || (echo "No VENV" && exit 1)
	cd src
	${PYTHON} -m samples.topic.server-1-puller &
	${PYTHON} -m samples.topic.server-2-puller &

.SILENT:
.ONESHELL:
kill-topic-puller:
	ps | awk '/python3 -m samples.topic.server/ {print $2}' | uniq | xargs kill -9


.SILENT:
.ONESHELL:
send-topic-task:  # Setup virtualenv & install
	$(VENV_ACTIVATE) || (echo "No VENV" && exit 1)
	echo "** Send task to direct queue **"
	cd src
	${PYTHON} -m samples.topic.client-send-task





.ONESHELL:
install:
	$(VENV_ACTIVATE) || echo "No VENV"  && \
	pip3 install -r requirements.txt


# Run the service
run-puller:
	$(VENV_ACTIVATE) || echo "No VENV"  && \
	cd src && \
	${PYTHON} -m puller


# Docker build
docker-build:
	docker build -t boilerplate:latest .