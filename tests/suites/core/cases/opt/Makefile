ENGINE_LOCAL_DIR := $(shell realpath ../../../../environments/core)
include ../../../../content/mk/case.mk

STMT_SELECT = $(OPT_CONTEXT) dash $(LIB)/sh/stmt-select.sh

subject:
	$(call run_step,test-stmt-select)
	$(call run_step,test-artifacts)

test-stmt-select:
	LIB=$(LIB) $(OPT_CONTEXT) dash $(ENGINE_PROJECT_DIR)/content/core/test-stmt-select.sh $(OPTSFILE_PATHS)

test-artifacts:
	test $(call path_relto,$(ENGINE_ARTIFACTS_DIR),.)/baz.txt = $(call artifact_path,baz) # artifact_path(baz)
	test baz = $(call artifact_frompath,$(call path_relto,$(ENGINE_ARTIFACTS_DIR),.)/baz.txt) # artifact_frompath({ENGINE_ARTIFACTS_DIR}/baz.txt)
	test baz = $(filter baz,$(call artifacts_matching,.+)) # artifacts_matching

.PHONY: test-stmt-select
.PHONY: test-artifacts
