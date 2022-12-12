ENGINE_ENV_DIR := $(shell realpath ../../../../environments/config)
include ../../../../../mk/subject.mk

stage:
	$(info INFO: GIT=$(GIT))
	test '$(call subject_config,configPipeline)' = fromPipeline # '<configPipeline>'
	test '$(call subject_config,configSubject)' = fromSubject # '<configSubject>'
	test '$(call subject_config,configEnv)' = fromEnv # '<configEnv>'
