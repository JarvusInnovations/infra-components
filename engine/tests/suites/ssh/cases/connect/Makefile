include ../../../../content/mk/case.mk

stage:
ifneq ($(SSH_CONFIG),)
	$(SSH) test-machine true
else
	$(call test_skip_env,sshConfigPath)
endif
