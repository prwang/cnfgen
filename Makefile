#!/bin/make

########### CONFIGURATION ########################
PROJECT="cnfgen"
SOURCES=index.org transformation.org background.org graphformats.org
EMACS=emacs

ifeq ($(shell uname -s),Darwin)
BROWSE=open
EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
else
BROWSE=xdg-open
endif


########### THE RULES ############################

TARGET= $(SOURCES:.org=.html)

all: ${TARGET}

clean:
	@-rm -f  ${TARGET}

view: ${TARGET}
	@${BROWSE} index.html

%.html: %.org 
	@echo "Convert org-files to html static files"
	@$(EMACS) -Q -batch --visit=$< -l setup.el -f my-export-org 2>/dev/null >/dev/null

.PHONY: all clean view
