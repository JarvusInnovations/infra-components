ENGINE_LOCAL_DIR := $(shell realpath ../../../../environments/core)
include ../../../../content/mk/case.mk

STMT_SELECT = $(OPT_CONTEXT) dash $(LIB)/sh/stmt-select.sh

subject:
	$(call run_step,test-stmt-select)
	$(call run_step,test-artifacts)
	$(call run_step,test-pipeline-opts)
	$(call run_step,test-filter-artifacts)

test-stmt-select:
	LIB=$(LIB) $(OPT_CONTEXT) dash $(ENGINE_PROJECT_DIR)/content/core/test-stmt-select.sh $(OPTSFILE_PATHS)

test-artifacts:
	test $(call path_relto,$(ENGINE_ARTIFACTS_DIR),.)/baz.txt = $(call artifact_path,baz) # artifact_path(baz)
	test baz = $(call artifact_frompath,$(call path_relto,$(ENGINE_ARTIFACTS_DIR),.)/baz.txt) # artifact_frompath({ENGINE_ARTIFACTS_DIR}/baz.txt)
	test baz = $(filter baz,$(call artifacts_matching,.+)) # artifacts_matching
	test setup/opt = $(call opt_artifact_var,baz,producer) # opt_artifact_var(baz,producer)
	test tests-publisher-2 = `printf '%s\n' '$(call opt_artifact_list,baz,publishersItem)' | awk '{print $$2}'` # opt_artifact_list(baz,publishersItem)
	test '$(shell $(LIB)/sh/path-relto.sh $(ENGINE_LOCAL_DIR) / | sed s,^.,,)/baz-input.conf' = '$(call opt_artifact_var,baz,config,abs)' # opt_artifact_var(baz,config,abs)
	test 'tests' = '$(call opt_artifact_var,foo,path producer)' # opt_artifact_var(foo,path producer)

test-pipeline-opts:
	test '$(shell $(LIB)/sh/path-relto.sh $(ENGINE_ARTIFACTS_DIR) / | sed s,^.,,)/baz.txt' = '$(call opt_pipeline_var,optBaz,abs)' # opt_pipeline_var(optBaz,abs)
	test bars-item-2 = `printf '%s\n' '$(call opt_pipeline_list,optBarsItem)' | awk '{print $$1}'` # opt_pipeline_list(optBarsItem)
	test foos-item-1 = `printf '%s\n' '$(call opt_pipeline_list,optBazsItem optFoosItem)' | awk '{print $$1}'` # opt_pipeline_list(optBazsItem optFoosItem)
	test 'bazs-item-3' = `printf '%s\n' '$(call opt_pipeline_list,optBazsItem optFoosItem)' | awk '{print $$NF}'` # opt_pipeline_list(optBazsItem optFoosItem)

test-filter-artifacts:
	test 'bar foo skipped' = '$(call filter_artifacts_opt_eq_val,$(call artifacts_matching,.+),producer,tests)' # filter_artifacts_opt_eq_val(*,producer,tests)
	test baz = $(call filter_artifacts_opt_ne_val,$(call artifacts_matching,.+),producer,tests) # filter_artifacts_opt_ne_val(*,producer,tests)

.PHONY: test-stmt-select
.PHONY: test-artifacts
