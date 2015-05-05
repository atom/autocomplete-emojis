provider = require('./emojis-provider')

module.exports =
  config:
    enableUnicodeEmojis:
      type: 'boolean'
      default: true
    enableMarkdownEmojis:
      type: 'boolean'
      default: true

  activate: ->
    provider.loadProperties()

    atom.commands.add 'atom-workspace',
      'autocomplete-emojis:show-cheat-sheet': ->
        require('./emoji-cheat-sheet').show()

  getProvider: -> provider
