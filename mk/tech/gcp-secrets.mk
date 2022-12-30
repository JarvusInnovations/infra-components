# = gcp-secrets =
#
# Artifacts interface to upload and download secrets from GCP Secret Manager
#
# == Inputs ==
#
# |===============================================================
# | Section        | Name              | Value       | Description
# | engineArtifact | producer          | gcp-secrets | Artifacts with this value will be used by gcp-secrets-artifacts-produce
# | engineArtifact | publisher         | gcp-secrets | Artifacts with this value will be used by gcp-secrets-artifacts-publish
# | engineArtifact | gcpSecretID       | *           | The ID associated with the secret in GCP
# |===============================================================
#
# == Steps ==
#
# `gcp-secrets-artifacts-produce`::
#   description:::
#     Downloads secret <engineArtifact.gcpSecretID> to <engineArtifact.path>
#   inputs:::
#     * engineArtifact.producer=gcp-secrets
#     * engineArtifact.path
#     * engineArtifact.gcpSecretID
#
# `gcp-secrets-artifacts-publish`::
#   description:::
#     Uploads data from <engineArtifact.path> to secret <engineArtifact.gcpSecretID>
#   inputs:::
#     * engineArtifact.publisher=gcp-secrets
#     * engineArtifact.path
#     * engineArtifact.gcpSecretID
#
# `gcp-secrets-artifacts-clean`::
#   description:::
#     Deletes all produced artifacts
#   inputs:::
#     * engineArtifact.producer=gcp-secrets
#     * engineArtifact.path

include $(MK)/tech/gcloud.mk

GCP_SECRETS_PRODUCE_ARTIFACTS  ?= $(call artifacts_filter_equalto,$(call artifacts_matching,.+),producer,gcp-secrets)
GCP_SECRETS_PUBLISH_ARTIFACTS  ?= $(call artifacts_filter_has,$(call artifacts_matching,.+),publisher,gcp-secrets)
GCP_SECRETS_PATHS              ?= $(foreach id,$(GCP_SECRETS_PRODUCE_ARTIFACTS),$(if $(call artifact_path,$(id)),$(call artifact_relpathjoin,$(call artifact_var,$(id),path))))

gcp-secrets-create:
gcp-secrets-artifacts-publish:
gcp-secrets-artifacts-produce:
gcp-secrets-artifacts-clean:

artifact_gcpSecretID         = $(call artifact_var,$(1),gcpSecretID)

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
	$(GCLOUD) secrets versions access latest --secret='$(call artifact_gcpSecretID,$(call artifacts_lookupby_relpath,$(GCP_SECRETS_PRODUCE_ARTIFACTS),$@))' --out-file='$@'
endif

.PHONY: gcp-secrets-create
.PHONY: gcp-secrets-artifacts-publish
.PHONY: gcp-secrets-artifacts-produce
.PHONY: gcp-secrets-artifacts-clean
