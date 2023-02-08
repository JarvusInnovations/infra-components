include ../../../../content/mk/case.mk

ifeq ($(GH_PR_URL),)
GH_PR_URL := $(call opt_pipeline_var,ghPullRequest)
endif

include $(MK)/tech/gh.mk

subject:
ifneq ($(GH_PR_ENVVAR),)
	$(call run_step,gh-pr-artifacts-publish)
else
	$(call skip_test_opt,ghPullRequest)
endif
