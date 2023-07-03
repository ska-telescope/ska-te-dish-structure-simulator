import pytest
import requests
import os
import assertpy


@pytest.fixture(name='ds_sim_hostname')
def fxt_ds_sim_hostname() -> str:
    return os.getenv("DS_SIM_HOSTNAME", "cluster.local")

@pytest.fixture(name='ds_sim_servicename')
def fxt_ds_sim_servicename() -> str:
    return os.getenv("DS_SIM_SERVICENAME", "ds-sim")

@pytest.fixture(name='kube_namespace')
def fxt_kube_namespace() -> str:
    return os.getenv("KUBE_NAMESPACE", "ds-sim")

@pytest.fixture(name='ds_url')
def fxt_ds_url(ds_sim_hostname: str, kube_namespace: str, ds_sim_servicename: str) -> str:
    return f"http://{ds_sim_servicename}.{kube_namespace}.svc.{ds_sim_hostname}"
 
def test_i_can_get_vnc(ds_url: str):
    result = requests.get(ds_url)
    assertpy.assert_that(result.ok)
