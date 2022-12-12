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
	$(if $(filter accept, $(SELECT_STAGES)), $(MAKE) -C accept stage )
	$(if $(filter build,  $(SELECT_STAGES)), $(MAKE) -C build  stage )
	$(if $(filter test,   $(SELECT_STAGES)), $(MAKE) -C test   stage )

cd:
	$(if $(filter deliver, $(SELECT_STAGES)), $(MAKE) -C deliver  stage )
	$(if $(filter deploy,  $(SELECT_STAGES)), $(MAKE) -C deploy   stage )

.PHONY: help
.PHONY: pipeline
.PHONY: ci
.PHONY: cd
