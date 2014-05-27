{Provider, Suggestion} = require 'autocomplete-plus'
fuzzaldrin = require 'fuzzaldrin'
emoji = require 'emoji-images'

module.exports =
class EmojiProvider extends Provider
  wordRegex: /:[a-zA-Z0-9\.\/_\+-]*/g
  possibleWords: emoji.list
  emojiLocal: 'atom://autocomplete-emojis/node_modules/emoji-images/pngs'
  emojiHost: 'https://raw.githubusercontent.com/arvida/emoji-cheat-sheet.com/master/public/graphics/emojis'

  buildSuggestions: ->
    selection = @editor.getSelection()
    prefix = @prefixOfSelection selection
    return unless prefix.length

    suggestions = @findSuggestionsForPrefix prefix
    return unless suggestions.length
    return suggestions

  findSuggestionsForPrefix: (prefix) ->
    words = fuzzaldrin.filter @possibleWords, prefix

    uriToEmoji = if atom.config.get 'autocomplete-emojis.getImagesFromCheatSheetSite' then @emojiHost else @emojiLocal

    suggestions = for word in words when word isnt prefix
      emojiImg = emoji word, uriToEmoji, 20
      if emojiImg.match /src="(.*\.png)"/
        uri = RegExp.$1
        emojiImg = emojiImg.replace uri, decodeURIComponent uri

      new Suggestion this, word: word, prefix: prefix, label: emojiImg, renderLabelAsHtml: true

    return suggestions
