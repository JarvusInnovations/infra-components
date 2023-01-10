ENGINE_LOCAL_DIR := $(shell realpath ../../../../environments/core)
include ../../../../content/mk/case.mk

STMT_SELECT = $(OPT_CONTEXT) dash $(LIB)/sh/stmt-select.sh

subject:
	$(call run_step,test-stmt-select)

test-stmt-select:
	LIB=$(LIB) $(OPT_CONTEXT) dash $(ENGINE_PROJECT_DIR)/content/core/test-stmt-select.sh $(OPTSFILE_PATHS)

.PHONY: test-stmt-select
