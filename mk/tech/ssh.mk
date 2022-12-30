#
# Config:
#
# [engineEnv "<env-name>"]
# sshConfigPath = <env-subpath>
# = ssh =
#
# OpenSSH remote management client
#
# == Inputs ==
#
# |================================================
# | Section       | Name              | Description
# | engineEnv     | sshConfigPath     | Env subpath to ssh_config file
# |================================================

SSH        ?= ssh
SSH_CONFIG ?= $(call env_config_path,sshConfigPath)

ifneq ($(SSH_CONFIG),)
SSH += -F '$(SSH_CONFIG)'
endif

GIT_SSH_COMMAND := $(SSH)
export GIT_SSH_COMMAND
