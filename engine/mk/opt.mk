# = opt =
#
# Reference options defined in config files
#
# == Methods ==
#
# `opt_pipeline_var`::
#   positionals:::
#     1. Option name
#     2. [optional] Path format; "abs" or "rel"
#   returns:::
#     * Last defined option value
#
# `opt_pipeline_list`::
#   positionals:::
#     1. Option name
#   returns:::
#     * All defined option values
#
# `opt_artifact_var`::
#   positionals:::
#     1. Artifact ID
#     2. Option name
#   returns:::
#     * Last defined option value
#
# `opt_artifact_list`::
#   positionals:::
#     1. Artifact ID
#     2. Option name
#   returns:::
#     * All defined option values
#
# `artifact_path`::
#   positionals:::
#     1. Artifact ID
#   returns:::
#     * <ENGINE_ARTIFACT_DIR>/<artifact.path>
#
# `artifact_frompath`::
#   positionals:::
#     1. <ENGINE_ARTIFACT_DIR>/<artifact.path>
#   returns:::
#     * Artifact ID
#
# `artifacts_matching`::
#   positionals:::
#     1. Regex pattern
#   returns:::
#     * Artifact IDs which match (1)
#
# `filter_artifacts_opt_eq_val`::
#   positionals:::
#     1. Set of Artifact IDs
#     2. Option name
#     3. Option value
#   returns:::
#     * Subset of (1) for which any value of (2) is equal to (3)
#
# `filter_artifacts_opt_ne_val`::
#   positionals:::
#     1. Set of Artifact IDs
#     2. Option name
#     3. Option value
#   returns:::
#     * Subset of (1) for which no value of (2) is equal to (3)
#
# == Context ==
#
# |===================================
# | Name                 | Description
# | PIPELINE_OPTS_PATHS  | Quoted list of absolute paths to .conf files in ENGINE_PIPELINE_DIR
# | SUBJECT_OPTS_PATHS   | Quoted list of absolute paths to .conf files in SUBJECT_DIR
# | LOCAL_OPTS_PATHS     | Quoted list of absolute paths to .conf files in ENGINE_LOCAL_DIR
# | OPTSFILE_PATHS       | Quoted list of absolute paths to all .conf files
# | OPT_CONTEXT          | List of environment variable definitions required by statement selection interface
# | STMT_SELECT          | Command to execute statement selection interface
# |===================================

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

opt_pipeline_var   = $(shell $(STMT_SELECT) -t pipelineOpts -c values -r last $(foreach key,$(1),-k '$(key)') $(if $(2),-p '$(2)') $(OPTSFILE_PATHS))
opt_pipeline_list  = $(shell $(STMT_SELECT) -t pipelineOpts -c values -r all  $(foreach key,$(1),-k '$(key)') $(OPTSFILE_PATHS))
opt_artifact_var   = $(shell $(STMT_SELECT) -t artifactOpts -c values -r last $(foreach aid,$(1),-a '$(aid)') $(foreach key,$(2),-k '$(key)') $(if $(3),-p '$(3)') $(OPTSFILE_PATHS))
opt_artifact_list  = $(shell $(STMT_SELECT) -t artifactOpts -c values -r all  $(foreach aid,$(1),-a '$(aid)') $(foreach key,$(2),-k '$(key)') $(OPTSFILE_PATHS))
artifact_path      = $(shell $(STMT_SELECT) -t artifactRefs -c values -r last $(foreach key,$(1),-k '$(key)') $(OPTSFILE_PATHS))
artifact_frompath  = $(shell $(STMT_SELECT) -t artifactRefs -c keys   -r last $(foreach val,$(1),-v '$(val)') $(OPTSFILE_PATHS))
artifacts_matching = $(shell $(STMT_SELECT) -t artifactRefs -c keys   -r all  $(foreach key,$(1),-k '$(key)') $(OPTSFILE_PATHS))

filter_artifacts_opt_eq_val = $(sort $(basename $(shell $(STMT_SELECT) -t artifactOpts -c keys -r all $(foreach aid,$(1),-a '$(aid)') $(foreach key,$(2),-k '$(key)') $(foreach val,$(3),-v '$(val)') $(OPTSFILE_PATHS))))
filter_artifacts_opt_ne_val = $(sort $(filter-out $(call filter_artifacts_opt_eq_val,$(1),$(2),$(3)),$(1)))

# Internal

list_optsfiles = $(shell find '$(1)' -mindepth 1 -maxdepth 1 -name '*.conf' -exec basename {} \;)
