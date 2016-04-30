describe 'Galen grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-galen')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.galen')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.galen'

  describe 'comments', ->
    it 'tokenizes line comments', ->
      {tokens} = grammar.tokenizeLine '# This line a comment'
      expect(tokens[0]).toEqual value: '#', scopes: ['source.galen', 'comment.line.number-sign.galen', 'punctuation.definition.comment.galen']
      expect(tokens[1]).toEqual value: ' This line a comment', scopes: ['source.galen', 'comment.line.number-sign.galen']

  describe 'object definition', ->
    it 'tokenizes @objects keyword', ->
      {tokens} = grammar.tokenizeLine '@objects'
      expect(tokens[0]).toEqual value: '@objects', scopes: ['source.galen', 'storage.type.galen']

    it 'tokenizes @groups keyword', ->
      {tokens} = grammar.tokenizeLine '@groups'
      expect(tokens[0]).toEqual value: '@groups', scopes: ['source.galen', 'storage.type.galen']

    it 'tokenizes id locator', ->
      {tokens} = grammar.tokenizeLine '''
      @objects
          search_panel            id      search-bar
      '''
      expect(tokens[0]).toEqual value: '@objects', scopes: ['source.galen', 'storage.type.galen']
      expect(tokens[3]).toEqual value: 'search_panel', scopes: ['source.galen', 'entity.name.type.object.galen']
      expect(tokens[5]).toEqual value: 'id', scopes: ['source.galen', 'support.type.locators.galen']
      expect(tokens[7]).toEqual value: 'search-bar', scopes: ['source.galen', 'entity.other.attribute-name.selector.galen']

    it 'tokenizes xpath locator', ->
      {tokens} = grammar.tokenizeLine '''
      @objects
          search_panel_input      xpath   //div[@id='search-bar']/input[@type='text']
      '''
      expect(tokens[0]).toEqual value: '@objects', scopes: ['source.galen', 'storage.type.galen']
      expect(tokens[3]).toEqual value: 'search_panel_input', scopes: ['source.galen', 'entity.name.type.object.galen']
      expect(tokens[5]).toEqual value: 'xpath', scopes: ['source.galen', 'support.type.locators.galen']
      expect(tokens[7]).toEqual value: '//div[@id=\'search-bar\']/input[@type=\'text\']', scopes: ['source.galen', 'entity.other.attribute-name.selector.galen']

    it 'tokenizes css locator', ->
      {tokens} = grammar.tokenizeLine '''
      @objects
          search_panel_button     css     #search-bar a
      '''
      expect(tokens[0]).toEqual value: '@objects', scopes: ['source.galen', 'storage.type.galen']
      expect(tokens[3]).toEqual value: 'search_panel_button', scopes: ['source.galen', 'entity.name.type.object.galen']
      expect(tokens[5]).toEqual value: 'css', scopes: ['source.galen', 'support.type.locators.galen']
      expect(tokens[7]).toEqual value: '#search-bar a', scopes: ['source.galen', 'entity.other.attribute-name.selector.galen']

    it 'tokenizes without locator', ->
      {tokens} = grammar.tokenizeLine '''
      @objects
          search_panel_button     #search-bar a
      '''
      expect(tokens[0]).toEqual value: '@objects', scopes: ['source.galen', 'storage.type.galen']
      expect(tokens[3]).toEqual value: 'search_panel_button', scopes: ['source.galen', 'entity.name.type.object.galen']
      expect(tokens[5]).toEqual value: '#search-bar a', scopes: ['source.galen', 'entity.other.attribute-name.selector.galen']

    it 'tokenizes asterisk in object name', ->
      {tokens} = grammar.tokenizeLine '''
      @objects
          menu_item-*     css     #menu li a
      '''
      expect(tokens[0]).toEqual value: '@objects', scopes: ['source.galen', 'storage.type.galen']
      expect(tokens[3]).toEqual value: 'menu_item-*', scopes: ['source.galen', 'entity.name.type.object.galen']
      expect(tokens[5]).toEqual value: 'css', scopes: ['source.galen', 'support.type.locators.galen']
      expect(tokens[7]).toEqual value: '#menu li a', scopes: ['source.galen', 'entity.other.attribute-name.selector.galen']

    it 'tokenizes nesting objects', ->
      {tokens} = grammar.tokenizeLine '''
      @objects
          search_panel   #search-bar
              input      input[type='text']
              button     a
      '''
      expect(tokens[0]).toEqual value: '@objects', scopes: ['source.galen', 'storage.type.galen']
      expect(tokens[3]).toEqual value: 'search_panel', scopes: ['source.galen', 'entity.name.type.object.galen']
      expect(tokens[5]).toEqual value: '#search-bar', scopes: ['source.galen', 'entity.other.attribute-name.selector.galen']
      expect(tokens[8]).toEqual value: 'input', scopes: ['source.galen', 'entity.name.type.object.galen']
      expect(tokens[10]).toEqual value: 'input[type=\'text\']', scopes: ['source.galen', 'entity.other.attribute-name.selector.galen']
      expect(tokens[13]).toEqual value: 'button', scopes: ['source.galen', 'entity.name.type.object.galen']
      expect(tokens[15]).toEqual value: 'a', scopes: ['source.galen', 'entity.other.attribute-name.selector.galen']

    it 'tokenizes objects corrections', ->
      {tokens} = grammar.tokenizeLine '''
      @objects
          some_test_object    @(0, 0, -50, 0)   id  some-container
      '''
      expect(tokens[0]).toEqual value: '@objects', scopes: ['source.galen', 'storage.type.galen']
      expect(tokens[3]).toEqual value: 'some_test_object', scopes: ['source.galen', 'entity.name.type.object.galen']
      expect(tokens[5]).toEqual value: '@', scopes: ['source.galen', 'support.function.corrections.gspec']
      expect(tokens[6]).toEqual value: '(', scopes: ['source.galen', 'punctuation.definition.parameters.begin.bracket.galen']
      expect(tokens[7]).toEqual value: '0, 0, -50, 0', scopes: ['source.galen', 'variable.parameter.corrections.galen']
      expect(tokens[8]).toEqual value: ')', scopes: ['source.galen', 'punctuation.definition.parameters.end.bracket.galen']
      expect(tokens[10]).toEqual value: 'id', scopes: ['source.galen', 'support.type.locators.galen']
      expect(tokens[12]).toEqual value: 'some-container', scopes: ['source.galen', 'entity.other.attribute-name.selector.galen']

    it 'tokenizes object groups', ->
      {tokens} = grammar.tokenizeLine '''
      @groups
          skeleton_elements   header, menu, content, footer
      '''
      expect(tokens[0]).toEqual value: '@groups', scopes: ['source.galen', 'storage.type.galen']
      expect(tokens[3]).toEqual value: 'skeleton_elements', scopes: ['source.galen', 'entity.name.type.object.galen']
      expect(tokens[5]).toEqual value: 'header, menu, content, footer', scopes: ['source.galen', 'entity.other.attribute-name.selector.galen']

  describe 'sections', ->
    it 'tokenizes declaration', ->
      {tokens} = grammar.tokenizeLine '''
      = Section =
      '''
      expect(tokens[0]).toEqual value: '= Section =', scopes: ['source.galen', 'entity.name.function.section.galen']

    it 'tokenizes multiple declaration', ->
      {tokens} = grammar.tokenizeLine '''
      = Header section =
          = Icons and text =
      '''
      expect(tokens[0]).toEqual value: '= Header section =', scopes: ['source.galen', 'entity.name.function.section.galen']
      expect(tokens[3]).toEqual value: '= Icons and text =', scopes: ['source.galen', 'entity.name.function.section.galen']
