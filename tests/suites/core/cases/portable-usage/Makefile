include ../../../../content/mk/case.mk

assert_noopt = if git -C '$(ENGINE_SYSTEM_DIR)' grep -n -E -- '$(1)[[:space:]]+-' $(2); then exit 1; else true; fi \# MUST NOT use options with $(1)

subject: assert-portable-realpath

assert-portable-realpath:
	$(call assert_noopt,realpath,mk/config.mk)
	$(call assert_noopt,realpath,mk/engine.mk)
	$(call assert_noopt,realpath,mk/pipeline.mk)
	$(call assert_noopt,realpath,mk/stage.mk)
	$(call assert_noopt,realpath,mk/subject.mk)
	$(call assert_noopt,realpath,Makefile)

.PHONY: assert-portable-realpath
