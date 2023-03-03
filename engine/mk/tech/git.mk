
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

ifeq ($(GIT_PUSH_ARTIFACTS),)
GIT_PUSH_ARTIFACTS  := $(call filter_artifacts_var_eq_val,$(call artifacts_matching,.+),publisherItem,git-push)
GIT_PUSH_ARTIFACTS  := $(call filter_artifacts_var_eq_val,$(GIT_PUSH_ARTIFACTS),gitRef)
ifneq ($(GIT_ARTIFACT_FILTERS),)
GIT_PUSH_ARTIFACTS  := $(filter $(GIT_ARTIFACT_FILTERS),$(GIT_PUSH_ARTIFACTS))
endif
endif

ifeq ($(GIT_TREE_ARTIFACTS),)
GIT_TREE_ARTIFACTS  := $(call filter_artifacts_var_eq_val,$(call artifacts_matching,.+),producer,git-tree)
GIT_TREE_ARTIFACTS  := $(call filter_artifacts_var_eq_val,$(GIT_TREE_ARTIFACTS),gitRef)
ifneq ($(GIT_ARTIFACT_FILTERS),)
GIT_TREE_ARTIFACTS  := $(filter $(GIT_ARTIFACT_FILTERS),$(GIT_TREE_ARTIFACTS))
endif
endif

GIT_FETCH_ARTIFACT_TARGETS := $(patsubst %,git-fetch-artifacts-produce-%,$(GIT_FETCH_ARTIFACTS))
GIT_PUSH_ARTIFACT_TARGETS  := $(patsubst %,git-push-artifacts-publish-%,$(GIT_PUSH_ARTIFACTS))
GIT_TREE_ARTIFACT_TARGETS  := $(patsubst %,git-tree-artifacts-produce-%,$(GIT_TREE_ARTIFACTS))

git_force_flag = $(if $(filter-out 0 false,$(shell echo $(call opt_artifact_var,$(2),$(1)) | tr '[:upper:]' '[:lower:]')),+)

git_fetch_args = \
  $(call opt_artifact_var,$(1),gitFetchRemote) \
	$(call git_force_flag,gitForceFetch,$(1))$(if $(call opt_artifact_var,$(1),gitFetchRef),$(call opt_artifact_var,$(1),gitFetchRef):)$(call opt_artifact_var,$(1),gitRef)

define git_push_artifact_to_remote
$(GIT) push $(2) $(call git_force_flag,gitForcePush,$(1))$(call opt_artifact_var,$(1),gitRef)$(if $(call opt_artifact_var,$(1),gitPushRef),:$(call opt_artifact_var,$(1),gitPushRef))

endef

git-fetch-artifacts-produce: $(GIT_FETCH_ARTIFACT_TARGETS)
git-fetch-artifacts-produce-%:
	$(GIT) fetch $(call opt_artifact_var,gitFetchRemote,$*) $(call git_fetch_args,$*)

git-push-artifacts-publish: $(GIT_PUSH_ARTIFACT_TARGETS)
git-push-artifacts-publish-%:
	$(foreach remote,$(call opt_artifact_list,$*,gitPushRemoteItem),$(call git_push_artifact_to_remote,$*,$(remote)))

git-tree-artifacts-produce: $(GIT_TREE_ARTIFACT_TARGETS)
git-tree-artifacts-produce-%:
	$(GIT) --work-tree=$(call artifact_path,$*) restore --worktree --source=$(call opt_artifact_var,$*,gitRef) .
