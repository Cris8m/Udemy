# @IgnorarTest
@HomePage
Feature: Primer test

  Background:
    Given url apiUrl

  @Getalltags
  Scenario: Get all tag - llamada a la API usando el path para el endpoint
    # Se usa path para definir el endpoint
    Given path 'tags'
    When method GET
    Then status 200
    # Se usa match para validar que la respuesta contenga el tag YouTube
    And match response.tags contains 'YouTube'
    # Se usa match para validar que la respuesta contenga los tags YouTube, Zoom, Bondar Academy y Git
    And match response.tags contains ['YouTube', 'Zoom', 'Bondar Academy', 'Git']
    # Se usa match para validar que la respuesta no contenga el tag YouTube1
    And match response.tags !contains 'Youtube1'
    # Se usa match para validar que la respuesta sea un array
    And match response.tags == "#array"
    # Se usa match para validar que cada elemento del array sea un string
    And match each response.tags == '#string'
    # Se usa match para validar que la respuesta contenga al menos un tag del array
    And match response.tags  contains any [ 'YouTube', '123']
    # Se usa match para validar que la respuesta contenga solo los tags del array
    And match response.tags  contains only [ 'YouTube', 'Zoom']

  @ArticulosGet
  Scenario: Get all articles
    # Se usa path para definir el endpoint
    Given path 'articles'
    # Se usa param para definir los parametros de la consulta
    Given params {offset: 0, limit: 10}
    When method GET
    Then status 200
    # Se usa match para validar que la respuesta sea un array de 10 elementos
    And match response.articles == '#[10]'
    # Se usa match para validar que el primer elemento del array sea un string
    And match response.articlesCount == 10
    # Se usa match para validar que la respuesta contenga un array de artículos y el numero de artículos sea 10
    And match response == {"articles": "#array","articlesCount": 10}
    # Se usa match para buscar  en cada elemento del array  y si alguno tiene 19 pasa
    And match  response.articles[*].favoritesCount contains 19
    And match each response..favoritesCount == '#number'
    And match  response.articles[*].author.bio contains null
    # El operador `..` busca todos los campos llamados `following` en cualquier parte del JSON,
    # sin importar su nivel o estructura. Es una búsqueda recursiva profunda.
    # Por ejemplo, `response..following` devuelve una lista con todos los valores de los campos `following` que existan.
    And match each response..following == false
    And match each response..following == '#boolean'
    # Se usa match para validar que la respuesta contenga un campo bio que sea un string o null
    And match each response..bio == '##string'

  @ValidarElResponse
  Scenario: Validar la estructura del response
    * def timeValidator = read('classpath:helpers/TimeValidator.js')
    Given path 'articles'
    Given params {offset: 0, limit: 10}
    When method GET
    Then status 200
    And match each response.articles ==
  """
    {
      "slug": "#string",
      "title": "#string",
      "description": "#string",
      "body": "#string",
      "tagList": "#array",
      "createdAt": "#? timeValidator(_)",
      "updatedAt": "#? timeValidator(_)",
      "favorited": "#boolean",
      "favoritesCount": "#number",
      "author": {
        "username": "#string",
        "bio": "##string",
        "image": "##string",
        "following": "#boolean"
      }
    }
  """




