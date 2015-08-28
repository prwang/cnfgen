;; Elisp script that sets the appropriate variables and export org
;; files to html.

;; Use as
;;
;; $ emacs -Q -batch --visit=file.org -l setup.el -f my-export-org
;;
;; The script requires a decent version of org-mode (say 6.33x).
;; Any Emacs 24.x should have it installed by default. For older emacs
;; installations the script breaks. In particular the Emacs 22 shipped
;; with MacOSX still has org-mode 4.6x.
;;
(require 'org)
(setq make-backup-files nil) 


(setq
 org-html-preamble nil      ; No default HTML preamble 
 org-html-postamble nil     ; No default HTML postamble
 org-html-toplevel-hlevel 3        ; Level 1 headings in ORG file become <H3> in HTML export.
 org-html-head-include-default-style nil) ; No default CSS style



;; Compatibility with older Org-mode
(setq
 org-export-html-auto-preamble org-html-preamble
 org-export-html-auto-postamble org-html-postamble)



(defun export-org-file ()
  (message (format "\n--- %s ---\n" (file-name-nondirectory (buffer-file-name))))
  (cond
   ((fboundp 'org-html-export-as-html)  ; recent org-mode
    (org-html-export-to-html))
   ((and (fboundp 'org-export-as-html) (string< "6.32" org-version)) ; older org-mode (6.33)
    (org-export-as-html 1 nil 
                        (list :style "<link rel=\"stylesheet\" type=\"text/css\" media=\"screen\" href=\"stylesheets/stylesheet.css\">"
                              :style-include-default nil)
			nil nil))
   (t
    (message "Org-mode is too old or missing. Can't convert to HTML"))))



(defun version-report ()
  (message (format "EMACS: %s" (emacs-version)))
  (message (format "ORG-MODE: %s (required >= 6.33x)" org-version)))
