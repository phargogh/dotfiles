ctags:
	cp ctags/.ctags ~/.ctags
	echo "--options=$(pwd)/javascript/ctags-patterns-for-javascript/ctagsrc" >> ~/.ctags
