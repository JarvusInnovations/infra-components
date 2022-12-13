#
# Config:
#
# [subject "<name>"]
# helmChart     = <engine-home-subpath>
# helmRelease   = <name>
# helmNamespace = <name>
# helmValues    = <engine-home-subpath>
# helmValues    = ...
ifeq ($(KUBECTL),)
$(error FATAL: helm: missing required module: kube)
endif

HELM             ?= KUBECONFIG='$(KUBECONFIG)' helm
HELM_CHART       ?= $(call subject_config_path,helmChart)
HELM_RELEASE     ?= $(call subject_config,helmRelease)
HELM_NAMESPACE   ?= $(call subject_config,helmNamespace)
HELM_VALUES      ?= $(call subject_config,helmValues,--get-all)
HELM_DEPLOY_VERB ?= $(if $(helm_release_exists),upgrade,install)

HELM_OPTS         = $(patsubst %,--namespace '%',$(HELM_NAMESPACE))
HELM_VALUES_OPTS  = $(patsubst %,--values '$(ENGINE_HOME)/%',$(HELM_VALUES))

HELM             += $(HELM_OPTS)

helm_release_exists        = $(shell if $(HELM) status '$(HELM_RELEASE)' &>/dev/null; then echo 1; else false; fi)
helm_release_changed       = $(or $(filter 1,$(helm_diff_status)),$(if $(helm_diff_is_error),$(info NOTICE: helm_diff_status encountered an error in stage $(PIPELINE_NAME)/$(STAGE_NAME) for subject $(SUBJECT_NAME); deployment will be unchanged)))
helm_dependencies_drifted  = $(shell $(HELM) dependency list '$(HELM_CHART)' | tail -n+2 | grep -v 'ok[[:space:]]*$$' | awk '{print $$1}')
helm_diff_status          := $(if $(helm_release_exists),$(shell $(HELM) template '$(HELM_RELEASE)' '$(HELM_CHART)' $(HELM_VALUES_OPTS) | $(KUBECTL) diff --namespace '$(HELM_NAMESPACE)' -f -; echo $?))
helm_diff_is_error        := $(if $(filter-out 0 1,$(helm_diff_status)),1)

helm-deploy:
	$(if $(helm_dependencies_drifted),$(call run_step,helm-dependency-update))
	$(if $(call kube_ns_exists,$(HELM_NAMESPACE)),,$(KUBECTL) create ns $(HELM_NAMESPACE))
	$(HELM) $(HELM_DEPLOY_VERB) $(HELM_RELEASE) $(HELM_CHART) $(HELM_VALUES_OPTS)

helm-dependency-update:
	$(HELM) dependency update '$(HELM_CHART)'
