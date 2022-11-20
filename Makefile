ENGINE_ENV_DIR ?= $(shell git -C .. rev-parse --absolute-git-dir)/engine

help:
	@echo
	@echo 'Actions:                              '
	@echo '                                      '
	@echo '    init - setup a new engine project '
	@echo

init: $(ENGINE_ENV_DIR)

$(ENGINE_ENV_DIR):
	mkdir -p '$@'

.PHONY: help
.PHONY: init
