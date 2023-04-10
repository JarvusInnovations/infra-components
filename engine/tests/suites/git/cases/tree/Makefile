include ../../../../content/mk/case.mk
include $(MK)/tech/git.mk

CONTENT_PATH := $(call artifact_path,tree-content)
GIT_IDENT    := $(and $(shell git config user.name),$(shell git config user.email))

subject:
ifeq ($(GIT_IDENT),)
	$(call test_skip_opt,git config user)
else
	test `stat -c %s $(CONTENT_PATH)/data.txt` -gt 0 # assert data file exists and is non-empty
	test -z "`$(GIT) status --porcelain=v1`" # assert working tree index was not changed
endif
