include config.mk

all: install

install:
	install -d ${DESTDIR}${PREFIX}share/instantshell
	install -Dm 755 instantshell.sh ${DESTDIR}${PREFIX}bin/instantshell
	install -Dm 755 instantos.plugin.zsh ${DESTDIR}${PREFIX}share/instantshell/instantos.plugin.zsh
	install -Dm 755 starship.toml ${DESTDIR}${PREFIX}share/instantshell/starship.toml
	install -Dm 755 zshrc ${DESTDIR}${PREFIX}share/instantshell/zshrc

uninstall:
	rm -rf ${DESTDIR}${PREFIX}share/instantshell
	rm ${DESTDIR}${PREFIX}bin/instantshell
