EmojisProvider = require './emojis-provider.coffee'
EmojiCheatSheet = require './emoji-cheat-sheet.coffee'

module.exports =
  configDefaults:
    fileWhitelist: "*.md"

  editorSubscription: null
  providers: []
  autocomplete: null

  activate: ->
    atom.workspaceView.command 'autocomplete-emojis:show-cheat-sheet', => EmojiCheatSheet.show()

    atom.packages.activatePackage 'autocomplete-plus'
      .then (pkg) =>
        @autocomplete = pkg.mainModule
        @registerProviders()

  registerProviders: ->
    @editorSubscription = atom.workspaceView.eachEditorView (editorView) =>
      if editorView.attached and not editorView.mini
        provider = new EmojisProvider editorView

        @autocomplete.registerProviderForEditorView provider, editorView

        @providers.push provider

  deactivate: ->
    @editorSubscription?.off()
    @editorSubscription = null

    @providers.forEach (provider) =>
      @autocomplete.unregisterProvider provider

    @providers = []
