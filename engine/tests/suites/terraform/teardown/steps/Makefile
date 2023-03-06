include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/terraform.mk

subject:
ifneq ($(KUBE_CONFIG_PATH),)
	$(call run_step,terraform-plan-artifacts-clean)
	$(TERRAFORM) destroy -auto-approve $(TERRAFORM_VAR_FILE_ARGS)
	rm -vf '$(TERRAFORM_ROOT_MODULE)'/*.tfstate*
	$(call run_step,terraform-clean)
else
	$(call test_skip_opt,kubeconfig)
endif
