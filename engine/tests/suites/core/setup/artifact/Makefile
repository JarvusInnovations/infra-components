include ../../../../content/mk/case.mk

ARTIFACT_IDS := $(call artifacts_using_producer,tests)

stage: $(ARTIFACT_IDS)
ifeq ($(ARTIFACT_IDS),)
	$(error FAIL: ARTIFACT_IDS is empty)
endif

$(ARTIFACT_IDS):
	printf '$(call artifact_var,$@,testsContent)' > '$(call artifact_path,$@)'

.PHONY: $(ARTIFACT_IDS)
