include ../../../../content/mk/case.mk

ARTIFACT_IDS := $(call artifacts_using_producer,tests)

stage: $(ARTIFACT_IDS)

$(ARTIFACT_IDS):
	rm -vf '$(call artifact_path,$@)'

.PHONY: $(ARTIFACT_IDS)
