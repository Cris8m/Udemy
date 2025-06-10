@CrearCuenta1
Feature:

  Background:
    Given url apiUrl

  @CrearCuenta
  Scenario: Crear una nueva cuenta
    Given path 'users'
    * def userdata = {"email":"preuba123c269@gmail.com"}
    And request
        """
        {
            "user": {
                "email": #(userdata.email),
                "password": "prueba1239",
                "username": "prueba123ca6s9"
            }
        }
        """
    When method POST
    Then status 201

