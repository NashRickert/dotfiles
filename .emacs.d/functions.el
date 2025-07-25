;; Will cause the output from the below func to not be displayed
(add-to-list 'display-buffer-alist
	     '("\*format-latex\*"
	       (display-buffer-no-window)))

(defun format-latex ()
  "Formats current tex file useing latexindent.pl"
  (interactive)

  (when (string-equal major-mode "LaTeX-mode")
    (save-buffer)
    (async-shell-command
    (concat "latexindent -w " (buffer-file-name))
    "\*format-latex\*")
    (revert-buffer nil 1)))
