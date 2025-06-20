Feature: Test de API súper simple

  Background:
    # personaje base
    * def character = read('classpath:data/karate-test/example-character.json')

    # Agregar sufijo para evitar duplicidad de nombre
    * def uuid = java.util.UUID.randomUUID().toString().substring(0, 8)
    * set character.name = character.name + '-' + uuid
    * print 'Unique character name:', character.name
    
    * configure ssl = true
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/esterodr/api/characters'

  Scenario: Crear un personaje
    When request character
    And method post
    Then status 201
    * print response
    And match response contains character
    And match response.id == '#number'

  
