include ../../../../content/mk/case.mk

ARTIFACT_IDS := $(call artifacts_filter_equalto,$(call artifacts_matching,.+),producer,tests)

subject: $(ARTIFACT_IDS)
ifeq ($(ARTIFACT_IDS),)
	$(error FAIL: ARTIFACT_IDS is empty)
endif

$(ARTIFACT_IDS):
	$(if $(filter skipped,$(ARTIFACT_IDS)),$(error FAIL: "skipped" appeared in ARTIFACT_IDS=$(ARTIFACT_IDS)),$(info INFO: ARTIFACT_IDS=$(ARTIFACT_IDS)))
	printf '$(call artifact_var,$@,testsContent)' > '$(call artifact_path,$@)'

.PHONY: $(ARTIFACT_IDS)
