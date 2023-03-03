include ../../../../content/mk/case.mk
include $(MK)/tech/git.mk

CONTENT_PATH := $(call artifact_path,tree-content)

subject:
	test `stat -c %s $(CONTENT_PATH)/data.txt` -gt 0 # assert data file exists and is non-empty
	test -z "`$(GIT) status --porcelain=v1`" # assert working tree index was not changed
