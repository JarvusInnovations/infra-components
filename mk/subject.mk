include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

ifeq ($(SUBJECT_NAME),)
SUBJECT_NAME   := $(shell basename "`realpath .`")
endif

ifeq ($(SUBJECT_DIR),)
SUBJECT_DIR    := $(shell realpath .)
endif

ifeq ($(STAGE_NAME),)
STAGE_NAME     := $(shell basename "`realpath ..`")
endif

ifeq ($(LIFECYCLE_NAME),)
LIFECYCLE_NAME := $(shell basename "`realpath ../..`")
endif

ifeq ($(LIFECYCLE_DIR),)
LIFECYCLE_DIR  := $(shell realpath '$(SUBJECT_DIR)'/../..)
endif

help:
	@echo
	@echo 'Activities:                                                           '
	@echo '                                                                      '
	@echo '    help   - show this message                                        '
	@echo '    test   - run tests for this stage                                 '
	@echo '    clean  - remove files cached by this stage                        '
	@echo '    stage  - execute this stage                                       '
	@echo '    report - publish stage-specific information to an external system '
	@echo '                                                                      '
	@echo 'To view all available activities, open: $(shell realpath .)/Makefile  '
	@echo

include $(MK)/config.mk

test:
clean:
stage:
report:

.PHONY: help
.PHONY: test
.PHONY: clean
.PHONY: stage
