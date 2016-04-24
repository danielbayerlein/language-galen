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
