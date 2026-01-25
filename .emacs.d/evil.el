;; For all of my evil mode configuration
;; Mostly consists of keybinds


;; Evil Mode
(use-package evil
  :init
  (setq evil-want-integration t) ;; important
  (setq evil-want-keybinding nil) ;; applies evil to other modes
  ;; Note that these 'want' settings are for overriding
  ;; the existing emacs keybindings with the evil mode ones
  ;; (Or turns some default ones off with nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-redo)
  ;; Evil mode overrides embark-act otherwise
  (define-key evil-normal-state-map (kbd "C-.") 'embark-act)
  ;; Let C-g exit insert mode too
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ;; Ret makes new line and stays in normal mode
  (define-key evil-normal-state-map (kbd "RET") (lambda () (interactive) (evil-open-below 1) (evil-normal-state)))
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (setq evil-want-fine-undo t)
  (setq evil-leader/in-all-states t)

  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC"))

  ;; Note: I copped most/all of these keybindings from emacs-kick
  ;; A lot of them overlaod existing keybindings with a leader key
  ;; But a lot of them provide keybindings to things that don't have them, mainly the consult commands

  ;; Miscellaneous keybindings
  (evil-define-key 'normal 'global (kbd "<leader> j") 'ace-window)
  ;; (evil-define-key 'normal 'global (kbd "<leader> m") 'mu4e)
  (evil-define-key 'normal 'global (kbd "<leader> m") 'magit)

  (evil-define-key 'normal 'global (kbd "<leader> <up>") 'enlarge-window)
  (evil-define-key 'normal 'global (kbd "<leader> <down>") 'shrink-window)
  (evil-define-key 'normal 'global (kbd "<leader> <left>") 'shrink-window-horizontally)
  (evil-define-key 'normal 'global (kbd "<leader> <right>") 'enlarge-window-horizontally)
  (evil-define-key 'normal 'global (kbd "<leader> w") 'window-configuration-to-register)
  (evil-define-key 'normal 'global (kbd "<leader> W") 'jump-to-register)

  ;; Note that the evil version of these commands allow an argument for the size of splitting
  ;; And that may be worth using over the base functionality
  ;; With no argument, they seem to operate as normal
  (evil-define-key 'normal 'global (kbd "<leader> 0") 'delete-window)
  (evil-define-key 'normal 'global (kbd "<leader> 1") 'delete-other-windows)
;; (lambda () (interactive)(split-window-vertically) (other-window 1)))
  (evil-define-key 'normal 'global (kbd "<leader> 2") (lambda () (interactive)(split-window-below) (other-window 1)))
  (evil-define-key 'normal 'global (kbd "<leader> 3") (lambda () (interactive)(split-window-right) (other-window 1)))
  ;; (evil-define-key 'normal 'global (kbd "<leader> 3") 'split-window-right)
  ;; (evil-define-key 'normal 'global (kbd "<leader> 2") 'split-window-below)
  ;; (evil-define-key 'normal 'global (kbd "<leader> 3") 'split-window-right)
  (evil-define-key 'normal 'global (kbd "<leader> @") 'split-root-window-below)
  (evil-define-key 'normal 'global (kbd "<leader> #") 'split-root-window-right)
  (evil-define-key 'normal 'global (kbd "<leader> r") 'consult-register-store)
  (evil-define-key 'normal 'global (kbd "<leader> R") 'consult-register)


  ;; Shortcut to open a new vterm terminal
  (evil-define-key 'normal 'global (kbd "<leader> v") 'vterm)

  ;; Shortcut to open devdocs
  ;; Note that in a buffer, a selection is remembered unless a prefix argument is given
  (evil-define-key 'normal 'global (kbd "<leader> d") 'devdocs-lookup)

  
  ;; Keybindings for searching and finding files.
  (evil-define-key 'normal 'global (kbd "<leader> s f") 'consult-find)
  (evil-define-key 'normal 'global (kbd "<leader> s g") 'consult-grep)
  (evil-define-key 'normal 'global (kbd "<leader> s G") 'consult-git-grep)
  (evil-define-key 'normal 'global (kbd "<leader> s r") 'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "<leader> s h") 'consult-info)
  (evil-define-key 'normal 'global (kbd "<leader> /") 'consult-line)

  ;; Flymake navigation
  (evil-define-key 'normal 'global (kbd "<leader> x x") 'consult-flymake);; Gives you something like `trouble.nvim'
  (evil-define-key 'normal 'global (kbd "] d") 'flymake-goto-next-error) ;; Go to next Flymake error
  (evil-define-key 'normal 'global (kbd "[ d") 'flymake-goto-prev-error) ;; Go to previous Flymake error

  (evil-define-key 'normal 'global (kbd "<leader> ?") 'consult-line-multi)
  (evil-define-key 'normal 'global (kbd "<leader> l") 'consult-goto-line)
  (evil-define-key 'normal 'global (kbd "<leader> g") 'consult-focus-lines)
  (evil-define-key 'normal 'global (kbd "<leader> y") 'consult-yank-from-kill-ring)

  ;; Dired commands for file management
  (evil-define-key 'normal 'global (kbd "<leader> e d") 'dired)
  ;; (evil-define-key 'normal 'global (kbd "<leader> x j") 'dired-jump)
  (evil-define-key 'normal 'global (kbd "<leader> e e") 'dired-jump)
  (evil-define-key 'normal 'global (kbd "<leader> f") 'find-file)
  (evil-define-key 'normal 'global (kbd "<leader> s s") 'save-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> k") 'save-buffer)

  ;; Diff-HL navigation for version control
  (evil-define-key 'normal 'global (kbd "] c") 'diff-hl-next-hunk) ;; Next diff hunk
  (evil-define-key 'normal 'global (kbd "[ c") 'diff-hl-previous-hunk) ;; Previous diff hunk

  ;; Buffer management keybindings
  (evil-define-key 'normal 'global (kbd "] b") 'switch-to-next-buffer) ;; Switch to next buffer
  (evil-define-key 'normal 'global (kbd "[ b") 'switch-to-prev-buffer) ;; Switch to previous buffer
  (evil-define-key 'normal 'global (kbd "<leader> b i") 'consult-buffer) ;; Open consult buffer list
  (evil-define-key 'normal 'global (kbd "<leader> b b") 'ibuffer) ;; Open Ibuffer
  (evil-define-key 'normal 'global (kbd "<leader> b d") 'kill-current-buffer) ;; Kill current buffer
  (evil-define-key 'normal 'global (kbd "<leader> b k") 'kill-current-buffer) ;; Kill current buffer
  (evil-define-key 'normal 'global (kbd "<leader> b x") 'kill-current-buffer) ;; Kill current buffer
  (evil-define-key 'normal 'global (kbd "<leader> b s") 'save-buffer) ;; Save buffer
  (evil-define-key 'normal 'global (kbd "<leader> b l") 'consult-buffer) ;; Consult buffer
  (evil-define-key 'normal 'global (kbd "<leader>SPC") 'consult-buffer) ;; Consult buffer

  ;; Project management keybindings
  (evil-define-key 'normal 'global (kbd "<leader> p b") 'consult-project-buffer) ;; Consult project buffer
  (evil-define-key 'normal 'global (kbd "<leader> p p") 'project-switch-project) ;; Switch project
  (evil-define-key 'normal 'global (kbd "<leader> p f") 'project-find-file) ;; Find file in project
  (evil-define-key 'normal 'global (kbd "<leader> p g") 'project-find-regexp) ;; Find regexp in project
  (evil-define-key 'normal 'global (kbd "<leader> p k") 'project-kill-buffers) ;; Kill project buffers
  (evil-define-key 'normal 'global (kbd "<leader> p D") 'project-dired) ;; Dired for project

  ;; Yank from kill ring
  ;; (evil-define-key 'normal 'global (kbd "P") 'consult-yank-from-kill-ring)
  (evil-define-key 'normal 'global (kbd "<leader> P") 'consult-yank-from-kill-ring)

  ;; Embark actions for contextual commands
  (evil-define-key 'normal 'global (kbd "<leader> .") 'embark-act)

  ;; Help keybindings
  (evil-define-key 'normal 'global (kbd "<leader> h m") 'describe-mode) ;; Describe current mode
  (evil-define-key 'normal 'global (kbd "<leader> h f") 'describe-function) ;; Describe function
  (evil-define-key 'normal 'global (kbd "<leader> h v") 'describe-variable) ;; Describe variable
  (evil-define-key 'normal 'global (kbd "<leader> h k") 'describe-key) ;; Describe key

  ;; Tab navigation
  (evil-define-key 'normal 'global (kbd "] t") 'tab-next) ;; Go to next tab
  (evil-define-key 'normal 'global (kbd "[ t") 'tab-previous) ;; Go to previous tab

  ;; K shows floating windows in Emacs 31
  (evil-define-key 'normal 'global (kbd "K")
    (if (>= emacs-major-version 31)
        #'eldoc-box-help-at-point
        #'ek/lsp-describe-and-jump))

  (evil-define-key 'normal 'global (kbd "gt") 'eglot-find-typeDefinition) ;; Go to previous tab
  (evil-define-key 'normal 'global (kbd "gi") 'eglot-find-implementation) ;; Go to previous tab
  (evil-define-key 'normal 'global (kbd "C-I") 'indent-for-tab-command) ;; Go to previous tab
  (evil-define-key 'normal 'global (kbd "C-i") 'evil-jump-forward) ;; Go to previous tab
  (evil-define-key 'normal 'global (kbd "ga") 'eglot-code-actions) ;; Go to previous tab

  ;; Commenting functionality for single and multiple lines
  (evil-define-key 'normal 'global (kbd "gcc")
    (lambda ()
      (interactive)
      (if (not (use-region-p))
          (comment-or-uncomment-region (line-beginning-position) (line-end-position)))))
  
  (evil-define-key 'visual 'global (kbd "gc")
    (lambda ()
      (interactive)
      (if (use-region-p)
          (comment-or-uncomment-region (region-beginning) (region-end))))))

(use-package evil-collection
  :after
  evil
  :config
  (evil-collection-init)

  ;; Note with-eval-after-load to make sure changes are only applied after map is loaded
  ;; Also note each call needs its own with-eval-after-load call
  (evil-collection-translate-key 'normal 'help-mode-map " " 'nil)
  (with-eval-after-load 'mu4e
      (evil-collection-translate-key 'normal 'mu4e-view-mode-map " " 'nil))
  (with-eval-after-load 'pdf-tools
      (evil-collection-translate-key 'normal 'pdf-view-mode-map " " 'nil))
  (with-eval-after-load 'devdocs
      (evil-collection-translate-key 'normal 'devdocs-mode-map " " 'nil))
  (with-eval-after-load 'image
      (evil-collection-translate-key 'normal 'image-mode-map " " 'nil))
  (with-eval-after-load 'dired
      (evil-collection-translate-key 'normal 'dired-mode-map " " 'nil)))


;; Evil Surround
;; Note that this provides another way to surround in visual mode
;; Aside from the M-({[ keybindings I defined
(use-package evil-surround
  :config
  (global-evil-surround-mode 1))
