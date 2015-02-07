module.exports =
  provider: null
  ready: false

  activate: ->
    @ready = true

    atom.commands.add 'atom-workspace',
      'autocomplete-emojis:show-cheat-sheet': ->
        require('./emoji-cheat-sheet').show()

  deactivate: ->
    @provider = null

  getProvider: ->
    return @provider if @provider?
    EmojisProvider = require('./emojis-provider')
    @provider = new EmojisProvider()
    return @provider

  provide: ->
    return {provider: @getProvider()}
