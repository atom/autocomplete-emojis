# autocomplete+ emojis suggestions [![Build Status](https://travis-ci.org/atom/autocomplete-emojis.svg?branch=master)](https://travis-ci.org/atom/autocomplete-emojis)

[View the changelog](https://github.com/atom/autocomplete-emojis/blob/master/CHANGELOG.md)

Adds Unicode emoji (like 😄) and Markdown emoji (like ```:smile:```) autocompletion to autocomplete-plus.

![autocomplete-emojis](https://cloud.githubusercontent.com/assets/734194/24737109/d9578ab8-1a51-11e7-8866-dee82b916601.gif)


## Features

* Shows Unicode and Markdown emojis as suggestions when typing ```:``` and a word<br>
　![smiley](https://cloud.githubusercontent.com/assets/734194/24737071/a92871f4-1a51-11e7-970c-37ffbcca98e6.png)
* Shows only Markdown emojis when typing ```::``` and a word<br>
　![markdown-smiley](https://cloud.githubusercontent.com/assets/734194/24737069/a62ec976-1a51-11e7-914f-d1594f9f4d5d.png)
* Disables Unicode and/or Markdown in the setting<br>
　![settings](https://cloud.githubusercontent.com/assets/734194/24737070/a7a9b87e-1a51-11e7-9cc5-06be2b342a45.png)
* Opens [Emoji Cheat Sheet](http://www.emoji-cheat-sheet.com/) for Markdown emojis in browser
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
* [gemoji](https://github.com/github/gemoji) gives [a JSON file](https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json) for Unicode emojis
