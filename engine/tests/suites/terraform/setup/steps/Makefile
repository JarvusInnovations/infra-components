include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/terraform.mk

subject:
ifneq ($(KUBE_CONFIG_PATH),)
	$(call run_step,terraform-plan)
	$(call run_step,terraform-apply)
	test 0 -eq `$(TERRAFORM) plan -detailed-exitcode $(TERRAFORM_VAR_FILES) >/dev/null; echo $$?` # assert no change after first apply
else
	$(call test_skip_opt,kubeconfig)
endif
