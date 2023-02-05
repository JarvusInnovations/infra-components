include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/terraform.mk

subject:
ifneq ($(KUBE_CONFIG_PATH),)
	$(TERRAFORM) destroy -auto-approve
	rm -vf '$(TERRAFORM_ROOT_MODULE)'/*.tfstate*
	$(call run_step,terraform-clean)
else
	$(call test_skip_opt,kubeconfig)
endif
