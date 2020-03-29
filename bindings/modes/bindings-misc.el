;;; bindings-misc.el --- Miscellaneous bindings (see config/config-misc.el)

;; Author: João Pedro de Amorim Paula <maybe_add_email@later>

;;; Commentary:
;;
;; This was mostly done by Bailey Ling. You can find all of Bailey Lings' Emacs
;; configuration in https://github.com/bling/dotemacs.
;;
;;; Code:
;;; treemacs
(after "treemacs-autoloads"
  (bindings-define-keys ctl-x-map
    ((kbd "t t") #'treemacs)
    ((kbd "t 1") #'treemacs-delete-other-windows)
    ((kbd "t B") #'treemacs-bookmark)
    ((kbd "t C-t") #'treemacs-find-file)
    ((kbd "t M-t") #'treemacs-find-tag))

  (bindings-define-keys bindings-space-map
    ((kbd "T") #'treemacs))

  (after 'treemacs
    (bindings-define-key treemacs-mode-map
      [mouse-1] #'treemacs-single-click-expand-action)

    (after 'evil
      (bindings-define-key treemacs-mode-map
        (kbd "C-w") evil-window-map))))
;;; pdf
(after 'doc-view
  (bindings-define-keys doc-view-mode-map
    ("j" (bind (doc-view-next-line-or-next-page 5)))
    ("k" (bind (doc-view-previous-line-or-previous-page 5)))
    ("J" #'doc-view-next-page)
    ("K" #'doc-view-previous-page)))

(after 'pdf-tools
  (bindings-define-keys pdf-view-mode-map
    ("j" (bind (pdf-view-next-line-or-next-page 5)))
    ("k" (bind (pdf-view-previous-line-or-previous-page 5)))
    ("J" #'pdf-view-next-page)
    ("K" #'pdf-view-previous-page)))

;;; helpful
(after "helpful-autoloads"
  (bindings-define-keys (current-global-map)
    ((kbd "C-h f") #'helpful-callable "describe function")
    ((kbd "C-h v") #'helpful-variable "describe variable")
    ((kbd "C-h F") #'helpful-command "describe command")
    ((kbd "C-h k") #'helpful-key "describe key")
    ((kbd "C-c C-d") #'helpful-at-point "help for symbol at point")))

(after 'helpful
  (bindings-define-keys helpful-mode-map
    ("q" #'quit-window)
    ((kbd "<tab>") #'forward-button)
    ((kbd "TAB") #'forward-button)))

;;; undo-tree
(bindings-define-prefix-keys bindings-space-map "SPC"
  ("U" #'undo-tree-visualize))

(provide 'bindings-misc)
;;; bindings-misc.el ends here