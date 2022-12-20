include ../../../../../mk/subject.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/helm.mk

stage:
ifneq ($(KUBECONFIG),)
	$(HELM) uninstall $(HELM_RELEASE)
	$(KUBECTL) delete ns $(HELM_NAMESPACE)
else
	$(test_skip_env,kubeconfig)
endif
