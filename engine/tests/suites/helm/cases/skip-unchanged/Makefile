include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/helm.mk

subject:
ifneq ($(KUBECONFIG),)
	$(if $(helm_release_changed),$(error FAIL: helm/skip-unchanged: helm_release_changed=$(helm_release_changed), helm_diff_status=$(helm_diff_status)),$(info OK: helm/skip-unchanged))
else
	$(call test_skip_opt,kubeconfig)
endif
