{Range}  = require('atom')
fuzzaldrin = require('fuzzaldrin')
emoji = require('emoji-images')

module.exports =
class EmojisProvider
  id: 'autocomplete-emojis-emojisprovider'
  selector: '*'
  wordRegex: /:[a-zA-Z0-9_\+-]*/g
  emojiFolder: 'atom://autocomplete-emojis/node_modules/emoji-images/pngs'

  requestHandler: (options = {}) =>
    return [] unless options.editor? and options.buffer? and options.cursor?

    prefix = @prefixForCursor(options.editor, options.buffer, options.cursor, options.position)
    return [] unless prefix.length

    suggestions = @findSuggestionsForPrefix(prefix)
    return [] unless suggestions?.length
    return suggestions

  prefixForCursor: (editor, buffer, cursor, position) =>
    return '' unless buffer? and cursor?
    start = @getBeginningOfCurrentWordBufferPosition(editor, position, {wordRegex: @wordRegex})
    end = cursor.getBufferPosition()
    return '' unless start? and end?
    buffer.getTextInRange(new Range(start, end))

  getBeginningOfCurrentWordBufferPosition: (editor, position, options = {}) ->
    return unless position?
    currentBufferPosition = position
    scanRange = [[currentBufferPosition.row, 0], currentBufferPosition]
    beginningOfWordPosition = null
    editor.backwardsScanInBufferRange (options.wordRegex), scanRange, ({range, stop}) ->
      if range.end.isGreaterThanOrEqual(currentBufferPosition)
        beginningOfWordPosition = range.start
        stop()
    beginningOfWordPosition

  findSuggestionsForPrefix: (prefix) ->
    words = fuzzaldrin.filter(emoji.list, prefix)

    suggestions = for word in words
      emojiImageElement = emoji(word, @emojiFolder, 20)
      if emojiImageElement.match(/src="(.*\.png)"/)
        uri = RegExp.$1
        emojiImageElement = emojiImageElement.replace(uri, decodeURIComponent(uri))

      suggestion =
        word: word
        prefix: prefix
        label: emojiImageElement
        renderLabelAsHtml: true
      suggestion

    return suggestions
