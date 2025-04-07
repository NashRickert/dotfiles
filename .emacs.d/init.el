;; Gui adjustments (more minimal)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tab-bar-mode -1) ; Value of 1 enables tabs
(tooltip-mode -1) ; Puts help text in minibuffer instead of popup

;; Startup preferences
(setq visible-bell t) ; Visible bell on improper action
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
(setq-default c-basic-offset 4)

;; Adds .ghcup/bin to both 'exec-path and "PATH" (those are different things)
(add-to-list 'exec-path "/home/nash/.ghcup/bin/") 
(setenv "PATH" (concat "/home/nash/.ghcup/bin:" (getenv "PATH")))
(setenv "SHELL" "/usr/bin/zsh")

(setopt dictionary-server "dict.org")
(server-start) ;; Done so I can use emacsclient inside of vterm


(load "~/.emacs.d/packages.el")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("a3a71b922fb6cbf9283884ac8a9109935e04550bcc5d2a05414a58c52a8ffc47" default))
 '(package-selected-packages
   '(devdocs aas ace-window company docker doom-modeline eglot-booster evil evil-collection evil-magit evil-surround gruvbox-theme haskell-mode helpful lsp-mode lsp-ui magit marginalia projectile sideline-flymake smartparens ultra-scroll vertico vterm which-key yasnippet))
 '(package-vc-selected-packages
   '((eglot-booster :vc-backend Git :url "https://github.com/jdtsmith/eglot-booster")
     (ultra-scroll :vc-backend Git :url "https://github.com/jdtsmith/ultra-scroll"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
