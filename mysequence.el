
;;; -*- lisp interaction -*-

(setq mylist '(0 1 2 3 4 5 6 7 8 9))
(0 1 2 3 4 5 6 7 8 9)

(cl-subseq mylist 1 3)
(1 2)

mylist
(0 1 2 3 4 5 6 7 8 9)

(nthcdr 1 mylist)
(1 2 3 4 5 6 7 8 9)

(defun my-subseq (seq beg &optional end)
  (let ((result (nthcdr beg seq)))
    (if end
	(reverse (nthcdr (- (length seq) end)
			 (reverse result)))
      result)))

(my-subseq mylist 1 3)
