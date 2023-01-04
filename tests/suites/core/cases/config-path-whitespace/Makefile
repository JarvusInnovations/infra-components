ENGINE_LOCAL_DIR := $(shell realpath '../../../../content/core/local dir whitespace')
include ../../../../content/mk/case.mk

subject:
	$(info INFO GIT=$(GIT))
	test '$(call subject_config,pass)' = true # engineSubject.$(PIPELINE_NAME)/$(SUBJECT_NAME).pass = true
