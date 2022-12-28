include ../../../../content/mk/case.mk

assert_no_relative = $(if $(shell git -C '$(shell git rev-parse --show-toplevel)' grep relative-to -- $(1)),$(error $(1): relatve path resolution forbidden))

subject:
	$(call assert_no_relative,mk/config.mk)
	$(call assert_no_relative,mk/engine.mk)
	$(call assert_no_relative,mk/pipeline.mk)
	$(call assert_no_relative,mk/stage.mk)
	$(call assert_no_relative,mk/subject.mk)
