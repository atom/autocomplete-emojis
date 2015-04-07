emojiCheatSheet = require('../lib/emoji-cheat-sheet')

packagesToTest =
  gfm:
    name: 'language-gfm'
    file: 'test.md'

describe "Emojis autocompletions", ->
  [editor, provider] = []

  getCompletions = ->
    cursor = editor.getLastCursor()
    start = cursor.getBeginningOfCurrentWordBufferPosition()
    end = cursor.getBufferPosition()
    prefix = editor.getTextInRange([start, end])
    request =
      editor: editor
      bufferPosition: end
      scopeDescriptor: cursor.getScopeDescriptor()
      prefix: prefix
    provider.getSuggestions(request)

  beforeEach ->
    waitsForPromise -> atom.packages.activatePackage('autocomplete-emojis')

    runs ->
      provider = atom.packages.getActivePackage('autocomplete-emojis').mainModule.getProvider()

  Object.keys(packagesToTest).forEach (packageLabel) ->
    describe "#{packageLabel} files", ->
      beforeEach ->
        waitsForPromise -> atom.packages.activatePackage(packagesToTest[packageLabel].name)
        waitsForPromise -> atom.workspace.open(packagesToTest[packageLabel].file)
        runs -> editor = atom.workspace.getActiveTextEditor()

      it "returns no completions without a prefix", ->
        editor.setText('')
        expect(getCompletions().length).toBe 0

      it "returns no completions with an improper prefix", ->
        editor.setText(':')
        editor.setCursorBufferPosition([0, 0])
        expect(getCompletions().length).toBe 0
        editor.setCursorBufferPosition([0, 1])
        expect(getCompletions().length).toBe 0

        editor.setText(':*')
        editor.setCursorBufferPosition([0, 1])
        expect(getCompletions().length).toBe 0

      it "autocompletes emojis with a proper prefix", ->
        editor.setText """
          :sm
        """
        editor.setCursorBufferPosition([0, 3])
        completions = getCompletions()
        expect(completions.length).toBe 47
        expect(completions[0].text).toBe ':smirk:'
        expect(completions[0].replacementPrefix).toBe ':sm'
        expect(completions[0].rightLabelHTML).toMatch /smirk\.png/
        expect(completions[1].text).toBe ':smile:'
        expect(completions[1].replacementPrefix).toBe ':sm'
        expect(completions[1].rightLabelHTML).toMatch /smile\.png/

        editor.setText """
          :+
        """
        editor.setCursorBufferPosition([0, 2])
        completions = getCompletions()
        expect(completions.length).toBe 1
        expect(completions[0].text).toBe ':+1:'
        expect(completions[0].replacementPrefix).toBe ':+'
        expect(completions[0].rightLabelHTML).toMatch /\+1\.png/

  describe 'when the autocomplete-emojis:showCheatSheet event is triggered', ->
    workspaceElement = null
    beforeEach ->
      workspaceElement = atom.views.getView(atom.workspace)

    it 'opens Emoji Cheat Sheet in browser', ->
      spyOn emojiCheatSheet, 'openUrlInBrowser'

      atom.commands.dispatch workspaceElement, 'autocomplete-emojis:show-cheat-sheet'

      expect(emojiCheatSheet.openUrlInBrowser).toHaveBeenCalledWith 'http://www.emoji-cheat-sheet.com/'
