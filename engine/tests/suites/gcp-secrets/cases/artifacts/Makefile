include ../../../../content/mk/case.mk
include $(MK)/tech/gcloud.mk
include $(MK)/tech/gcp-secrets.mk

subject:
ifneq ($(GCP_PROJECT),)
	$(call run_step,gcp-secrets-artifacts-produce)
	test "`cat '$(call artifact_path,tests-gcp-secrets)'`" = 'secret data'
else
	$(call test_skip_opt,gcpProject)
endif
