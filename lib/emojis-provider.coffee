{Provider, Suggestion} = require "autocomplete-plus"

module.exports =
class ExampleProvider extends Provider
  buildSuggestions: ->
    suggestions = []
    suggestions.push new Suggestion(this, word: "async", label: "@async")
    suggestions.push new Suggestion(this, word: "attribute", label: "@attribute")
    suggestions.push new Suggestion(this, word: "author", label: "@author")
    suggestions.push new Suggestion(this, word: "beta", label: "@beta")
    suggestions.push new Suggestion(this, word: "borrows", label: "@borrows")
    suggestions.push new Suggestion(this, word: "bubbles", label: "@bubbles")
    return suggestions
