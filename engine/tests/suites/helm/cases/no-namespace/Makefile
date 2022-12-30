include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/helm.mk

subject:
	$(HELM) status $(HELM_RELEASE) | tee /dev/stderr | grep 'NAMESPACE: default'
