include ../../../../content/mk/case.mk

COMMENT_ARTIFACTS      := $(call filter_artifacts_var_eq_val,$(call artifacts_matching,.+),producer,setup)
COMMENT_ARTIFACT_PATHS := $(foreach id,$(COMMENT_ARTIFACTS),$(call artifact_path,$(id)))

subject:
	rm -vf $(COMMENT_ARTIFACT_PATHS)
