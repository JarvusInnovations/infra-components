ENGINE_PROJECT_DIR ?= $(shell realpath ../../../..)
ENGINE_SYSTEM_DIR  ?= $(shell realpath ../../../../..)
ENGINE_ENV         ?= tests
include ../../../../../mk/subject.mk
test_skip_subject = $(info SKIP: $(PIPELINE_NAME)/$(SUBJECT_NAME): $(1) not configured)
test_skip_env     = $(info SKIP: environment $(ENGINE_ENV): $(1) not configured)
test_skip_opt     = $(info SKIP: $(ENGINE_ENV) $(PIPELINE_NAME)/$(SUBJECT_NAME) ($(STAGE_NAME)): needs option: $(1))
