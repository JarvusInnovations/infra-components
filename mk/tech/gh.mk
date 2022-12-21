# = gh =
#
# The GitHub API CLI interface
#
# == Inputs ==
#
# |================================================
# | Section       | Name              | Description
# | [None]        | GH_PR_NUMBER      | The number of a pull request to operate on
# |================================================
#
# == Steps ==
#
# `gh-pr-comment-terraform-plan`::
#   description:::
#     Posts a formatted comment with the output of `terraform plan`
#   inputs:::
#     * See: terraform
#
# == Methods ==
#
# `gh_pr_comment_tf`::
#   positionals:::
#     1. PR number to post comment to
#   inputs:::
#     * See: terraform

ifneq ($(TERRAFORM),)

gh_pr_comment_tf  = $(TERRAFORM) plan -compact-warnings -no-color $(TERRAFORM_VAR_FILES) | printf '\#\# Terraform Changes\n```hcl\n%s\n```\n' "`cat /dev/stdin`" | gh pr comment '$(1)' --body-file -

gh-pr-comment-terraform-plan:
ifneq ($(GH_PR_NUMBER),)
	$(if $(filter 2,$(tf_plan_status)),$(call gh_pr_comment_tf,$(GH_PR_NUMBER)))
else
	$(error GH_PR_NUMBER is not defined)
endif

else
gh-pr-comment-terraform-plan:
endif

.PHONY: gh-pr-comment-terraform-plan
