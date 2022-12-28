include ../../../../content/mk/case.mk
include $(MK)/tech/virsh.mk

subject:
ifneq ($(VIRSH_DOMAIN),)
	$(call run_step,virsh-domain-start)
	$(call run_step,virsh-domain-stop)
ifneq ($(VIRSH_BASE_SNAPSHOT),)
	$(call run_step,virsh-domain-start)
	$(call run_step,virsh-domain-reset)
	$(call run_step,virsh-domain-stop)
else
	$(call test_skip_subject,virshBaseSnapshot)
endif
else
	$(call test_skip_subject,virshDomain)
endif
