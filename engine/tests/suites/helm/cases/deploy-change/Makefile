include ../../../../../mk/subject.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/helm.mk

stage:
ifneq ($(KUBECONFIG),)
	$(if $(helm_release_changed),$(info OK: helm/deploy-change),$(error FAIL: helm/deploy-change: helm_release_changed=$(helm_release_changed), helm_diff_status=$(helm_diff_status)))
else
	$(test_skip_env,kubeconfig)
endif
