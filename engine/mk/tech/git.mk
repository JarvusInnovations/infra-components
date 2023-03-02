
ifeq ($(GIT_WORKDIR),)
GIT_WORKDIR := $(call opt_pipeline_var,gitWorkDir)
endif

ifeq ($(GIT),)
GIT := git $(if $(GIT_WORKDIR),-C '$(GIT_WORKDIR)')
endif

ifeq ($(GIT_ARTIFACT_FILTERS),)
GIT_ARTIFACT_FILTERS := $(call opt_pipeline_list,gitArtifactFilterItem)
endif

ifeq ($(GIT_FETCH_ARTIFACTS),)
GIT_FETCH_ARTIFACTS  := $(call filter_artifacts_var_eq_val,$(call artifacts_matching,.+),producer,git-fetch)
GIT_FETCH_ARTIFACTS  := $(call filter_artifacts_var_eq_val,$(GIT_FETCH_ARTIFACTS),gitRef)
ifneq ($(GIT_ARTIFACT_FILTERS),)
GIT_FETCH_ARTIFACTS  := $(filter $(GIT_ARTIFACT_FILTERS),$(GIT_FETCH_ARTIFACTS))
endif
endif

GIT_FETCH_ARTIFACT_TARGETS := $(patsubst %,git-fetch-artifacts-produce-%,$(GIT_FETCH_ARTIFACTS))

git_fetch_args = \
  $(call opt_artifact_var,$(1),gitFetchRemote) \
	$(if $(call opt_artifact_var,$(1),gitFetchRef),$(call opt_artifact_var,$(1),gitFetchRef):)$(call opt_artifact_var,$(1),gitRef)

git-fetch-artifacts-produce: $(GIT_FETCH_ARTIFACT_TARGETS)
git-fetch-artifacts-produce-%:
	$(GIT) fetch $(call opt_artifact_var,gitFetchRemote,$*) $(call git_fetch_args,$*)
