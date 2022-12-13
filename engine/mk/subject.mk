include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

ifeq ($(SUBJECT_NAME),)
SUBJECT_NAME  := $(shell basename "`realpath .`")
endif

ifeq ($(STAGE_NAME),)
STAGE_NAME    := $(shell basename "`realpath ..`")
endif

ifeq ($(PIPELINE_NAME),)
PIPELINE_NAME := $(shell basename "`realpath ../..`")
endif

ifeq ($(SUBJECT_DIR),)
SUBJECT_DIR   := $(shell realpath .)
endif

ifeq ($(PIPELINE_DIR),)
PIPELINE_DIR  := $(shell realpath ../..)
endif

run_step = $(MAKE) $(1)

stage:

.PHONY: stage

include $(MK)/config.mk
