AutocompleteEmojisView = require './autocomplete-emojis-view'

module.exports =
  autocompleteEmojisView: null

  activate: (state) ->
    @autocompleteEmojisView = new AutocompleteEmojisView(state.autocompleteEmojisViewState)

  deactivate: ->
    @autocompleteEmojisView.destroy()

  serialize: ->
    autocompleteEmojisViewState: @autocompleteEmojisView.serialize()
