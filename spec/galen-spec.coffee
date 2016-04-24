describe 'Galen grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-galen')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.gspec')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.gspec'

  describe 'comments', ->
    it 'tokenizes line comments', ->
      {tokens} = grammar.tokenizeLine '# This line a comment'
      expect(tokens[0]).toEqual value: '#', scopes: ['source.gspec', 'comment.line.number-sign.gspec', 'punctuation.definition.comment.gspec']
      expect(tokens[1]).toEqual value: ' This line a comment', scopes: ['source.gspec', 'comment.line.number-sign.gspec']
