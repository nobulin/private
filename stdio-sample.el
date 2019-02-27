#!/usr/local/bin/emacs --script

(load "~/private/stdio.el" nil t)

(start-process-shell-command
 "sample" nil "echo this is a sample with stdio. > ~/private/.stdio-fifo")

(let (c)
  (while (not (= 0 (setq c (getchar))))
    (putchar c)))

(stdio-exit)
