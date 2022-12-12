include ../../../../../mk/subject.mk
include $(MK)/tech/virsh.mk
include $(ENGINE_SYSTEM)/tests/content/mk/case.mk

stage:
ifneq ($(VIRSH_DOMAIN),)
	$(MAKE) virsh-domain-start
	$(MAKE) virsh-domain-stop
ifneq ($(VIRSH_BASE_SNAPSHOT),)
	$(MAKE) virsh-domain-start
	$(MAKE) virsh-domain-reset
	$(MAKE) virsh-domain-stop
else
	$(call test_skip_subject,virshBaseSnapshot)
endif
else
	$(call test_skip_subject,virshDomain)
endif
