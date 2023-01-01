include ../../../../content/mk/case.mk

SSH_CONFIG_ARTIFACT      = $(call artifacts_filter_equalto,$(call artifacts_matching,.+),producer,connect-artifact-setup)
SSH_CONFIG_ARTIFACT_PATH = $(call artifact_path,$(SSH_CONFIG_ARTIFACT))

subject:
	$(if $(SSH_CONFIG_ARTIFACT_PATH),rm -f -v '$(SSH_CONFIG_ARTIFACT_PATH)')
