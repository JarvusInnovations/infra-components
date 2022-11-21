include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

SELECTED_ALL ?=

ifeq ($(STAGE_NAME),)
STAGE_NAME      := $(shell basename "`realpath .`")
endif

ifeq ($(LIFECYCLE_NAME),)
LIFECYCLE_NAME  := $(shell basename "`realpath ..`")
endif

ifeq ($(SELECT_SUBJECTS),)
SELECT_SUBJECTS := $(shell find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;)
SELECTED_ALL    := 1
endif

export STAGE_NAME
export LIFECYCLE_NAME
export SELECTED_ALL
