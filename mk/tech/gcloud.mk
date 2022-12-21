#
# Config:
#
# [engineEnv "<name>"]
# gcpProject = <project-name>

GCLOUD      ?= gcloud
GCP_PROJECT ?= $(call env_config,gcpProject,--get --default '$(call subject_config,gcpProject)')

ifneq ($(GCP_PROJECT),)
GCLOUD += --project='$(GCP_PROJECT)'
endif
