# = kube =
#
# The Kubernetes control plane CLI interface
#
# == Inputs ==
#
# |================================================
# | Section       | Name              | Description
# | engineEnv     | kubeconfig        | Value to assign to `KUBECONFIG` environment variable
# |================================================
#
# == Methods ==
#
# `kube_ns_exists`::
#   positionals::
#     1. Namespace to check existence of
#   inputs:::
#     * engineEnv.kubeconfig
#   return:::
#     * Non-empty if the specified namespace exists
#     * Empty if the specified namespace does not exist

KUBECONFIG ?= $(call env_config,kubeconfig)
KUBECTL    ?= KUBECONFIG='$(KUBECONFIG)' kubectl

kube_ns_exists = $(if $(shell $(KUBECTL) get ns '$(1)' 2>/dev/null),1)

export KUBECONFIG
