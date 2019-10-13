;; GUI FILES
;; A header for the scripts to be run when on GUI mode.

;; Sets the value this file's path. Doesn't work when evaluating.
;; (TODO) Fix this mess here. What have I done?
(defvar my/locn-gui nil)
(setq my/locn-gui (file-name-directory (concat "" load-file-name)))

;; General options
(scroll-bar-mode -1) ;; Disable scroll bar
(tool-bar-mode -1) ;; Disable tool bar

;; Set the font
(set-face-attribute 'default nil :font "Consolas-11")
(set-frame-font "Consolas-11" nil t)
