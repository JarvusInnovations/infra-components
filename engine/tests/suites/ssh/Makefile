PIPELINE_DIR   := $(shell realpath .)
include ../../../mk/pipeline.mk

help:
	@echo
	@echo 'Orchestrations:                                                 '
	@echo '                                                                '
	@echo '    run - execute test suite                                    '
	@echo '                                                                '
	@echo 'Selections:                                                     '
	@echo '                                                                '
	@echo '    SELECT_STAGES   = list of stages to execute                 '
	@echo '    SELECT_SUBJECTS = list of subjects to include in each stage '
	@echo

run:
	$(call run_stage,setup)
	$(call run_stage,cases)
	$(call run_stage,teardown)

pipeline: run

.PHONY: run
