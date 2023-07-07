import pytest
import requests
import os
import assertpy
import socket
from asyncua import Client
from asyncua import Client

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
    if ds_sim_host_ip := os.getenv("DS_SIM_HOST_IP"):
        return f"http://{ds_sim_host_ip}"
    return f"http://{ds_sim_servicename}.{kube_namespace}.svc.{ds_sim_hostname}"

 
def test_i_can_get_vnc(ds_url: str):
    result = requests.get(f'{ds_url}:8090')
    assertpy.assert_that(result.ok)

@pytest.fixture(name='opc_ua_socket')
def fxt_opc_ua_socket():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as opc_ua_socket:
        yield opc_ua_socket


@pytest.mark.asyncio
async def test_opc_ua_client():
    ds_sim_host_ip = os.getenv("DS_SIM_HOST_IP")
    client = Client(url=f'opc.tcp://ds-sim:4840', timeout=10)
    await client.connect()
    foo = 'bat'



def test_i_can_get_opc_ua(opc_ua_socket: socket.socket):
    ds_sim_host_ip = os.getenv("DS_SIM_HOST_IP")
    assert ds_sim_host_ip
    opc_ua_socket.connect((ds_sim_host_ip,5350))
    foo = 'bar'

