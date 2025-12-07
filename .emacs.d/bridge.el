(require 'package)

;; Add MELPA (or other repos) if needed
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Initialize the package system
(package-initialize)

;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(use-package markdown-mode
  :ensure t)

;; yasnippet
(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

;; Add lsp-bridge to load-path manually (not on MELPA)
(add-to-list 'load-path (concat (getenv "HOME") "/lsp-bridge"))

;; lsp-bridge (local install)
(use-package lsp-bridge
  :load-path "/home/nash/lsp-bridge/" ;(list (concat (getenv "HOME") "/lsp-bridge/"))
  :init
  ;; Set variables before the package loads
  (setq lsp-bridge-python-command
        (concat (getenv "HOME") "/lb-venv/bin/python3"))
  (setq lsp-bridge-enable-hover-diagnostic t)
  :config
  (global-lsp-bridge-mode))

;; (load "~/.emacs.d/evil.el")

