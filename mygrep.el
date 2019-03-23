;;; 私の grep コマンド！

;;; キーワード文字列を入力する
(defun mygrep-keyword ()
  (if command-line-args-left
      (car command-line-args-left)
    (read-string "Keyword(RE): ")))

;;; 入力された条件のファイルを集める
(defun mygrep-files ()
  (let* ((input (if command-line-args-left
		    (cadr command-line-args-left)
		  (read-string "Files(RE): ")))
	 (dir (file-name-directory input))
	 (match (file-name-nondirectory input)))
    (directory-files dir t match)))

;;; 集めたファイルをキーワード探索し、一致する行を保存する
(defun mygrep-search (keyword files)
  (let (result)
    (dolist (file files)
      (with-temp-buffer
	(insert-file-contents file)
	(goto-char (point-min))
	(while (re-search-forward keyword nil t)
	  (push (list file
		      (count-lines (point-min) (point))
		      (buffer-substring (line-beginning-position)
					(line-end-position)))
		result))))
    (reverse result)))

;;; 結果を出力する
(defun mygrep-output (outputs)
  (with-current-buffer (let ((buffer (get-buffer "*MYGREP*")))
			 (and buffer (kill-buffer buffer))
			 (get-buffer-create "*MYGREP*"))
    (erase-buffer)
    (setq truncate-lines t)
    (dolist (output outputs)
      (let ((string (apply 'format "%s:%d:%s" output)))
	(if noninteractive
	    (message "%s" string)
	  (insert-before-markers string "\n"))))
    (compilation-mode)))

;;; メイン処理
(defun mygrep ()
  (interactive)
  (let* ((keyword (mygrep-keyword))
	 (files (mygrep-files))
	 (outputs (mygrep-search keyword files)))
    (mygrep-output outputs))
  (pop-to-buffer "*MYGREP*"))

(when noninteractive (mygrep))
