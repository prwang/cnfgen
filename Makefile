#!/bin/make

########### CONFIGURATION ########################
PROJECT="cnfgen"
SOURCES=index.org transformation.org background.org
EMACS=emacs

ifeq ($(shell uname -s),Darwin)
BROWSE=open
else
BROWSE=xdg-open
endif


########### THE RULES ############################

TARGET= $(SOURCES:.org=.html)

all: ${TARGET}

clean:
	@-rm -f  ${TARGET}

view:
	@${BROWSE} index.html

%.html: %.org 
	@echo "Convert org-files to html static files"
	@$(EMACS) -Q -batch --visit=$< -l setup.el -f my-export-org 2>/dev/null >/dev/null

.PHONY: all clean view
