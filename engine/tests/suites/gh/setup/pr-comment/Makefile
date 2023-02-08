include ../../../../content/mk/case.mk

COMMENT_ARTIFACTS      := $(call filter_artifacts_opt_eq_val,$(call artifacts_matching,.+),producer,setup)
COMMENT_ARTIFACT_PATHS := $(foreach id,$(COMMENT_ARTIFACTS),$(call artifact_path,$(id)))

subject: $(COMMENT_ARTIFACT_PATHS)
$(COMMENT_ARTIFACT_PATHS):
	printf '$(or $(call opt_artifact_var,$(call artifact_frompath,$@),ghCommentContent),foo)\n' > '$@'

.PHONY: $(COMMENT_ARTIFACTS)
