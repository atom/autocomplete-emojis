{Provider, Suggestion} = require 'autocomplete-plus'
fuzzaldrin = require 'fuzzaldrin'
emoji = require 'emoji-images'

module.exports =
class EmojiProvider extends Provider
  wordRegex: /:[a-zA-Z0-9\.\/_\+-]*/g
  possibleWords: emoji.list
  emojiFolder: 'atom://autocomplete-emojis/node_modules/emoji-images/pngs'
  buildSuggestions: ->
    selection = @editor.getSelection()
    prefix = @prefixOfSelection selection
    return unless prefix.length

    suggestions = @findSuggestionsForPrefix prefix
    return unless suggestions.length
    return suggestions

  findSuggestionsForPrefix: (prefix) ->
    words = fuzzaldrin.filter @possibleWords, prefix

    suggestions = for word in words when word isnt prefix
      emojiImg = emoji word, @emojiFolder, 20
      new Suggestion this, word: word, prefix: prefix, label: emojiImg, renderLabelAsHtml: true

    return suggestions
