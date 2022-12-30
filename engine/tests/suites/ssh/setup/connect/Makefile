include ../../../../content/mk/case.mk

VIRSH_DOMAIN ?= $(call subject_config,virshDomain)

ifneq ($(VIRSH_DOMAIN),)
include $(MK)/tech/virsh.mk
endif

subject:
ifneq ($(VIRSH_DOMAIN),)
	$(call run_step,virsh-domain-start)
endif
