;; Evil
(use-package evil
  :init
  (setq evil-want-integration t) ;; important
  (setq evil-want-keybinding nil) ;; applies evil to other modes
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-redo)
  (setq evil-want-fine-undo t))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; General.el
(use-package general
  :config
  (define-key key-translation-map (kbd "ESC") (kbd "C-g")))

(general-create-definer my/leader
  :states '(normal visual)
  :keymaps 'override 
  :prefix "SPC"
  :non-normal-prefix "M-SPC")

(my/leader
  ;; Window / navigation
  "j"   #'ace-window
  "m"   #'magit

  "<up>"    #'enlarge-window
  "<down>"  #'shrink-window
  "<left>"  #'shrink-window-horizontally
  "<right>" #'enlarge-window-horizontally

  "w" #'window-configuration-to-register
  "W" #'jump-to-register

  ;; Window splitting
  "0" #'delete-window
  "1" #'delete-other-windows
  "2" (lambda ()
        (interactive)
        (split-window-below)
        (other-window 1))
  "3" (lambda ()
        (interactive)
        (split-window-right)
        (other-window 1))
  "@" #'split-root-window-below
  "#" #'split-root-window-right

  ;; Registers
  "r" #'consult-register-store
  "R" #'consult-register

  ;; Utilities
  "v" #'vterm
  "d" #'devdocs-lookup

  ;; Search / consult
  "/" #'consult-line
  "?" #'consult-line-multi
  "l" #'consult-goto-line
  "g" #'consult-focus-lines
  "y" #'consult-yank-from-kill-ring

  ;; Files / buffers
  "f" #'find-file
  "k" #'save-buffer
  "s s" #'save-buffer

  ;; Embark
  "." #'embark-act

  ;; Yank
  "P" #'consult-yank-from-kill-ring

  ;; Buffer group
  "b" '(:ignore t :which-key "buffers")
  "b i" #'consult-buffer
  "b b" #'ibuffer
  "b d" #'kill-current-buffer
  "b k" #'kill-current-buffer
  "b x" #'kill-current-buffer
  "b s" #'save-buffer
  "b l" #'consult-buffer
  "SPC" #'consult-buffer

  ;; File management (dired)
  "e d" #'dired
  "e e" #'dired-jump

  ;; Project
  "p" '(:ignore t :which-key "project")
  "p b" #'consult-project-buffer
  "p p" #'project-switch-project
  "p f" #'project-find-file
  "p g" #'project-find-regexp
  "p k" #'project-kill-buffers
  "p D" #'project-dired

  ;; Help
  "h" '(:ignore t :which-key "help")
  "h m" #'describe-mode
  "h f" #'describe-function
  "h v" #'describe-variable
  "h k" #'describe-key

  ;; Flymake
  "x x" #'consult-flymake

  ;; Search group
  "s" '(:ignore t :which-key "search/save")
  "s f" #'consult-find
  "s g" #'consult-grep
  "s G" #'consult-git-grep
  "s r" #'consult-ripgrep
  "s h" #'consult-info)

(general-def 'motion
  "j" #'evil-next-visual-line
  "k" #'evil-previous-visual-line)

(general-def 'insert
  "C-g" #'evil-normal-state)

(general-def 'normal
  "RET" (lambda ()
          (interactive)
          (evil-open-below 1)
          (evil-normal-state))

  "C-." #'embark-act 

  "C-I" #'indent-for-tab-command

  ;; Flymake
  "] d" #'flymake-goto-next-error
  "[ d" #'flymake-goto-prev-error

  ;; Diff-hl
  "] c" #'diff-hl-next-hunk
  "[ c" #'diff-hl-previous-hunk

  ;; Buffers
  "] b" #'switch-to-next-buffer
  "[ b" #'switch-to-prev-buffer

  ;; Tabs
  "] t" #'tab-next
  "[ t" #'tab-previous)

(general-def
  ;; Wrap Text (Pairs)
  "M-[" #'insert-pair
  "M-{" #'insert-pair
  "M-\"" #'insert-pair
  ;; Delete Pairs
  "M-]" #'delete-pair
  "M-}" #'delete-pair
  "M-)" #'delete-pair)

(general-def 'normal prog-mode-map
  ;; Documentation / help at point
  "K" (if (>= emacs-major-version 31)
          #'eldoc-box-help-at-point
        #'ek/lsp-describe-and-jump)

  ;; Eglot navigation
  "gt" #'eglot-find-typeDefinition
  "gi" #'eglot-find-implementation
  "ga" #'eglot-code-actions

  ;; Comment current line (gcc)
  "gcc" (lambda ()
          (interactive)
          (unless (use-region-p)
            (comment-or-uncomment-region
             (line-beginning-position)
             (line-end-position)))))

(general-def 'visual prog-mode-map
  "gc" (lambda ()
         (interactive)
         (when (use-region-p)
           (comment-or-uncomment-region
            (region-beginning)
            (region-end)))))
