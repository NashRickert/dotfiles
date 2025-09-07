(use-package mu4e
  :load-path  "/usr/share/emacs/site-lisp/mu4e")

(setq mail-user-agent 'mu4e-user-agent)
(setq mu4e-change-filenames-when-moving t)

;; Leaving this as a global signature, but otherwise put it in contexts 
(setq mu4e-compose-signature
      (s-join
       "\n"
       '("Best," "Nash Rickert")))

(setq mu4e-attachment-dir "~/Downloads")

;; For now, makes the get mail command update all
;; Does this need to include mu index?
(setq mu4e-get-mail-command "mbsync --all")


;; Note I have a systemd timer that handles this
;; Possible problem: time won't run when mu4e is open on emacs
;; but running u in mu4e works fine
;; Also: change to this if systemd asks for a password too much
;; (setq mu4e-update-interval 600)


;; Sending mail settings:
(setq mu4e-compose-dont-reply-to-self t)
(setq message-send-mail-function 'message-send-mail-with-sendmail)
(setq sendmail-program "/usr/bin/msmtp")
(setq message-sendmail-extra-arguments '("--read-envelope-from"))
(setq message-sendmail-f-is-evil t)

(setq mu4e-headers-results-limit 3000)

;; Backed for mu4e for date. This should local time sent and lapsed time
;; Note time might still be an hour off based on pst or pdt, sometimes might be in utc
(setq gnus-article-date-headers '(combined-local-lapsed))

(setq mu4e-contexts
      `(,(make-mu4e-context
	  :name "yahoo-nash"
	  ;; Might need to change this to also check against from, cc, bcc fields to make sure it's right it :to is not robust enough
	  :match-func (lambda (msg)
			(when msg
			  (mu4e-message-contact-field-matches msg
							      :to "nashrickert@yahoo.com")))
	  :enter-func
	  (lambda () (mu4e-message "Entering nashrickert@yahoo.com context"))
	  :leave-func
	  (lambda ()
	    (mu4e-message "Leaving nashrickert@yahoo.com context")
	    (mu4e-clear-caches))
	  :vars '((user-mail-address . "nashrickert@yahoo.com")
		  ;; (mu4e-mu-home . "~/.mu/nash-yahoo")
                  (mu4e-maildir . "~/Mail")
                  (mu4e-refile-folder . "/nash-yahoo/archive")
                  (mu4e-sent-folder . "/nash-yahoo/sent")
                  (mu4e-drafts-folder . "/nash-yahoo/drafts")
                  (mu4e-trash-folder . "/nash-yahoo/trash")
		  (mu4e-maildir-shortcuts .
					  (("/nash-yahoo/inbox" . ?i)
			  		   ("/nash-yahoo/trash" . ?t)
			  		   ("/nash-yahoo/sent" . ?s)
					   ("/nash-yahoo/drafts" . ?d)))
		  (user-full-name . "Nash Rickert")))
      ,(make-mu4e-context
	  :name "gmail-nash"
	  :match-func (lambda (msg)
			(when msg
			  (mu4e-message-contact-field-matches msg
							      :to "nash.rickert@gmail.com")))
	  :enter-func
	  (lambda () (mu4e-message "Entering nash.rickert@gmail.com context"))
	  :leave-func
	  (lambda ()
	    (mu4e-message "Leaving nash.rickert@gmail.com context")
	    (mu4e-clear-caches))
	  :vars '((user-mail-address . "nash.rickert@gmail.com")
		  ;; (mu4e-mu-home . "~/.mu/nash-gmail")
		  (mu4e-maildir . "~/Mail")
                  (mu4e-refile-folder . "/nash-gmail/archive")
                  (mu4e-sent-folder . "/nash-gmail/sent")
                  (mu4e-drafts-folder . "/nash-gmail/drafts")
                  (mu4e-trash-folder . "/nash-gmail/trash")
		  (mu4e-maildir-shortcuts .
					  (("/nash-gmail/inbox" . ?i)
			  		   ("/nash-gmail/trash" . ?t)
			  		   ("/nash-gmail/sent" . ?s)
					   ("/nash-gmail/drafts" . ?d)
			  		   ("/nash-gmail/starred" . ?S)
			  		   ("/nash-gmail/all" . ?a)))
		  (user-full-name . "Nash Rickert")))))

;; Might want to change this
(setq mu4e-context-policy 'ask)
(setq mu4e-compose-context-policy 'ask)
