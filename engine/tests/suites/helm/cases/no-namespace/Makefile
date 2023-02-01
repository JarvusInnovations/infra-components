include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/helm.mk

subject:
ifneq ($(KUBECONFIG),)
	$(HELM) status $(HELM_RELEASE) | tee /dev/stderr | grep 'NAMESPACE: default'
else
	$(call test_skip_opt,kubeconfig)
endif
