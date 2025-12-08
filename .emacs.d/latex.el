;; LATEX

;; Auctex

;; Possible extra desired functionality:
;; Could try autocompleting snippers, either as karthink does
;; or with auto-activating-snippets package
;; C-c C-p to preview
;; C-c C-v and C-mouse-1 to jump between places in pdf and latex
;; Read Auctex manual (C-h i m auctex)

;; Latex settings. Note automatic auctex installation
; (use-package latex
;   :ensure auctex
;   :hook
;   ((plain-TeX-mode . LaTeX-mode)
;    (LaTeX-mode . prettify-symbols-mode)
;    (LaTeX-mode . LaTeX-math-mode)
;    (LaTeX-mode . font-lock-mode) ; it may do this automatically already
;    (LaTeX-mode . my-LaTeX-mode-dollars) ;; syntax highlights dollar signs properly
;    (LaTeX-mode . preview-larger-previews)
;    (TeX-after-compilation-finished . TeX-revert-document-buffer))
;   :config
;   (setq LaTeX-indent-level 4)
;   (setq LaTeX-item-indent 0)
;   (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
;   (setq TeX-source-correlate-mode t)
;   (setq TeX-source-correlate-start-server t)
;   ;; This setting makes \left ( automatically insert the right part (same for other delimiters)
;   ;; However, it also automatically expands \{ and \[ which I dislike
;   ;; For not I will disable it and replicate the \left\right behavior with aas, but it makes me unhappy to do so
;   ;; (setq LaTeX-electric-left-right-brace t)
;   (setq TeX-electric-math '("$" . "$"))
;   (defun my-LaTeX-mode-dollars () (font-lock-add-keywords nil `((,(rx "$") (0 'success t))) t))
;   (defun preview-larger-previews ()
;     (setq preview-scale-function
;           (lambda () (* 1.25 (funcall (preview-scale-from-face))))))) 
  

;; CDLatex settings
; (use-package cdlatex
;   :ensure t
;   :hook (LaTeX-mode . turn-on-cdlatex)
;   :bind (:map cdlatex-mode-map 
; 	      ;; ("|" . nil)
;               ("<tab>" . cdlatex-tab))
;   :config
;   ;; These intended to get parentheses to work, but possibly not necessary
;   (setq cdlatex-paired-parens "$[{") 
;   (define-key cdlatex-mode-map  "|" nil)
;   (define-key cdlatex-mode-map  "{" nil)
;   (define-key cdlatex-mode-map  "[" nil)
;   (define-key cdlatex-mode-map  "(" nil))


;; CDLatex integration with YaSnippet: Allow cdlatex tab to work inside Yas fields
;; Unfortunately, this complexity seems necessary
; (use-package cdlatex
;   :hook ((cdlatex-tab . yas-expand)
;          (cdlatex-tab . cdlatex-in-yas-field))
;   :config
;   (use-package yasnippet
;     :bind (:map yas-keymap
;            ("<tab>" . yas-next-field-or-cdlatex)
;            ("TAB" . yas-next-field-or-cdlatex))
;     :config
;     (defun cdlatex-in-yas-field ()
;       ;; Check if we're at the end of the Yas field
;       (when-let* ((_ (overlayp yas--active-field-overlay))
;                   (end (overlay-end yas--active-field-overlay)))
;         (if (>= (point) end)
;             ;; Call yas-next-field if cdlatex can't expand here
;             (let ((s (thing-at-point 'sexp)))
;               (unless (and s (assoc (substring-no-properties s)
;                                     cdlatex-command-alist-comb))
;                 (yas-next-field-or-maybe-expand)
;                 t))
;           ;; otherwise expand and jump to the correct location
;           (let (cdlatex-tab-hook minp)
;             (setq minp
;                   (min (save-excursion (cdlatex-tab)
;                                        (point))
;                        (overlay-end yas--active-field-overlay)))
;             (goto-char minp) t))))
;
;     (defun yas-next-field-or-cdlatex nil
;       (interactive)
;       "Jump to the next Yas field correctly with cdlatex active."
;       (if
;           (or (bound-and-true-p cdlatex-mode)
;               (bound-and-true-p org-cdlatex-mode))
;           (cdlatex-tab)
;         (yas-next-field-or-maybe-expand)))))


;; PDF-Tools

;; In Auctex, theoretically can jump to point in pdf from source with C-c C-v
;; If this doesn't work, indicates additional work needed in config
;; (And jump to source from pdf with C-mouse-1)
; (use-package pdf-tools
;   :custom
;   (pdf-view-resize-factor 1.1)
;   :config
;   (pdf-tools-install)
;   (setq-default pdf-view-display-size 'fit-page))


;; Auto-Acativating-Snippets
;; Should definitely add more snippets based on what I use most for my classes
;; The github page gives a nice example config with some more ways to use these
;; Can disable snippets in certain modes, bind the to functions, etc.
;; This just works ... wow
; (use-package aas
;   :hook
;   (LaTeX-mode . aas-activate-for-major-mode)
;   :config
;   (aas-set-snippets 'LaTeX-mode
;     "sigma algebra" '(yas "$\\sigma$-algebra$0")
;     "sigma finite" '(yas "$\\sigma$-finite$0")
;     ;; "\\[" '(yas "\\[ $0 \\]")
;     :cond #'texmathp ; expand only in math mode
;     ;; Doesn't work because of math-mode electric pairs. Use yas
;     ;; "\\{ " '(yas "\\{ $0 \\}")
;     ;; "in" '(yas "\\in$0")
;     "sub" '(yas "\\subset$0")
;     "m*" '(yas "\\mu^*$0")
;     "m+" '(yas "\\mu^+$0")
;     "m-" '(yas "\\mu^-$0")
;     "perp" '(yas "\\perp$0")
;     ;; "n+" '(yas "\\nu^+$0")
;     ;; "n-" '(yas "\\nu^-$0")
;     "Om" '(yas "\\Omega$0")
;     "mu" '(yas "\\mu$0")
;     "pi" '(yas "\\pi$0")
;     "nu" '(yas "\\nu$0")
;     "bot" '(yas "\\bot$0")
;     "lam" '(yas "\\lambda$0")
;     "inf" '(yas "\\infty$0")
;     "lim" '(yas "\\lim_{$1}$0")
;     "to" '(yas "\\to$0")
;     "frak" '(yas "\\mathfrak{$1}$0")
;     "bb" '(yas "\\mathbb{$1}$0")
;     "cal" '(yas "\\mathcal{$1}$0")
;     ;; "int" '(yas "\\int_{$1}^{$2}$0")
;     "int" '(yas "\\int$0")
;     "eps" '(yas "\\varepsilon$0")
;     "..." '(yas "\\cdots$0")
;     "||" '(yas "\\|$0\\|")
;     "chi" '(yas "\\chi$0")
;     "cupp" '(yas "\\bigcup_{$1}^{$2}$0")
;     "capp" '(yas "\\bigcap_{$1}^{$2}$0")
;     "prod" '(yas "\\prod_{$1}^{$2}$0")
;     "Ex" '(yas "\\E[$0]")
;     ;; "<" '(yas "\\langle $0")
;     "left|" '(yas "\\left\\| $0 \\right\\|")
;     "sum" '(yas "\\sum_{$1}^{$2}$0")))
;; Todo if necessary/desired: if \left \right is used frequently, add snippets here
