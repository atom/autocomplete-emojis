fs = require('fs')
path = require('path')
fuzzaldrin = require('fuzzaldrin')
emoji = require('emoji-images')

module.exports =
  selector: '.source.gfm, .text.md, .text.html, .text.slim, .text.plain, .text.git-commit, .comment, .string, .source.emojicode'

  wordRegex: /::?[\w\d_\+-]+$/
  emojiFolder: 'atom://autocomplete-emojis/node_modules/emoji-images/pngs'
  properties: {}
  keys: []

  loadProperties: ->
    fs.readFile path.resolve(__dirname, '..', 'properties.json'), (error, content) =>
      return if error

      @properties = JSON.parse(content)
      @keys = Object.keys(@properties)

  getSuggestions: ({editor, bufferPosition}) ->
    prefix = @getPrefix(editor, bufferPosition)
    return [] unless prefix?.length >= 2

    if prefix.charAt(1) is ':'
      isMarkdownEmojiOnly = true
      replacementPrefix = prefix
      prefix = prefix.slice(1)

    unicodeEmojis = []
    if atom.config.get('autocomplete-emojis.enableUnicodeEmojis') && not isMarkdownEmojiOnly
      unicodeEmojis = @getUnicodeEmojiSuggestions(prefix)

    markdownEmojis = []
    if atom.config.get('autocomplete-emojis.enableMarkdownEmojis')
      markdownEmojis = @getMarkdownEmojiSuggestions(prefix, replacementPrefix)

    return unicodeEmojis.concat(markdownEmojis)

  getPrefix: (editor, bufferPosition) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(@wordRegex)?[0] or ''

  getUnicodeEmojiSuggestions: (prefix) ->
    words = fuzzaldrin.filter(@keys, prefix.slice(1))
    for word in words
      {
        text: @properties[word].emoji
        replacementPrefix: prefix
        rightLabel: word
      }

  getMarkdownEmojiSuggestions: (prefix, replacementPrefix) ->
    words = fuzzaldrin.filter(emoji.list, prefix)
    for word in words
      emojiImageElement = emoji(word, @emojiFolder, 20)
      if emojiImageElement.match(/src="(.*\.png)"/)
        uri = RegExp.$1
        emojiImageElement = emojiImageElement.replace(uri, decodeURIComponent(uri))

      {
        text: word
        replacementPrefix: replacementPrefix || prefix
        rightLabelHTML: emojiImageElement
      }
