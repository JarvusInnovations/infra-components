include ../../../../../mk/subject.mk
include $(MK)/tech/ssh.mk
include $(MK)/test.mk

stage:
ifneq ($(SSH_CONFIG),)
	$(SSH) test-machine true
else
	$(call test_skip,sshConfig)
endif
