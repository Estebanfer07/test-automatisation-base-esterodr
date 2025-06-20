Feature: Test de API súper simple

  Background:
    # personaje base
    * def character = read('classpath:data/karate-test/example-character.json')
    * configure ssl = true
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/esterodr/api/characters'

    @Create-HappyPath
    Scenario: Crear un personaje
      # Agregar sufijo para evitar duplicidad de nombre
      * def uuid = java.util.UUID.randomUUID().toString().substring(0, 8)
      * set character.name = character.name + '-' + uuid
      * print 'Unique character name:', character.name
      When request character
      And method post
      Then status 201
      * print response
      And match response contains character
      And match response.id == '#number'
    
    @Create-Error-AlreadyExists
    Scenario: Error => Crear un personaje con nombre ya existente
      * call read('classpath:get-first-character.feature')
      * def dbCharacter = firstCharacter
      * character.name = dbCharacter.name

      When request character
      And method post
      Then status 400
      * print response
      And match response.error == "Character name already exists"
    
    @Create-Error-MissingFields
    Scenario: Error => Crear un personaje sin enviar la información necesaria
      When request {}
      And method post
      Then status 400
      * print response
      And match response.name == "Name is required"
      And match response.alterego == "Alterego is required"
      And match response.description == "Description is required"
      And match response.powers == "Powers are required"
      
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


    @GetById-Error-NotFound
    Scenario: Error => Obtener personaje por id inexistente
      And path -1
      When method get
      Then status 404
      
    @Update-HappyPath
    Scenario: Actualizar personaje
      * def editedDescription = "descripción editada"
      * call read('classpath:get-first-character.feature')
      * def dbCharacter = firstCharacter
      * def characterId = dbCharacter.id
      * dbCharacter.description = editedDescription
      * print 'ID del personaje a editar:', characterId
      * print 'personaje por editar:', dbCharacter
    
      And path characterId
      When request dbCharacter
      And method put
      Then status 200
      * print 'Personaje editado:', response
      And match response contains dbCharacter
    
    
