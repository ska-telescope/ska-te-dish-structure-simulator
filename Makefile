# set env vars for local dev environment
ENV_TYPE ?= ci # the environment in which the k8s installation takes place
KUBE_NAMESPACE ?= ds-sim
ATOMIC ?= True## Whether helm chart installation must be atomic
OCI_IMAGE_BUILD_CONTEXT = $(shell echo $(PWD))
# we use this image tag to know which image to use in the chart
KUBERNETES_HOST ?= cluster.local
IMAGE_TAG ?= $(VERSION)-dev.c$(CI_COMMIT_SHORT_SHA)
OCI_REGISTRY = $(CI_REGISTRY)
PROJECT_NAMESPACE = /$(CI_PROJECT_NAMESPACE)/$(CI_PROJECT_NAME)
ifeq ($(CI_JOB_ID),)
  OCI_REGISTRY = 
  PROJECT_NAMESPACE =
  VERSION = latest
  HELM_RELEASE = dev
  ENV_TYPE =  dev
  IMAGE_TAG = $(VERSION)
  #HELM_BUILD_PUSH_SKIP=yes
endif

ATOMIC_ARGS =
ifeq ($(ATOMIC),True)
  ATOMIC_ARGS = --atomic --timeout 300s 
endif

K8S_CHART_PARAMS = $(ATOMIC_ARGS) \
  --set env.type=${ENV_TYPE} \
  --set image.repository=$(OCI_REGISTRY)$(PROJECT_NAMESPACE) \
  --set image.name=$(OCI_IMAGE) \
  --set image.tag=$(IMAGE_TAG)

include .make/base.mk
include .make/oci.mk
include .make/helm.mk
include .make/k8s.mk

# we ovcerride default helm lint as yamllint isnt helm lint
helm-do-lint:
	helm lint charts/ska-te-dish-structure-simulator

# ignoring k8s-wait as we rely on the helm install
k8s-wait:
	@echo "ignoring k8s-wait as we rely on the helm install"

k8s-do-test-runner:
	helm test $(HELM_RELEASE) --namespace $(KUBE_NAMESPACE)


k8s-do-template-chart:
	mkdir -p build/manifests
	@echo "template-chart: install $(K8S_UMBRELLA_CHART_PATH) release: $(HELM_RELEASE) in Namespace: $(KUBE_NAMESPACE) with params: $(K8S_CHART_PARAMS)"
	kubectl create ns $(KUBE_NAMESPACE) --dry-run=client -o yaml | tee build/manifests/manifests.yaml; \
	helm template $(HELM_RELEASE) \
	$(K8S_CHART_PARAMS) \
	--debug \
	 $(K8S_UMBRELLA_CHART_PATH) --namespace $(KUBE_NAMESPACE) | tee -a build/manifests/manifests.yaml

credentials:  ## PIPELINE USE ONLY - allocate credentials for deployment namespaces
	make k8s-namespace
	curl -s https://gitlab.com/ska-telescope/templates-repository/-/raw/master/scripts/namespace_auth.sh | bash -s $(SERVICE_ACCOUNT) $(KUBE_NAMESPACE) || true



pre-fligh-check: helm-lint


