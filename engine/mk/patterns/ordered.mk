# FIXME: hard coded .engine
include ../../.engine/mk/pipeline.mk

ALL_STAGES := $(sort $(shell find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;))
RUN_STAGES := $(filter $(DO_STAGES),$(ALL_STAGES))

help:
	@echo
	@echo 'Actions:                                                                    '
	@echo '                                                                            '
	@echo '    pipeline - run full pipeline                                            '
	@echo '                                                                            '
	@echo 'Stages:                                                                     '
	@echo '                                                                            '
	@echo '    $(ALL_STAGES)                                                           '
	@echo '                                                                            '
	@echo 'Filters:                                                                    '
	@echo '                                                                            '
	@echo '    DO_STAGES   = space delimited list of stages to execute                 '
	@echo '    DO_SUBJECTS = space delimited list of subjects to include in each stage '
	@echo

pipeline:
	$(MAKE) $(RUN_STAGES)

$(ALL_STAGES):
	$(call run_stage,$@)

.PHONY: $(ALL_STAGES)

UNSUPPORTED := $(filter-out pipeline help $(ALL_STAGES),$(MAKECMDGOALS))

$(UNSUPPORTED): help
.PHONY: $(UNSUPPORTED)
