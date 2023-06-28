# set env vars for local dev environment
ifeq ($(CI_JOB_ID),)
  CAR_OCI_REGISTRY_HOST = docker.io
  VERSION = latest
  HELM_RELEASE = dev
  #HELM_BUILD_PUSH_SKIP=yes
endif

K8S_CHART_PARAMS = --atomic --timeout 300s

temp:
	@echo "K8S_CHART_PARAMS=$(K8S_CHART_PARAMS)"

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

