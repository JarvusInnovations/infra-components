include ../../../../content/mk/case.mk
include $(MK)/tech/kustomize.mk

subject:
ifeq ($(KUBECONFIG),)
	$(call test_skip_opt,kubeconfig)
else
	$(call run_step,kustomize-apply)
endif
