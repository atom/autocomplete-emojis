##### Atom and all repositories under Atom will be archived on December 15, 2022. Learn more in our [official announcement](https://github.blog/2022-06-08-sunsetting-atom/)
 # autocomplete+ emojis suggestions [![Build Status](https://travis-ci.org/atom/autocomplete-emojis.svg?branch=master)](https://travis-ci.org/atom/autocomplete-emojis)

[View the changelog](https://github.com/atom/autocomplete-emojis/blob/master/CHANGELOG.md)

Adds unicode emoji (like 😄) and markdown emoji (like ```:smile:```) autocompletion to autocomplete-plus.

![autocomplete-emojis](https://github.com/atom/autocomplete-emojis/blob/master/doc/images/atom-autocomplete-emojis.gif?raw=true)


## Features

* Shows unicode and markdown emojis as suggestions when typing ```:``` and a word<br>
　![smiley](https://github.com/atom/autocomplete-emojis/blob/master/doc/images/atom-autocomplete-emojis-smiley.png?raw=true)
* Shows only markdown emojis when typing ```::``` and a word<br>
　![markdown-smiley](https://github.com/atom/autocomplete-emojis/blob/master/doc/images/atom-autocomplete-emojis-markdown-smiley.png?raw=true)
* Disables unicode and/or markdown in the setting<br>
　![settings](https://github.com/atom/autocomplete-emojis/blob/master/doc/images/atom-autocomplete-emojis-settings.png?raw=true)
* Opens [Emoji Cheat Sheet](http://www.emoji-cheat-sheet.com/) for markdown emojis in browser
  when you run the ```autocomplete-emojis:show-cheat-sheet``` command


## Scopes

Please note that this package shows emoji suggestions in the scopes below.

* .source.gfm
* .text.md
* .text.html
* .text.slim
* .text.plain
* .text.git-commit
* .comment
* .string
* .source.emojicode


## Acknowledgements

* [autocomplete-plus](https://atom.io/packages/autocomplete-plus) and
  [its document of the provider API](https://github.com/atom/autocomplete-plus/wiki/Provider-API)
  inspired and helped me a lot to create this package
* [gemoji](https://github.com/github/gemoji) gives [a JSON file](https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json) for unicode emojis
