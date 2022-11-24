#
# Config:
#
# [env "<env-name>"]
# gcpSecret = foo-secret
# gcpSecret = bar-secret
# [gcpSecret "foo-secret"]
# id   = <secret-id>
# file = <env-subpath>
# [gcpSecret "bar-secret"]
# ...
#

include $(MK)/tech/gcloud.mk

GCP_SECRETS_NAMES          ?= $(call env_config,gcpSecret,--get-all)
GCP_SECRETS_PATHS          ?= $(foreach name,$(GCP_SECRETS_NAMES),$(call gcpSecret_path,$(name)))

gcp-secrets-create:
gcp-secrets-upload:
gcp-secrets-get:

GCP_SECRETS_CREATE_TARGETS := $(patsubst %,gcp-secrets-create-%,$(GCP_SECRETS_NAMES))
GCP_SECRETS_UPDATE_TARGETS := $(patsubst %,gcp-secrets-upload-%,$(GCP_SECRETS_NAMES))

gcpSecret_id            = $(shell $(GIT_CONFIG) gcpSecret.$(1).id)
gcpSecret_path          = $(call env_pathjoin,$(shell $(GIT_CONFIG) gcpSecret.$(1).file))
gcpSecret_name_fromfile = $(shell $(GIT_CONFIG) --get-regex 'gcpSecret\.[^.]+\.file' '(^|\./)?$(1)$$' | cut -d. -f2)

ifneq ($(GCP_SECRETS_CREATE_TARGETS),)
gcp-secrets-create: $(GCP_SECRETS_CREATE_TARGETS)
gcp-secrets-create-%:
	$(if $(shell $(GCLOUD) secrets versions describe latest --secret='$(call gcpSecret_id,$*)' 2>/dev/null),,$(GCLOUD) secrets create '$(call gcpSecret_id,$*)' --replication-policy=automatic)
endif

ifneq ($(GCP_SECRETS_UPDATE_TARGETS),)
gcp-secrets-upload: $(GCP_SECRETS_UPDATE_TARGETS)
gcp-secrets-upload-%: gcp-secrets-create
	$(GCLOUD) secrets versions add '$*' --data-file='$(call gcpSecret_path,$*)'
endif

ifneq ($(GCP_SECRETS_PATHS),)
gcp-secrets-get: $(GCP_SECRETS_PATHS)
$(GCP_SECRETS_PATHS):
	$(GCLOUD) secrets versions access latest --secret='$(call gcpSecret_id,$(call gcpSecret_name_fromfile,$(call env_pathstrip,$@)))' --out-file='$@'
endif

.PHONY: gcp-secrets-create
.PHONY: gcp-secrets-upload
.PHONY: gcp-secrets-get
