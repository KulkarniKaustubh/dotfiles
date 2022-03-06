;;; goto-chg-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "goto-chg" "../../../../../.emacs.d/elpa/goto-chg-20220107.1733/goto-chg.el"
;;;;;;  "2b6e74a4658d8801742ab2e69e4dc4da")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/goto-chg-20220107.1733/goto-chg.el

(autoload 'goto-last-change "goto-chg" "\
Go to the point where the last edit was made in the current buffer.
Repeat the command to go to the second last edit, etc.

To go back to more recent edit, the reverse of this command, use \\[goto-last-change-reverse]
or precede this command with \\[universal-argument] - (minus).

It does not go to the same point twice even if there has been many edits
there. I call the minimal distance between distinguishable edits \"span\".
Set variable `glc-default-span' to control how close is \"the same point\".
Default span is 8.
The span can be changed temporarily with \\[universal-argument] right before \\[goto-last-change]:
\\[universal-argument] <NUMBER> set current span to that number,
\\[universal-argument] (no number) multiplies span by 4, starting with default.
The so set span remains until it is changed again with \\[universal-argument], or the consecutive
repetition of this command is ended by any other command.

When span is zero (i.e. \\[universal-argument] 0) subsequent \\[goto-last-change] visits each and
every point of edit and a message shows what change was made there.
In this case it may go to the same point twice.

This command uses undo information. If undo is disabled, so is this command.
At times, when undo information becomes too large, the oldest information is
discarded. See variable `undo-limit'.

\(fn ARG)" t nil)

(autoload 'goto-last-change-reverse "goto-chg" "\
Go back to more recent changes after \\[goto-last-change] have been used.
See `goto-last-change' for use of prefix argument.

\(fn ARG)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "goto-chg" "../../../../../.emacs.d/elpa/goto-chg-20220107.1733/goto-chg.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/goto-chg-20220107.1733/goto-chg.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "goto-chg" '("glc-")))

;;;***

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/goto-chg-20220107.1733/goto-chg-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/goto-chg-20220107.1733/goto-chg.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; goto-chg-autoloads.el ends here
