EmojiCheatSheet = require '../lib/emoji-cheat-sheet'

describe "AutocompleteEmojis", ->
  [workspaceElement, completionDelay, editor, editorView, autocompleteManager, mainModule] = []

  beforeEach ->
    # Set to live completion
    atom.config.set 'autocomplete-plus.enableAutoActivation', true

    # Set the completion delay
    completionDelay = 100
    atom.config.set 'autocomplete-plus.autoActivationDelay', completionDelay
    completionDelay += 100 # Rendering delay

    # Set the blacklist of autocomplete-plus
    atom.config.set 'autocomplete-plus.fileBlacklist', '.*'

    # Set the whitelist
    atom.config.set 'autocomplete-emojis.fileWhitelist', '*.md'

    waitsForPromise ->
      atom.workspace.open('sample.md').then (e) ->
        editor = e
        editorView = atom.views.getView(editor)

    runs ->
      workspaceElement = atom.views.getView(atom.workspace)
      jasmine.attachToDOM(workspaceElement)

    waitsForPromise -> atom.packages.activatePackage('autocomplete-plus').then (a) ->
      mainModule = a.mainModule
      autocompleteManager = mainModule.autocompleteManagers[0]

    waitsForPromise -> atom.packages.activatePackage('autocomplete-emojis')

  describe "when autocomplete-plus is enabled", ->
    it "shows autocompletions in whitelisted file when typing :+", ->
      runs ->
        expect(editorView.querySelector('.autocomplete-plus')).not.toExist()

        editor.moveToBottom()
        editor.insertText ':'
        editor.insertText '+'

        advanceClock completionDelay

        expect(editorView.querySelector('.autocomplete-plus')).toExist()
        expect(editorView.querySelector('.autocomplete-plus span.word')).toHaveText ':+1:'
        expect(editorView.querySelector('.autocomplete-plus span.label').innerHTML).toMatch /\+1\.png/

    it "not shows autocompletions in non-whitelisted file when typing :", ->
      runs ->
        atom.config.set 'autocomplete-emojis.fileWhitelist', '*.js'

        editor.moveToBottom()
        editor.insertText ':'

        advanceClock completionDelay

        expect(editorView.querySelector('.autocomplete-plus')).not.toExist()

    describe 'when the autocomplete-emojis:showCheatSheet event is triggered', ->
      it "opens Emoji Cheat Sheet in browser", ->
        spyOn EmojiCheatSheet, 'openUrlInBrowser'

        atom.commands.dispatch workspaceElement, 'autocomplete-emojis:show-cheat-sheet'

        expect(EmojiCheatSheet.openUrlInBrowser).toHaveBeenCalledWith 'http://www.emoji-cheat-sheet.com/'
