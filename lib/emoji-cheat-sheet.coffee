Shell = require('shell')

module.exports =
class EmojiCheatSheet
  @show: ->
    @openUrlInBrowser('http://www.emoji-cheat-sheet.com/')

  @openUrlInBrowser: (url) ->
    Shell.openExternal(url)
