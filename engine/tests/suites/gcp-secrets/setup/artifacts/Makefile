include ../../../../content/mk/case.mk
include $(MK)/tech/gcloud.mk
include $(MK)/tech/gcp-secrets.mk

subject:
ifneq ($(GCP_PROJECT),)
	echo 'secret data' > '$(call artifact_path,tests-gcp-secrets)'
	$(call run_step,gcp-secrets-artifacts-publish)
	$(call run_step,gcp-secrets-artifacts-clean)
else
	$(call test_skip_opt,gcpProject)
endif
