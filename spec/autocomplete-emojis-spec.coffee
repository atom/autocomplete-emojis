{WorkspaceView} = require 'atom'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

EmojiCheatSheet = require '../lib/emoji-cheat-sheet.coffee'

describe "AutocompleteEmojis", ->
  [activationPromise, completionDelay] = []

  beforeEach ->
    # Enable live autocompletion
    atom.config.set "autocomplete-plus.enableAutoActivation", true

    # Set the completion delay
    completionDelay = 100
    atom.config.set "autocomplete-plus.autoActivationDelay", completionDelay
    completionDelay += 100 # Rendering delay

    # Set the blacklist of autocomplete-plus
    atom.config.set "autocomplete-plus.fileBlacklist", ".*"

    # Set the whitelist
    atom.config.set "autocomplete-emojis.fileWhitelist", "*.md"

    atom.workspaceView = new WorkspaceView()
    atom.workspaceView.openSync "sample.md"
    atom.workspaceView.simulateDomAttachment()

    activationPromise = atom.packages.activatePackage("autocomplete-emojis")
      .then => atom.packages.activatePackage("autocomplete-plus")
    waitsForPromise ->
      activationPromise

  it "shows autocompletions in whitelisted file when typing :+", ->
    runs ->
      editorView = atom.workspaceView.getActiveView()
      editorView.attachToDom()
      editor = editorView.getEditor()

      expect(editorView.find(".autocomplete-plus")).not.toExist()

      editor.moveCursorToBottom()
      editor.insertText ":"
      editor.insertText "+"

      advanceClock completionDelay

      expect(editorView.find(".autocomplete-plus")).toExist()
      expect(editorView.find(".autocomplete-plus span.word:eq(0)")).toHaveText ":+1:"
      expect(editorView.find(".autocomplete-plus span.label:eq(0)").html()).toMatch /\+1\.png/

  it "not shows autocompletions in non-whitelisted file when typing :", ->
    runs ->
      atom.config.set "autocomplete-emojis.fileWhitelist", "*.js"

      editorView = atom.workspaceView.getActiveView()
      editorView.attachToDom()
      editor = editorView.getEditor()

      editor.moveCursorToBottom()
      editor.insertText ":"

      advanceClock completionDelay

      expect(editorView.find(".autocomplete-plus")).not.toExist()

  describe 'when the autocomplete-emojis:showCheatSheet event is triggered', ->
    it "opens Emoji Cheat Sheet in browser", ->
      spyOn EmojiCheatSheet, 'openUrlInBrowser'

      atom.workspaceView.trigger 'autocomplete-emojis:show-cheat-sheet'

      expect(EmojiCheatSheet.openUrlInBrowser).toHaveBeenCalledWith 'http://www.emoji-cheat-sheet.com/'
