include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/terraform.mk

subject:
ifneq ($(KUBE_CONFIG_PATH),)
	grep -n -E '^Plan: [0-9]+ to add, [0-9]+ to change, [0-9]+ to destroy.' $(TERRAFORM_PLAN_ARTIFACT_PATHS) # assert artifact shows changes
	test 2 -eq `$(TERRAFORM) plan -detailed-exitcode $(TERRAFORM_VAR_FILE_ARGS) >&2; echo $$?` # assert pending change
	$(call run_step,terraform-apply)
else
	$(call test_skip_opt,kubeconfig)
endif
