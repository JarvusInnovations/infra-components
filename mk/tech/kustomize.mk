# = kustomize =
#
# Declarative configuration of kubernetes
#
# == Options ==
#
# |======================================================
# | Name                | Reference Type    | Description
# | kustomizeDir        | var               | Path to a directory containing a kustomization.yaml
# |======================================================
#
# == Steps ==
#
# `kustomize-apply`::
#   description:::
#     Deploys a kustomization when there are changes to apply
#   inputs:::
#     * kustomizeDir
#
# == Methods ==
#
# `kustomize_changes_pending`::
#   inputs:::
#     * kustomizeDir
#   return:::
#     * Non-empty if there are changes to apply

ifeq ($(KUBECTL),)
include $(MK)/tech/kube.mk
endif

ifeq ($(KUSTOMIZE_DIR),)
KUSTOMIZE_DIR                := $(call opt_pipeline_var,kustomizeDir)
endif

ifeq ($(KUSTOMIZE_CREATED_PENDING),)
KUSTOMIZE_CREATED_PENDING    := $(KUBECTL) --dry-run=client apply -k $(KUSTOMIZE_DIR) | grep -E ' created([[:space:]]|$$)'
endif

ifeq ($(KUSTOMIZE_CONFIGURED_PENDING),)
KUSTOMIZE_CONFIGURED_PENDING := $(KUBECTL) --dry-run=server apply -k $(KUSTOMIZE_DIR) | grep -E ' configured([[:space:]]|$$)'
endif

kustomize_changes_pending     = $(if $(KUSTOMIZE_DIR),$(or $(shell $(KUSTOMIZE_CREATED_PENDING)),$(shell $(KUSTOMIZE_CONFIGURED_PENDING))),$(error kustomize_changes_pending: missing required option: kustomizeDir))

kustomize-apply:
ifneq ($(kustomize_changes_pending),)
	$(KUBECTL) apply -k $(KUSTOMIZE_DIR)
endif

kustomize-delete:
	$(KUBECTL) delete -k $(KUSTOMIZE_DIR)
