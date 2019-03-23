
;;; リストって、こんな感じ？

'(0 1 2 3 4 5 6 7 8 9)
(0 1 2 3 4 5 6 7 8 9)

;;; このリストって、どうやって作るの？

'(0 1 2 3 4 5 6 7 8 9)
(0 1 2 3 4 5 6 7 8 9)

;;; もう少し真面目にやると？

(setq mylist '(0 1 2 3 4 5 6 7 8 9))
(0 1 2 3 4 5 6 7 8 9)

;;; リストの先頭の要素を変更する

(setcar mylist 10)
10

(setq mylist2 (cons 10 (cdr mylist)))
(10 1 2 3 4 5 6 7 8 9)

(eq (nthcdr 1 mylist) (nthcdr 1 mylist2))
t

(cl-mapcar 'eq (nthcdr 1 mylist) (nthcdr 1 mylist2))
(t t t t t t t t t)

(let (result)
  (dotimes (i 10)
    (push (eq (nth i mylist) (nth i mylist2)) result))
  (reverse result))
(nil t t t t t t t t t)

;;; リストのＸ番目からＹ番目までの要素を取り出す

(setq mylist (cl-loop for x to 9 collect x))

(setq mylist2 (cons 10 (cdr mylist)))

(defun my-subseq (seq beg &optional end)
  (let ((result (nthcdr beg seq)))
    (if end
	(reverse (nthcdr (- (length seq) end)
			 (reverse result)))
      result)))

;;; まずテストケースを作る

(setq my-test-case
      (let (result)
	(dolist (x mylist)
	  (dolist (y mylist)
	    (push (cons (cons x y) 'subseq) result)))
	(reverse result)))

;;; テストする

(dolist (test my-test-case)
  (let ((x (caar test))
	(y (cdar test)))
    (setcdr test
	    (condition-case err
		(cl-subseq mylist x y)
	      (error 'subseq)))))

;;; テスト結果を確認する

(dolist (test my-test-case)
  (insert-before-markers
   (format "x=%d|y=%d => %S\n"
	   (caar test)
	   (cdar test)
	   (cdr test))))

(my-subseq my-test-case 0 9)
(((0 . 0)) ((0 . 1) 0) ((0 . 2) 0 1) ((0 . 3) 0 1 2) ((0 . 4) 0 1 2 3) ((0 . 5) 0 1 2 3 4) ((0 . 6) 0 1 2 3 4 5) ((0 . 7) 0 1 2 3 4 5 6) ((0 . 8) 0 1 2 3 4 5 6 7))

;;; 連想リストを参照したり変更したりする

(assoc '(0 . 2) (my-subseq my-test-case 0 9))
((0 . 2) 0 1)

(rassoc '(0 1) (my-subseq my-test-case 0 9))
((0 . 2) 0 1)

(setq my-subtest (my-subseq my-test-case 0 9))
(((0 . 0)) ((0 . 1) 0) ((0 . 2) 0 1) ((0 . 3) 0 1 2) ((0 . 4) 0 1 2 3) ((0 . 5) 0 1 2 3 4) ((0 . 6) 0 1 2 3 4 5) ((0 . 7) 0 1 2 3 4 5 6) ((0 . 8) 0 1 2 3 4 5 6 7))

(let ((test (assoc '(0 . 2) my-subtest)))
  (setcdr test 'subseq))
subseq

(assoc '(0 . 2) my-subtest)
((0 . 2) . subseq)

(setq my-subtest '(((0 . 0)) ((0 . 1) 0) ((0 . 2) . subseq) ((0 . 3) 0 1 2) ((0 . 4) 0 1 2 3) ((0 . 5) 0 1 2 3 4) ((0 . 6) 0 1 2 3 4 5) ((0 . 7) 0 1 2 3 4 5 6) ((0 . 8) 0 1 2 3 4 5 6 7)))

;;; リストの中の任意の要素を取り除く

my-subtest
(((0 . 0)) ((0 . 1) 0) ((0 . 2) . subseq) ((0 . 3) 0 1 2) ((0 . 4) 0 1 2 3) ((0 . 5) 0 1 2 3 4) ((0 . 6) 0 1 2 3 4 5) ((0 . 7) 0 1 2 3 4 5 6) ((0 . 8) 0 1 2 3 4 5 6 7))

(length my-subtest)
9

(setq my-3rd-test '((0 . 2) . subseq))
((0 . 2) . subseq)

(setcdr (nthcdr 1 my-subtest) (nthcdr 3 my-subtest))
(((0 . 3) 0 1 2) ((0 . 4) 0 1 2 3) ((0 . 5) 0 1 2 3 4) ((0 . 6) 0 1 2 3 4 5) ((0 . 7) 0 1 2 3 4 5 6) ((0 . 8) 0 1 2 3 4 5 6 7))

(length my-subtest)
8

;;; リストの途中に要素を追加する

my-subtest
(((0 . 0)) ((0 . 1) 0) ((0 . 3) 0 1 2) ((0 . 4) 0 1 2 3) ((0 . 5) 0 1 2 3 4) ((0 . 6) 0 1 2 3 4 5) ((0 . 7) 0 1 2 3 4 5 6) ((0 . 8) 0 1 2 3 4 5 6 7))

my-3rd-test
((0 . 2) . subseq)

(setq my-3rd-test (list my-3rd-test))
(((0 . 2) . subseq))

(setcdr my-3rd-test (nthcdr 2 my-subtest))
(((0 . 3) 0 1 2) ((0 . 4) 0 1 2 3) ((0 . 5) 0 1 2 3 4) ((0 . 6) 0 1 2 3 4 5) ((0 . 7) 0 1 2 3 4 5 6) ((0 . 8) 0 1 2 3 4 5 6 7))

my-3rd-test
(((0 . 2) . subseq) ((0 . 3) 0 1 2) ((0 . 4) 0 1 2 3) ((0 . 5) 0 1 2 3 4) ((0 . 6) 0 1 2 3 4 5) ((0 . 7) 0 1 2 3 4 5 6) ((0 . 8) 0 1 2 3 4 5 6 7))

(setcdr (nthcdr 1 my-subtest) my-3rd-test)
(((0 . 2) . subseq) ((0 . 3) 0 1 2) ((0 . 4) 0 1 2 3) ((0 . 5) 0 1 2 3 4) ((0 . 6) 0 1 2 3 4 5) ((0 . 7) 0 1 2 3 4 5 6) ((0 . 8) 0 1 2 3 4 5 6 7))

my-subtest
(((0 . 0)) ((0 . 1) 0) ((0 . 2) . subseq) ((0 . 3) 0 1 2) ((0 . 4) 0 1 2 3) ((0 . 5) 0 1 2 3 4) ((0 . 6) 0 1 2 3 4 5) ((0 . 7) 0 1 2 3 4 5 6) ((0 . 8) 0 1 2 3 4 5 6 7))

(length my-subtest)
9

;;; ヘビの共食い？

(setq mylist (cl-loop for x to 9 collect x))
(0 1 2 3 4 5 6 7 8 9)

(nthcdr 9 mylist)
(9)

(setcdr (nthcdr 9 mylist) mylist)
(0 1 2 3 4 5 6 7 8 9 0 1 ...)

(nth 10000 mylist)
0

(nth 1000001 mylist)
1

;;; Oh! my god??
