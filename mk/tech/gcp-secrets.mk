include $(MK)/tech/gcloud.mk

GCP_SECRETS_PATHS          ?= $(foreach subpath,$(call env_config,gcpSecretFile,--get-all),$(call env_pathjoin,$(subpath)))

ifeq ($(GCP_SECRETS_IDS),)
GCP_SECRETS_IDS            := $(foreach path,$(GCP_SECRETS_PATHS),$(basename $(notdir $(path))))
endif

GCP_SECRETS_CREATE_TARGETS := $(patsubst %,gcp-secrets-create-%,$(GCP_SECRETS_IDS))
GCP_SECRETS_UPDATE_TARGETS := $(patsubst %,gcp-secrets-upload-%,$(GCP_SECRETS_IDS))

gcp-secrets-create:
gcp-secrets-upload:
gcp-secrets-get:

gcpSecretFile_get_id        = $(basename $(notdir $(1)))
gcpSecretFile_id_valpattern = (^|/)$(1)(\.[^.]+)?$$

ifneq ($(GCP_SECRETS_CREATE_TARGETS),)
gcp-secrets-create: $(GCP_SECRETS_CREATE_TARGETS)
gcp-secrets-create-%:
	$(if $(shell $(GCLOUD) secrets versions describe latest --secret='$*' 2>/dev/null),,$(GCLOUD) secrets create '$*' --replication-policy=automatic)
endif

ifneq ($(GCP_SECRETS_UPDATE_TARGETS),)
gcp-secrets-upload: $(GCP_SECRETS_UPDATE_TARGETS)
gcp-secrets-upload-%: gcp-secrets-create
	$(GCLOUD) secrets versions add '$*' --data-file='$(call env_pathjoin,$(call env_config,gcpSecretFile '$(call gcpSecretFile_id_valpattern,$*)',--get))'
endif

ifneq ($(GCP_SECRETS_PATHS),)
gcp-secrets-get: $(GCP_SECRETS_PATHS)
$(GCP_SECRETS_PATHS):
	$(GCLOUD) secrets versions access latest --secret='$(call gcpSecretFile_get_id,$@)' --out-file='$@'
endif
