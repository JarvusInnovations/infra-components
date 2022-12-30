# = helm =
#
# The package manager for kubernetes
#
# == Inputs ==
#
# |================================================
# | Section       | Name              | Description
# | engineSubject | helmChart         | A helm chart source
# | engineSubject | helmRelease       | A release name for a deployed helm chart
# | engineSubject | helmNamespace     | The kubernetes namespace the helm release should deploy into
# | engineSubject | helmValues [...]  | A helm values file used to perform the release
# |================================================
#
# == Steps ==
#
# `helm-deploy`::
#   description:::
#     Performs a `helm install` when the release does not yet exist and a
#     `helm upgrade` when it does. Creates the kubernetes namespace if it does not exist.
#   inputs:::
#     * engineSubject.helmChart
#     * engineSubject.helmRelease
#     * engineSubject.helmNamespace
#     * engineSubject.helmValues
#
# `helm-dependency-update`::
#   description:::
#     Performs a `helm dependency update` on the specified chart.
#   inputs:::
#     * engineSubject.helmChart
#
# == Methods ==
#
# `helm_release_exists`::
#   inputs:::
#     * engineSubject.helmRelease
#     * engineSubject.helmNamespace
#   return:::
#     * Non-empty when specified release exists within namespace
#     * Empty when specified release does not exist within namespace
#
# `helm_release_changed`::
#   inputs:::
#     * engineSubject.helmChart
#     * engineSubject.helmRelease
#     * engineSubject.helmNamespace
#     * engineSubject.helmValues
#   return:::
#     * Non-empty when desired release state has changed
#     * Empty when desired release state has not changed
#
# `helm_dependencies_drifted`::
#   inputs:::
#     * engineSubject.helmChart
#   return:::
#     * Non-empty when one or more chart dependencies are missing or ourdated
#     * Empty when all chart dependencies are present and up to date
#
# `helm_diff_status`::
#   inputs:::
#     * engineSubject.helmChart
#     * engineSubject.helmRelease
#     * engineSubject.helmNamespace
#     * engineSubject.helmValues
#   return:::
#     * Exit code of `kubectl diff` on the rendered helm release
#
# `helm_diff_is_error`::
#   inputs:::
#     * engineSubject.helmChart
#     * engineSubject.helmRelease
#     * engineSubject.helmNamespace
#     * engineSubject.helmValues
#   return:::
#     * Non-empty if the return value of `helm_diff_status` indicates an error
#     * Empty if the return value of `helm_diff_status` does not indicate an error

ifeq ($(KUBECTL),)
$(error FATAL: helm: missing required module: kube)
endif

HELM             ?= KUBECONFIG='$(KUBECONFIG)' helm
# FIXME: it should not be presumed that a helm chart is a filesystem path
HELM_CHART       ?= $(call subject_config_path,helmChart)
HELM_RELEASE     ?= $(call subject_config,helmRelease)
HELM_NAMESPACE   ?= $(call subject_config,helmNamespace)
HELM_VALUES      ?= $(call subject_config,helmValues,--get-all)
HELM_DEPLOY_VERB ?= $(if $(helm_release_exists),upgrade,install)

HELM_ARGS         = $(if $(HELM_NAMESPACE),--namespace '$(HELM_NAMESPACE)')
HELM_VALUES_ARGS  = $(foreach subpath,$(HELM_VALUES),--values '$(ENGINE_PROJECT_DIR)/$(subpath)')

HELM             += $(HELM_ARGS)

# FIXME: "&>" is non-portable
helm_release_exists        = $(shell if $(HELM) status '$(HELM_RELEASE)' &>/dev/null; then echo 1; else false; fi)
helm_release_changed       = $(or $(filter 1,$(helm_diff_status)),$(if $(helm_diff_is_error),$(info NOTICE: helm_diff_status encountered an error in stage $(PIPELINE_NAME)/$(STAGE_NAME) for subject $(SUBJECT_NAME); deployment will be unchanged)))
helm_dependencies_drifted  = $(shell $(HELM) dependency list '$(HELM_CHART)' | tail -n+2 | grep -v 'ok[[:space:]]*$$' | awk '{print $$1}')
helm_diff_status          := $(if $(helm_release_exists),$(shell $(HELM) template '$(HELM_RELEASE)' '$(HELM_CHART)' $(HELM_VALUES_ARGS) | $(KUBECTL) diff --namespace '$(HELM_NAMESPACE)' -f -; echo $?))
helm_diff_is_error        := $(if $(filter-out 0 1,$(helm_diff_status)),1)

helm-deploy:
	$(if $(helm_dependencies_drifted),$(call run_step,helm-dependency-update))
	$(if $(call kube_ns_exists,$(HELM_NAMESPACE)),,$(KUBECTL) create ns $(HELM_NAMESPACE))
	$(HELM) $(HELM_DEPLOY_VERB) $(HELM_RELEASE) $(HELM_CHART) $(HELM_VALUES_ARGS)

helm-dependency-update:
	$(HELM) dependency update '$(HELM_CHART)'
