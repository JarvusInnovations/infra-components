include ../../../../content/mk/case.mk

ARTIFACT_IDS := $(call artifact_match,tests/.+)

stage: $(ARTIFACT_IDS)

$(ARTIFACT_IDS):
	rm -vf '$(call artifact_path,$@)'

.PHONY: $(ARTIFACT_IDS)
