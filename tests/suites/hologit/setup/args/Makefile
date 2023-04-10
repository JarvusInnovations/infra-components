include ../../../../content/mk/case.mk
HOLOGIT_ARTIFACTS := $(call artifacts_matching,arg-.+)
include $(MK)/tech/hologit.mk

REPO_DIR        := $(call artifact_path,args-repo)
GIT_IDENT       := $(and $(shell git config user.name),$(shell git config user.email))
TEST_COMMIT_MSG := commit message body
export TEST_COMMIT_MSG

subject:
ifeq ($(GIT_IDENT),)
	$(call test_skip_opt,git config user)
else
ifeq ($(call test_find_cmd,git-holo),)
	$(call test_skip_cmd,git-holo)
else
	if echo $(HOLOGIT_ARTIFACTS) | grep hologit-excluded; then false; else true; fi # assert hologit-excluded is not in HOLOGIT_ARTIFACTS
	$(call run_step,setup-git-repo)
	$(call run_step,hologit-artifacts-produce)
endif
endif

setup-git-repo:
	mkdir -pv '$(REPO_DIR)'
	cp -r '$(ENGINE_PROJECT_DIR)'/content/hologit/. '$(REPO_DIR)'
	$(GIT) init
	$(GIT) add -A
	if [ "`$(GIT) status --porcelain=v1`" ]; then $(GIT) commit -m "initial commit"; fi
