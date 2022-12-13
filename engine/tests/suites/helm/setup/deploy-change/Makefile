include ../../../../../mk/subject.mk
include $(MK)/tech/kube.mk
include $(MK)/tech/helm.mk

stage:
ifdef KUBECONFIG
	$(call run_step,helm-deploy)
else
	$(test_skip_env,kubeconfig)
endif
