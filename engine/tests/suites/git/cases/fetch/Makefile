include ../../../../content/mk/case.mk
include $(MK)/tech/git.mk

subject:
	$(GIT) show-ref refs/heads/$(call opt_artifact_var,$(GIT_FETCH_ARTIFACTS),gitRef)
	test '+' = '$(call git_force_flag,gitForceFetch,fetch-branch)' # assert fetch artifact uses force flag
