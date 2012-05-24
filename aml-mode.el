;;; aml-mode.el --- An Emacs major mode for AML

;; Copyright (C) 2012  David Christiansen

;; Author: David Christiansen <drc@itu.dk>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is a major mode for working with AML code.

;;; Code:


(defvar aml-keywords
  '("value"
    "variable"
    "statemodel"
    "riskmodel"
    "contract"
    "function"
    "type"
    "where"
    "pays"))

(defvar aml-operators
  '(":" "=>" "->" "+" "-" "*" "/" "<" ">" ">=" "<=" "="))

(defvar aml-font-lock-defaults
  `((
     ("\"\\.\\*\\?" . font-lock-string-face)
     (,(regexp-opt aml-operators 'symbols) . font-lock-builtin-face)
     (,(regexp-opt aml-keywords 'words) . font-lock-keyword-face)
     )))

(defgroup aml nil "AML mode customization" :prefix 'aml)

(defcustom aml-tab-width 2
  "Width to indent AML"
  :type 'integer
  :group 'aml)

(defcustom aml-mode-hook nil
  "Hook to run when entering AML mode"
  :type 'hook
  :group 'aml)

;;; Blindly stolen from haskell-simple-indent
(defun aml-indent ()
  "Space out to under next visible indent point.
Indent points are positions of non-whitespace following whitespace in
lines preceeding point.  A position is visible if it is to the left of
the first non-whitespace of every nonblank line between the position and
the current line.  If there is no visible indent point beyond the current
column, `tab-to-tab-stop' is done instead."
  (interactive)
  (let* ((start-column (current-column))
         (invisible-from nil)		; `nil' means infinity here
         (indent
          (catch 'aml-simple-indent-break
            (save-excursion
              (while (progn (beginning-of-line)
                            (not (bobp)))
                (forward-line -1)
                (if (not (looking-at "[ \t]*\n"))
                    (let ((this-indentation (current-indentation)))
                      (if (or (not invisible-from)
                              (< this-indentation invisible-from))
                          (if (> this-indentation start-column)
                              (setq invisible-from this-indentation)
                            (let ((end (line-beginning-position 2)))
                              (move-to-column start-column)
                              ;; Is start-column inside a tab on this line?
                              (if (> (current-column) start-column)
                                  (backward-char 1))
                              (or (looking-at "[ \t]")
                                  (skip-chars-forward "^ \t" end))
                              (skip-chars-forward " \t" end)
                              (let ((col (current-column)))
                                (throw 'aml-simple-indent-break
                                       (if (or (= (point) end)
                                               (and invisible-from
                                                    (> col invisible-from)))
                                           invisible-from
                                         col)))))))))))))
    (if indent
	(let ((opoint (point-marker)))
	  (indent-line-to indent)
	  (if (> opoint (point))
	      (goto-char opoint))
	  (set-marker opoint nil))
      (tab-to-tab-stop))))



(define-derived-mode aml-mode fundamental-mode "Actulus Modeling Language"
  "AML Mode is a mode for writing AML products and computations."
  :group 'aml

  (setq font-lock-defaults aml-font-lock-defaults)

  (setq comment-column 0)
  (setq comment-start "(*")
  (setq comment-end " *)")

  (modify-syntax-entry ?\( ". 1bn" aml-mode-syntax-table)
  (modify-syntax-entry ?\* ". 23bn" aml-mode-syntax-table)
  (modify-syntax-entry ?\) ". 4bn" aml-mode-syntax-table)
  (modify-syntax-entry ?\/ ". 12" aml-mode-syntax-table)
  (modify-syntax-entry ?\n ">" aml-mode-syntax-table)

  (set (make-local-variable 'indent-line-function) 'aml-indent)

  (when aml-mode-hook
    (funcall aml-mode-hook))
)

(provide 'aml-mode)
;;; aml-mode.el ends here