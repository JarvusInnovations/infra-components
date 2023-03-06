include ../../../../content/mk/case.mk

VIRSH_DOMAIN ?= $(call opt_pipeline_var,virshDomain)

ifneq ($(VIRSH_DOMAIN),)
include $(MK)/tech/virsh.mk
subject: virsh-domain-start
endif
