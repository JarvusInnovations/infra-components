LIFECYCLE_HOME ?= ../lifecycles
ENGINE_ENV_DIR ?= ../$(shell git -C .. rev-parse --git-dir --path-format=relative)/engine
ENGINE_SYSTEM  ?= $(shell realpath --relative-to='$(LIFECYCLE_HOME)' .)

# new-pipeline
LIFECYCLE ?=
PATTERN   ?=

VALID_PATTERNS := cicd
STAGES_cicd    := develop integrate deploy operate

help:
	@echo
	@echo 'Actions:                                                                                      '
	@echo '                                                                                              '
	@echo '    init                                - setup a new engine project                          '
	@echo '    new-pipeline (LIFECYCLE=, PATTERN=) - create a new lifecycle pipeline in engine project   '
	@echo '    new-subject  (LIFECYCLE=, SUBJECT=) - create a new subject within the specified lifecycle '
	@echo

init: $(ENGINE_ENV_DIR) $(LIFECYCLE_HOME)

$(ENGINE_ENV_DIR) $(LIFECYCLE_HOME):
	mkdir -p '$@'

# new-pipeline, new-subject dynamic processing
ifndef LIFECYCLE
new-pipeline:
	$(error FATAL: LIFECYCLE= is required)

new-subject:
	$(error FATAL: LIFECYCLE= is required)
else

LIFECYCLE_DIR        := $(LIFECYCLE_HOME)/$(LIFECYCLE)
LIFECYCLE_MAKEFILE   := $(LIFECYCLE_DIR)/Makefile

ifndef SUBJECT
new-subject:
	$(error FATAL: SUBJECT= is required)
else
EXISTING_STAGE_DIRS  := $(shell find '$(LIFECYCLE_DIR)' -mindepth 1 -maxdepth 1 -type d ! -name '.*')
SUBJECT_DIRS         := $(patsubst %,%/$(SUBJECT),$(EXISTING_STAGE_DIRS))
SUBJECT_MAKEFILES    := $(patsubst %,%/Makefile,$(SUBJECT_DIRS))

new-subject: $(SUBJECT_MAKEFILES)
$(SUBJECT_MAKEFILES): | $(SUBJECT_DIRS)
	echo 'include ../../../$(ENGINE_SYSTEM)/mk/subject.mk' > '$@'
$(SUBJECT_DIRS): | $(LIFECYCLE_MAKEFILE)
	mkdir -p '$@'
endif
ifeq ($(filter $(VALID_PATTERNS),$(PATTERN)),)
new-pipeline:
	$(error FATAL: PATTERN= must be one of: $(VALID_PATTERNS))
else
PIPELINE_STAGES          := $(STAGES_$(PATTERN))
PIPELINE_STAGE_DIRS      := $(patsubst %,$(LIFECYCLE_DIR)/%,$(PIPELINE_STAGES))
PIPELINE_STAGE_MAKEFILES := $(patsubst %,%/Makefile,$(PIPELINE_STAGE_DIRS))

new-pipeline: $(PIPELINE_STAGE_MAKEFILES)

$(PIPELINE_STAGE_MAKEFILES): | $(PIPELINE_STAGE_DIRS)
	echo 'include ../../$(ENGINE_SYSTEM)/mk/stage.mk' > '$@'

$(PIPELINE_STAGE_DIRS): | $(LIFECYCLE_MAKEFILE)
	mkdir -p '$@'

$(LIFECYCLE_MAKEFILE): | $(LIFECYCLE_DIR)
	echo 'include ../$(ENGINE_SYSTEM)/mk/patterns/$(PATTERN).mk' > '$@'

$(LIFECYCLE_DIR): | $(LIFECYCLE_HOME)
	mkdir -p '$@'
endif
endif

.PHONY: help
.PHONY: init
.PHONY: new-pipeline
