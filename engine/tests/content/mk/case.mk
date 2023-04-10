ifeq ($(ENGINE_PROJECT_DIR),)
ENGINE_PROJECT_DIR := $(shell realpath ../../../..)
endif

ifeq ($(ENGINE_SYSTEM_DIR),)
ENGINE_SYSTEM_DIR  := $(shell realpath ../../../../..)
endif

ifeq ($(ENGINE_ENV),)
ENGINE_ENV         := tests
endif

include ../../../../../mk/subject.mk
test_skip_opt     = $(info SKIP: $(ENGINE_ENV) $(PIPELINE_NAME)/$(SUBJECT_NAME) ($(STAGE_NAME)): needs option: $(1))
test_skip_cmd     = $(info SKIP: $(ENGINE_ENV) $(PIPELINE_NAME)/$(SUBJECT_NAME) ($(STAGE_NAME)): needs command: $(1))
test_find_cmd     = $(wildcard $(patsubst %,%/$(1),$(subst :, ,$(PATH))))
