;; ORG-MODE EXTRA SETTINGS
;; A simple pack of settings for using org-mode better.

;; (Export) Preserve line breaks, even on HTML
(setq org-export-preserve-breaks t)

;; (Export) Set custom CSS
(setq org-export-html-style-include-scripts ""
			org-export-html-style-include-default ""
			org-html-head (concat (my/file-contents (concat my/locn "etc/orghead.html"))
														"<style>"
														(my/file-contents (concat my/locn "etc/orgstyle.css"))
														"</style>"))

;; Set up Agenda
(global-set-key [C-c a] 'org-agenda)
(setq org-agenda-files (quote ("~/git/orgnz/notes/")))
(setq org-agenda-custom-commands
      '(("c" "Main view" agenda "")))
