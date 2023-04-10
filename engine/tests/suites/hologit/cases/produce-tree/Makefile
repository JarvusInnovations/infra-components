include ../../../../content/mk/case.mk
include $(MK)/tech/git.mk

subject:
ifeq ($(call test_find_cmd,git-holo),)
	$(call test_skip_cmd,git-holo)
else
	if $(GIT) ls-tree -r $(shell cat $(call artifact_path,tree-id)); then true; else false; fi # assert hologit tree exists
	if $(GIT) ls-tree -r $(shell cat $(call artifact_path,tree-id)) | grep \\.holo; then false; else true; fi # assert hologit tree is valid
endif
