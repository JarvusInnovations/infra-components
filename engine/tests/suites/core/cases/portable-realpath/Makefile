include ../../../../content/mk/case.mk


assert_portable_realpath = if git -C '$(ENGINE_SYSTEM_DIR)' grep -n -E -- 'realpath[[:space:]]+-' $(1); then exit 1; else true; fi \# usage of realpath MUST be portable

subject:
	$(call assert_portable_realpath,mk/config.mk)
	$(call assert_portable_realpath,mk/engine.mk)
	$(call assert_portable_realpath,mk/pipeline.mk)
	$(call assert_portable_realpath,mk/stage.mk)
	$(call assert_portable_realpath,mk/subject.mk)
	$(call assert_portable_realpath,Makefile)
