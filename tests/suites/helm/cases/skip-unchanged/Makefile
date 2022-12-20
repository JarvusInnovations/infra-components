include ../../../../content/mk/case.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/helm.mk

stage:
ifneq ($(KUBECONFIG),)
	$(if $(helm_release_changed),$(error FAIL: helm/skip-unchanged: helm_release_changed=$(helm_release_changed), helm_diff_status=$(helm_diff_status)),$(info OK: helm/skip-unchanged))
else
	$(test_skip_env,kubeconfig)
endif
