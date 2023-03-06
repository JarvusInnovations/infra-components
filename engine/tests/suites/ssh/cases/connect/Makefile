include ../../../../content/mk/case.mk
include $(MK)/tech/ssh.mk

subject:
ifneq ($(SSH_CONFIG),)
	$(SSH) tests-connect true
else
	$(call test_skip_opt,sshConfig)
endif
