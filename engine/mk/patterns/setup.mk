include ../../.engine/mk/pipeline.mk

help:
	@echo
	@echo 'Orchestrations:                                                 '
	@echo '                                                                '
	@echo '    pipeline - run full setup pipeline                          '
	@echo '                                                                '
	@echo 'Selections:                                                     '
	@echo '                                                                '
	@echo '    SELECT_STAGES   = list of stages to execute                 '
	@echo '    SELECT_SUBJECTS = list of subjects to include in each stage '
	@echo

pipeline:
	$(call run_stage,secrets)

UNSUPPORTED := $(filter-out pipeline help secrets,$(MAKECMDGOALS))

$(UNSUPPORTED): help
.PHONY: $(UNSUPPORTED)
