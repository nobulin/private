
(let ((dirs (with-temp-buffer
	      (shell-command "find ~/ -type d 2>/dev/null" t)
	      (split-string (buffer-substring-no-properties
			     (point-min) (point-max)) "\n" t)))
      (obuff (with-current-buffer (get-buffer-create "*OBUFF*")
	       (erase-buffer) (current-buffer))))
  (dolist (dir dirs)
    (with-current-buffer obuff
      (goto-char (point-max))
      (when (file-readable-p dir)
	(message "%s" dir)
	(insert-before-markers
	 (format "%s,%d,%s\n"
		 (format-time-string "%H:%M:%S.%6N")
		 (with-current-buffer (dired dir)
		   (prog1 (point-max) (kill-current-buffer)))
		 (format-time-string "%H:%M:%S.%6N")))))))

(with-current-buffer "dired-time.csv"
  (let* (result
	 (lines (split-string (buffer-substring-no-properties
			       (point-min) (point-max)) "\n" t))
	 (csvs (mapcar (lambda (l) (split-string l "," t)) lines)))
    (dolist (e csvs)
      (let* ((beg (nth 0 e))
	     (siz (string-to-number (nth 1 e)))
	     (end (nth 2 e))
	     (tim (- (* 1000000
			(+ (* 60 (string-to-number (substring end 3 5)))
			   (string-to-number (substring end 6))))
		     (* 1000000
			(+ (* 60 (string-to-number (substring beg 3 5)))
			   (string-to-number (substring beg 6))))))
	     (div (/ tim siz)))
	(push (cons tim siz) result)))
    (sort result (lambda (a b) (> (car a) (car b))))))
