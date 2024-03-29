;;; company-oddmuse.el --- a company-mode completion back-end for oddmuse-mode
;;
;; Copyright (C) 2009 Nikolaj Schumacher
;;
;; This file is part of company 0.2.1.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(require 'company)
(eval-when 'compile (require 'yaooddmuse nil t))
(eval-when 'compile (require 'oddmuse nil t))
(eval-when-compile (require 'cl))

(defvar company-oddmuse-link-regexp
  "\\(\\<[A-Z][[:alnum:]]*\\>\\)\\|\\[\\[\\([[:alnum:]]+\\>\\|\\)")

(defun company-oddmuse-get-page-table ()
  (case major-mode
    ('yaoddmuse-mode (with-no-warnings
                       (yaoddmuse-get-pagename-table yaoddmuse-wikiname)))
    ('oddmuse-mode (with-no-warnings
                     (oddmuse-make-completion-table oddmuse-wiki)))))

(defun company-oddmuse (command &optional arg &rest ignored)
  "A `company-mode' completion back-end for `oddmuse-mode'."
  (case command
    ('prefix (let ((case-fold-search nil))
               (and (memq major-mode '(oddmuse-mode yaoddmuse-mode))
                    (looking-back company-oddmuse-link-regexp (point-at-bol))
                    (or (match-string 1)
                        (match-string 2)))))
    ('candidates (all-completions arg (company-oddmuse-get-page-table)))))

(provide 'company-oddmuse)
;;; company-oddmuse.el ends here
