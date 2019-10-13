(defun my/file-contents (filename)
	"Return the contents of FILENAME."
	(with-temp-buffer
		(insert-file-contents filename)
		(buffer-string)))

(defun rmacs ()
	"Loads my settings files"
	(interactive)
	(load-file "~/.emacs.d/init.el"))

