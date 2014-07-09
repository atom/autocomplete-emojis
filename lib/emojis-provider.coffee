{Provider, Suggestion} = require 'autocomplete-plus'
fuzzaldrin = require 'fuzzaldrin'
emoji = require 'emoji-images'
path = require 'path'
minimatch = require 'minimatch'

module.exports =
class EmojiProvider extends Provider
  wordRegex: /:[a-zA-Z0-9\.\/_\+-]*/g
  possibleWords: emoji.list
  emojiFolder: 'atom://autocomplete-emojis/node_modules/emoji-images/pngs'

  buildSuggestions: ->
    return unless @currentFileWhitelisted()

    selection = @editor.getSelection()
    prefix = @prefixOfSelection selection
    return unless prefix.length

    suggestions = @findSuggestionsForPrefix prefix
    return unless suggestions.length
    return suggestions

  currentFileWhitelisted: ->
    whitelist = (atom.config.get('autocomplete-emojis.fileWhitelist') or '')
      .split ','
      .map (s) -> s.trim()

    fileName = path.basename @editor.getBuffer().getPath()
    for whitelistGlob in whitelist
      if minimatch fileName, whitelistGlob
        return true

    return false

  findSuggestionsForPrefix: (prefix) ->
    words = fuzzaldrin.filter @possibleWords, prefix

    suggestions = for word in words when word isnt prefix
      emojiImg = emoji word, @emojiFolder, 20
      if emojiImg.match /src="(.*\.png)"/
        uri = RegExp.$1
        emojiImg = emojiImg.replace uri, decodeURIComponent uri

      new Suggestion this, word: word, prefix: prefix, label: emojiImg, renderLabelAsHtml: true, className: 'emoji'

    return suggestions
