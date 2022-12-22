include ../../../../content/mk/case.mk

ARTIFACT_IDS := $(call subject_config,verifyArtifact,--get-all)

stage: $(ARTIFACT_IDS)

$(ARTIFACT_IDS):
	test "`cat '$(call artifact_path,$@)'`" = '$(call artifact_var,$@,testsContent)'

.PHONY: $(ARTIFACT_IDS)
