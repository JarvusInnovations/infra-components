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
