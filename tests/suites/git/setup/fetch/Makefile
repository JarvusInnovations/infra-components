include ../../../../content/mk/case.mk
include $(MK)/tech/git.mk

REPO_PATH := $(call artifact_path,fetch-repo)

subject:
	mkdir -pv $(REPO_PATH)
	$(GIT) init
	if ! $(GIT) rev-list HEAD --; then $(GIT) commit --allow-empty --message="a fetchable commit"; fi
	$(call run_step,git-fetch-artifacts-produce)
