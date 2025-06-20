Feature: Obtener primer personaje de la lista

  Background:
    * configure ssl = true
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/esterodr/api/characters'

  Scenario: Obtener id del primer personaje de la lista
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/esterodr/api/characters'
    When method get
    Then status 200
    And assert response.length > 0
    * def lastCreated = response.reduce(function(a, b) { return a.id > b.id ? a : b })
    * karate.set('lastCharacterCreated', lastCreated)
