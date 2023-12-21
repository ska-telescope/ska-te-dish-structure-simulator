Feature: Dish Structure Simulator

    @AT-1590
    Scenario: Connect to Dish Structure Simulator via OPCUA
        Given the dish structure simulator is deployed in the Mid ITF
        Given its connection details can be retrieved
        When the OPCUA client connects to it
        Then it responds with the expected values

    @AT-1795
    Scenario: Connect to Dish Structure Simulator via HTTP
        Given the dish structure simulator is deployed in the Mid ITF
        Given its connection details can be retrieved
        When a HTTP client connects to it
        Then it responds with 200/OK
