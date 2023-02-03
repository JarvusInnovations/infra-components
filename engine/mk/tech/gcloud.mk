# = gcloud =
#
# The Google Cloud Platform CLI interface
#
# == Options ==
#
# |================================================
# | Name          | Reference Type    | Description
# | gcpProject    | var               | The name of the Google Cloud project to operate on
# |================================================

ifeq ($(GCLOUD),)
GCLOUD      := gcloud
endif

ifeq ($(GCP_PROJECT),)
GCP_PROJECT := $(call opt_pipeline_var,gcpProject)
endif

GCLOUD += --quiet
ifneq ($(GCP_PROJECT),)
GCLOUD += --project='$(GCP_PROJECT)'
endif
