# set env vars for local dev environment
ENV_TYPE ?= ci # the environment in which the k8s installation takes place
# we use this image tag to know which image to use in the chart
IMAGE_TAG ?= $(VERSION)-dev.c$(CI_COMMIT_SHORT_SHA)
ifeq ($(CI_JOB_ID),)
  CAR_OCI_REGISTRY_HOST = docker.io
  VERSION = latest
  HELM_RELEASE = dev
  ENV_TYPE = dev
  IMAGE_TAG = $(VERSION)
  #HELM_BUILD_PUSH_SKIP=yes
endif


K8S_CHART_PARAMS = --atomic --timeout 300s \
  --set env.type=${ENV_TYPE} \
  --set image.repository=$(CAR_OCI_REGISTRY_HOST) \
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
	helm test $(HELM_RELEASE)

