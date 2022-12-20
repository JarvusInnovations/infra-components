PIPELINE_DIR   := $(shell realpath .)
ENGINE_HOME    := $(shell realpath ../..)
ENGINE_SYSTEM  := $(shell realpath ../../..)
include ../../../mk/pipeline.mk

help:
	@echo
	@echo 'Actions:                                                                    '
	@echo '                                                                            '
	@echo '    run - execute test suite                                                '
	@echo '                                                                            '
	@echo 'Selections:                                                                 '
	@echo '                                                                            '
	@echo '    DO_STAGES   = space delimited list of stages to execute                 '
	@echo '    DO_SUBJECTS = space delimited list of subjects to include in each stage '
	@echo

run:
	$(call run_stage,setup)
	$(call run_stage,cases)
	$(call run_stage,teardown)

pipeline: run

.PHONY: run
