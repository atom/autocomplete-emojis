{View} = require 'atom'

module.exports =
class AutocompleteEmojisView extends View
  @content: ->
    @div class: 'autocomplete-emojis overlay from-top', =>
      @div "The AutocompleteEmojis package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "autocomplete-emojis:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "AutocompleteEmojisView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
