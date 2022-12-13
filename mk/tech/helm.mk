ifeq ($(KUBECONFIG),)
$(error FATAL: helm: missing required module: kube)
endif

HELM         = $(error NOT IMPLEMENTED)
HELM_RELEASE = $(error NOT IMPLEMENTED)

helm_deployment_changed = $(error NOT IMPLEMENTED)

helm-deploy:
	$(error NOT IMPLEMENTED)
