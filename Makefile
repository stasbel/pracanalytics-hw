# ANSI colors.
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

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
REQS_FILE := requirements.txt

# Targets.
all: help

help:	##@miscellaneous	Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

freeze:	##@basic	Place venv packages into reqs file.
	pip freeze >${REQS_FILE}

deps:	##@basic	Install necessary packages.
	pip install -r ${REQS_FILE}

clean:	##@basic	Do the cleaning, removing unnecessary files.
	rm -rf *~ \#*

.PHONY: all help freeze deps clean