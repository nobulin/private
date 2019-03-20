
(setq mylist (cl-loop for x to 9 collect x))
(0 1 2 3 4 5 6 7 8 9)

(defun my-subseq (seq beg &optional end)
  (let ((result (nthcdr beg seq)))
    (if end
	(reverse (nthcdr (- (length seq) end)
			 (reverse result)))
      result)))

(my-subseq mylist 1 3)

(setq my-subseq-alist
      (let (result)
	(dolist (x mylist)
	  (dolist (y mylist)
	    (setq y (1+ y))
	    (when (< x y)
	      (push (cons
		     (cons x y)
		     (my-subseq mylist x y))
		    result))))
	(reverse result)))
(((0 . 1) 0) ((0 . 2) 0 1) ((0 . 3) 0 1 2) ((0 . 4) 0 1 2 3) ((0 . 5) 0 1 2 3 4) ((0 . 6) 0 1 2 3 4 5) ((0 . 7) 0 1 2 3 4 5 6) ((0 . 8) 0 1 2 3 4 5 6 7) ((0 . 9) 0 1 2 3 4 5 6 7 8) ((0 . 10) 0 1 2 3 4 5 6 7 8 9) ((1 . 2) 1) ((1 . 3) 1 2) ...)

(cdr (assoc '(1 . 3) my-subseq-alist))
(1 2)
