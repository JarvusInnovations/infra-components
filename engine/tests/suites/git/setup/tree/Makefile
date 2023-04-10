include ../../../../content/mk/case.mk
include $(MK)/tech/git.mk

REPO_PATH    := $(call artifact_path,tree-repo)
CONTENT_PATH := $(call artifact_path,tree-content)
GIT_IDENT    := $(and $(shell git config user.name),$(shell git config user.email))

subject:
ifeq ($(GIT_IDENT),)
	$(call test_skip_opt,git config user)
else
	mkdir -pv $(REPO_PATH)
	mkdir -pv $(CONTENT_PATH)
	test -e "$(REPO_PATH)/data.txt" || cp -r '$(ENGINE_PROJECT_DIR)'/content/git/tree/. '$(REPO_PATH)'
	$(GIT) init
	if [ "`$(GIT) status --porcelain=v1`" ]; then $(GIT) add -A; $(GIT) commit --message="add test data"; $(GIT) branch populated-data; fi
	truncate -s0 $(REPO_PATH)/data.txt
	if [ "`$(GIT) status --porcelain=v1`" ]; then $(GIT) add -A; $(GIT) commit --message="truncate data"; fi
	$(call run_step,git-tree-artifacts-produce)
endif
