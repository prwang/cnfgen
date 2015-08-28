;; Elisp script that sets the appropriate variables and export org
;; files to html.

;; Use as
;;
;; $ emacs -Q -batch --visit=file.org -l setup.el -f my-export-org
;;
;; The script requires a decent version of org-mode (say 8.x).
;; Any Emacs 24.x should have it installed by default. For older emacs
;; installations the script breaks. In particular the Emacs 22 shipped
;; with MacOSX still has org-mode 4.6x.
;;
(require 'org)

(setq org-html-preamble nil             ; Do not add a default HTML preamble
      org-html-postamble nil            ; Do not add a default HTML postamble
      org-html-toplevel-hlevel 3        ; Level 1 headings in ORG file become <H3> in HTML export.
      org-html-head-include-default-style nil
                                        ; No default CSS style
      )


(defun export-org-file ()
  (message (format "\n--- %s ---\n" (file-name-nondirectory (buffer-file-name))))
    (condition-case nil
        (if (version-list-< (version-to-list org-version) '(8 0 0))
            (org-export-as-html 1 nil nil t nil)
          (org-html-export-to-html))
      ('error
       (message "ERROR: org-mode package is either missing or very old.")
       )))


(defun version-report ()
  (message (format "EMACS: %s" (emacs-version)))
  (message (format "ORG-MODE: %s (required >= 6.x)" org-version)))
