# Kiss' VIM Files

> My (neo)vim configuration

## Installation

**1. Clone the repository**

```sh
git clone https://github.com/filipekiss/vim ~/vimfiles
cd ~/vimfiles
```

2a. Make the magic happens

```sh
make magic
```

---

If you do not wish to do things in a magical way, you may run the commands below
(the order doesn't really matter)

**2b. Link required folders**

```sh
make link
```

**3. Install Plugins**

You can install from the lockfile, to ensure versions are the same as this
repository:

```sh
make restore
```

Or you can install the latest versions of all plugins:

```sh
make install
```

A new `bin/restore` file will be generated. You'll need to confirm you wish to
overwrite it.

Or simply open (neo)vim. The plugins should begin to install if any of them are
missing.

## Usage

You can check the help files in the `doc` folder or run `:help VimFiles` inside
(neo)vim.

## Adding extensions

See [extensions/readme](extensions/README.md) for instructions or `:help vimfiles-extensions` inside (neo)vim.

## Big Thanks

- [Rico's vim files](https://github.com/rstacruz/vimfiles/) - The inspiration to separate my vimfiles from my big dotfiles repository
- [Ahmed's dotfiles](http://github.com/ahmedelgabri/dotfiles) - Ahmed, for inspiring me to use vim during an interview a few years ago
- [Weslly Honorato](http://github.com/weslly) - For putting up with all my craziness when tweaking my dotfiles

## Related

- [Dotfiles](http://github.com/filipekiss/dotfiles) - My Dotfiles repository

**filipekiss/vim** © 2019+, Filipe Kiss Released under the [MIT] License.<br>
Authored and maintained by Filipe Kiss with help from contributors ([list][contributors]).

> GitHub [@filipekiss](https://github.com/filipekiss) &nbsp;&middot;&nbsp;
> Twitter [@filipekiss](https://twitter.com/filipekiss)

[mit]: http://mit-license.org/
[contributors]: http://github.com/filipekiss/vim/contributors
