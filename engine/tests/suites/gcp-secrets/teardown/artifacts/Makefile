include ../../../../content/mk/case.mk
include $(MK)/tech/gcloud.mk
include $(MK)/tech/gcp-secrets.mk

subject:
ifneq ($(GCP_PROJECT),)
	$(GCLOUD) secrets delete '$(call opt_artifact_var,tests-gcp-secrets,gcpSecretId)'
	$(call run_step,gcp-secrets-artifacts-clean)
else
	$(call test_skip_opt,gcpProject)
endif
