.PHONY: ctags zsh

CURRENT_DIR=$(shell pwd)

mac-packages:
	brew install vim fzf
	$(brew --prefix)/opt/fzf/install

zsh:
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	cp oh-my-zsh/.zshrc ~/.zshrc
	cp oh-my-zsh/my_patches.zsh ~/.oh-my-zsh/custom/my_patches.zsh

ctags:
	cp ctags/.ctags ~/.ctags
	echo "--options=$(CURRENT_DIR)/javascript/ctags-patterns-for-javascript/ctagsrc" >> ~/.ctags
