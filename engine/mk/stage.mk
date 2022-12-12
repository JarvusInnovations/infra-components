include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

SELECTED_ALL ?=

ifeq ($(STAGE_NAME),)
STAGE_NAME      := $(shell basename "`realpath .`")
endif

ifeq ($(PIPELINE_NAME),)
PIPELINE_NAME   := $(shell basename "`realpath ..`")
endif

ifeq ($(SELECT_SUBJECTS),)
SELECT_SUBJECTS := $(shell find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;)
SELECTED_ALL    := 1
endif

export STAGE_NAME
export PIPELINE_NAME
export SELECTED_ALL

SUBJECT_TARGETS := $(patsubst %,subject-%,$(SELECT_SUBJECTS))

subject_exists = $(shell find . -mindepth 1 -maxdepth 1 -type d -name $(1) 2>/dev/null)

$(MAKECMDGOALS): $(SUBJECT_TARGETS)

subject-%:
	$(if $(call subject_exists,$*),$(MAKE) -C '$*' $(MAKECMDGOALS))

.PHONY: $(MAKECMDGOALS)
