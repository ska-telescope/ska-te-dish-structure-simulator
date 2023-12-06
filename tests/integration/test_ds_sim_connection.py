"""Test connection to dish structure simulator."""
import asyncio
import logging
from typing import Any

import requests
from asyncua import Client
from asyncua.common.node import Node
from pytest_bdd import given, scenario, then, when

from .conftest import DSSimService


@scenario(
    "features/ds_sim_connection.feature",
    "Connect to Dish Structure Simulator via OPCUA",
)
def test_connection_to_ds_sim_opcua():
    """Test connection to the Dish Structure Simulator via OPCUA."""


@given("the dish structure simulator is deployed in the Mid ITF")
def ds_sim_deployed(ds_sim_svc: DSSimService):
    """
    Verify that the dish structure simulator is deployed.

    :param ds_sim_svc: The dish structure simulator service.
    :type ds_sim_svc: DSSimService
    """
    logging.debug("ds_sim_deployed %s", ds_sim_svc)


@given("its connection details can be retrieved")
def connection_details(ds_sim_svc: DSSimService):
    """
    Verify that we can retrieve the dish structure simulator's connection details.

    :param ds_sim_ip: dish structure simulator IP address
    :type ds_sim_ip: str
    :param ds_sim_discover_port: dish structure simulator discover port
    :type ds_sim_discover_port: int
    """
    assert ds_sim_svc.ip_address() != ""
    assert ds_sim_svc.discover_port() != 0
    assert ds_sim_svc.http_port() != 0
    logging.debug(
        "ds-sim connection details: ip=%s,discover_port=%s",
        ds_sim_svc.ip_address,
        ds_sim_svc.discover_port,
    )


@when("the OPCUA client connects to it")
def opcua_client_connect_ds_sim(opcua_client: Client):
    """
    Verify that we are connected to the OPCUA server.

    :param opcua_client: The OPCUA client used to connect to the server.
    :type opcua_client: Client
    """
    loop = asyncio.get_event_loop()
    loop.run_until_complete(opcua_client.check_connection())
    logging.debug("opcua_client connected: %s", opcua_client.application_uri)


@then("it responds with the expected values")
def responds_with_expected_values(opcua_client: Client):
    """
    Verify that the OPCUA server responds with expected values when queried.

    :param opcua_client: The OPCUA client used to connect to the server.
    :type opcua_client: Client
    """
    path = [
        "0:Objects",
        "2:Logic",
        "2:Application",
        "2:PLC_PRG",
        "2:Azimuth",
        "2:AxisState",
    ]
    expected_axis_state = 1
    # pytest-asyncio & pytest-bdd don't work together,
    # so we run until the Futures are done
    loop = asyncio.get_event_loop()
    val = loop.run_until_complete(retrieve_value(opcua_client=opcua_client, path=path))
    assert val == expected_axis_state
    logging.debug("it responds with the expected value: %s", val)


async def retrieve_value(opcua_client: Client, path: [str]) -> Any:
    """
    Check that the OPCUA server responds with expected values when queried.

    This is separate from the responds_with_expected_values method because
    pytest-bdd & pytest-asyncio don't work together.

    :param opcua_client: The OPCUA client used to connect to the server.
    :type opcua_client: Client
    :return: the AxisState of the Azimuth
    :rtype: Any
    """
    child: Node = await opcua_client.nodes.root.get_child(path)
    val = await child.get_value()
    logging.debug("opcua_client read value for '%s' as '%s'", ";".join(path), val)
    return val


@scenario(
    "features/ds_sim_connection.feature",
    "Connect to Dish Structure Simulator via HTTP",
)
def test_connection_to_ds_sim_http():
    """Test connection to the Dish Structure Simulator via HTTP."""


@when("a HTTP client connects to it", target_fixture="http_request_result")
def http_client_connect_ds_sim(ds_sim_svc: DSSimService) -> requests.Response:
    """
    Make a connection to the HTTP port of the OPCUA server.

    :param ds_sim_svc: The ds sim service with connection details.
    :type ds_sim_svc: DSSimService
    """
    result = requests.head(ds_sim_svc.http_url(), timeout=10)
    return result


@then("it responds with 200/OK")
def http_client_responds_ok(http_request_result: requests.Response):
    """
    Make a connection to the HTTP port of the OPCUA server and check the status code.

    :param ds_sim_svc: The ds sim service with connection details.
    :type ds_sim_svc: DSSimService
    """
    logging.debug("HTTP client connected: %s", http_request_result.status_code)
    assert http_request_result.ok
