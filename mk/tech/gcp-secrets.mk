# = gcp-secrets =
#
# Artifacts interface to upload and download secrets from GCP Secret Manager
#
# == Artifacts ==
#
# |======================================================
# | Option              | Value             | Description
# | producer            | gcp-secrets       | Artifacts with this value will be used by gcp-secrets-artifacts-produce
# | publisherItem       | gcp-secrets       | Artifacts with this value will be used by gcp-secrets-artifacts-publish
# | gcpSecretID         | [var]             | The ID associated with the secret in GCP
# |======================================================
#
# == Steps ==
#
# `gcp-secrets-artifacts-produce`::
#   description:::
#     Downloads secret `gcpSecretID` to `path`
#   artifacts:::
#     * producer=gcp-secrets
#   inputs:::
#     * <artifact>.path
#     * <artifact>.gcpSecretID
#
# `gcp-secrets-artifacts-publish`::
#   description:::
#     Uploads data from `path` to secret `gcpSecretID`
#   artifacts:::
#     * publisherItem=gcp-secrets
#   inputs:::
#     * <artifact>.path
#     * <artifact>.gcpSecretID
#
# `gcp-secrets-artifacts-clean`::
#   description:::
#     Deletes all produced artifacts
#   artifacts:::
#     * producer=gcp-secrets
#   inputs:::
#     * <artifact>.path

ifeq ($(GCLOUD),)
include $(MK)/tech/gcloud.mk
endif

GCP_SECRETS_PRODUCE_ARTIFACTS  ?= $(call filter_artifacts_opt_eq_val,$(call artifacts_matching,.+),producer,gcp-secrets)
GCP_SECRETS_PUBLISH_ARTIFACTS  ?= $(call filter_artifacts_opt_eq_val,$(call artifacts_matching,.+),publisherItem,gcp-secrets)
GCP_SECRETS_PATHS              ?= $(foreach id,$(GCP_SECRETS_PRODUCE_ARTIFACTS),$(call artifact_path,$(id)))

gcp-secrets-create:
gcp-secrets-artifacts-publish:
gcp-secrets-artifacts-produce:
gcp-secrets-artifacts-clean:

artifact_gcpSecretID         = $(call opt_artifact_var,$(1),gcpSecretID)

GCP_SECRETS_CREATE_TARGETS  := $(patsubst %,gcp-secrets-create-%,$(GCP_SECRETS_PUBLISH_ARTIFACTS))
GCP_SECRETS_PUBLISH_TARGETS := $(patsubst %,gcp-secrets-artifacts-publish-%,$(GCP_SECRETS_PUBLISH_ARTIFACTS))

gcp-secrets-artifacts-clean:
	rm -vf $(GCP_SECRETS_PATHS)

ifneq ($(GCP_SECRETS_CREATE_TARGETS),)
gcp-secrets-create: $(GCP_SECRETS_CREATE_TARGETS)
gcp-secrets-create-%:
	$(if $(shell $(GCLOUD) secrets describe '$(call artifact_gcpSecretID,$*)' 2>/dev/null),,$(GCLOUD) secrets create '$(call artifact_gcpSecretID,$*)' --replication-policy=automatic)
endif

ifneq ($(GCP_SECRETS_PUBLISH_TARGETS),)
gcp-secrets-artifacts-publish: $(GCP_SECRETS_PUBLISH_TARGETS)
gcp-secrets-artifacts-publish-%: gcp-secrets-create
	$(GCLOUD) secrets versions add '$(call artifact_gcpSecretID,$*)' --data-file='$(call artifact_path,$*)'
endif

ifneq ($(GCP_SECRETS_PATHS),)
gcp-secrets-artifacts-produce: $(GCP_SECRETS_PATHS)
$(GCP_SECRETS_PATHS):
	$(GCLOUD) secrets versions access latest --secret='$(call artifact_gcpSecretID,$(call artifact_frompath,$@))' --out-file='$@'
endif

.PHONY: gcp-secrets-create
.PHONY: gcp-secrets-artifacts-publish
.PHONY: gcp-secrets-artifacts-produce
.PHONY: gcp-secrets-artifacts-clean
