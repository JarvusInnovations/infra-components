include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/helm.mk

subject:
ifneq ($(KUBECONFIG),)
	$(HELM) uninstall $(HELM_RELEASE)
	$(KUBECTL) delete ns $(HELM_NAMESPACE)
else
	$(test_skip_env,kubeconfig)
endif
