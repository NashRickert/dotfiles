;; Gui adjustments (more minimal)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tab-bar-mode -1) ; Value of 1 enables tabs
(tooltip-mode -1) ; Puts help text in minibuffer instead of popup

;; Startup preferences
(setq visible-bell nil) ; Visible bell on improper action
(setq ring-bell-function 'ignore)
(setq inhibit-startup-screen t)
(setq initial-scratch-message "Hello Nash")

;; Visual preferences
(global-visual-line-mode 1)
(set-fringe-mode 10) ; Sets size of edge fringe
(column-number-mode t)
(setq word-wrap t)

;; Line Numbers
;; Possible issues for 1000+ lines mitigated by grow-only
(setq-default display-line-numbers-width 3) 
(setq-default display-line-numbers-grow-only t) 
(add-hook 'prog-mode-hook (lambda () (display-line-numbers-mode 1)))
(add-hook 'text-mode-hook (lambda () (display-line-numbers-mode 1)))

;; Keybindings
(define-key key-translation-map (kbd "ESC") (kbd "C-g")) 

;; M-( works automatically. This is to allow wrapping over selected text in visual mode
(global-set-key (kbd "M-[") 'insert-pair)
(global-set-key (kbd "M-{") 'insert-pair)
(global-set-key (kbd "M-\"") 'insert-pair)
;; These settings allow deleting of matching with these commands (done on first delimiter)
(global-set-key (kbd "M-)") 'delete-pair)
(global-set-key (kbd "M-]") 'delete-pair)
(global-set-key (kbd "M-}") 'delete-pair)


;; Parentheses
(electric-pair-mode 1)
(setq electric-pair-pairs '((?\" . ?\") (?\{ . ?\}) (?\( . ?\))))

;; Misc
(setq password-cache-expiry nil)
(setq switch-to-buffer-obey-display-actions t)
(savehist-mode 1)
(setq history-length 25)
(global-auto-revert-mode 1)
;; Winner-Mode: reverse changes in window configuration with C-c <left> and redo with C-c <right>
(winner-mode 1) 

(setq-default c-electric-pound-behavior '(alignleft))
;; (setq c-default-style "linux")
(setq-default c-basic-offset 8)
(setq c-ts-mode-indent-style 'linux)
(setq-default c-ts-mode-indent-offset 8)
(setq-default go-ts-mode-indent-offset 8)
;; (setq c-ts-common-indent-offset 8)

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; All this style garbage should arguably go not in init.el

;; Go: use tabs (required by gofmt/gopls)
(defun my-go-mode-style ()
  (setq indent-tabs-mode t)      ;; use tabs for indentation
  (setq tab-width 4)             ;; but display as 4-space wide
  (setq go-ts-mode-indent-offset 4)) ;; for tree-sitter go-ts-mode
(add-hook 'go-ts-mode-hook #'my-go-mode-style)

;; C/C++: use spaces, 8-wide indentation
;; (defun my-c-style ()
;;   (setq indent-tabs-mode nil)
;;   (setq c-basic-offset 8)
;;   (setq tab-width 8))
;; (add-hook 'c-ts-mode-hook #'my-c-style)
;; (add-hook 'c++-ts-mode-hook #'my-c-style)

;; Adds .ghcup/bin to both 'exec-path and "PATH" (those are different things)
(add-to-list 'exec-path "/home/nash/.ghcup/bin/") 
(setenv "PATH" (concat "/home/nash/.ghcup/bin:" (getenv "PATH")))
(setenv "SHELL" "/bin/zsh")
(setq shell-file-name "/bin/zsh")

(setopt dictionary-server "dict.org")
;; (server-start) ;; Done so I can use emacsclient inside of vterm

(setq use-short-answers t)
(setq auto-save-default nil)
;; Make these buffer types appear in the bottom 25% of window
;; Good to note that I can add other types myself using this template
(add-to-list 'display-buffer-alist
	    '("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\|[Hh]elp\\|Messages\\|Bookmark List\\|Ibuffer\\|Occur\\|eldoc.*\\)\\*"
	    (display-buffer-in-side-window)
	    (window-height . 0.25)
	    (side . bottom)
	    (slot . 0))

	    '("\\*\\(Flymake diagnostics\\|xref\\|ivy\\|Swiper\\|Completions\\)"
	    (display-buffer-in-side-window)
	    (window-height . 0.25)
	    (side . bottom)
	    (slot . 1)))

(load "~/.emacs.d/packages.el")
(load "~/.emacs.d/functions.el")
;; (load "~/.emacs.d/email.el")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("c5975101a4597094704ee78f89fb9ad872f965a84fb52d3e01b9102168e8dc40"
     default))
 '(package-selected-packages
   '(aas ace-window auctex cdlatex clang-format company-prescient devdocs
         diff-hl doom-modeline eglot-booster eldoc-box embark-consult
         envrc evil-collection evil-surround go-mode haskell-mode
         helpful keychain-environment magit marginalia markdown-mode
         modus-themes orderless pdf-tools posframe projectile quelpa
         rainbow-delimiters sideline-flymake treesit-auto
         vertico-prescient vterm yasnippet))
 '(package-vc-selected-packages
   '((eglot-booster :vc-backend Git :url
                    "https://github.com/jdtsmith/eglot-booster")
     (pomo-cat :vc-backend Git :url
               "https://github.com/kn66/pomo-cat.el")
     (doom-two-tone-themes :vc-backend Git :url
                           "https://github.com/eliraz-refael/doom-two-tone-themes"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
