include ../../../../content/mk/case.mk
include $(MK)/tech/git.mk

REPO_PATH := $(call artifact_path,push-repo)

subject:
	mkdir -pv $(REPO_PATH)
	$(GIT) init
	if ! $(GIT) rev-list HEAD --; then $(GIT) commit --allow-empty --message="a pushable commit"; fi
	$(call run_step,git-push-artifacts-publish)
