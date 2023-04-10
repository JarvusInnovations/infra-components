include ../../../../content/mk/case.mk
include $(MK)/tech/kustomize.mk

subject:
ifeq ($(KUBECONFIG),)
	$(call test_skip_opt,kubeconfig)
else
	test '' = '$(call kustomize_changes_pending)' # kustomize_changes_pending should be empty
endif
