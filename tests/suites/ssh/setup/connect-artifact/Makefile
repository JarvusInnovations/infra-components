include ../../../../content/mk/case.mk
include $(MK)/tech/ssh.mk

VIRSH_DOMAIN ?= $(call subject_config,virshDomain)

ifneq ($(VIRSH_DOMAIN),)
include $(MK)/tech/virsh.mk
endif

SSH_CONFIG_ARTIFACT = $(call artifacts_filter_equalto,$(call artifacts_matching,.+),producer,connect-artifact-setup)

subject:
ifneq ($(SSH_CONFIG),)
ifneq ($(VIRSH_DOMAIN),)
subject: virsh-domain-start
endif
subject: ssh-config-artifact
ssh-config-artifact:
	cp -v '$(SSH_CONFIG)' '$(call artifact_path,$(SSH_CONFIG_ARTIFACT))'
.PHONY: ssh-config-artifact
else
	$(call test_skip_env,sshConfigPath)
endif
