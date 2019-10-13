;; MODE LINE CUSTOMIZATION
;; Some changes I made to customize my modeline.

;; Set the format for the modeline and link to the faces
(setq-default
 mode-line-format
 '((:propertize " emacs " face mode-line-session-face)
	 (:propertize " %m " face mode-line-mode-face)
	 (:propertize " %b " face mode-line-buffer-face)
	 (:propertize " l:%l, c:%c " face mode-line-lcol-face)))

;; Create the slot for the faces
(make-face 'mode-line-session-face)
(make-face 'mode-line-buffer-face)
(make-face 'mode-line-mode-face)
(make-face 'mode-line-lcol-face)

;; Define the faces ;;

;; The mode-line itself. For some reason there is a weird box on the GUI.
(set-face-attribute 'mode-line nil
                    :box 'nil)

(set-face-attribute 'mode-line-session-face nil
										:foreground "#CCCCCC"
										:background "#333333"
										:inverse-video nil)

(set-face-attribute 'mode-line-buffer-face nil
										:foreground "#99AACC"
										:background "#222222"
										:inverse-video nil)

(set-face-attribute 'mode-line-mode-face nil
										:foreground "#CCCCCC"
										:background "#850F60"
										:inverse-video nil)

(set-face-attribute 'mode-line-lcol-face nil
										:foreground "gray00"
										:background "gray25"
										:inverse-video nil)

(set-face-background 'mode-line "#333333")
