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

    @Create-HappyPath
    Scenario: Crear un personaje
      When request character
      And method post
      Then status 201
      * print response
      And match response contains character
      And match response.id == '#number'
    
    @Create-Error-AlreadyExists
    Scenario: Crear un personaje con nombre ya existente
      * call read('classpath:get-first-character.feature')
      * def dbCharacter = firstCharacter
      * character.name = dbCharacter.name

      When request character
      And method post
      Then status 400
      * print response
      And match response.error == "Character name already exists"
      
    @GetAll-HappyPath
    Scenario: Obtener todos los personajes
      When method get
      Then status 200
      * print response
      And match response != null
      And assert response.length > 0
      
    @GetById-HappyPath
    Scenario: Obtener personaje por id
      * call read('classpath:get-first-character.feature')
      * def dbCharacter = firstCharacter
      * def characterId = dbCharacter.id
      * print 'ID del personaje a buscar:', characterId
      
      And path characterId
      When method get
      Then status 200
      * print 'Personaje encontrado:', response
      And match response contains dbCharacter


      @GetById-NotFound
      Scenario: Obtener personaje por id
        And path -1
        When method get
        Then status 404
      
   
