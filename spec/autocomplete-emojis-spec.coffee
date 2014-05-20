{WorkspaceView} = require 'atom'
AutocompleteEmojis = require '../lib/autocomplete-emojis'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AutocompleteEmojis", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('autocomplete-emojis')

  describe "when the autocomplete-emojis:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.autocomplete-emojis')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'autocomplete-emojis:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.autocomplete-emojis')).toExist()
        atom.workspaceView.trigger 'autocomplete-emojis:toggle'
        expect(atom.workspaceView.find('.autocomplete-emojis')).not.toExist()
