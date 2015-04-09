provider = require('./emojis-provider')

module.exports =
  configDefaults:
    enableUnicodeEmoji: true
    enableMarkdownEmoji: true

  activate: ->
    provider.loadProperties()

    atom.commands.add 'atom-workspace',
      'autocomplete-emojis:show-cheat-sheet': ->
        require('./emoji-cheat-sheet').show()

  getProvider: -> provider
