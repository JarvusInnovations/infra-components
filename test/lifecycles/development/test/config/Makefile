ENGINE_ENV_DIR := $(shell realpath ../../../../environment)
include ../../../../../mk/subject.mk

stage:
	$(info INFO: GIT=$(GIT))
	test '$(call subject_config,configLifecycle)' = fromLifecycle # configLifecycle
	test '$(call subject_config,configSubject)' = fromSubject # configSubject
	test '$(call subject_config,configEnv)' = fromEnv # configEnv
