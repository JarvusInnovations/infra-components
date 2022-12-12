#
# Config:
#
# [subject "<name>"]
# virshDomain       = <domain-name>
# virshBaseSnapshot = <snapshot-name>
VIRSH ?= virsh

VIRSH_DOMAIN        ?= $(call subject_config,virshDomain)
VIRSH_BASE_SNAPSHOT ?= $(call subject_config,virshBaseSnapshot)

virsh_domain_running = $(filter running,$(shell $(VIRSH) domstate '$(VIRSH_DOMAIN)'))

virsh-domain-start:
	$(if $(virsh_domain_running),,$(VIRSH) start '$(VIRSH_DOMAIN)')

virsh-domain-stop:
	$(if $(virsh_domain_running),$(VIRSH) destroy '$(VIRSH_DOMAIN)')

virsh-domain-reset:
	$(VIRSH) snapshot-revert --domain '$(VIRSH_DOMAIN)' --snapshotname '$(VIRSH_BASE_SNAPSHOT)'
