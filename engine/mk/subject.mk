include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

ifeq ($(SUBJECT_NAME),)
SUBJECT_NAME   := $(shell basename "`realpath .`")
endif

ifeq ($(STAGE_NAME),)
STAGE_NAME     := $(shell basename "`realpath ..`")
endif

ifeq ($(LIFECYCLE_NAME),)
LIFECYCLE_NAME := $(shell basename "`realpath ../..`")
endif

help:
	@echo
	@echo Activities:
	@echo
	@echo     To view, open: $(shell realpath .)/Makefile
	@echo

include $(MK)/config.mk
