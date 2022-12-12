include ../../.engine/mk/pipeline.mk

help:
	@echo
	@echo 'Orchestrations:                                                 '
	@echo '                                                                '
	@echo '    pipeline - run full ci/cd pipeline over selections          '
	@echo '    ci       - package & test selections                        '
	@echo '    cd       - deploy a package                                 '
	@echo '                                                                '
	@echo 'Selections:                                                     '
	@echo '                                                                '
	@echo '    SELECT_STAGES   = list of stages to execute                 '
	@echo '    SELECT_SUBJECTS = list of subjects to include in each stage '
	@echo

pipeline:
	$(MAKE) ci cd

ci:
	$(if $(filter develop,   $(SELECT_STAGES)), $(MAKE) -C develop   stage test )
	$(if $(filter integrate, $(SELECT_STAGES)), $(MAKE) -C integrate stage test )

cd:
	$(if $(filter deploy,    $(SELECT_STAGES)), $(MAKE) -C deploy stage         )

PASSTHROUGH_GOALS  := $(filter-out help pipeline ci cd,$(MAKECMDGOALS))
PASSTHROUGH_STAGES := $(patsubst %,stage-%,$(SELECT_STAGES))
ifneq ($(PASSTHROUGH_GOALS),)
.PHONY: $(PASSTHROUGH_GOALS)
$(PASSTHROUGH_GOALS): $(PASSTHROUGH_STAGES)
stage-%:
	$(MAKE) -C '$*' $(PASSTHROUGH_GOALS)
endif

.PHONY: help
.PHONY: pipeline
.PHONY: ci
.PHONY: cd
