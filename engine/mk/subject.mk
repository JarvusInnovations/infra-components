# = subject =
#
# Provider of subject-local context and methods
#
# == Context ==
#
# |===================================
# | Name                 | Description
# | SUBJECT_DIR          | Absolute path to the directory containing the Subject file (<pipeline>/<stage>/<subject>/Makefile)
# | SUBJECT_NAME         | Name of the currently in-scope subject
# | STAGE_NAME           | Name of the currently in-scope stage
# | PIPELINE_NAME        | Name of the currently in-scope pipeline
# |===================================
#
# == Methods ==
#
# `run_step`::
#   positionals:::
#     1. step name
#   returns:::
#     * shell command to embed in a target recipe

include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

ifeq ($(SUBJECT_DIR),)
SUBJECT_DIR   := $(shell realpath .)
endif

ifeq ($(SUBJECT_NAME),)
SUBJECT_NAME  := $(shell basename "`realpath .`")
endif

ifeq ($(STAGE_NAME),)
STAGE_NAME    := $(shell basename "`realpath ..`")
endif

ifeq ($(PIPELINE_NAME),)
PIPELINE_NAME := $(shell basename "`realpath ../..`")
endif

run_step = $(MAKE) $(1)

stage:

.PHONY: stage

include $(MK)/config.mk
