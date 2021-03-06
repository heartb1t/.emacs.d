;;; bindings-lsp.el --- LSP bindings -*- lexical-bindings: t; -*-

;; Author: João Pedro de Amorim Paula <maybe_add_email@later>

;;; Commentary:

;;; Code:
(after 'lsp-mode
  (bindings-define-keys lsp-mode-map
    ([remap xref-find-definitions] #'lsp-find-definition)
    ([remap xref-find-references] #'lsp-find-references))

  (after 'lsp-ivy
    (bindings-define-keys lsp-mode-map
      ([remap xref-find-apropos] #'lsp-ivy-workspace-symbol)
      ((kbd "C->") #'lsp-ivy-global-workspace-symbol)))

  ;; for some reason this needs to be defined here and can't be define in
  ;; bindings-hydra.el like i intended
  (after [hydra lsp-ui]
    (defhydra hydras/lsp/workspace (:exit t)
      ("a" lsp-workspace-folders-add "add folder" :column "workspace")
      ("r" lsp-workspace-folders-remove "remove folder")
      ("s" lsp-workspace-folders-switch "switch folder"))

    (defhydra hydras/lsp/config (:quit-key "q")
      ("d e" (lsp-ui-doc-enable (not lsp-ui-doc-mode))
       "enable doc" :toggle lsp-ui-doc-mode :column "doc")

      ("d s" (setvar 'lsp-ui-doc-include-signature
                     (not lsp-ui-doc-include-signature))
       "include signature" :toggle lsp-ui-doc-include-signature)

      ("d t" (setvar 'lsp-ui-doc-position 'top)
       "top" :toggle (eq lsp-ui-doc-position 'top))

      ("d b" (setvar 'lsp-ui-doc-position 'bottom)
       "bottom" :toggle (eq lsp-ui-doc-position 'bottom))

      ("d p" (setvar 'lsp-ui-doc-position 'at-point)
       "at point" :toggle (eq lsp-ui-doc-position 'at-point))

      ("d f" (setvar 'lsp-ui-doc-alignment 'frame)
       "align frame" :toggle (eq lsp-ui-doc-alignment 'frame))

      ("d w" (setvar 'lsp-ui-doc-alignment 'window)
       "align window" :toggle (eq lsp-ui-doc-alignment 'window))

      ("s e" (lsp-ui-sideline-enable (not lsp-ui-sideline-mode))
       "enable signature" :toggle lsp-ui-sideline-mode :column "signature")

      ("s h" (setvar 'lsp-ui-sideline-show-hover
                     (not lsp-ui-sideline-show-hover))
       "show on hover" :toggle lsp-ui-sideline-show-hover)

      ("s d" (setvar 'lsp-ui-sideline-show-diagnostics
                     (not lsp-ui-sideline-show-diagnostics))
       "show diagnostics" :toggle lsp-ui-sideline-show-diagnostics)

      ("s s" (setvar 'lsp-ui-sideline-show-symbol
                     (not lsp-ui-sideline-show-symbol))
       "show symbol" :toggle lsp-ui-sideline-show-symbol)

      ("s c" (setvar 'lsp-ui-sideline-show-code-actions
                     (not lsp-ui-sideline-show-code-actions))
       "show code actions" :toggle lsp-ui-sideline-show-code-actions)

      ("s i" (setvar 'lsp-ui-sideline-ignore-duplicate
                     (not lsp-ui-sideline-ignore-duplicate))
       "ignore duplicate" :toggle lsp-ui-sideline-ignore-duplicate))

    (defhydra hydras/lsp (:exit t)
      ("d" lsp-ui-peek-find-definitions "peek definition" :column "definitions")
      ("D" xref-find-definitions "xref definitions")
      ("I" lsp-ivy-workspace-symbol "ivy symbols")

      ("r" lsp-ui-peek-find-references "peek references" :column "references")
      ("R" xref-find-references "xref references")
      ("u" lsp-treemacs-references "usages")

      ("n" lsp-rename "rename" :column "refactor")
      ("=" lsp-format-buffer "format")
      ("a" lsp-ui-sideline-apply-code-actions "apply code action")

      ("s" lsp-treemacs-symbols "symbols" :column "info")

      ("e" lsp-treemacs-errors-list "list" :column "errors")

      ("S" lsp-restart-workspace "restart workspace" :column "workspace")
      ("w" hydras/lsp/workspace/body "folders")
      ("i" lsp-describe-session "session info")

      ("c" hydras/lsp/config/body "config" :column "config")))

  (after 'lsp-ui
    (bindings-define-keys lsp-ui-mode-map
      ([remap imenu] #'lsp-ui-imenu)
      ([remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
      ([remap xref-find-references] #'lsp-ui-peek-find-references)
      ((kbd "C-c l <tab>") #'lsp-ui-doc-focus-frame)
      ((kbd "C-c l TAB") #'lsp-ui-doc-focus-frame)))

  (after 'evil
    (bindings-define-keys bindings-space-map
      ("l" lsp-command-map "lsp")
      ((kbd "l TAB") #'lsp-ui-doc-focus-frame)
      ((kbd "l <tab>") #'lsp-ui-doc-focus-frame))

    (bindings-define-key lsp-mode-map
      [remap evil-lookup] #'lsp-describe-thing-at-point)

    (evil-define-key '(normal visual) lsp-mode-map
      "ga" #'lsp-execute-code-action
      "gr" #'lsp-rename
      "g=" #'lsp-format-buffer
      "g+" #'lsp-format-region)

    (after 'lsp-ivy
      (evil-define-key '(normal visual) lsp-mode-map
        "g." #'xref-find-apropos
        "g>" #'lsp-ivy-global-workspace-symbol))

    (after 'lsp-ui
      (evil-define-key '(normal visual) lsp-mode-map
        (kbd "RET") #'hydras/lsp/body
        (kbd "<ret>") #'hydras/lsp/body
        "gD" #'lsp-ui-doc-glance
        "g?" #'lsp-ui-doc-glance)

      (evil-define-key '(normal visual motion) lsp-ui-doc-frame-mode-map
        "q" #'lsp-ui-doc-unfocus-frame)
      ;; (define-key lsp-ui-doc-frame-mode-map "q" nil)

      (evil-define-key '(normal visual) lsp-ui-imenu-mode-map
        "q" #'lsp-ui-imenu--kill)))

  ;;; `dap-mode'
  (after 'dap-mode
    (bindings-define-keys lsp-mode-map
      ((kbd "<f5>") #'dap-debug)
      ((kbd "M-<f5>") #'dap-hydra))))

(provide 'config-bindings-lsp)
;;; bindings-lsp.el ends here
