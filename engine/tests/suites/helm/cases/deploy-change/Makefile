include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/helm.mk

subject:
ifneq ($(KUBECONFIG),)
	$(if $(helm_release_changed),$(info OK: helm/deploy-change),$(error FAIL: helm/deploy-change: helm_release_changed=$(helm_release_changed), helm_diff_status=$(helm_diff_status), HELM_VALUES_ARGS=$(HELM_VALUES_ARGS)))
else
	$(call test_skip_opt,kubeconfig)
endif
