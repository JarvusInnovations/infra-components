include $(dir $(lastword $(MAKEFILE_LIST)))../pipeline.mk

help:
	@echo
	@echo 'Actions:                                                                    '
	@echo '                                                                            '
	@echo '    pull - download binary files                                            '
	@echo '    push - upload binary files                                              '
	@echo '                                                                            '
	@echo 'Filters:                                                                    '
	@echo '                                                                            '
	@echo '    DO_STAGES   = space delimited list of stages to execute                 '
	@echo '    DO_SUBJECTS = space delimited list of subjects to include in each stage '
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
