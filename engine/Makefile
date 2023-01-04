-include local.mk
ENGINE_PROJECT_DIR   ?= ..
-include $(ENGINE_PROJECT_DIR)/.engine-project.mk
ENGINE_SYSTEM_DIR    ?= .
ENGINE_PIPELINES_DIR ?= $(ENGINE_PROJECT_DIR)/pipelines
ENGINE_LOCAL_DIR     ?= $(shell git -C '$(ENGINE_PIPELINES_DIR)' rev-parse --absolute-git-dir)/engine/local
ENGINE_ARTIFACTS_DIR ?= $(shell git -C '$(ENGINE_PIPELINES_DIR)' rev-parse --absolute-git-dir)/engine/artifacts
LIB                  ?= $(ENGINE_SYSTEM_DIR)/lib

PIPELINE ?=
PATTERN  ?= ordered
STAGE    ?=
STAGES   ?= $(STAGE)
SUBJECT  ?=

STAGES_cicd    := 1-accept 2-build 3-test 4-deliver 5-deploy
STAGES_bins    := pull push

COMMA                 := ,
VALID_PATTERNS        := $(notdir $(basename $(wildcard mk/patterns/*.mk)))
VALID_PATTERNS_HELPST := $(patsubst %,%$(COMMA),$(filter-out $(lastword $(VALID_PATTERNS)),$(VALID_PATTERNS))) $(lastword $(VALID_PATTERNS))
VALID_MODS            := $(patsubst mk/%,%,$(wildcard mk/*.mk mk/tech/*.mk))
MODS_PATHS            := $(if $(MOD),$(foreach mod,$(MOD),mk/$(mod)))

help:
	@echo
	@echo 'Actions:                                                                                                                    '
	@echo '                                                                                                                            '
	@echo '    init                                        - setup a new engine project                                                '
	@echo '    lsmod                                       - list module names                                                         '
	@echo '    printdoc     (MOD=)                         - print module documentation                                                '
	@echo '    new-pipeline (PIPELINE=, PATTERN=)          - create a new pipeline from a pattern template ($(VALID_PATTERNS_HELPSTR)) '
	@echo '    new-stage    (PIPELINE=, STAGE=)            - create a new stage within the specified pipeline                          '
	@echo '    new-subject  (PIPELINE=, STAGES=, SUBJECT=) - create a new subject within the specified pipeline stages                 '
	@echo

init:
	mkdir -pv '$(ENGINE_PIPELINES_DIR)'
	mkdir -pv '$(ENGINE_LOCAL_DIR)'
	mkdir -pv '$(ENGINE_ARTIFACTS_DIR)'

lsmod:
	@printf '%s\n' $(VALID_MODS)

printdoc:
ifdef MOD
	@awk -f '$(LIB)'/awk/comment-embedded-adoc.awk $(MODS_PATHS)
else
	$(error MOD= is required)
endif

PIPELINE_DIR          := $(if $(PIPELINE),$(ENGINE_PIPELINES_DIR)/$(PIPELINE))
PIPELINE_MAKEFILE     := $(if $(PIPELINE),$(PIPELINE_DIR)/Makefile)
SYSTEM_RELTO_PIPELINE := $(if $(PIPELINE),$(shell $(LIB)/sh/dir-relto.sh '$(ENGINE_SYSTEM_DIR)' '$(PIPELINE_DIR)'))

ifdef PIPELINE

ifeq ($(shell echo '$(SYSTEM_RELTO_PIPELINE)' | head -c 1),/)
$(error FATAL: BUG: SYSTEM_RELTO_PIPELINE must be a relative path; got the absolute path $(SYSTEM_RELTO_PIPELINE))
endif

# wrap these checks in dir function because the pipeline dir may not yet exist
ifeq ($(shell cd '$(dir $(PIPELINE_DIR))' && stat '$(dir $(SYSTEM_RELTO_PIPELINE))'),)
$(error FATAL: cannot stat $(SYSTEM_RELTO_PIPELINE) from $(dir $(PIPELINE_DIR)))
endif

endif

DEFAULT_STAGE_DIRS         := $(if $(STAGES),,$(shell find '$(PIPELINE_DIR)' -mindepth 1 -maxdepth 1 -type d ! -name '.*' 2>/dev/null))
DEFAULT_STAGE_MAKEFILES    := $(if $(STAGES),,$(patsubst %,%/Makefile,$(DEFAULT_STAGE_DIRS)))
DEFAULT_SUBJECT_DIRS       := $(if $(STAGES),,$(patsubst %,%/$(SUBJECT),$(DEFAULT_STAGE_DIRS)))
DEFAULT_SUBJECT_MAKEFILES  := $(if $(STAGES),,$(patsubst %,%/Makefile,$(DEFAULT_SUBJECT_DIRS)))
SELECTED_STAGE_DIRS        := $(if $(STAGES),$(patsubst %,$(PIPELINE_DIR)/%,$(STAGES)))
SELECTED_STAGE_MAKEFILES   := $(if $(STAGES),$(patsubst %,%/Makefile,$(SELECTED_STAGE_DIRS)))
SELECTED_SUBJECT_DIRS      := $(if $(STAGES),$(patsubst %,$(PIPELINE_DIR)/%/$(SUBJECT),$(STAGES)))
SELECTED_SUBJECT_MAKEFILES := $(if $(STAGES),$(patsubst %,%/Makefile,$(SELECTED_SUBJECT_DIRS)))
SUBJECT_MAKEFILES          := $(sort $(DEFAULT_SUBJECT_MAKEFILES) $(SELECTED_SUBJECT_MAKEFILES) )
SUBJECT_DIRS               := $(sort $(DEFAULT_SUBJECT_DIRS)      $(SELECTED_SUBJECT_DIRS)      )
SUBJECT_STAGE_MAKEFILES    := $(sort $(DEFAULT_STAGE_MAKEFILES)   $(SELECTED_STAGE_MAKEFILES)   )
SUBJECT_STAGE_DIRS         := $(sort $(DEFAULT_STAGE_DIRS)        $(SELECTED_STAGE_DIRS)        )

NEW_STAGE_DIR              := $(if $(STAGE),$(PIPELINE_DIR)/$(STAGE))
NEW_STAGE_MAKEFILE         := $(if $(STAGE),$(NEW_STAGE_DIR)/Makefile)

PATTERN_STAGES             := $(STAGES_$(PATTERN))
PATTERN_STAGE_DIRS         := $(if $(PATTERN_STAGES),$(patsubst %,$(PIPELINE_DIR)/%,$(PATTERN_STAGES)))
PATTERN_STAGE_MAKEFILES    := $(if $(PATTERN_STAGES),$(patsubst %,%/Makefile,$(PATTERN_STAGE_DIRS)))

STAGE_MAKEFILES            := $(sort $(NEW_STAGE_MAKEFILE) $(PATTERN_STAGE_MAKEFILES) $(SUBJECT_STAGE_MAKEFILES))
STAGE_DIRS                 := $(sort $(NEW_STAGE_DIR) $(PATTERN_STAGE_DIRS) $(SUBJECT_STAGE_DIRS))

ALL_DIRS                   := $(sort $(PIPELINE_DIR) $(STAGE_DIRS) $(SUBJECT_DIRS))

new-pipeline:
ifndef PIPELINE
	$(error FATAL: PIPELINE= is required)
else
new-pipeline: $(PIPELINE_MAKEFILE) $(PATTERN_STAGE_MAKEFILES)
endif

new-stage:
ifndef PIPELINE
	$(error FATAL: PIPELINE= is required)
endif
ifndef STAGE
	$(error FATAL: STAGE= is required)
endif
ifdef PIPELINE
ifdef STAGE
new-stage: $(NEW_STAGE_MAKEFILE)
endif
endif

new-subject:
ifndef PIPELINE
	$(error FATAL: PIPELINE= is required)
ifndef SUBJECT
	$(error FATAL: SUBJECT= is required)
endif
endif
ifdef PIPELINE
ifdef SUBJECT
new-subject: $(SUBJECT_MAKEFILES)
endif
endif

$(PIPELINE_DIR)      : | $(ENGINE_PIPELINES_DIR)
$(PIPELINE_MAKEFILE) : | $(PIPELINE_DIR)
$(STAGE_MAKEFILES)   : $(PIPELINE_MAKEFILE) | $(STAGE_DIRS)
$(SUBJECT_MAKEFILES) : $(STAGE_MAKEFILES)   | $(SUBJECT_DIRS)

$(PIPELINE_MAKEFILE):
	echo 'include $(SYSTEM_RELTO_PIPELINE)/mk/patterns/$(PATTERN).mk' > '$@'

$(STAGE_MAKEFILES):
	echo 'include ../$(SYSTEM_RELTO_PIPELINE)/mk/stage.mk' > '$@'

$(SUBJECT_MAKEFILES):
	echo 'include ../../$(SYSTEM_RELTO_PIPELINE)/mk/subject.mk' > '$@'

$(ALL_DIRS):
	mkdir -pv '$@'

.PHONY: help
.PHONY: init
.PHONY: lsmod
.PHONY: printdoc
.PHONY: new-pipeline
.PHONY: new-stage
.PHONY: new-subject
