#!/bin/make

########### CONFIGURATION ########################
PROJECT="cnfgen"
SOURCES=index.org transformation.org background.org graphformats.org
EMACS=/usr/bin/emacs

ifeq ($(shell uname -s),Darwin)
BROWSE=open
EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
else
BROWSE=xdg-open
endif


########### THE RULES ############################

TARGET= $(SOURCES:.org=.html)

all: version ${TARGET}

version:
	@$(EMACS) -Q -batch -l setup.el -f version-report >/dev/null

clean:
	@-rm -f  ${TARGET}

view: ${TARGET}
	@${BROWSE} index.html

%.html: %.org 
	@$(EMACS) -Q -batch --visit=$< -l setup.el -f export-org-file >/dev/null

.PHONY: all clean view version
