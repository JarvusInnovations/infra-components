# = virsh =
#
# The libvirt CLI interface
#
# == Options ==
#
# |======================================================
# | Name                | Reference Type    | Description
# | virshDomain         | var               | The name of the target domain
# | virshBaseSnapshot   | var               | The name of an existing snapshot for `virshDomain`
# |======================================================
#
# == Steps ==
#
# `virsh-domain-start`::
#   description:::
#     Starts the specified domain
#   inputs:::
#     * virshDomain
#
# `virsh-domain-stop`::
#   description:::
#     Stops the specified domain
#   inputs:::
#     * virshDomain
#
#  `virsh-domain-reset`::
#    description:::
#      Reverts the specified domain to the specified snapshot
#    inputs:::
#     * virshDomain
#     * virshBaseSnapshot
#
# == Methods ==
#
# `virsh_domain_running`::
#   inputs:::
#     * virshDomain
#   return:::
#     * Non-empty if `virshDomain` is in a "running" state
#     * Empty if `virshDomain` in any other state

ifeq ($(VIRSH),)
VIRSH               := virsh
endif

ifeq ($(VIRSH_DOMAIN),)
VIRSH_DOMAIN        := $(call opt_pipeline_var,virshDomain)
endif

ifeq ($(VIRSH_BASE_SNAPSHOT),)
VIRSH_BASE_SNAPSHOT := $(call opt_pipeline_var,virshBaseSnapshot)
endif

virsh_domain_running = $(filter running,$(shell $(VIRSH) domstate '$(VIRSH_DOMAIN)'))

virsh-domain-start:
	$(if $(virsh_domain_running),,$(VIRSH) start '$(VIRSH_DOMAIN)')

virsh-domain-stop:
	$(if $(virsh_domain_running),$(VIRSH) destroy '$(VIRSH_DOMAIN)')

virsh-domain-reset:
	$(VIRSH) snapshot-revert --domain '$(VIRSH_DOMAIN)' --snapshotname '$(VIRSH_BASE_SNAPSHOT)'
