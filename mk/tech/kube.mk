#
# Config:
#
# [env "<name>"]
# kubeconfig = <absolute-path>
KUBECONFIG ?= $(call env_config,kubeconfig)
KUBECTL    ?= KUBECONFIG='$(KUBECONFIG)' kubectl

kube_ns_exists = $(if $(shell $(KUBECTL) get ns '$(1)' 2>/dev/null),1)

export KUBECONFIG
