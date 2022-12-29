# FIXME: hard coded .engine
include ../../.engine/mk/pipeline.mk

help:
	@echo
	@echo 'Actions:                                                                    '
	@echo '                                                                            '
	@echo '    pipeline - run full ci/cd pipeline over selections                      '
	@echo '    ci       - package & test selections                                    '
	@echo '    cd       - deploy a package                                             '
	@echo '                                                                            '
	@echo 'Filters:                                                                    '
	@echo '                                                                            '
	@echo '    DO_STAGES   = space delimited list of stages to execute                 '
	@echo '    DO_SUBJECTS = space delimited list of subjects to include in each stage '
	@echo

pipeline:
	$(MAKE) ci cd

ci:
	$(call run_stage,1-accept)
	$(call run_stage,2-build)
	$(call run_stage,3-test)

cd:
	$(call run_stage,4-deliver)
	$(call run_stage,5-deploy)

.PHONY: ci
.PHONY: cd

UNSUPPORTED := $(filter-out pipeline help ci cd,$(MAKECMDGOALS))

$(UNSUPPORTED): help
.PHONY: $(UNSUPPORTED)
