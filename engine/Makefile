-include local.mk
PIPELINES_HOME ?= ../pipelines
ENGINE_ENV_DIR ?= $(shell git -C '$(PIPELINES_HOME)' rev-parse --absolute-git-dir)/engine

PIPELINE ?=
PATTERN  ?=
STAGE    ?=
STAGES   ?=
SUBJECT  ?=

VALID_PATTERNS := cicd setup
STAGES_cicd    := accept build test deliver deploy
STAGES_setup   := secrets

help:
	@echo
	@echo 'Actions:                                                                                                            '
	@echo '                                                                                                                    '
	@echo '    init                                        - setup a new engine project                                        '
	@echo '    new-pipeline (PIPELINE=, PATTERN=)          - create a new pipeline from a pattern template ($(VALID_PATTERNS)) '
	@echo '    new-stage    (STAGE=, PIPELINE=)            - create a new stage within the specified pipeline                  '
	@echo '    new-subject  (SUBJECT=, PIPELINE=, STAGES=) - create a new subject within the specified pipeline stages         '
	@echo

PIPELINE_DIR          := $(PIPELINES_HOME)/$(PIPELINE)
PIPELINE_MAKEFILE     := $(PIPELINE_DIR)/Makefile

ifdef PIPELINE

SYSTEM_RELTO_PIPELINE := $(shell realpath --relative-to='$(PIPELINE_DIR)' .)

ifeq ($(shell echo '$(SYSTEM_RELTO_PIPELINE)' | head -c 1),)
$(error FATAL: SYSTEM_RELTO_PIPELINE must be a relative path; got the absolute path $(SYSTEM_RELTO_PIPELINE))
endif

# wrap these checks in dir function because the pipeline dir may not yet exist
ifeq ($(shell cd '$(dir $(PIPELINE_DIR))' && stat '$(dir $(SYSTEM_RELTO_PIPELINE))'),)
$(error FATAL: cannot stat $(SYSTEM_RELTO_PIPELINE) from $(PIPELINE_DIR))
endif

endif

EXISTING_STAGE_DIRS        := $(shell find '$(PIPELINE_DIR)' -mindepth 1 -maxdepth 1 -type d ! -name '.*' 2>/dev/null)
DEFAULT_SUBJECT_DIRS       := $(patsubst %,%/$(SUBJECT),$(EXISTING_STAGE_DIRS))
DEFAULT_SUBJECT_MAKEFILES  := $(patsubst %,%/Makefile,$(DEFAULT_SUBJECT_DIRS))
SELECTED_SUBJECT_DIRS      := $(patsubst %,$(PIPELINE_DIR)/%/$(SUBJECT),$(STAGES))
SELECTED_SUBJECT_MAKEFILES := $(patsubst %,%/Makefile,$(SELECTED_SUBJECT_DIRS))

NEW_STAGE_DIR           := $(PIPELINE_DIR)/$(STAGE)
NEW_STAGE_MAKEFILE      := $(NEW_STAGE_DIR)/Makefile

PATTERN_STAGES          := $(STAGES_$(PATTERN))
PATTERN_STAGE_DIRS      := $(patsubst %,$(PIPELINE_DIR)/%,$(PATTERN_STAGES))
PATTERN_STAGE_MAKEFILES := $(patsubst %,%/Makefile,$(PATTERN_STAGE_DIRS))

init:
	mkdir -pv '$(ENGINE_ENV_DIR)'
	mkdir -pv '$(PIPELINES_HOME)'

new-pipeline:
ifdef PIPELINE
ifdef PATTERN
new-pipeline: $(PATTERN_STAGE_MAKEFILES)

$(PIPELINE_MAKEFILE): | $(PIPELINE_DIR)
	echo 'include $(SYSTEM_RELTO_PIPELINE)/mk/patterns/$(PATTERN).mk' > '$@'
else
new-pipeline: $(PIPELINE_MAKEFILE)

$(PIPELINE_MAKEFILE): | $(PIPELINE_DIR)
	echo 'include $(SYSTEM_RELTO_PIPELINE)/mk/pipeline.mk' > '$@'
endif
else
	$(error FATAL: PIPELINE= is required)
endif

new-stage:
ifdef PIPELINE
ifdef STAGE
new-stage: $(NEW_STAGE_MAKEFILE)
else
	$(error FATAL: STAGE= is required)
endif
else
	$(error FATAL: PIPELINE= is required)
endif

new-subject:
ifdef SUBJECT
ifdef PIPELINE
ifdef STAGES
new-subject: $(SELECTED_SUBJECT_MAKEFILES)
else
new-subject: $(DEFAULT_SUBJECT_MAKEFILES)
endif
else
	$(error FATAL: PIPELINE= is required)
endif
else
	$(error FATAL: SUBJECT= is required)
endif

$(PIPELINE_DIR): | $(PIPELINES_HOME)
	mkdir -p '$@'

$(PATTERN_STAGE_MAKEFILES): | $(PATTERN_STAGE_DIRS)
	echo 'include ../$(SYSTEM_RELTO_PIPELINE)/mk/stage.mk' > '$@'

$(PATTERN_STAGE_DIRS): | $(PIPELINE_MAKEFILE)
	mkdir -p '$@'

$(NEW_STAGE_MAKEFILE): | $(NEW_STAGE_DIR)
	echo 'include ../$(SYSTEM_RELTO_PIPELINE)/mk/stage.mk' > '$@'

$(NEW_STAGE_DIR):
	mkdir -p '$@'

$(SELECTED_SUBJECT_MAKEFILES) $(DEFAULT_SUBJECT_MAKEFILES): | $(SUBJECT_DIRS)
	echo 'include ../../$(SYSTEM_RELTO_PIPELINE)/mk/subject.mk' > '$@'

$(SUBJECT_DIRS): | $(PIPELINE_MAKEFILE)
	mkdir -p '$@'

.PHONY: help
.PHONY: init
.PHONY: new-pipeline
.PHONY: new-stage
.PHONY: new-subject
