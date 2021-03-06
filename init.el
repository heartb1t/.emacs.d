;;; init.el --- Main file  -*- lexical-binding: t; -*-

;; Author: João Pedro de Amorim Paula <maybe_add_email@later>

;;; Commentary:
;;
;; Most (if not all,) of this configuration was inspired/copied from Bailey
;; Ling's Emacs configuration, found on https://github.com/bling/dotemacs
;;
;; TODO: make this a literate config
;; TODO: [related to above] move bindings to the packages configs
;; TODO: check if without the provide's it makes it faster
;; TODO: add a comment to all non-local variables
;;; Code:
;; some common lisp functions
(require 'cl-lib)

;;; log Emacs startup time in *Messages*. this adds about 0.2 secs to init time
;; (lexical-let ((emacs-start-time (current-time)))
;;   (add-hook 'emacs-startup-hook
;;             (lambda ()
;;               (let ((elapsed (float-time (time-subtract (current-time)
;;                                                         emacs-start-time))))
;;                 (message "[Emacs initialized in %.3fs]" elapsed)))))

;;; let
;; we wrap our whole initializatino inside this let because we set some
;; variables to make it snappier and faster to start Emacs. also, we don't need
;; a variable to store the location of our config outside of the initialization,
;; that's why it is also inside the let. and i also create a constant to store
;; the original value of the gc-cons-threshold while initing Emacs.
;; TODO: maybe wrap setq's or setvar's for the original value of these variables
;; in a (add-hook 'emacs-startup-hook) and see how much init time we gain
(setq gc-cons-threshold-before-init gc-cons-threshold)
(let ((gc-cons-threshold most-positive-fixnum) ; the value for the gc is too low
      (gc-cons-percentage 0.6)
      (file-name-handler-alist nil)
      (bindings-directory (expand-file-name "bindings/" user-emacs-directory))
      (config-directory (expand-file-name "config/" user-emacs-directory)))

  ;;; packages
  (setq package-archives
        '(("melpa" . "https://melpa.org/packages/")
          ("melpa-stable" . "https://stable.melpa.org/packages/")
          ("gnu" . "https://elpa.gnu.org/packages/")
          ("org" . "https://orgmode.org/elpa/")))

  ;; set the priorities when installing packages
  (setq package-archive-priorities
        '(("melpa" . 4)
          ("melpa-stable" . 3)
          ("gnu" . 2)
          ("org" . 1)))

  ;; activate installed packages when Emacs starts
  ;; we set this to nil to stop Emacs from starting it twice
  (setq package-enable-at-startup nil)
  ;; start the package system
  (package-initialize)

  ;;; load some core stuff
  (load (expand-file-name "core.el" user-emacs-directory))

  ;;; set and load custom file
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  ;; (when (file-exists-p custom-file)
  ;;   (load custom-file))

  ;;; load all of our configuration files
  ;; the bindings configuration needs to get loaded before every thing else,
  ;; since it has the definitions for the macros of defining keys and what not,
  ;; that's why we use the reverse on the bindings.
  (cl-loop for file in (append (reverse (directory-files-recursively
                                         config-directory "\\.el\\'"))
                               (reverse (directory-files-recursively
                                         bindings-directory "\\.el$")))
           do (condition-case ex
                  (load (file-name-sans-extension file))
                ('error
                 (with-current-buffer "*scratch*"
                   (insert (format "[INIT ERROR]\n%s\n%s\n\n" file ex)))))))

(provide 'init)
;;; init.el ends here
