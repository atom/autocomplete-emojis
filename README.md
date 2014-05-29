# autocomplete-emojis package

[View the changelog](https://github.com/eqot/autocomplete-emojis/blob/master/CHANGELOG.md)

Adds emoji autocompletion to autocomplete-plus.

![autocomplete-emojis](https://dl.dropboxusercontent.com/u/972960/Documents/atom/atom-autocomplete-emojis/atom-autocomplete-emojis.gif)


## Installation

You can install autocomplete-emojis using the Preferences pane.

Please make sure you have [autocomplete-plus](https://atom.io/packages/autocomplete-plus) installed as well.

Also please note that autocomplete-plus is disabled in \*.md files by default.
If you would like to use autocomplete-emojis in \*.md file,
you need to change 'File Blacklist' in autocomplete-plus settings to ```.*```, or remove ```*.md```.

![autocomplete-plus-settings](https://dl.dropboxusercontent.com/u/972960/Documents/atom/atom-autocomplete-emojis/autocomplete-plus-settins.png)


## Features

* Shows autocompletion suggestions for emojis when typing ```:```
* Opens [Emoji Cheat Sheet](http://www.emoji-cheat-sheet.com/) in browser
  when you run the ```autocomplete-emojis:show-cheat-sheet``` command
* File whiltelisting


## Acknowledgements

* [autocomplete-plus](https://atom.io/packages/autocomplete-plus) and
  [its tutorial to create a new suggestion provider](https://github.com/saschagehlich/autocomplete-plus/wiki/Tutorial:-Registering-and-creating-a-suggestion-provider)
  inspired me to create this package
