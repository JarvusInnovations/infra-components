include ../../../../content/mk/case.mk

assert_portable_realpath = $(if $(shell git -C '$(ENGINE_SYSTEM_DIR)' grep -E -- 'realpath[[:space:]]+-' $(1)),$(error $(1): non-portable use of realpath forbidden))

subject:
	$(call assert_portable_realpath,mk/config.mk)
	$(call assert_portable_realpath,mk/engine.mk)
	$(call assert_portable_realpath,mk/pipeline.mk)
	$(call assert_portable_realpath,mk/stage.mk)
	$(call assert_portable_realpath,mk/subject.mk)
	$(call assert_portable_realpath,Makefile)
