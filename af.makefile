
SHELL :=	/bin/bash

PROGRAM =	archive-files
VERSION =	`./af -VV`
DIR =		$(PROGRAM)
TAR =		$(PROGRAM)-$(VERSION)


SCRIPTS =	af
MANPG =		af.1 moba.1 delete-files.1 extract-volumes.1 restore-files.1
LIB =		moba.sh delete-files extract-volumes restore-files check-archive


all:
	@echo no targets to build.

install:	all
	cp $(SCRIPTS) /usr/local/bin/
	cp $(MANPG) /usr/local/man/man1/
	mkdir -p /usr/local/lib/af  &&  cp $(LIB) /usr/local/lib/af/


debian:		moba-$(VERSION).tar.gz
	deb-packager -u $(PROGRAM) $(VERSION) debian/files.list


moba-$(VERSION).tar.gz:	$(SCRIPTS) $(LIB) $(MANPG)
	bash zz-moba/make-tar

clean:
	rm -f *.o *.deb cut out $(TARGETS) $(TAR).tar.gz


.PHONY:		debian html-doc refs tags

