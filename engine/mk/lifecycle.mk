include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

ifeq ($(LIFECYCLE_NAME),)
LIFECYCLE_NAME := $(shell basename "`realpath .`")
endif

ifeq ($(LIFECYCLE_DIR),)
LIFECYCLE_DIR  := $(LIFECYCLE_HOME)/$(LIFECYCLE_NAME)
endif

ifeq ($(SELECT_STAGES),)
SELECT_STAGES  := $(shell find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;)
endif

export LIFECYCLE_NAME
export LIFECYCLE_DIR
