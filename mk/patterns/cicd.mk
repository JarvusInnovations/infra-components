include ../../.engine/mk/lifecycle.mk

help:
	@echo
	@echo 'Orchestrations:                                                 '
	@echo '                                                                '
	@echo '    pipeline - run full ci/cd pipeline over selections          '
	@echo '    ci       - build & publish packaging, run integration tests '
	@echo '    cd       - deploy a package                                 '
	@echo '    test     - run acceptance & integration tests               '
	@echo '                                                                '
	@echo 'Selections:                                                     '
	@echo '                                                                '
	@echo '    SELECT_STAGES   = list of stages to execute                 '
	@echo '    SELECT_SUBJECTS = list of subjects to include in each stage '
	@echo

pipeline:
	$(MAKE) ci
	$(MAKE) cd

ci:
	$(if $(filter develop,   $(SELECT_STAGES)), $(MAKE) -C develop test         )
	$(if $(filter integrate, $(SELECT_STAGES)), $(MAKE) -C integrate stage test )

cd:
	$(if $(filter deploy,    $(SELECT_STAGES)), $(MAKE) -C deploy stage         )

test:
	$(if $(filter develop,   $(SELECT_STAGES)), $(MAKE) -C develop test         )
	$(if $(filter integrate, $(SELECT_STAGES)), $(MAKE) -C integrate test       )

PASSTHROUGH_GOALS  := $(filter-out help pipeline ci cd test,$(MAKECMDGOALS))
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
.PHONY: test
