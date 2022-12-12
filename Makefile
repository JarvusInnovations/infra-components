-include local.mk
PIPELINES_HOME ?= ../pipelines
ENGINE_ENV_DIR ?= $(shell git -C '$(PIPELINES_HOME)' rev-parse --git-path engine)
ENGINE_SYSTEM  ?= $(shell realpath --relative-to='$(PIPELINES_HOME)' .)

# new-pipeline
PIPELINE ?=
PATTERN  ?=

VALID_PATTERNS := cicd
STAGES_cicd    := develop integrate deploy operate

help:
	@echo
	@echo 'Actions:                                                                                     '
	@echo '                                                                                             '
	@echo '    init                                - setup a new engine project                         '
	@echo '    new-pipeline (PIPELINE=, PATTERN=) - create a new pipeline from a pattern template       '
	@echo '    new-subject  (PIPELINE=, SUBJECT=) - create a new subject within the specified pipeline  '
	@echo

init: $(ENGINE_ENV_DIR) $(PIPELINES_HOME)

$(ENGINE_ENV_DIR) $(PIPELINES_HOME):
	mkdir -p '$@'

# new-pipeline, new-subject dynamic processing
ifndef PIPELINE
new-pipeline:
	$(error FATAL: PIPELINE= is required)

new-subject:
	$(error FATAL: PIPELINE= is required)
else

PIPELINE_DIR        := $(PIPELINES_HOME)/$(PIPELINE)
PIPELINE_MAKEFILE   := $(PIPELINE_DIR)/Makefile

ifndef SUBJECT
new-subject:
	$(error FATAL: SUBJECT= is required)
else
EXISTING_STAGE_DIRS := $(shell find '$(PIPELINE_DIR)' -mindepth 1 -maxdepth 1 -type d ! -name '.*')
SUBJECT_DIRS        := $(patsubst %,%/$(SUBJECT),$(EXISTING_STAGE_DIRS))
SUBJECT_MAKEFILES   := $(patsubst %,%/Makefile,$(SUBJECT_DIRS))

new-subject: $(SUBJECT_MAKEFILES)
$(SUBJECT_MAKEFILES): | $(SUBJECT_DIRS)
	echo 'include ../../../$(ENGINE_SYSTEM)/mk/subject.mk' > '$@'
$(SUBJECT_DIRS): | $(PIPELINE_MAKEFILE)
	mkdir -p '$@'
endif
ifeq ($(filter $(VALID_PATTERNS),$(PATTERN)),)
new-pipeline:
	$(error FATAL: PATTERN= must be one of: $(VALID_PATTERNS))
else
PATTERN_STAGES          := $(STAGES_$(PATTERN))
PATTERN_STAGE_DIRS      := $(patsubst %,$(PIPELINE_DIR)/%,$(PATTERN_STAGES))
PATTERN_STAGE_MAKEFILES := $(patsubst %,%/Makefile,$(PATTERN_STAGE_DIRS))

new-pipeline: $(PATTERN_STAGE_MAKEFILES)

$(PATTERN_STAGE_MAKEFILES): | $(PATTERN_STAGE_DIRS)
	echo 'include ../../$(ENGINE_SYSTEM)/mk/stage.mk' > '$@'

$(PATTERN_STAGE_DIRS): | $(PIPELINE_MAKEFILE)
	mkdir -p '$@'

$(PIPELINE_MAKEFILE): | $(PIPELINE_DIR)
	echo 'include ../$(ENGINE_SYSTEM)/mk/patterns/$(PATTERN).mk' > '$@'

$(PIPELINE_DIR): | $(PIPELINES_HOME)
	mkdir -p '$@'
endif
endif

.PHONY: help
.PHONY: init
.PHONY: new-pipeline
