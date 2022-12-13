include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

DOING_ALL ?=

ifeq ($(STAGE_NAME),)
STAGE_NAME    := $(shell basename "`realpath .`")
endif

ifeq ($(PIPELINE_NAME),)
PIPELINE_NAME := $(shell basename "`realpath ..`")
endif

ifeq ($(DO_SUBJECTS),)
DO_SUBJECTS  := $(shell find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;)
DOING_ALL    := 1
endif

export STAGE_NAME
export PIPELINE_NAME
export DOING_ALL

SUBJECT_TARGETS := $(patsubst %,subject-%,$(DO_SUBJECTS))

subject_exists = $(shell find . -mindepth 1 -maxdepth 1 -type d -name $(1) 2>/dev/null)

$(MAKECMDGOALS): $(SUBJECT_TARGETS)

subject-%:
	$(if $(call subject_exists,$*),$(MAKE) -C '$*' $(MAKECMDGOALS))

.PHONY: $(MAKECMDGOALS)
