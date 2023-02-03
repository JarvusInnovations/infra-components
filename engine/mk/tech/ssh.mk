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

ifeq ($(SSH),)
SSH        := ssh
endif

ifeq ($(SSH_CONFIG),)
SSH_CONFIG := $(call opt_pipeline_var,sshConfig)
endif

ifneq ($(SSH_CONFIG),)
SSH        += -F '$(SSH_CONFIG)'
endif

GIT_SSH_COMMAND := $(SSH)
export GIT_SSH_COMMAND
