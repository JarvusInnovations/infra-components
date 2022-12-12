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
	$(if $(filter setup,    $(SELECT_STAGES)),$(MAKE) -C setup    stage )
	$(if $(filter cases,    $(SELECT_STAGES)),$(MAKE) -C cases    stage )
	$(if $(filter teardown, $(SELECT_STAGES)),$(MAKE) -C teardown stage )

.PHONY: help
.PHONY: run
