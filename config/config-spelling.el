;;; config-spelling.el --- Flyspell configuration -*- lexical-bindings: t; -*-

;; Author: João Pedro de Amorim Paula <maybe_add_email@later>

;;; Commentary:

;;; Code:
(defun spelling-start-ispell ()
  "Start `ispell' and configure its variables."
  (interactive)
  ;; only enable spelling and go through its configurations if one of the
  ;; programs is available
  (when (or (executable-find "aspell")
            (executable-find "ispell")
            (executable-find "hunspell"))
    (cond
     ;; configuration for hunspell
     ((executable-find "hunspell")
      (setvar 'ispell-program-name (executable-find "hunspell"))
      ;; default dictionary (overrided by `ispell-local-dictionary')
      (setvar 'ispell-dictionary "en_US,pt_BR")
      (after 'ispell
        ;; enable the use of multiple dictionaries with hunspell
        ;; `ispell-set-spellchecker-params' has to be called
        ;; before `ispell-hunspell-add-multi-dic' will work
        (ispell-set-spellchecker-params)
        (ispell-hunspell-add-multi-dic "en_US,pt_BR")))
     ;; configuration for aspell
     ((executable-find "aspell")
      (setvar 'ispell-program-name "aspell"))
     (t
      (setvar 'ispell-program-name "ispell")))

    (add-hook 'text-mode-hook #'turn-on-flyspell)
    (add-hook 'prog-mode-hook #'flyspell-prog-mode)))

;; (add-hook 'after-init-hook #'spelling-start-ispell)

(provide 'config-spelling)
;;; config-spelling.el ends here
