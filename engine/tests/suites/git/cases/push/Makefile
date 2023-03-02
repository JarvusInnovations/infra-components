include ../../../../content/mk/case.mk
include $(MK)/tech/git.mk

subject:
	$(GIT) show-ref refs/heads/$(call opt_artifact_var,$(GIT_PUSH_ARTIFACTS),gitPushRef)
	test '' = '$(call git_force_flag,gitForcePush,push-branch)' # assert push artifact does not use force flag
