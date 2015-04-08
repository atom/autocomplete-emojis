fs = require('fs')
path = require('path')
fuzzaldrin = require('fuzzaldrin')
emoji = require('emoji-images')

module.exports =
  selector: '.source.gfm, .text.html, .text.plain, .comment, .string'

  wordRegex: /:[\w\d_\+-]+$/
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

    unicodeEmojis = @getUnicodeEmojiSuggestions(prefix)
    markdownEmojis = @getMarkdownEmojiSuggestions(prefix)

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

  getMarkdownEmojiSuggestions: (prefix) ->
    words = fuzzaldrin.filter(emoji.list, prefix)
    for word in words
      emojiImageElement = emoji(word, @emojiFolder, 20)
      if emojiImageElement.match(/src="(.*\.png)"/)
        uri = RegExp.$1
        emojiImageElement = emojiImageElement.replace(uri, decodeURIComponent(uri))

      {
        text: word
        replacementPrefix: prefix
        rightLabelHTML: emojiImageElement
      }
