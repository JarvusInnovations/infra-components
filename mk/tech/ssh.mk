# = ssh =
#
# OpenSSH remote management client
#
# == Options ==
#
# |================================================
# | Name          | Reference Type    | Description
# | sshConfig     | var               | Path to ssh_config file
# |================================================

SSH        ?= ssh
SSH_CONFIG ?= $(call opt_pipeline_var,sshConfig)

ifneq ($(SSH_CONFIG),)
SSH += -F '$(SSH_CONFIG)'
endif

GIT_SSH_COMMAND := $(SSH)
export GIT_SSH_COMMAND
