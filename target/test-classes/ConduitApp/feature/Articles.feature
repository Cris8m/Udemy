@Articles
Feature: Articles API Tests

  Background: Define URL
    Given url 'https://conduit-api.bondaracademy.com/api'
    # Se llama a otro script para crear un token de autenticación
    # Este script se ejecuta una sola vez y guarda el token en la variable 'token
    * def tokenResponse =  callonce read('classpath:helpers/CreatenewToken.feature'){"email": "karate@test123c.com", "password": "Karate1234"}
    * def token = tokenResponse.authtoken

  @CrearArticulo
  Scenario: Login y Create a new article
    # Agregar el token a la cabecera de autorización
    Given header Authorization = 'Token ' + token
    Given path 'articles'
    And request {"article": {"title": "prueba Karate1236","description": "asdf","body": "asdfasd","tagList": []}}
    When method POST
    Then status 201
    #Validar que el título del artículo sea 'prueba Karate'
    And match response.article.title == 'prueba Karate1236'


  @Eliminararticulo
  Scenario: Eliminar un artículo
    Given path 'articles'
    Given header Authorization = 'Token ' + token
    And request {"article": {"title": "EliminarArticulo1234","description": "asdf","body": "asdfasd","tagList": []}}
    When method POST
    Then status 201
    * def articleId = response.article.slug
    Given header Authorization = 'Token ' + token
    # Usando , Añades al endpoint otro tag en este caso el ID del artículo que quieres eliminar
    Given path 'articles',articleId
    When method DELETE
    Then status 204
