include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/terraform.mk

subject:
ifneq ($(KUBE_CONFIG_PATH),)
	test 2 -eq `$(TERRAFORM) plan -detailed-exitcode $(TERRAFORM_VAR_FILES) >/dev/null; echo $$?` # assert pending change
	$(call run_step,terraform-apply)
else
	$(call test_skip_opt,kubeconfig)
endif
