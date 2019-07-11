# Help command adapted from https://gist.github.com/prwhite/8168133#gistcomment-2749866
SHELL=bash

# Makefile variables
# Set path to nvim
vim := $(shell which nvim)
ifeq ($(strip $(vim)),)
	# If nvim is not on path, use vim
	vim := $(shell which vim)
endif
# Current folder location resolved
pwd := $(shell pwd -LP)
# Vim Plug Lockfile
lockfile := $(pwd)/bin/restore

# Formating
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)
COLUMNS := $(shell tput cols)
DESCRIPTION_SIZE := $((COLUMNS/3))

.DEFAULT_GOAL := help
## Print this help
.PHONY: help
help:
	@printf "VimFiles\n\n"
	@printf "USAGE:\n"
	@printf "┌"
	@printf "%.0s━" {4..$(COLUMNS)}
	@printf "┐\n"

	@awk '{ \
			if ($$0 ~ /^.PHONY: [a-zA-Z\-\_0-9]+$$/) { \
				helpCommand = substr($$0, index($$0, ":") + 2); \
				if (helpMessage) { \
					printf "│\033[36m  %-17s\033[0m│ %-56s│\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^[a-zA-Z\-\_0-9.]+:/) { \
				helpCommand = substr($$0, 0, index($$0, ":")); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^##/) { \
				if (helpMessage) { \
					helpMessage = helpMessage"\n                     "substr($$0, 3); \
				} else { \
					helpMessage = substr($$0, 3); \
				} \
			} else { \
				if (helpMessage) { \
					print "\n                     "helpMessage"\n" \
				} \
				helpMessage = ""; \
			} \
		}' \
		$(MAKEFILE_LIST)
	@printf "└"
	@printf "%.0s━" {4..$(COLUMNS)}
	@printf "┘"

## Run everything needed
.PHONY: magic
magic: link docs packages restore

## Link cwd to ~/.vim and ~/.config/nvim
.PHONY: link
link: link-vim link-neovim

.PHONY: link-vim
link-vim:
	@echo "→ ~/.vim"
	@if [ ! . -ef ~/.vim ]; then ln -nfs "${pwd}" ~/.vim; fi
	@echo "→ ~/.vimrc"
	@ln -nfs "${pwd}/init.vim" ~/.vimrc

.PHONY: link-neovim
link-neovim:
	@mkdir -p ~/.config
	@echo "→ ~/.config/nvim"
	@if [ ! . -ef ~/.config/nvim ]; then ln -nfs "${pwd}" ~/.config/nvim; fi
	@$(vim) "+helptags $(pwd)/doc" +qa

## Runs :PlugInstall
.PHONY: install
install:
	@$(vim) --cmd "let g:fck_extensions_ignore_local = 1"  +PlugInstall +PlugClean +"PlugSnapshot ${lockfile}" +qa

## Runs :PlugUpdate (updates plugins)
.PHONY: upgrade
upgrade:
	@$(vim) --cmd "let g:fck_extensions_ignore_local = 1" +PlugUpdate +PlugUpgrade +PlugClean +"PlugSnapshot ${lockfile}" +PlugDiff

## Install required external packages
.PHONY: packages
packages:
	@bash ./.tools/install-cargo-packages

## Install plugins from lockfile
.PHONY: restore
restore:
	$(vim) -S ${lockfile}

## Generate documentation (:h VimFiles)
.PHONY: docs
docs: doc/vimfiles-keys.txt doc/vimfiles-commands.txt
	@$(vim) "+helptags $(pwd)/doc" +qa

doc: docs

.PHONY: doc/vimfiles-keys.txt
doc/vimfiles-keys.txt:
	@mkdir -p doc
	@echo "${GREEN}→${RESET} Help for keybindings generated - $@"
	@bash ./.tools/generate-mappings-help > $@

.PHONY: doc/vimfiles-commands.txt
doc/vimfiles-commands.txt:
	@mkdir -p doc
	@echo "${GREEN}→${RESET} Help for commands generated - $@"
	@bash ./.tools/generate-commands-help > $@

