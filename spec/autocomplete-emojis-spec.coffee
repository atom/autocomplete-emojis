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

    waitsFor -> Object.keys(provider.properties).length > 0

  Object.keys(packagesToTest).forEach (packageLabel) ->
    describe "#{packageLabel} files", ->
      beforeEach ->
        atom.config.set('autocomplete-emojis.enableUnicodeEmojis', true)
        atom.config.set('autocomplete-emojis.enableMarkdownEmojis', true)

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
        expect(completions.length).toBe 96
        expect(completions[ 0].text).toBe '😄'
        expect(completions[ 0].replacementPrefix).toBe ':sm'
        expect(completions[49].text).toBe ':smirk:'
        expect(completions[49].replacementPrefix).toBe ':sm'
        expect(completions[49].rightLabelHTML).toMatch /smirk\.png/
        expect(completions[50].text).toBe ':smile:'
        expect(completions[50].replacementPrefix).toBe ':sm'
        expect(completions[50].rightLabelHTML).toMatch /smile\.png/

        editor.setText """
          :+
        """
        editor.setCursorBufferPosition([0, 2])
        completions = getCompletions()
        expect(completions.length).toBe 2
        expect(completions[0].text).toBe '👍'
        expect(completions[0].replacementPrefix).toBe ':+'
        expect(completions[1].text).toBe ':+1:'
        expect(completions[1].replacementPrefix).toBe ':+'
        expect(completions[1].rightLabelHTML).toMatch /\+1\.png/

      it "autocompletes markdown emojis with '::'", ->
        editor.setText """
          ::sm
        """
        editor.setCursorBufferPosition([0, 4])
        completions = getCompletions()
        expect(completions.length).toBe 47
        expect(completions[0].text).toBe ':smirk:'
        expect(completions[0].replacementPrefix).toBe '::sm'
        expect(completions[0].rightLabelHTML).toMatch /smirk\.png/
        expect(completions[1].text).toBe ':smile:'
        expect(completions[1].replacementPrefix).toBe '::sm'
        expect(completions[1].rightLabelHTML).toMatch /smile\.png/

      it "autocompletes unicode emojis with a proper prefix", ->
        atom.config.set('autocomplete-emojis.enableUnicodeEmojis', true)
        atom.config.set('autocomplete-emojis.enableMarkdownEmojis', false)

        editor.setText """
          :sm
        """
        editor.setCursorBufferPosition([0, 3])
        completions = getCompletions()
        expect(completions.length).toBe 49
        expect(completions[ 0].text).toBe '😄'
        expect(completions[ 0].replacementPrefix).toBe ':sm'

      it "autocompletes markdown emojis with a proper prefix", ->
        atom.config.set('autocomplete-emojis.enableUnicodeEmojis', false)
        atom.config.set('autocomplete-emojis.enableMarkdownEmojis', true)

        editor.setText """
          :sm
        """
        editor.setCursorBufferPosition([0, 3])
        completions = getCompletions()
        expect(completions.length).toBe 47
        expect(completions[ 0].text).toBe ':smirk:'
        expect(completions[ 0].replacementPrefix).toBe ':sm'

      it "autocompletes no emojis", ->
        atom.config.set('autocomplete-emojis.enableUnicodeEmojis', false)
        atom.config.set('autocomplete-emojis.enableMarkdownEmojis', false)

        editor.setText """
          :sm
        """
        editor.setCursorBufferPosition([0, 3])
        completions = getCompletions()
        expect(completions.length).toBe 0

  describe 'when the autocomplete-emojis:showCheatSheet event is triggered', ->
    workspaceElement = null
    beforeEach ->
      workspaceElement = atom.views.getView(atom.workspace)

    it 'opens Emoji Cheat Sheet in browser', ->
      spyOn emojiCheatSheet, 'openUrlInBrowser'

      atom.commands.dispatch workspaceElement, 'autocomplete-emojis:show-cheat-sheet'

      expect(emojiCheatSheet.openUrlInBrowser).toHaveBeenCalledWith 'http://www.emoji-cheat-sheet.com/'
