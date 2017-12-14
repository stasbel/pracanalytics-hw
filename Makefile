# This Makefile provide some useful commands for developing and using this
# project. Remeber, this is just for the convinience, so dont rely on them
# too much. You can do all sort of things (including running and using code)
# all by yourself.
# Partially based on good style guide on creating Makefiles at
# `http://clarkgrubb.com/makefile-style-guide`, still not following it blindly.
# Author: Stanislav Belyaev stasbelyaev96@gmail.com

### PROLOGUE ###

# Basic prologue mashinery from the Makefile style guide
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
THIS_FILE := $(lastword $(MAKEFILE_LIST))
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

### BODY ###

## INTERNAL VARIABLES ##

# ANSI colors
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Functions for printing color text
define COLOR_ECHO
	@echo "${$2}$1${RESET}"
endef
SUCCESS := $(call COLOR_ECHO,Success!,GREEN)

## RULES AND TARGETS ##

all: help

# Miscellaneous

# Add the following `help` target to your Makefile and add help text after
# each target name starting with `##`. A category can be added with `@caregory`.
HELP_FUN := \
    %help; \
    while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if \
    /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]+\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }

help:	##@miscellaneous	Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

# Dev

pip_tool := pipenv
reqs_dev_file := requirements-dev.txt
reqs_file := requirements.txt
py_files := $(shell find . -name "*.py" | cut -c 3-)

reqs_dev :=

reqs:	##@dev	Install all project dependencies.
	@$(pip_tool) install --dev

check:	##@dev	Check project vulnerabilities and code style (pep + flake).
	@$(pip_tool) check
	@for file in $(py_files); do \
		echo "check" $$file ; \
		$(pip_tool) check --style $$file ; \
	done
	$(SUCCESS)

lock:	##@dev	Lock currect env into specific files.
	@echo 'Locking current enviroment using `$(pip_tool)`...'
	@$(pip_tool) lock
	@$(eval reqs_dev := $(shell $(pip_tool) lock -r -d))
ifneq ($(strip $(reqs_dev)),)
	@echo 'Saving devs requirements to `$(reqs_dev_file)`...'
	@echo '$(reqs_dev)' >$(reqs_dev_file)
endif
	@echo 'Saving requirements to `$(reqs_file)`...'
	@$(pip_tool) lock -r >$(reqs_file)
	$(SUCCESS)

# Basic

clean:	##@basic	Do the cleaning, removing unnecessary files.
	@echo 'Removing unnecessary files...'
	@rm -rf *~ \#*

## PHONY TARGETS ##

.PHONY: all help reqs check lock clean