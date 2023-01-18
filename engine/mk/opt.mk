# Context
PIPELINE_OPTS_PATHS = $(foreach optsfile,$(call list_optsfiles,$(shell realpath ../..)),'$(shell realpath ../..)/$(optsfile)')
SUBJECT_OPTS_PATHS  = $(foreach optsfile,$(call list_optsfiles,$(shell realpath .)),'$(shell realpath .)/$(optsfile)')
LOCAL_OPTS_PATHS    = $(foreach optsfile,$(call list_optsfiles,$(ENGINE_LOCAL_DIR)),'$(ENGINE_LOCAL_DIR)/$(optsfile)')
OPTSFILE_PATHS      = $(PIPELINE_OPTS_PATHS) $(SUBJECT_OPTS_PATHS) $(LOCAL_OPTS_PATHS)

OPT_CONTEXT            = \
  ENGINE_ENV='$(ENGINE_ENV)'                     \
  ENGINE_PROJECT_DIR='$(ENGINE_PROJECT_DIR)'     \
  ENGINE_LOCAL_DIR='$(ENGINE_LOCAL_DIR)'         \
  ENGINE_ARTIFACTS_DIR='$(ENGINE_ARTIFACTS_DIR)' \
  PIPELINE_NAME=$(PIPELINE_NAME)                 \
  SUBJECT_NAME=$(SUBJECT_NAME)                   \
  SUBJECT_DIR='$(SUBJECT_DIR)'
STMT_SELECT = $(OPT_CONTEXT) $(LIB)/sh/stmt-select.sh

# Methods
opt_pipeline_var   = $(shell $(STMT_SELECT) -t pipelineOpts -c values -r variable -k '$(1)' $(if $(2),-p '$(2)') $(OPTSFILE_PATHS))
opt_pipeline_list  = $(shell $(STMT_SELECT) -t pipelineOpts -c values -r list     -k '$(1)' $(OPTSFILE_PATHS))
opt_artifact_var   = $(shell $(STMT_SELECT) -t artifactOpts -c values -r variable -a '$(1)' -k '$(2)' $(if $(3),-p '$(3)') $(OPTSFILE_PATHS))
opt_artifact_list  = $(shell $(STMT_SELECT) -t artifactOpts -c values -r list     -a '$(1)' -k '$(2)' $(OPTSFILE_PATHS))
artifact_path      = $(shell $(STMT_SELECT) -t artifactRefs -c values -r variable -k '$(1)' $(OPTSFILE_PATHS))
artifact_frompath  = $(shell $(STMT_SELECT) -t artifactRefs -c keys   -r variable -v '$(1)' $(OPTSFILE_PATHS))
artifacts_matching = $(shell $(STMT_SELECT) -t artifactRefs -c keys   -r list     -k '$(1)' $(OPTSFILE_PATHS))

filter_artifacts_opt_eq_val     =
filter_artifacts_opt_ne_val     =
filter_artifacts_list_has_val   =
filter_artifacts_list_hasno_val =

# Internal

list_optsfiles = $(shell find '$(1)' -mindepth 1 -maxdepth 1 -name '*.conf' -exec basename {} \;)
