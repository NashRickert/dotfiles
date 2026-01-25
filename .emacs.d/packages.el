;; -*- lexical-binding: t -*-
;; Note the above is necessary for consult and related packages

;; Package Management

;; Setting up use-package
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize) ; Gets packages ready (a little unsure what it actually does)
(require 'use-package)
(setq use-package-always-ensure t) ; When using UP, installs package if not already installed

(use-package modus-themes
  :ensure t
  :config
  (load-theme 'modus-vivendi-tinted t))

;; modus-vivendi-tinted, modus-operandi-tinted, modus-vivendi-deuteranopia


(use-package dired
  :ensure nil
  :custom
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-listing-switches "-lah --group-directories-first")
  :config
  (with-system darwin
               ;; (setq dired-use-ls-dired t) ;; may be necessary, unsure
               (setq insert-directory-program "gls"))
  (use-package dired-x
    :ensure nil
    :hook
    (dired-mode . dired-omit-mode)
    :config
    ;; Hide files ending in ~
    (setq dired-omit-files (concat dired-omit-files "\\|~$"))))

(use-package isearch
  :ensure nil
  :config
  (setq lazy-count-prefix-format "(%s/%s) ")
  ;; searches across whitespace
  ;; if I want only exact matches across white space (in contrast to
  ;; consult-line), then remove this
  (setq search-whitespace-regexp ".*?") 
  (setq isearch-lazy-count t))


(use-package org
  :ensure nil
  :defer t)

;; Note that using treesitter as default may cause some issues with hooking into other modes
;; eg settings for c-mode don't apply to c-ts-mode automatically
;; will need to resolve issues as they come up
(use-package treesit-auto
  :ensure t
  :after emacs
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode t))


;; Minibuffer Completion Frameworks
(use-package vertico
  :init
  (vertico-mode)
  :bind
  (:map vertico-map
	("C-d" . (lambda () (interactive) (vertico-next 5)))
	("C-u" . (lambda () (interactive) (vertico-previous 5)))
	("C-j" . vertico-next)
	("C-k" . vertico-previous))
  :custom
  (vertico-resize t))

(use-package marginalia
  ; I believe this adjusts level of annotation
  :bind(:map minibuffer-local-map
	     ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-default nil) ; orderless is used by default
  (completion-category-overrides '((file (styles basic partial-completion)))))

	

;; Don't know how useful exactly this is
(use-package prescient
  :custom
  (prescient-aggressive-file-save t)
  (prescient-sort-length-enable nil)
  (prescient-sort-full-matches-first t)
  (prescient-history-length 200)
  (prescient-frequency-decay 0.997)
  (prescient-frequency-threshold 0.05)
  :config
  (prescient-persist-mode 1))

(use-package vertico-prescient
  :demand t
  :after vertico prescient
  :custom
  ;; default values
  (vertico-prescient-enable-sorting t)
  (vertico-prescient-override-sorting nil) ; Don't override `display-sort-function'

  ;; Filtering
  (vertico-prescient-enable-filtering nil) ; We want orderless to do the filtering
  :config
  (vertico-prescient-mode 1))

(use-package company-prescient
  :demand t
  :after company prescient
  :custom
  ;; defaults
  (company-prescient-enable-sorting t)
  (company-prescient-override-sorting nil) ; Don't override `display-sort-function'
  :config
  (company-prescient-mode 1))


;; Consult
;; No keybindings come predefined. I do a couple in the evil-section using a leader keybinding
;; Anything I use a lot probably deserves a keybinding
(use-package consult
  :config
  (setq consult-narrow-key "<")
  :init
  (setq xref-show-xrefs-function #'consult-xref)
  (setq xref-show-definitions-function #'consult-xref))


;; Embark
(use-package embark
  :bind
  ("C-." . embark-act)
  ("C-;" . embark-dwim)
  ("C-h B" . embark-bindings)) ;; Alternative for describe-bindings

;; Embark-consult
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package eldoc-box
  :ensure t
  :defer t)

;; Note: C eldoc stuff is very minimalistic (eg no fields displayed for structs)
;; Unsure how I could fix this, or if it's eldoc's fault
(use-package eldoc
  :ensure nil                                ;; This is built-in, no need to fetch it.
  :config
  (setq eldoc-idle-delay 0.5)                  ;; Automatically fetch doc help
  (setq eldoc-echo-area-use-multiline-p nil) ;; We use the "K" floating help instead
                                             ;; set to t if you want docs on the echo area
  (setq eldoc-echo-area-display-truncation-message nil)
  :init
  (global-eldoc-mode))


;; Projectile
;; Note to self: This is awesome and can't believe I didn't use before
(use-package projectile
  :config
  (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; First thing on project switch is to open dired
  (setq projectile-switch-project-action #'projectile-dired))

(load "~/.emacs.d/evil.el")
(load "~/.emacs.d/basic.el")

;; Magit
(use-package magit
  ;; This would make magit open its buffer in the same window by default
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))


;; Company
;; I copy pasted this from the Emacs-kick init
(use-package company
  :defer t
  :ensure t
  :custom
  (company-tooltip-align-annotations t)      ;; Align annotations with completions.
  (company-minimum-prefix-length 1)          ;; Trigger completion after typing 1 character
  (company-idle-delay 0.75)                   ;; Delay before showing completion (adjust as needed)
  (company-tooltip-maximum-width 50)
  :config

  ;; While using C-p C-n to select a completion candidate
  ;; C-y quickly shows help docs for the current candidate
  (define-key company-active-map (kbd "C-y")
			  (lambda ()
				(interactive)
				(company-show-doc-buffer)))
  (define-key company-active-map [tab] 'company-complete-selection)
  (define-key company-active-map (kbd "TAB") 'company-complete-selection)
  (define-key company-active-map [ret] nil)
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "RET") nil)
  :hook
  ;; Enable Company Mode globally after initialization.
  (after-init . global-company-mode) 
  ;; For now I think eshell mode is fine so long as command doesn't complete
  ;; (eshell-mode . (lambda() (company-mode 0)))
  ;; Use of tabs doesn't play nice in latex mode
  (cdlatex-mode . (lambda() (company-mode 0)))) 


;; There is special documentation on gopls for emacs on the golang website
;; https://go.dev/gopls/editor/emacs
(use-package go-mode)

;; Necessary for project pacakge to know about GOPATH and Go modules
;; This tells it to go the the nearest parent go.mod as the project root
(defun project-find-go-module (dir)
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))

(cl-defmethod project-root ((project (head go-module)))
  (cdr project))

(add-hook 'project-find-functions #'project-find-go-module)

;; Note may want to consider package set-path-from-shell in the future to do this and others (adds startup time -- fine with daemon?)
(setenv "PATH" (concat (getenv "HOME") "/go/bin:" (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/go/bin"))


;; Eglot Mode
;; Using this for my minimal lsp
;; Note there are some possible performance improvements from
;; (setq eglot-events-buffer-size 0)
;; (fset #'jsonrpc--log-event #'ignore)
;; But I have no performance issues so I won't bother
(use-package eglot
:init
(setq eglot-autoshutdown t) ;; shutdown when no more relevant buffers exist
; These are annoying but do give persistent diagnostics (other is only in normal mode on the same line)
(setq flymake-show-diagnostics-at-end-of-line nil) 
:hook ((python-mode . eglot-ensure)
	(go-mode . eglot-ensure)
	(go-ts-mode . eglot-ensure)
	(c-mode . eglot-ensure)
	(c-ts-mode . eglot-ensure)
	(c++-mode . eglot-ensure)
	(c++-ts-mode . eglot-ensure)
	(java-ts-mode . eglot-ensure)
	(java-mode . eglot-ensure)
	(python-ts-mode . eglot-ensure)
	(python-mode . eglot-ensure)
	(haskell-mode . eglot-ensure)))

;; Optional: install eglot-format-buffer as a save hook.
;; The depth of -10 places this before eglot's willSave notification,
;; so that notification reports the actual contents that will be saved.
;; (defun eglot-format-buffer-before-save ()
;;   (add-hook 'before-save-hook #'eglot-format-buffer -10 t))
;; (add-hook 'go-mode-hook #'eglot-format-buffer-before-save)

;; Note: wraps around emacs-lsp-booster installed from AUR
;; Or through crates.io, or through binaries
;; Theoretically improves performance
;; Currently the emacs package itself requires manual installation with package-vc-install
;; url: https://github.com/jdtsmith/eglot-booster
;; Theoretically could be automated through this use-package declaration, but I couldn't get it to work
;; Additional note: Only works through tramp if emacs-lsp-booster is installed there.
;; no-remote-boost t turns it off remotely
(use-package eglot-booster
  :after eglot
  :vc (:url "https://github.com/jdtsmith/eglot-booster")
  :custom
  (eglot-booster-no-remote-boost t)
  :config
  (eglot-booster-mode))

(setenv "PATH" (concat (getenv "HOME") "/.opt/bin:" (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/.opt/bin"))

;; Note that jdtls is non trivial, but we basically install it somewhere and then
;; set up a script that starts it like we want (jdtls.sh) and add that to the path
;; An llm can give the script
(with-eval-after-load 'eglot
  ;; Add jdtls for Java
  (add-to-list 'eglot-server-programs
	       ;; actually important file path is absolute for eglot booster, otherwise won't work
               `(java-mode . (,(expand-file-name "~/.opt/bin/jdtls.sh")
                              :initializationOptions
                              (:workspaceFolders
                               [,(concat "file://" (expand-file-name "~/.cache/jdtls-workspace"))]))))
  
  ;; Add clangd for C/C++
  ;; Should force emacs to use clangd instead of ccls
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode) . ("clangd"))))

;; Specific Language Modes
(use-package haskell-mode)

;; Sideline Modes
;; Used to get sideline diagnostics for eglot
;; Note sideline is the frontend, sideline-flymake the backend. See github for more info
(use-package sideline-flymake
:init
(setq sideline-flymake-display-mode 'line))

(use-package sideline
:after sideline-flymake
:init
(setq sideline-backends-right '(sideline-flymake))
(setq sideline-backends-left-skip-current-line t   ; don't display on current line (left)
	sideline-backends-right-skip-current-line t  ; don't display on current line (right)
	sideline-order-left 'down                    ; or 'up
	sideline-order-right 'up                     ; or 'down
	sideline-format-left "%s   "                 ; format for left aligment
	sideline-format-right "   %s"                ; format for right aligment
	sideline-priority 100                        ; overlays' priority
	sideline-display-backend-name t)            ; display the backend name
:hook
(flymake-mode . sideline-mode))


;; LATEX

;; Auctex

;; Possible extra desired functionality:
;; Could try autocompleting snippers, either as karthink does
;; or with auto-activating-snippets package
;; C-c C-p to preview
;; C-c C-v and C-mouse-1 to jump between places in pdf and latex
;; Read Auctex manual (C-h i m auctex)

;; Latex settings. Note automatic auctex installation
(use-package latex
  :ensure auctex
  :hook
  ((plain-TeX-mode . LaTeX-mode)
   (LaTeX-mode . prettify-symbols-mode)
   (LaTeX-mode . LaTeX-math-mode)
   (LaTeX-mode . font-lock-mode) ; it may do this automatically already
   (LaTeX-mode . my-LaTeX-mode-dollars) ;; syntax highlights dollar signs properly
   (LaTeX-mode . preview-larger-previews)
   (TeX-after-compilation-finished . TeX-revert-document-buffer))
  :config
  (setq LaTeX-indent-level 4)
  (setq LaTeX-item-indent 0)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-start-server t)
  ;; This setting makes \left ( automatically insert the right part (same for other delimiters)
  ;; However, it also automatically expands \{ and \[ which I dislike
  ;; For not I will disable it and replicate the \left\right behavior with aas, but it makes me unhappy to do so
  ;; (setq LaTeX-electric-left-right-brace t)
  (setq TeX-electric-math '("$" . "$"))
  (defun my-LaTeX-mode-dollars () (font-lock-add-keywords nil `((,(rx "$") (0 'success t))) t))
  (defun preview-larger-previews ()
    (setq preview-scale-function
          (lambda () (* 1.25 (funcall (preview-scale-from-face))))))) 
  

;; CDLatex settings
(use-package cdlatex
  :ensure t
  :hook (LaTeX-mode . turn-on-cdlatex)
  :bind (:map cdlatex-mode-map 
	      ;; ("|" . nil)
              ("<tab>" . cdlatex-tab))
  :config
  ;; These intended to get parentheses to work, but possibly not necessary
  (setq cdlatex-paired-parens "$[{") 
  (define-key cdlatex-mode-map  "|" nil)
  (define-key cdlatex-mode-map  "{" nil)
  (define-key cdlatex-mode-map  "[" nil)
  (define-key cdlatex-mode-map  "(" nil))


;; CDLatex integration with YaSnippet: Allow cdlatex tab to work inside Yas fields
;; Unfortunately, this complexity seems necessary
(use-package cdlatex
  :hook ((cdlatex-tab . yas-expand)
         (cdlatex-tab . cdlatex-in-yas-field))
  :config
  (use-package yasnippet
    :bind (:map yas-keymap
           ("<tab>" . yas-next-field-or-cdlatex)
           ("TAB" . yas-next-field-or-cdlatex))
    :config
    (defun cdlatex-in-yas-field ()
      ;; Check if we're at the end of the Yas field
      (when-let* ((_ (overlayp yas--active-field-overlay))
                  (end (overlay-end yas--active-field-overlay)))
        (if (>= (point) end)
            ;; Call yas-next-field if cdlatex can't expand here
            (let ((s (thing-at-point 'sexp)))
              (unless (and s (assoc (substring-no-properties s)
                                    cdlatex-command-alist-comb))
                (yas-next-field-or-maybe-expand)
                t))
          ;; otherwise expand and jump to the correct location
          (let (cdlatex-tab-hook minp)
            (setq minp
                  (min (save-excursion (cdlatex-tab)
                                       (point))
                       (overlay-end yas--active-field-overlay)))
            (goto-char minp) t))))

    (defun yas-next-field-or-cdlatex nil
      (interactive)
      "Jump to the next Yas field correctly with cdlatex active."
      (if
          (or (bound-and-true-p cdlatex-mode)
              (bound-and-true-p org-cdlatex-mode))
          (cdlatex-tab)
        (yas-next-field-or-maybe-expand)))))


;; PDF-Tools

;; In Auctex, theoretically can jump to point in pdf from source with C-c C-v
;; If this doesn't work, indicates additional work needed in config
;; (And jump to source from pdf with C-mouse-1)
(use-package pdf-tools
  :custom
  (pdf-view-resize-factor 1.1)
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page))


;; Auto-Acativating-Snippets
;; Should definitely add more snippets based on what I use most for my classes
;; The github page gives a nice example config with some more ways to use these
;; Can disable snippets in certain modes, bind the to functions, etc.
;; This just works ... wow
(use-package aas
  :hook
  (LaTeX-mode . aas-activate-for-major-mode)
  :config
  (aas-set-snippets 'LaTeX-mode
    "sigma algebra" '(yas "$\\sigma$-algebra$0")
    "sigma finite" '(yas "$\\sigma$-finite$0")
    ;; "\\[" '(yas "\\[ $0 \\]")
    :cond #'texmathp ; expand only in math mode
    ;; Doesn't work because of math-mode electric pairs. Use yas
    ;; "\\{ " '(yas "\\{ $0 \\}")
    ;; "in" '(yas "\\in$0")
    "sub" '(yas "\\subset$0")
    "m*" '(yas "\\mu^*$0")
    "m+" '(yas "\\mu^+$0")
    "m-" '(yas "\\mu^-$0")
    "perp" '(yas "\\perp$0")
    "Phi" '(yas "\\Phi$0")
    ;; "n+" '(yas "\\nu^+$0")
    ;; "n-" '(yas "\\nu^-$0")
    "Om" '(yas "\\Omega$0")
    "mu" '(yas "\\mu$0")
    "pi" '(yas "\\pi$0")
    "nu" '(yas "\\nu$0")
    "bot" '(yas "\\bot$0")
    "lam" '(yas "\\lambda$0")
    "inf" '(yas "\\infty$0")
    "lim" '(yas "\\lim_{$1}$0")
    "to" '(yas "\\to$0")
    "frak" '(yas "\\mathfrak{$1}$0")
    "bb" '(yas "\\mathbb{$1}$0")
    "cal" '(yas "\\mathcal{$1}$0")
    ;; "int" '(yas "\\int_{$1}^{$2}$0")
    "int" '(yas "\\int$0")
    "eps" '(yas "\\varepsilon$0")
    "..." '(yas "\\cdots$0")
    "||" '(yas "\\|$0\\|")
    "chi" '(yas "\\chi$0")
    "cupp" '(yas "\\bigcup_{$1}^{$2}$0")
    "capp" '(yas "\\bigcap_{$1}^{$2}$0")
    "prod" '(yas "\\prod_{$1}^{$2}$0")
    "Ex" '(yas "\\E[$0]")
    ;; "<" '(yas "\\langle $0")
    "left|" '(yas "\\left\\| $0 \\right\\|")
    "sum" '(yas "\\sum_{$1}^{$2}$0")))
;; Todo if necessary/desired: if \left \right is used frequently, add snippets here


;; Ultra Scroll
;; Note that this is not on MELPA, so there is one more step involving package-vc-install
;; If that hasn't already been done. More info on the package's github
;; I turned this off because it doesn't behave nicely enough with pdfs
;; And I don't use my trackpad enough to justify it

;; (use-package ultra-scroll
;;   ;:load-path "~/code/emacs/ultra-scroll" ; if you git clone'd instead of package-vc-install
;;   :init
;;   (setq scroll-conservatively 101 ; important!
;;         scroll-margin 0) 
;;   :hook
;;   (pdf-view-mode . (lambda () (ultra-scroll-mode 0)))
;;   :config
;;   (ultra-scroll-mode 1))



;; This and the tramp configs are done to allow
;; Better ssh hopping (the keychain is to sync with an ssh agent)
;; Super high chance the tramp config stuff is unnecessary
;; Also can remove this stuff if I don't use it for a while
(use-package keychain-environment
  :defer 1
  :config (keychain-refresh-environment)
  :hook
  (server-after-make-frame . keychain-refresh-environment))

(use-package tramp
  :defer t
  :config
  (setq tramp-default-method "ssh")
  (setq tramp-use-ssh-controlmaster-options nil))


;; Don't thing I need envrc to sync direnvs -- I just open emacs from the terminal properly
