# set env vars for local dev environment
ENV_TYPE ?= ci # the environment in which the k8s installation takes place
KUBE_NAMESPACE ?= ds-sim
ATOMIC ?= True## Whether helm chart installation must be atomic
OCI_IMAGE_BUILD_CONTEXT = $(PWD)
# we use this image tag to know which image to use in the chart
IMAGE_TAG ?= $(VERSION)-dev.c$(CI_COMMIT_SHORT_SHA)
OCI_REGISTRY = $(CI_REGISTRY)
PROJECT_NAMESPACE = /$(CI_PROJECT_NAMESPACE)/$(CI_PROJECT_NAME)
ifeq ($(CI_JOB_ID),)
  OCI_REGISTRY = 
  PROJECT_NAMESPACE =
  VERSION = latest
  HELM_RELEASE = dev
  ENV_TYPE = dev
  IMAGE_TAG = $(VERSION)
endif

ATOMIC_ARGS =
ifeq ($(ATOMIC),True)
  ATOMIC_ARGS = --atomic --timeout 300s
endif

K8S_CHART_PARAMS = $(ATOMIC_ARGS) \
  --set env.type=${ENV_TYPE} \
  --set image.repository=$(OCI_REGISTRY)$(PROJECT_NAMESPACE) \
  --set image.tag=$(IMAGE_TAG)

include .make/base.mk
include .make/oci.mk
include .make/helm.mk
include .make/k8s.mk

# we ovcerride default helm lint as yamllint isnt helm lint
helm-do-lint:
	helm lint charts/ska-te-dish-structure-simulator

k8s-do-test-runner:
	$(helm_test_command)

helm_test_command = /bin/bash -o pipefail -c "\
	mkdir -p build; \
	helm test --debug $(HELM_RELEASE) --namespace $(KUBE_NAMESPACE); \
	echo \$$? > build/status; \
	echo \"helm test: test command exit is: \$$(cat build/status)\";"

k8s-do-template-chart:
	mkdir -p build/manifests
	@echo "template-chart: install $(K8S_UMBRELLA_CHART_PATH) release: $(HELM_RELEASE) in Namespace: $(KUBE_NAMESPACE) with params: $(K8S_CHART_PARAMS)"
	kubectl create ns $(KUBE_NAMESPACE) --dry-run=client -o yaml | tee build/manifests/manifests.yaml; \
	helm template $(HELM_RELEASE) \
	$(K8S_CHART_PARAMS) \
	--debug \
	 $(K8S_UMBRELLA_CHART_PATH) --namespace $(KUBE_NAMESPACE) | tee -a build/manifests/manifests.yaml

deployment-info:
	@echo "Pods for $(KUBE_NAMESPACE)"
	@kubectl get pods -n $(KUBE_NAMESPACE) -owide
	@echo "Services"
	@kubectl get svc -n $(KUBE_NAMESPACE) -owide
.PHONY: deployment-info

credentials:  ## PIPELINE USE ONLY - allocate credentials for deployment namespaces
	make k8s-namespace
	curl -s https://gitlab.com/ska-telescope/templates-repository/-/raw/master/scripts/namespace_auth.sh | bash -s $(SERVICE_ACCOUNT) $(KUBE_NAMESPACE) || true
