include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/helm.mk

subject:
ifneq ($(KUBECONFIG),)
	$(HELM) uninstall $(HELM_RELEASE)
else
	$(test_skip_opt,kubeconfig)
endif
