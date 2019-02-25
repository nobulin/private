
(set-process-filter
 (start-process-shell-command "dired" nil "while sleep 10; do echo; done")
 (lambda (proc string)
   (with-timeout (5 nil)
     (let ((dired-buffs (mapcar 'cdr dired-buffers)))
       (dolist (buff dired-buffs)
	 (when (buffer-live-p buff)
	   (with-current-buffer buff (revert-buffer))))))))

(advice-add 'save-buffers-kill-terminal
	    :before
	    #'(lambda (&rest r) (delete-process (get-process "dired"))))

(provide 'dired-sync-update-2)
