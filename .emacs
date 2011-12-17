(modify-frame-parameters nil '((wait-for-wm . nil)))
(progn                            ; load paths
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp") 1)
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/yasnippet") 1)
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/icicles") 1)
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/nxhtml") 1)
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/auto-complete") 1 ))

(load "~/.emacs.d/elisp/nxhtml/autostart.el")

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/auto-complete/ac-dict")
(ac-config-default)


(defun cygwin17-bindir ()
  "Return Cygwin bin directory."
  (load-library "w32-regdat")
  (let ((bindir (w32-reg-iface-culm-read-value "SOFTWARE\\Wow6432Node\\Cygwin\\setup\\rootdir")))
    (when bindir
      (file-name-as-directory (concat (car bindir) "\\bin")))))

(defun do-for-windows ()
  (message "Running windows specific init")
  (custom-set-faces                 ;Meslo (Menlo clone) font on windows.
   '(default ((t ( :background "SystemWindow" :foreground "SystemWindowText" :height 95 :family "Meslo LG L")))))
  (setq sql-mysql-options '("-C" "-t" "-f" "-n" "--protocol=tcp"))  ;mysql options on Windows.
  (progn 				; set up cygwin
    (setenv "PATH" (concat (cygwin17-bindir) ";" (getenv "PATH")))
    (setq exec-path (cons  (cygwin17-bindir) exec-path))
    (setq tramp-default-method "plink")
    (require 'cygwin-mount)
    (cygwin-mount-activate))
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/windows"))
  (custom-set-variables
   '(pgg-gpg-program (concat  (cygwin17-bindir) "gpg"))
   '(tramp-encoding-shell (concat  (cygwin17-bindir) "sh"))
   '(w32shell-cygwin-bin (cygwin17-bindir))
   '(w32shell-shell (quote cygwin)))
)

(defun do-for-mac () 
  (message "Running mac os X specific init")
  (custom-set-faces
   '(default ((t (:background "white" :foreground "black" :height 130 :width normal :family "Menlo")))))
)

(defun do-for-linux () 
  (message "Running Linux specific init")
  (server-start)
  (custom-set-faces
   '(default ((t ( :background "white" :foreground "black" :height 100 :family "DejaVu Sans Mono")))))
)

;; platform specific hacks.
(if (equal system-type 'windows-nt)
    (do-for-windows)
  ;; ELSE: check if on MacOS X - Menlo on Mac
  (if (equal system-type 'darwin)
      (do-for-mac)
    ;; Else - Linux/etc.
    (do-for-linux)
    )
  )

;;;;;;;;;;;;;;;;;;;; 
;; set up unicode
(progn
  (message "setting up unicode")
  (prefer-coding-system       'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  ;; This from a japanese individual.  I hope it works.
  (setq default-buffer-file-coding-system 'utf-8-auto)
  ;; From Emacs wiki
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
  ;; MS Windows clipboard is UTF-16LE 
  (set-clipboard-coding-system 'utf-16le-dos))

;; Server mode 
;; put e.cmd/emacsclient on path so that you can re-raise the emacs frame 
(progn                                  ; put in server mode
  (defun my-done ()
    (interactive)
    (server-edit)
    (make-frame-invisible nil t))
  (global-set-key (kbd "C-z") 'my-done))

(progn
  (require 'font-lock)
  (global-font-lock-mode t))

;; moinmoin mode for trac wiki markup
(require 'moinmoin-mode)

(progn           ;; line number mode
  (require 'linum)
  (global-set-key (kbd "<f6>") 'linum-mode))
;; General Editing Helpers - not mode specific
;; --------------------------------------------
(require 'pair-mode)

;; browse-kill-ring - very neat.
(require 'browse-kill-ring)
(global-set-key (kbd "M-y") 'browse-kill-ring )

(progn                    ; avoid hard tabs.
  ;; I hate tabs!
  ;; insert spaces for tabs and set width to 4
  (setq tab-width 4)
  (setq-default indent-tabs-mode nil))

;; shorten yes or no to y or n
(defalias 'yes-or-no-p 'y-or-n-p)

;; get rid of the tool bar and the scroll bar
(tool-bar-mode -1)
(scroll-bar-mode -1)

(progn                                  ; mic paren
  (require 'mic-paren)
  (paren-activate))

(pending-delete-mode 1)

(require 'mwheel)
(mwheel-install)

(line-number-mode 1)
(column-number-mode 1)

(require 'eldoc)
(eldoc-mode 1)

(desktop-save-mode 1)                   

;; Completion helpers
;; --------------------------------------------
(progn                                  ;ido mode
  (require 'ido)
  (ido-mode t))

(progn                                  ; yippe - predictive abbrevs
  (require 'pabbrev)
  ;; (pabbrev-mode)
  ;; (global-pabbrev-mode t)
)

(progn
  ;; yasnippet
  (require 'yasnippet)
  (yas/initialize)
  (yas/load-directory (expand-file-name "~/.emacs.d/elisp/yasnippet/snippets")))

(global-auto-complete-mode)

;; Mode setups
;; -------------------------------------

;; wikipedia mode
;; (require 'wikipedia-mode)



(progn
  (require 'crypt++)
  (setq crypt-encryption-type 'gpg)
                                        ; pgg mode for gpg
  (require 'pgg))

(progn
  ;; org mode
  ;;(require 'org-mode)			
  (setq org-log-done '(state))
  (setq org-todo-keywords '("TODO" "DONE")
        org-todo-interpretation 'sequence)
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
  (global-set-key "\C-cl" 'org-store-link)
  (global-set-key "\C-ca" 'org-agenda)
  (global-set-key "\C-cb" 'org-iswitchb))

(defun shell-mode-hook-function nil
  (ansi-color-for-comint-mode-on))

(add-hook 'shell-mode-hook 'shell-mode-hook-function)

(progn
  (message "setting up python mode")
  (setq python-mode-hook '(ac-yasnippet-candidate))           ;dont want the pylint hook to be added.
  ;; (ac-ropemacs-initialize)
)
;;(load (expand-file-name "~/.emacs.d/elisp/python-setup")) 
;;(load (expand-file-name "~/.emacs.d/elisp/ryan-python")) 


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote (("." . "~/.emacs.d/.backups"))))
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "English")
 '(ispell-program-name "aspell")
 '(line-number-mode t)
 '(nxml-slash-auto-complete-flag t)
 '(org-agenda-files (quote ("~/Profile folder/My Documents/Singlepoint/Singlepoint.org")))
 '(paren-sexp-mode t)
 '(pc-selection-mode t nil (pc-select))

 '(pgg-default-user-id "Raghu Rajagopalan")
 '(read-file-name-completion-ignore-case t)
 '(sql-mysql-program "mysql")
 '(transient-mark-mode t)
 '(visible-bell t)
 '(x-select-enable-clipboard t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ac-menu-face ((t (:background "white smoke" :foreground "black"))))
 '(ac-selection-face ((t (:background "white smoke" :foreground "black" :weight bold))))
 '(paren-face-match ((((class color)) (:background "gray90"))))
 '(tooltip ((((class color)) (:background "lightyellow" :foreground "black" :height 0.8)))))
