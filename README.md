# Dish Structure Simulator

This repo contains images and charts for deploying dish structure simulators.

## Images

The images are built to run the artefacts delivered by CETC.

## Charts

The `ska-te-dish-structure-simulator` deploys the `ska-te-ds-sim` container with a service which exposes a webserver and a OPCUA server.

## Deployments

There are two deployments in this repo:

1. A dev environment deployment to the STFC using `deploy.dev.gitlab-ci.yml`.
2. A custom deployment to the ITF, see the `deploy-mid-itf` job.

### Local Deployment

Deploy to your local minikube as follows:

```bash
# Ensure that the minikube docker env is being used
eval $(minikube docker-env)
# Build the ds-sim image
make oci-build-all OCI_IMAGES=ska-te-ds-web-sim
# Install the chart
make k8s-install-chart
# Get services
minikube service -n ds-sim  ds-sim
```

You can then connect to the simulator as follows:

```bash
# setup environment
poetry shell
poetry install
# get minikube IP
MINIKUBE_IP=$(minikube ip)
# get discover port
DISCOVER_PORT=$(kubectl get svc -n ds-sim ds-sim  -o jsonpath='{.spec.ports[?(@.name=="discover")].nodePort}')
# interrogate the OPCUA server
# NOTE: this currently gives an error on minikube, something like:
# The server does not recognize the QueryString specified.(BadTcpEndpointUrlInvalid)
uals -u opc.tcp://${MINIKUBE_IP}:${DISCOVER_PORT}/OPCUA/SimpleServer -p0:Objects,2:Logic,2:Application,2:PLC_PRG
```

You can connect to the web application by visiting the URL:

```bash
# get minikube IP
MINIKUBE_IP=$(minikube ip)
# get discover port
WEB_PORT=$(kubectl get svc -n ds-sim ds-sim  -o jsonpath='{.spec.ports[?(@.name=="server")].nodePort}')
# Get the URL
printf "http://${MINIKUBE_IP}:${WEB_PORT}\n"
```

## Tests

You can run the tests locally against in instance of the dish structure simulator running in minikube.
See the *Local Deployment* section for details on how to set this up.
Once deployed, you will need to configure your system to connect to the OPCUA server. You can do this as follows:

1. Extract the `images/ska-te-ds-web-sim/simulator.tar` tarball: `tar -xvf images/ska-te-ds-web-sim/simulator.tar`.
2. Copy the server certificate to a convenient location: `cp simulator/PKI/private/SimpleServer_2048.der ignored/SimpleServer_2048.der`
3. Create a `PrivateRules.mak` file and populate it with the following:

```
export DS_SIM_USER := <username>
export DS_SIM_PASSWORD := <password>
export DS_SIM_SERVER_CERT := ignored/SimpleServer_2048.der
export CLUSTER_DOMAIN := cluster.local
```

Ask @pjgjordaan about the username & password details.

Once this is complete, you can run the tests with `make python-test`.

In the pipeline, the tests are executed using the `k8s-test-runner` template.
