;; Elisp script that sets the appropriate variables and export org
;; files to html.

;; Use as
;;
;; $ emacs -Q -batch --visit=file.org -l setup.el -f my-export-org
;;

(defun my-export-org ()
  (let ((org-html-preamble nil)
        (org-html-postamble nil)
        (org-html-toplevel-hlevel 3)
        (org-html-head-include-default-style nil))
    (org-html-export-to-html)))
