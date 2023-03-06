# = kube =
#
# The Kubernetes control plane CLI interface
#
# == Options ==
#
# |======================================================
# | Name                | Reference Type    | Description
# | kubeconfig          | var               | Value to assign to `KUBECONFIG` environment variable
# |======================================================
#
# == Methods ==
#
# `kube_ns_exists`::
#   positionals::
#     1. Namespace to check existence of
#   inputs:::
#     * kubeconfig
#   return:::
#     * Non-empty if the specified namespace exists
#     * Empty if the specified namespace does not exist

ifeq ($(KUBECONFIG),)
KUBECONFIG := $(call opt_pipeline_var,kubeconfig)
endif

ifeq ($(KUBECTL),)
KUBECTL    := KUBECONFIG='$(KUBECONFIG)' kubectl
endif

kube_ns_exists = $(if $(shell $(KUBECTL) get ns '$(1)' 2>/dev/null),1)

export KUBECONFIG
