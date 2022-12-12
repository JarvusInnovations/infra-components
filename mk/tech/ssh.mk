#
# Config:
#
# [env "<env-name>"]
# sshConfig = <env-subpath>

SSH        ?= ssh
SSH_CONFIG ?= $(call env_config_path,sshConfig)

ifneq ($(SSH_CONFIG),)
SSH += -F $(shell realpath '$(SSH_CONFIG)')
endif

GIT_SSH_COMMAND := $(SSH)
export GIT_SSH_COMMAND
