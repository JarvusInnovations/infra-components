# = gh =
#
# The GitHub API CLI interface
#
# == Options ==
#
# |======================================================
# | Name                | Reference Type    | Description
# | ghPullRequestEnvVar | var               | Name of environment variable which contains GitHub Pull Request identifier
# |======================================================
#
# == Artifacts ==
#
# |============================================================
# | Option              | Value                   | Description
# | publisherItem       | github-pr               | Artifacts with this value will be published to `GH_PR_NUMBER`
# |============================================================
#
# == Steps ==
#
# `gh-pr-artifacts-publish`::
#   description:::
#     Post artifact contents to a comment on the pull request identified in the
#     enironment variable `ghPullRequestEnvVar`
#   artifacts:::
#     * publisherItem=github-pr
#   inputs:::
#     * ghPullRequestEnvVar
#     * `<artifact>.ghCommentTemplate`

ifeq ($(GH_PR_ENVVAR),)
GH_PR_ENVVAR := $(call opt_pipeline_var,ghPullRequestEnvVar)
endif

ifeq ($(GH_PR_ARTIFACTS),)
GH_PR_ARTIFACTS := $(call filter_artifacts_list_has_val,$(call artifacts_matching,.+),publisherItem,github-pr)
endif

ifeq ($(GH_PR_ARTIFACT_PATHS),)
GH_PR_ARTIFACT_PATHS := $(foreach id,$(GH_PR_ARTIFACTS),$(call artifact_path,$(id)))
endif

ifneq ($(GH_PR_ENVVAR),)
GH_PR_ARG := $(value $(GH_PR_ENVVAR))
endif

gh-pr-artifacts-publish: $(GH_PR_ARTIFACT_PATHS)
$(GH_PR_ARTIFACT_PATHS):
ifneq ($(GH_PR_ENVVAR),)
ifneq ($(GH_PR_ARG),)
	printf '$(or $(call opt_artifact_var,$(call artifact_frompath,$@),ghCommentTemplate),%s\n)' "`cat $@`" | gh pr comment '$(GH_PR_ARG)' --body-file -
else
	$(error required environment variable is not defined: $(GH_PR_ENVVAR))
endif
else
	$(error required option is not defined: ghPullRequestEnvVar)
endif

.PHONY: $(GH_PR_ARTIFACT_PATHS)
