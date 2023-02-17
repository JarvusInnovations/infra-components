include ../../../../content/mk/case.mk
include $(MK)/tech/git.mk

subject:
	if $(GIT) ls-tree -r $(shell cat $(call artifact_path,tree-id)); then true; else false; fi # assert hologit tree exists
	if $(GIT) ls-tree -r $(shell cat $(call artifact_path,tree-id)) | grep \\.holo; then false; else true; fi # assert hologit tree is valid
