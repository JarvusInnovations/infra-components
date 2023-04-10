include ../../../../content/mk/case.mk
include $(MK)/tech/kustomize.mk

subject:
ifeq ($(KUBECONFIG),)
	$(call test_skip_opt,kubeconfig)
else
	test -n '$(call kustomize_changes_pending)' # kustomize_changes_pending should show pending changes
	$(call run_step,kustomize-apply)
endif
