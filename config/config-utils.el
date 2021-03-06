;;; config-utils.el --- Some useful functions -*- lexical-bindings: t; -*-

;; Author: João Pedro de A. Paual <maybe_email_here@later>

;;; Commentary:

;;; Code:
(defun utils-reload-init-file ()
  "Reload Emacs configurations."
  (interactive)
  (load-file user-init-file))

(defun utils-window-killer ()
  "Close the window, and delete the buffer if it's the last window open."
  (interactive)
  (if (> buffer-display-count 1)
      (if (= (length (window-list)) 1)
          (kill-buffer)
        (delete-window))
    (kill-buffer-and-window)))

(defun utils-minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

;; NOTE: this is from https://with-emacs.com/posts/tips/quit-current-context/ i
;; just changed the name of the function to match my pattern
(defun utils-keyboard-quit-context ()
  "Quit current context.
This function is a combination of `keyboard-quit' and
`keyboard-escape-quit' with some parts omitted and some custom
behavior added."
  (interactive)
  (cond ((region-active-p)
         ;; avoid adding the region to the window selection.
         (setq saved-region-selection nil)
         (let (select-active-regions)
           (deactivate-mark)))
        ((eq last-command 'mode-exited) nil)
        (current-prefix-arg
         nil)
        (defining-kbd-macro
          (message
           (substitute-command-keys
            "Quit is ignored during macro defintion, use \\[kmacro-end-macro] if you want to stop macro definition"))
          (cancel-kbd-macro-events))
        ((active-minibuffer-window)
         (when (get-buffer-window "*Completions*")
           ;; hide completions first so point stays in active window when
           ;; outside the minibuffer
           (minibuffer-hide-completions))
         (abort-recursive-edit))
        (t
         ;; if we got this far just use the default so we don't miss
         ;; any upstream changes
         (keyboard-quit))))

(defun utils-set-transparency (alpha)
  "Set the transparency of the current frame to ALPHA."
  (interactive "nAlpha: ")
  (set-frame-parameter nil 'alpha alpha))

(defun utils-copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(defun utils-eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (let ((value (eval (elisp--preceding-sexp))))
    ;; if in evil, save the state
    (if (bound-and-true-p evil-mode)
        (evil-save-state
          (evil-emacs-state)
          (forward-char)
          (backward-kill-sexp)
          (insert (format "%s" value)))
      (backward-kill-sexp)
      (insert (format "%s" value)))))

(defun utils-rename-buffer-file (buffer)
  "Rename file associated to BUFFER."
  (interactive "bBuffer: ")
  (let ((filename (if (bufferp buffer)
                      (buffer-file-name buffer)
                    (buffer-file-name (get-file-buffer buffer)))))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name 1)
          (save-excursion
            (switch-to-buffer buffer)
            (rename-buffer new-name)
            (set-visited-file-name new-name t t)
            (set-buffer-modified-p nil))))))))

(defun utils-rename-current-buffer-file ()
  "Rename current buffer and file it is visiting."
  (interactive)
  (utils-rename-buffer-file (current-buffer)))

;; TODO: delete-buffer-file
(defun utils-delete-buffer-file (buffer)
  "Delete file associated to BUFFER."
  (interactive "bBuffer: ")
  (let ((filename (buffer-file-name buffer)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (when (y-or-n-p
               (format "Are you sure you want to delete %s?" filename))
          (delete-file filename)
          (message "Deleted file %s." filename)
          (kill-buffer))))))

(defun utils-delete-current-buffer-file ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (utils-delete-buffer-file (current-buffer)))

(defun utils-goto-scratch-buffer ()
  "Create a new scratch buffer. If *scratch* already exists, switch to it."
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*")))

(defun utils-goto-notepad ()
  "Go to $NOTEPAD and if it is not set, create it."
  (interactive)
  ;; check if `notepad-file' was created and if not, create a notepad file
  (when (string= "" notepad-file)
    (setvar 'notepad-file
            (make-temp-file
             (concat "emacs-notepad-" user-login-name ".") nil
             "# file to take quick note"))
    (add-to-list 'auto-mode-alist `(,notepad-file . org-mode)))
  (find-file notepad-file))

(defun utils-insert-last-kbd-macro ()
  "Insert the last defined keyboard macro."
  (interactive)
  (name-last-kbd-macro 'my-last-macro)
  (insert-kbd-macro 'my-last-macro))

(defun utils-set-buffer-to-unix-format ()
  "Convert the current buffer to UNIX file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-unix nil))

(defun utils-set-buffer-to-dos-format ()
  "Convert the current buffer to DOS file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-dos nil))

(defun utils-find-file-as-root (file)
  "Edit FILE as root."
  (interactive "f")
  (find-file-other-window
   (if (string-equal system-type "berkley-unix")
       (concat "/doas::" file)
     (concat "/doas::" file))))

(defun utils-restart-emacs ()
  "Restart Emacs configuration."
  (interactive)
  (load (expand-file-name "init.el" user-emacs-directory)))

(provide 'config-utils)
;;; config-utils.el ends here
