#!/usr/local/bin/emacs --script

(let* ((keyword (car command-line-args-left))
       (filematch (cadr command-line-args-left))
       (dir (file-name-directory filematch))
       (match (file-name-nondirectory filematch))
       (files (directory-files dir t match))
       (result ()))
  (dolist (file files)
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (while (re-search-forward keyword nil t)
	(push (list file
		    (count-lines (point-min)
				 (point))
		    (buffer-substring (line-beginning-position)
				      (line-end-position)))
	      result))))
  (dolist (hit (reverse result))
    (message "%s" (apply 'format "%s:%d:%s" hit))))
