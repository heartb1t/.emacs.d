;;; config-evil.el --- Evil-mode configuration -*- lexical-bindings: t; -*-

;; Author: João Pedro de Amorim Paula <maybe_add_email@later>

;;; Commentary:

;;; Code:
;;; constants
(defconst evil-emacs-state-hooks
  '(org-log-buffer-setup-hook
    org-capture-mode-hook)
  "List of hooks to automatically start up in Evil Emacs state.")

(defconst evil-emacs-state-major-modes
  '(ibuffer-mode
    bookmark-bmenu-mode
    calculator-mode
    calc-mode
    calc-trail-mode
    makey-key-mode
    dired-mode
    diff-mode
    compilation-mode
    comint-mode
    occur-mode
    image-mode
    ivy-occur-mode
    package-menu-mode
    profiler-report-mode
    process-menu-mode
    xref--xref-buffer-mode
    treemacs-mode
    lsp-browser-mode
    flycheck-error-list-mode)
  "List of major modes that should default to Emacs state.")

(defconst evil-motion-state-major-modes
  '(pomidor-mode)
  "List of major modes that should default to Motion state.")

;;; install `evil-mode'
(require-package 'evil)

;;; variables
(setvar 'evil-search-module 'evil-search) ; what to use on / and ?
(setvar 'evil-magic 'very-magic)      ; vim's magicness (for 'evil-search)
(setvar 'evil-want-C-i-jump t)        ; whether C-i works like in vim
(setvar 'evil-want-C-u-scroll t)      ; whether C-u works like in vim
(setvar 'evil-want-fine-undo nil)     ; whether to undo like vim or emacs
(setvar 'evil-want-keybinding nil)    ; whether to load evil-keybindings.el
(setvar 'evil-want-abbrev-expand-on-insert-exit nil) ; expand abbrev with ESC
(setvar 'evil-insert-state-bindings nil) ; use emacs editing bindings in insert
;; move evil tag to beginning of modeline
(setvar 'evil-mode-line-format '(before . mode-line-front-space))
;; set the cursor for each state
(setvar 'evil-emacs-state-cursor    '("red" box))
(setvar 'evil-motion-state-cursor   '("grey" box))
(setvar 'evil-normal-state-cursor   '("white" box))
(setvar 'evil-visual-state-cursor   '("orange" box))
(setvar 'evil-insert-state-cursor   '("red" bar))
(setvar 'evil-replace-state-cursor  '("red" hbar))
(setvar 'evil-operator-state-cursor '("white" hollow))
(setvar 'evil-overriding-maps '((Buffer-menu-mode-map)
                                (color-theme-mode-map)
                                (comint-mode-map . insert)
                                (compilation-mode-map)
                                (grep-mode-map)
                                (dictionary-mode-map)
                                (ert-results-mode-map . motion)
                                (Info-mode-map . motion)
                                (speedbar-key-map)
                                (speedbar-file-key-map)
                                (speedbar-buffers-key-map)))

;; recenter after any jump in evil-mode
(add-hook 'evil-jumps-post-jump-hook #'recenter)

;;; load `evil'
(evil-mode 1)

;;; evil ex commands config
;; redefine :bd
(evil-ex-define-cmd "bd[elete]" (bind (kill-buffer (current-buffer))))

;; emacs state hooks
(add-hooks evil-emacs-state-hooks #'evil-emacs-state)

;; emacs state in major modes
(dolist (mode evil-emacs-state-major-modes)
  (evil-set-initial-state mode 'emacs))

;; motion state in major modes
(dolist (mode evil-motion-state-major-modes)
  (evil-set-initial-state mode 'motion))

;;; change the modeline tag for each state
(after 'evil-common
  (evil-put-property 'evil-state-properties 'normal   :tag "N")
  (evil-put-property 'evil-state-properties 'insert   :tag "I")
  (evil-put-property 'evil-state-properties 'visual   :tag "V")
  (evil-put-property 'evil-state-properties 'motion   :tag "M")
  (evil-put-property 'evil-state-properties 'emacs    :tag "E")
  (evil-put-property 'evil-state-properties 'replace  :tag "R")
  (evil-put-property 'evil-state-properties 'operator :tag "O"))

(defadvice evil-ex-search-forward (after dotemacs activate)
  "Recenter after a forward search."
  (recenter))

(defadvice evil-ex-search-backward (after dotemacs activate)
  "Recenter after a backward search."
  (recenter))

(defadvice evil-ex-search-next (after dotemacs activate)
  "Recenter after going to the next result of a ex search."
  (recenter))

(defadvice evil-ex-search-previous (after dotemacs activate)
  "Recenter after going to the previous result of a ex search."
  (recenter))

;; this package shows different cursors for different modes like in GUI emacs
(require-package 'evil-terminal-cursor-changer)
(evil-terminal-cursor-changer-activate)
(evil-esc-mode 1)                       ; make esc behave correctly

(after 'org
  (require-package 'evil-org)
  (add-hook 'org-mode-hook #'evil-org-mode)
  (after 'evil-org
    (evil-org-set-key-theme '(navigation
                              textobjects
                              additional
                              shift
                              calendar))))

;; match tags like <b> in html or \begin{env} in LaTeX
(require-package 'evil-matchit)
(global-evil-matchit-mode t)

;; add text objects to work with surroundings
(require-package 'evil-surround)
(global-evil-surround-mode t)
;; add new surrounds for different modes
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            "Add `' as surrounds for `elisp-mode'."
            (push '(?` . ("`" . "'")) evil-surround-pairs-alist)))
(add-hook 'org-mode-hook
          (lambda ()
            "Add `' as surrounds for `org-mode'."
            (push '(?` . ("`" . "'")) evil-surround-pairs-alist)))

;; add comment text objects
(require-package 'evil-commentary)
(evil-commentary-mode t)

(provide 'config-evil)
;;; config-evil.el ends here
