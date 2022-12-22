include ../../../../content/mk/case.mk

ARTIFACT_IDS := $(call artifact_match,tests/.+)

stage: $(ARTIFACT_IDS)

$(ARTIFACT_IDS):
	printf '$(call artifact_var,$@,testsContent)' > '$(call artifact_path,$@)'

.PHONY: $(ARTIFACT_IDS)
