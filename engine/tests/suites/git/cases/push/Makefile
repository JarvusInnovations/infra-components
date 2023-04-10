include ../../../../content/mk/case.mk
include $(MK)/tech/git.mk

GIT_IDENT := $(and $(shell git config user.name),$(shell git config user.email))

subject:
ifeq ($(GIT_IDENT),)
	$(call test_skip_opt,git config user)
else
	$(GIT) show-ref refs/heads/$(call opt_artifact_var,$(GIT_PUSH_ARTIFACTS),gitPushRef)
	test '' = '$(call git_force_flag,gitForcePush,push-branch)' # assert push artifact does not use force flag
endif
