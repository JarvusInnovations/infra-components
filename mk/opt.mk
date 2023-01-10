OPT_CONTEXT            = \
  ENGINE_ENV='$(ENGINE_ENV)'                     \
  ENGINE_PROJECT_DIR='$(ENGINE_PROJECT_DIR)'     \
  ENGINE_LOCAL_DIR='$(ENGINE_LOCAL_DIR)'         \
  ENGINE_ARTIFACTS_DIR='$(ENGINE_ARTIFACTS_DIR)' \
  PIPELINE_NAME=$(PIPELINE_NAME)                 \
  SUBJECT_NAME=$(SUBJECT_NAME)                   \
  SUBJECT_DIR='$(SUBJECT_DIR)'
STMT_SELECT = $(OPT_CONTEXT) $(LIB)/sh/stmt-select.sh

list_optsfiles         = $(shell find '$(1)' -mindepth 1 -maxdepth 1 -name '*.conf' -exec basename {} \;)

PIPELINE_OPTS_PATHS = $(foreach optsfile,$(call list_optsfiles,$(shell realpath ../..)),'$(shell realpath ../..)/$(optsfile)')
SUBJECT_OPTS_PATHS  = $(foreach optsfile,$(call list_optsfiles,$(shell realpath .)),'$(shell realpath .)/$(optsfile)')
LOCAL_OPTS_PATHS    = $(foreach optsfile,$(call list_optsfiles,$(ENGINE_LOCAL_DIR)),'$(ENGINE_LOCAL_DIR)/$(optsfile)')
OPTSFILE_PATHS      = $(PIPELINE_OPTS_PATHS) $(SUBJECT_OPTS_PATHS) $(LOCAL_OPTS_PATHS)

opt_vals            =
opt_keys            =
opt_equalto_path    =
opt_equalto_scalar  =
opt_has_path        =
opt_has_scalar      =
