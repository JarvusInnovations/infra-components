include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/helm.mk

subject:
ifneq ($(KUBECONFIG),)
	$(call run_step,helm-deploy)
else
	$(call test_skip_opt,kubeconfig)
endif
