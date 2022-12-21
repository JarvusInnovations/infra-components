# = virsh =
#
# The libvirt CLI interface
#
# == Inputs ==
#
# |================================================
# | Section       | Name              | Description
# | engineSubject | virshDomain       | The name of the target domain
# | engineSubject | virshBaseSnapshot | The name of an existing snapshot for `virshDomain`
# |================================================
#
# == Steps ==
#
# `virsh-domain-start`::
#   description:::
#     Starts the specified domain
#   inputs:::
#     * engineSubject.virshDomain
#
# `virsh-domain-stop`::
#   description:::
#     Stops the specified domain
#   inputs:::
#     * engineSubject.virshDomain
#
#  `virsh-domain-reset`::
#    description:::
#      Reverts the specified domain to the specified snapshot
#    inputs:::
#     * engineSubject.virshDomain
#     * engineSubject.virshBaseSnapshot
#
# == Methods ==
#
# `virsh_domain_running`::
#   inputs:::
#     * engineSubject.virshDomain
#   return:::
#     * Non-empty if the specified domain is in a "running" state
#     * Empty if in any other state

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
