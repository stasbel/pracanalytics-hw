### INCLUDES ###
# ...

### PROLOGUE ###
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

# ANSI colors.
GREEN := $(shell tput -Txterm setaf 2)
WHITE := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET := $(shell tput -Txterm sgr0)

define color_echo
	@echo "${$2}$1${RESET}"
endef

# Add the following "help" target to your Makefile and add help text after
# each target name starting with "##".
# A category can be added with "@category".
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

# Consts.
PIP_TOOL := pipenv
REQUIREMENTS_FILE := requirements.txt

# Targets.
all: help

help:	##@miscellaneous	Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

lock:	##@dev	Lock currect env into specific files.
	${PIP_TOOL} lock
	${PIP_TOOL} lock -r >${REQUIREMENTS_FILE}
	$(call color_echo,Success,GREEN)

deps:	##@dev	Install necessary packages.
	pipenv install

check:	##@dev	Check project safety and code style.
	pipenv check
	pipenv check --style $(shell find . -name "*.py" | cut -c 3-)

clean:	##@basic	Do the cleaning, removing unnecessary files.
	rm -rf *~ \#*

.PHONY: all help lock deps clean