fuzzaldrin = require('fuzzaldrin')
emoji = require('emoji-images')

module.exports =
  selector: '*'

  wordRegex: /:[\w\d_\+-]+$/
  emojiFolder: 'atom://autocomplete-emojis/node_modules/emoji-images/pngs'

  getSuggestions: ({editor, bufferPosition}) ->
    prefix = @getPrefix(editor, bufferPosition)
    return [] unless prefix?.length >= 2

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

  getPrefix: (editor, bufferPosition) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(@wordRegex)?[0] or ''
