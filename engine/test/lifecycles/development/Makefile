LIFECYCLE_DIR := $(shell realpath .)
include ../../../mk/lifecycle.mk

help:
	@echo
	@echo 'Orchestrations:                                                 '
	@echo '                                                                '
	@echo '    pipeline - run full development pipeline over selections    '
	@echo '                                                                '
	@echo 'Selections:                                                     '
	@echo '                                                                '
	@echo '    SELECT_STAGES   = list of stages to execute                 '
	@echo '    SELECT_SUBJECTS = list of subjects to include in each stage '
	@echo

pipeline:
	$(MAKE) setup test clean

setup test:
	$(MAKE) -C $@ stage

PASSTHROUGH_GOALS  := $(filter-out help pipeline setup test,$(MAKECMDGOALS))
PASSTHROUGH_STAGES := $(patsubst %,stage-%,$(SELECT_STAGES))
ifneq ($(PASSTHROUGH_GOALS),)
.PHONY: $(PASSTHROUGH_GOALS)
$(PASSTHROUGH_GOALS): $(PASSTHROUGH_STAGES)
stage-%:
	$(MAKE) -C '$*' $(PASSTHROUGH_GOALS)
endif

.PHONY: help
.PHONY: pipeline
.PHONY: setup
.PHONY: test
