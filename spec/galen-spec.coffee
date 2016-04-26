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
    it 'tokenizes keyword', ->
      {tokens} = grammar.tokenizeLine '@objects'
      expect(tokens[0]).toEqual value: '@objects', scopes: ['source.galen', 'storage.type.galen']
