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
  ;; :hook
  :custom
  (dired-kill-when-opening-new-dired-buffer t)
  (insert-directory-program "gls" dired-use-ls-dired-t) ;; necessary for dired to work on mac (if using below option)
  (dired-listing-switches "-lah --group-directories-first")
  :config
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


; (use-package org
;   :ensure nil
;   :defer t)

;; Huge issue on mac with installing the correct tree-sitter grammar versions (ABI 15 not supported, at least on this distribution of emacs)
;; Solution is to ensure that I install an older version of the tree-sitter
;; A differe emacs distribution might not have this issue? Idk
; (with-eval-after-load 'treesit
; (add-to-list 'treesit-language-source-alist
;              '(go . ("https://github.com/tree-sitter/tree-sitter-go"
;                      "v0.20.0"  ; <-- **REPLACE THIS WITH A KNOWN COMPATIBLE TAG**
;                      "src"))
;              '(go-mod . ("https://github.com/camdencheek/tree-sitter-go-mod"
;                      "v1.1.0"  ; <-- **REPLACE THIS WITH A KNOWN COMPATIBLE TAG**
;                      "src"))
;             )
; )

;; Note that using treesitter as default may cause some issues with hooking into other modes
;; eg settings for c-mode don't apply to c-ts-mode automatically
;; will need to resolve issues as they come up
(use-package treesit-auto
  :ensure t
  :after emacs
  :custom
  ;; (treesit-auto-langs '(go, go-mod))
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



(load "~/.emacs.d/evil.el")
(load "~/.emacs.d/basic.el")

;; Magit
(use-package magit)
  ;; This would make magit open its buffer in the same window by default
  ;; :custom
  ;; (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)




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

(which-function-mode 1)
(use-package posframe
  :after dashboard)
(add-to-list 'load-path (concat (getenv "HOME") "/lsp-bridge"))
(require 'yasnippet)
(yas-global-mode 1)
(require 'lsp-bridge)
(setq lsp-bridge-python-command (concat (getenv "HOME") "/lb-venv/bin/python3"))
(global-lsp-bridge-mode)
(setq lsp-bridge-enable-hover-diagnostic t)
;; (setq lsp-bridge-log-level 'debug)



(setenv "PATH" (concat (getenv "HOME") "/.opt/bin:" (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/.opt/bin"))


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
;; (use-package keychain-environment
;;   :defer 1
;;   :config (keychain-refresh-environment)
;;   :hook
;;   (server-after-make-frame . keychain-refresh-environment))

; (use-package tramp
;   :defer t
;   :config
;   (setq tramp-default-method "ssh")
;   (setq tramp-use-ssh-controlmaster-options nil))


;; Used to sync direnvs with buffers so launched processes inherit proper environment
;; Probably want to make sure this works, but not exactly sure how to
; (use-package envrc
;   :hook (after-init . envrc-global-mode))
