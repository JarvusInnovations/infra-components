include ../../../../content/mk/case.mk

subject: assert-portable-realpath
subject: assert-portable-basename
subject: assert-portable-dirname

assert-portable-realpath:
	$(call assert_noopt,realpath,mk/config.mk)
	$(call assert_noopt,realpath,mk/engine.mk)
	$(call assert_noopt,realpath,mk/pipeline.mk)
	$(call assert_noopt,realpath,mk/stage.mk)
	$(call assert_noopt,realpath,mk/subject.mk)
	$(call assert_noopt,realpath,Makefile)

assert-portable-basename:
	$(call assert_noopt,basename)

assert-portable-dirname:
	$(call assert_noopt,dirname)

assert_noopt = if git -C '$(ENGINE_SYSTEM_DIR)' grep -n -E -- '$(1)[[:space:]]+-' $(2); then exit 1; else true; fi \# MUST NOT use options with $(1)

.PHONY: assert-portable-realpath
.PHONY: assert-portable-basename
.PHONY: assert-portable-dirname
