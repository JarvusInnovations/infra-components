ENGINE_LOCAL_DIR := $(shell realpath '../../../../content/core/local dir whitespace')
include ../../../../content/mk/case.mk

subject:
	test '$(call opt_pipeline_var,pass)' = true # opt_pipeline_var(pass) = true
