;; For my packages which only require minimal standalone configuration
;; Also could consider these to be simple or tertiary packages
;; That don't really interact with emacs in a complex way

;; Not positive formatting on save is working
(use-package clang-format
  :hook
  ((c-ts-mode c-mode) . clang-format-on-save-mode)
  ((c++-ts-mode c++-mode) . clang-format-on-save-mode))


;; YASnippet
;; Karthink does something weird with warning which I ignore at my own peril
(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (yas-global-mode 1)
  ;; Allow snippets in side of snippets
  (setq yas-triggers-in-field t))

;; Ace-Window
(use-package ace-window
  :bind ("M-o" . 'ace-window)
  :init
  ;; (setq aw-dispatch-always nil)
  (setq aw-minibuffer-flag t)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))


;; Tools for looking at diffs in file
(use-package diff-hl
  :defer t
  :ensure t
  :custom
  (diff-hl-side 'left)                           ;; Set the side for diff indicators.
  (diff-hl-margin-symbols-alist '((insert . "┃") ;; Customize symbols for each change type.
                                  (delete . "-")
                                  (change . "┃")
                                  (unknown . "┆")
                                  (ignored . "i"))))


;; Which-Key
(use-package which-key
  :defer t
  :hook
  (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.30))


;; Helpful
;; Should remap the most important help commands to helpful
(use-package helpful
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-function] . helpful-callable)
  ([remap describe-key] . helpful-key))


;; Doom Modeline
(use-package doom-modeline
  :custom
  (doom-modeline-project-detection 'project)
  (doom-modeline-buffer-name t)
  :init (doom-modeline-mode 1))


;; Rainbow Delimiters
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode)
  (LaTeX-mode . rainbow-delimiters-mode)
  (text-mode . rainbow-delimiters-mode))


;; Used to resolve merge conflicts in files. Can enter the mode and use commands
(use-package smerge-mode
  :ensure nil                                  ;; This is built-in, no need to fetch it.
  :defer t
  :bind (:map smerge-mode-map
              ("C-c ^ u" . smerge-keep-upper)  ;; Keep the changes from the upper version.
              ("C-c ^ l" . smerge-keep-lower)  ;; Keep the changes from the lower version.
              ("C-c ^ n" . smerge-next)        ;; Move to the next conflict.
              ("C-c ^ p" . smerge-previous)))  ;; Move to the previous conflict.


;; This is pretty sick (although I now can't use enter in markdown)
(use-package markdown-mode
  :defer t
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)            ;; Use gfm-mode (gh-flavored-md-mode) for README.md files.
  :init (setq markdown-command "multimarkdown")) ;; Set the Markdown processing command.


;; Vterm
(use-package vterm
  :custom
  ;; Gives a custom name to vterm terminals
  (vterm-buffer-name-string "vterm %s")
  (vterm-max-scrollback 10000)
  (vterm-shell shell-path))
  ;; :config
  ;; (define-key vterm-mode-map (kbd "C-a") #'vterm-send-C-a)
  ;; (define-key vterm-mode-map (kbd "C-x") #'vterm-send-C-x))


;; Really nice documentation package
(use-package devdocs
  :hook
  ((python-mode . (lambda () (setq-local devdocs-current-docs '("python~3.13"))))
   (python-ts-mode . (lambda () (setq-local devdocs-current-docs '("python~3.13"))))
   (c-ts-mode . (lambda () (setq-local devdocs-current-docs '("c"))))
   (c-mode . (lambda () (setq-local devdocs-current-docs '("c"))))))


(use-package quelpa
  :defer t
  :custom
  ;; Note: the below means I need to run quelpa-upgrade or quelpa-self-update sometimes
  (quelpa-update-melpa-p nil "Don't update the MELPA git repo (takes forever)."))
