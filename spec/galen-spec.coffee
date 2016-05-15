path = require 'path'
grammarTest = require 'atom-grammar-test'

describe 'Galen grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-galen'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.galen'

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.galen'

  grammarTest path.join(__dirname, 'fixtures/comments.gspec')
  grammarTest path.join(__dirname, 'fixtures/object-definition.gspec')
  grammarTest path.join(__dirname, 'fixtures/multiple-object-definition.gspec')
  grammarTest path.join(__dirname, 'fixtures/objects-corrections.gspec')
  grammarTest path.join(__dirname, 'fixtures/object-groups.gspec')
  grammarTest path.join(__dirname, 'fixtures/declaring-groups-inline-with-objects.gspec')
  grammarTest path.join(__dirname, 'fixtures/specs.gspec')
