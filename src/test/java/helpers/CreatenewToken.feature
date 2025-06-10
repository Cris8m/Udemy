Feature: Crear token
    Scenario:
        Given url apiUrl
        Given path 'users/login'
        And request {"user": {"email": "#(email)","password": "#(password)"}}
        When method POST
        Then status 200
        #Define la variable token y Guardar el token de respuesta
        * def authtoken = response.user.token 
        