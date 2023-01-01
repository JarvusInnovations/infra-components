include ../../../../content/mk/case.mk
SSH_CONFIG := $(call env_config_artifact,sshConfigArtifact)
include $(MK)/tech/ssh.mk

subject:
ifneq ($(call env_config_path,sshConfigPath),)
	$(SSH) tests-connect true
else
	$(call test_skip_env,sshConfigPath)
endif
