{WorkspaceView} = require 'atom'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AutocompleteEmojis", ->
  [activationPromise, completionDelay] = []

  beforeEach ->
    # Enable live autocompletion
    atom.config.set "autocomplete-plus.enableAutoActivation", true

    # Set the completion delay
    completionDelay = 100
    atom.config.set "autocomplete-plus.autoActivationDelay", completionDelay
    completionDelay += 100 # Rendering delay

    atom.workspaceView = new WorkspaceView()
    atom.workspaceView.openSync "sample.js"
    atom.workspaceView.simulateDomAttachment()

    activationPromise = atom.packages.activatePackage("autocomplete-emojis")
      .then => atom.packages.activatePackage("autocomplete-plus")
    waitsForPromise ->
      activationPromise

  it "shows autocompletions when typing :+", ->
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
