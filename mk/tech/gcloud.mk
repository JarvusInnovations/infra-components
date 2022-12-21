# = gcloud =
#
# The Google Cloud Platform CLI interface
#
# == Inputs ==
#
# |================================================
# | Section       | Name              | Description
# | engineEnv     | gcpProject        | The name of the Google Cloud project to operate on
# |================================================

GCLOUD      ?= gcloud
GCP_PROJECT ?= $(call env_config,gcpProject,--get --default '$(call subject_config,gcpProject)')

ifneq ($(GCP_PROJECT),)
GCLOUD += --project='$(GCP_PROJECT)'
endif
