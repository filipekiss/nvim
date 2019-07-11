# Vim Extensions

I used to have a setup where all my extensions (plugins) where in my giant
`packages.vim` file and their configurations where in `after/plugin` folder.

In this new approach, I have multiple files, one for each extension. They are
responsible for installing and configuring the extensions at the same time. That
way, extensions and their configuration are together, so things are easier to
manage.

## Adding extensions

To add extensions, there are two options:

### Adding versioned extensions

To add a new versioned extension (one that should be replicated to all machines
where this setup is configured), add a new file to
`extensions/extension-name.vim`. The [file below] is an example for [startify]:

```viml
if extensions#isInstalling()
	extensions#loadExtension('https://github.com/mhinz/vim-startify')
	finish
endif

if extensions#isMissing('vim-startify', 'startify.vim')
	finish
endif

" ... Plugin configurations go here
```

The `extensions#loadExtension` function call is there for two reasons: If I ever
swap [vim-plug] for some other manager (or maybe even `minpac`), I can reduce
the number of changes that I need to do to make everything work. The second
reason is that it will check if the plugin needs to be installed or just loaded,
so I don't ever need to remember to call `:PlugInstall` manually. I'm lazy, I
know.

### Adding non-versioned extensions

I have different machines that need different setups. Some vim extensions are
very particular for a given setup, so there's no need to version it. If that's
the case, the `extensions/local/*` files are ignored. They must be written in
the same fashion as the files above.

### Configuring extensions

The biggest advantage of this setup is that the configuration may be put next to
the plugin installation command itself, making related things easier to find. By
default, the configurations set in the extension files are run _before_ the
plugin is loaded. Some plugins, like [abolish] need to have their settings ran
_after_ the plugin is loaded. In that case, there's a special function to add to
the `extension/<extension>.vim` file. Let's take Abolish as an example:

```viml
" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/tpope/vim-abolish')
    finish
endif

if extensions#isMissing('vim-abolish', 'abolish.vim')
    finish
endif

function! abolish#after() abort
    Abolish ret{run,unr}    return
    Abolish delte{,e}       delete{}
    Abolish funciton{,ed,s} function{}
    Abolish seconde{,s}     second{,s}
    Abolish relatvie        relative
    Abolish haeder          header
    Abolish realted         related
    Abolish withouth without
endfunction

```

The `abolish#after` function will be called from `extensions#after`. The pattern
to define the function name is `filename#after`, so for
`extensions/abolish.vim`, the function is called `abolish#after`.

### Delaying extensions loading

Some extensions, for example, [vim-devicons] are required to be loaded after
some other extensions, like [startify]. Since the extensions are loaded by
reading the files from the extensions folder, they're loaded in alphabetical
order. There are two approaches to loading an extension after another.

The first and most obvious one is to rename the extension file to something like
`z0_devicons.vim`, to ensure it will be the last extension loaded. This is
mostly useful if you have two or more extensions that require specific ordering,
so using the _"z trick"_ you can do something like `z0_startify.vim`,
`z1_devicons.vim`

Since my need is to just load the extension after everything else was loaded, I
added an `delay` option:

```viml
call extensions#loadExtension('https://github.com/ryanoasis/vim-devicons', {'delay': 1})
```

If the delay option is present, the extension will be delayed until all other
extensions were loaded. You can delay multiple extensions, but don't be fooled:
the `delay` attribute is a boolean, not an integer. It doesn't matter if it's 1
or 99, the extension will be added to the delayed list in the order they are
originally loaded, so `devicons.vim` and `startify.vim`, both with a delay would
work exactly as if no delay was set.

[abolish]: https://github.com/tpope/vim-abolish
[startify]: https://github.com/mhinz/vim-startify
[vim-plug]: https://github.com/junegunn/vim-plug
[file below]: /sidekicks/vim/extensions/startify.vim
[vim-devicons]: https://github.com/ryanoasis/vim-devicons
