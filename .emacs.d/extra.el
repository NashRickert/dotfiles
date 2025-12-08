;; For stuff that's basically nonessential on mac

;; Eglot Mode
;; Using this for my minimal lsp
;; Note there are some possible performance improvements from
;; (setq eglot-events-buffer-size 0)
;; (fset #'jsonrpc--log-event #'ignore)
;; But I have no performance issues so I won't bother
;; (use-package eglot
;; :init
;; (setq eglot-autoshutdown t) ;; shutdown when no more relevant buffers exist
;; ; These are annoying but do give persistent diagnostics (other is only in normal mode on the same line)
;; (setq flymake-show-diagnostics-at-end-of-line nil) 
;; :hook ((python-mode . eglot-ensure)
;; 	(go-mode . eglot-ensure)
;; 	(go-ts-mode . eglot-ensure)
;; 	(c-mode . eglot-ensure)
;; 	(c-ts-mode . eglot-ensure)
;; 	(c++-mode . eglot-ensure)
;; 	(c++-ts-mode . eglot-ensure)
;; 	(java-ts-mode . eglot-ensure)
;; 	(java-mode . eglot-ensure)
;; 	(python-ts-mode . eglot-ensure)
;; 	(python-mode . eglot-ensure)
;; 	(haskell-mode . eglot-ensure)))

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

;; Note that jdtls is non trivial, but we basically install it somewhere and then
;; set up a script that starts it like we want (jdtls.sh) and add that to the path
;; An llm can give the script
;; (with-eval-after-load 'eglot
;;   ;; Add jdtls for Java
;;   (add-to-list 'eglot-server-programs
;; 	       ;; actually important file path is absolute for eglot booster, otherwise won't work
;;                `(java-mode . (,(expand-file-name "~/.opt/bin/jdtls.sh")
;;                               :initializationOptions
;;                               (:workspaceFolders
;;                                [,(concat "file://" (expand-file-name "~/.cache/jdtls-workspace"))]))))
  
;;   ;; Add clangd for C/C++
;;   ;; Should force emacs to use clangd instead of ccls
;;   (add-to-list 'eglot-server-programs
;;                '((c++-mode c-mode) . ("clangd"))))


;; Sideline Modes
;; Used to get sideline diagnostics for eglot
;; Note sideline is the frontend, sideline-flymake the backend. See github for more info
; (use-package sideline-flymake
; :init
; (setq sideline-flymake-display-mode 'line))

; (use-package sideline
; :after sideline-flymake
; :init
; (setq sideline-backends-right '(sideline-flymake))
; (setq sideline-backends-left-skip-current-line t   ; don't display on current line (left)
; 	sideline-backends-right-skip-current-line t  ; don't display on current line (right)
; 	sideline-order-left 'down                    ; or 'up
; 	sideline-order-right 'up                     ; or 'down
; 	sideline-format-left "%s   "                 ; format for left aligment
; 	sideline-format-right "   %s"                ; format for right aligment
; 	sideline-priority 100                        ; overlays' priority
; 	sideline-display-backend-name t)            ; display the backend name
; :hook
; (flymake-mode . sideline-mode))

; (use-package eglot-booster
;   :after eglot
;   :vc (:url "https://github.com/jdtsmith/eglot-booster")
;   :custom
;   (eglot-booster-no-remote-boost t)
;   :config
;   (eglot-booster-mode))


;; Company
;; I copy pasted this from the Emacs-kick init
;; (use-package company
;;   :defer t
;;   :ensure t
;;   :custom
;;   (company-tooltip-align-annotations t)      ;; Align annotations with completions.
;;   (company-minimum-prefix-length 1)          ;; Trigger completion after typing 1 character
;;   (company-idle-delay 0.75)                   ;; Delay before showing completion (adjust as needed)
;;   (company-tooltip-maximum-width 50)
;;   :config

;;   ;; While using C-p C-n to select a completion candidate
;;   ;; C-y quickly shows help docs for the current candidate
;;   (define-key company-active-map (kbd "C-y")
;; 			  (lambda ()
;; 				(interactive)
;; 				(company-show-doc-buffer)))
;;   (define-key company-active-map [tab] 'company-complete-selection)
;;   (define-key company-active-map (kbd "TAB") 'company-complete-selection)
;;   (define-key company-active-map [ret] nil)
;;   (define-key company-active-map (kbd "<return>") nil)
;;   (define-key company-active-map (kbd "RET") nil)
;;   :hook
;;   ;; Enable Company Mode globally after initialization.
;;   (after-init . global-company-mode) 
;;   ;; For now I think eshell mode is fine so long as command doesn't complete
;;   ;; (eshell-mode . (lambda() (company-mode 0)))
;;   ;; Use of tabs doesn't play nice in latex mode
;;   (cdlatex-mode . (lambda() (company-mode 0)))) 

;; (use-package company-prescient
;;   :demand t
;;   :after company prescient
;;   :custom
;;   ;; defaults
;;   (company-prescient-enable-sorting t)
;;   (company-prescient-override-sorting nil) ; Don't override `display-sort-function'
;;   :config
;;   (company-prescient-mode 1))

;; Projectile
;; Note to self: This is awesome and can't believe I didn't use before
; (use-package projectile
;   :config
;   (projectile-mode)
;   :bind-keymap
;   ("C-c p" . projectile-command-map)
;   :init
;   ;; First thing on project switch is to open dired
;   (setq projectile-switch-project-action #'projectile-dired))
