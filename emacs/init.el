;; EMACS SETUP
;; My personal file for settting up emacs

;; Sets the value this file's path. Doesn't work when evaluating.
;; (TODO) Fix this mess here. What have I done?
(defvar my/locn nil)
(setq my/locn (file-name-directory (concat "" load-file-name)))

;; Coding Options ((TODO) To be moved)
(show-paren-mode) ;; Show matching parentheses
(setq-default tab-width 2) ;; Set the tab width

;; Editor settings
(menu-bar-mode -1) ;; Disable menu bar
(global-visual-line-mode) ;; Toggle Visual Line Mode (better wrapping)
(global-linum-mode 1) (setq linum-format "%2d") ;; Enable lines at the left side of the screen

;; Set up the Debug Mode
(defvar my/debug-mode t	"The debug mode variable.")
(defun debugmsg (msg) "Prints the message only if the debug mode is enabled."
	(cond ((or my/debug-mode) (message msg))))

;; Run files based on the current platform and GUI mode.
(defvar my/platform nil "The platform of the current session")
(defun charge (rpath) "load-file on the script path"
			 (load-file (concat my/locn rpath)))
(cond ((file-directory-p "/mnt/c/Windows")
			 (progn
				 (debugmsg "WSL!")
				 (setq my/platform "wsl")
				 (charge "wsl/wsl.el")))
			((file-directory-p "/sdcard")
			 (progn
				 (debugmsg "Termux!")
				 (setq my/platform "termux")
				 (charge "termux/termux.el")))
			((file-directory-p "C:/Windows/")
			 (progn
				 (debugmsg "Windows!")
				 (setq my/platform "windows")
				 (charge "win/win.el"))))

(when (display-graphic-p)
	(load-file (concat my/locn "gui/gui.el")))

;; Theming ;;
(add-to-list 'custom-theme-load-path "~/git/datafiles/config/emacs/themes")

;; Load the Dracula Theme
;; (TODO) Put background in simple black.
(load-theme 'dracula t)

;; End ;;

;; Run other files that aren't exclusive to any of them ("all/" folder)
(charge "all/functions.el")
(charge "all/mode-line.el")
(charge "all/org-extra.el")
