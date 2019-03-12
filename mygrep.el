;;; 私の grep コマンド！

(require 'subr-x)

;;; 探索キーワード

(defun mygrep-keyword ()
  (if command-line-args-left
      (car command-line-args-left)
    (read-string "Keyword(RE): ")))

;;; 探索ファイル

(defun mygrep-files ()
  (let* ((filematch (if command-line-args-left
			(cadr command-line-args-left)
		      (read-string "Files(RE): ")))
	 (dir (file-name-directory filematch))
	 (match (file-name-nondirectory filematch)))
    (directory-files dir t match)))

;;; 探索処理

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

;;; 結果出力

(defun mygrep-output (outputs)
  (let (result)
    (dolist (output outputs)
      (push (apply 'format "%s:%d:%s" output) result))
    (reverse result)))

;;; メイン処理

(let ((string (string-join
	       (mygrep-output
		(mygrep-search (mygrep-keyword)
			       (mygrep-files)))
	       "\n")))
  (if command-line-args-left
      (message "%s" string)
    (with-current-buffer (get-buffer-create "*mygrep*")
      (erase-buffer)
      (insert (format "%s\n" string)))))
