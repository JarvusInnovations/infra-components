# = hologit =
#
# Create content-driven build pipelines for derivative git trees
#
# == Artifacts ==
#
# |=========================================================
# | Option                 | Value             | Description
# | producer               | hologit           | Matching artifacts will be built by hologit-artifacts-produce
# | hologitHolobranch      | [required]        | Name of the holobranch (build pipeline) used to create the artifact. Must be defined to be built.
# | path                   | [optional]        | If specified, outputs built tree id to this file
# | hologitCommitTo        | [optional]        | Value for --commit-to option
# | hologitCommitMsg       | [optional]        | Value for --commit-msg option
# | hologitCommitMsgEnvVar | [optional]        | Name of an environment variable to fill the --commit-msg value from
# | hologitBaseRef         | [optional]        | Value for --ref option
# | hologitEnableLens      | [optional]        | Value for --lens option
# |=========================================================
#
# == Steps ==
#
# `hologit-artifacts-produce`::
#   description:::
#     Build defined holobranches
#   selectors:::
#     * producer=hologit
#     * hologitHolobranch=<nonempty>
#   inputs:::
#     * <artifact>.path
#     * <artifact>.hologitHolobranch
#     * <artifact>.hologitCommitTo
#     * <artifact>.hologitCommitMsg
#     * <artifact>.hologitCommitMsgEnvVar
#     * <artifact>.hologitBaseRef
#     * <artifact>.hologitEnableLens

ifeq ($(GIT),)
include $(MK)/tech/git.mk
endif

ifeq ($(HOLOGIT),)
HOLOGIT := $(GIT) holo
endif

ifeq ($(HOLOGIT_ARTIFACTS),)
HOLOGIT_ARTIFACTS := $(call filter_artifacts_var_eq_val,$(call artifacts_matching,.+),producer,hologit)
HOLOGIT_ARTIFACTS := $(call filter_artifacts_var_eq_val,$(HOLOGIT_ARTIFACTS),hologitHolobranch)
endif

ifeq ($(HOLOGIT_ARTIFACTS_TARGETS),)
HOLOGIT_ARTIFACTS_TARGETS  := $(patsubst %,hologit-artifacts-produce-%,$(HOLOGIT_ARTIFACTS))
endif

hologit_args = \
  $(if $(call opt_artifact_var,$(1),hologitCommitTo),--commit-to '$(call opt_artifact_var,$(1),hologitCommitTo)')                      \
  $(if $(call opt_artifact_var,$(1),hologitCommitMsg),--commit-message '$(call opt_artifact_var,$(1),hologitCommitMsg)')               \
  $(if $(call opt_artifact_var,$(1),hologitCommitMsgEnvVar),--commit-message "$$$(call opt_artifact_var,$(1),hologitCommitMsgEnvVar)") \
  $(if $(call opt_artifact_var,$(1),hologitBaseRef),--ref '$(call opt_artifact_var,$(1),hologitBaseRef)')                              \
  $(if $(call opt_artifact_var,$(1),hologitEnableLens),--lens '$(call opt_artifact_var,$(1),hologitEnableLens)')

hologit_output = $(if $(call artifact_path,$(1)),> $(call artifact_path,$(1)))

hologit-artifacts-produce: $(HOLOGIT_ARTIFACTS_TARGETS)
hologit-artifacts-produce-%:
	$(HOLOGIT) project $(call opt_artifact_var,$*,hologitHolobranch) $(call hologit_args,$*) $(call hologit_output,$*)

.PHONY: hologit-artifacts-produce
