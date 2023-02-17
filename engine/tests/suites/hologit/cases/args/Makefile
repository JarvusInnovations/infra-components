include ../../../../content/mk/case.mk
include $(MK)/tech/git.mk

ARG_COMMIT_MSG_ARTIFACT := arg-commit-message
ARGS_REF_ARTIFACT       := arg-ref

subject:
	$(call run_step,verify-commit-message)
	$(call run_step,verify-ref)

verify-commit-message:
	test 'commit message subject' = "`$(GIT) log -1 --format=%s $(call opt_artifact_var,$(ARG_COMMIT_MSG_ARTIFACT),hologitCommitTo)`"
	test "`printf 'commit message body\n\n'`" = "`$(GIT) log -1 --format=%b $(call opt_artifact_var,$(ARG_COMMIT_MSG_ARTIFACT),hologitCommitTo)`"

verify-ref:
	test "`$(GIT) rev-list -1 $(call opt_artifact_var,$(ARGS_REF_ARTIFACT),hologitBaseRef)`" = "`$(GIT) log -1 --format=%P $(call opt_artifact_var,$(ARGS_REF_ARTIFACT),hologitCommitTo) | awk '{print $$2}'`"
