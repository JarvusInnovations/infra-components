include ../../.engine/mk/pipeline.mk

help:
	@echo
	@echo 'Actions:                                                        '
	@echo '                                                                '
	@echo '    pull - download binary files                                '
	@echo '    push - upload binary files                                  '
	@echo '                                                                '
	@echo 'Selections:                                                     '
	@echo '                                                                '
	@echo '    SELECT_STAGES   = list of stages to execute                 '
	@echo '    SELECT_SUBJECTS = list of subjects to include in each stage '
	@echo

pipeline: help

pull:
	$(call run_stage,pull)

push:
	$(call run_stage,push)

.PHONY: pull
.PHONY: push

UNSUPPORTED := $(filter-out pipeline help pull push,$(MAKECMDGOALS))

$(UNSUPPORTED): help
.PHONY: $(UNSUPPORTED)
