EmojiCheatSheet = require('../lib/emoji-cheat-sheet')

describe 'Autocomplete Emojis', ->
  [workspaceElement, completionDelay, editor, editorView, emojisMain, autocompleteMain, autocompleteManager] = []

  beforeEach ->
    runs ->
      # Set to live completion
      atom.config.set('autocomplete-plus.enableAutoActivation', true)
      # Set the completion delay
      completionDelay = 100
      atom.config.set('autocomplete-plus.autoActivationDelay', completionDelay)
      completionDelay += 100 # Rendering delay
      workspaceElement = atom.views.getView(atom.workspace)
      jasmine.attachToDOM(workspaceElement)
      autocompleteMain = atom.packages.loadPackage('autocomplete-plus').mainModule
      spyOn(autocompleteMain, 'consumeProvider').andCallThrough()
      emojisMain = atom.packages.loadPackage('autocomplete-emojis').mainModule
      spyOn(emojisMain, 'provide').andCallThrough()

    waitsForPromise ->
      atom.workspace.open('sample.md').then (e) ->
        editor = e
        editorView = atom.views.getView(editor)

    waitsForPromise ->
      atom.packages.activatePackage('autocomplete-plus')

    waitsFor ->
      autocompleteMain.autocompleteManager?.ready

    runs ->
      autocompleteManager = autocompleteMain.autocompleteManager
      spyOn(autocompleteManager, 'findSuggestions').andCallThrough()
      spyOn(autocompleteManager, 'displaySuggestions').andCallThrough()
      spyOn(autocompleteManager, 'showSuggestionList').andCallThrough()
      spyOn(autocompleteManager, 'hideSuggestionList').andCallThrough()

    waitsForPromise ->
      atom.packages.activatePackage('autocomplete-emojis')

    waitsFor ->
      emojisMain.provide.calls.length is 1

    waitsFor ->
      autocompleteMain.consumeProvider.calls.length is 1

  afterEach ->
    jasmine.unspy(autocompleteMain, 'consumeProvider')
    jasmine.unspy(emojisMain, 'provide')
    jasmine.unspy(autocompleteManager, 'findSuggestions')
    jasmine.unspy(autocompleteManager, 'displaySuggestions')
    jasmine.unspy(autocompleteManager, 'showSuggestionList')
    jasmine.unspy(autocompleteManager, 'hideSuggestionList')

  describe 'when autocomplete-plus is enabled', ->
    it 'shows autocompletions when typing .+', ->
      runs ->
        expect(editorView.querySelector('.autocomplete-plus')).not.toExist()

        editor.moveToBottom()
        editor.insertText(':')
        editor.insertText('+')

        advanceClock(completionDelay)

      waitsFor ->
        autocompleteManager.displaySuggestions.calls.length is 1

      runs ->
        expect(editorView.querySelector('.autocomplete-plus')).toExist()
        expect(editorView.querySelector('.autocomplete-plus span.word')).toHaveText ':+1:'
        expect(editorView.querySelector('.autocomplete-plus span.completion-label').innerHTML).toMatch /\+1\.png/

  describe 'when the autocomplete-emojis:showCheatSheet event is triggered', ->
    it 'opens Emoji Cheat Sheet in browser', ->
      spyOn EmojiCheatSheet, 'openUrlInBrowser'

      atom.commands.dispatch workspaceElement, 'autocomplete-emojis:show-cheat-sheet'

      expect(EmojiCheatSheet.openUrlInBrowser).toHaveBeenCalledWith 'http://www.emoji-cheat-sheet.com/'
