ENGINE_LOCAL_DIR := $(shell realpath ../../../../environments/core)
include ../../../../content/mk/case.mk

subject:
	$(info INFO: GIT=$(GIT))
	test '$(call subject_config,configPipeline)' = fromPipeline # '<configPipeline>'
	test '$(call subject_config,configSubject)' = fromSubject # '<configSubject>'
	test '$(call subject_config,configEnv)' = fromEnv # '<configEnv>'
	stat '$(call subject_config_path,verifyProjectPath)' # '<verifyProjectPath>'
	stat '$(call env_config_path,verifyEnvPath)' # '<verifyEnvPath>'
