;;; nb.el --- Emacs interface for nb.sh -*- lexical-binding: t; -*-

;; Author: TAKAHASHI Kazto
;; URL: https://github.com/kazto/nb-sh-el
;; Version: 0.1.0
;; Package-Requires: ((emacs "25.1"))
;; Keywords: tools, notes, bookmarks

;;; Commentary:

;; This package provides an Emacs interface for nb.sh
;; (https://nb.sh), a command line note-taking, bookmarking,
;; and archiving application.

;;; Code:

(require 'ansi-color)

(defgroup nb nil
  "Emacs interface for nb.sh."
  :group 'tools
  :prefix "nb-")

(defcustom nb-executable "nb"
  "Path to the nb executable."
  :type 'string
  :group 'nb)

(defcustom nb-output-buffer "*nb*"
  "Name of the buffer for nb output."
  :type 'string
  :group 'nb)

;;; Output buffer mode

(setq nb-output-mode-map (make-keymap))
(suppress-keymap nb-output-mode-map)
(define-key nb-output-mode-map "q" #'nb-output-quit)
(define-key nb-output-mode-map (kbd "<return>") #'nb-output-open-at-point)
(define-key nb-output-mode-map (kbd "RET") #'nb-output-open-at-point)
(define-key nb-output-mode-map "n" #'next-line)
(define-key nb-output-mode-map "p" #'previous-line)

(defun nb-output-mode ()
  "Major mode for nb output buffer."
  (interactive)
  (kill-all-local-variables)
  (use-local-map nb-output-mode-map)
  (setq major-mode 'nb-output-mode)
  (setq mode-name "nb-output")
  (setq buffer-read-only t)
  (run-mode-hooks 'nb-output-mode-hook))

(defun nb-output-quit ()
  "Quit nb output buffer and close window."
  (interactive)
  (quit-window t))

(defun nb--get-id-at-line ()
  "Get nb item ID from current line.
Returns the number inside brackets like [8], or nil if not found."
  (save-excursion
    (beginning-of-line)
    (when (re-search-forward "\\[\\([0-9]+\\)\\]" (line-end-position) t)
      (match-string 1))))

(defun nb--get-path (id)
  "Get file path for nb item ID."
  (let ((path (string-trim
               (shell-command-to-string
                (format "%s show --path %s" nb-executable id)))))
    (when (and path (file-exists-p path))
      path)))

(defun nb-output-open-at-point ()
  "Open nb item at point in a new buffer."
  (interactive)
  (let ((id (nb--get-id-at-line)))
    (if id
        (let ((path (nb--get-path id)))
          (if path
              (progn
                (quit-window)
                (find-file path))
            (message "Cannot find file for item %s" id)))
      (message "No item ID found on this line"))))

;;; Core functions

(defun nb--run (args &optional callback)
  "Run nb with ARGS and display output.
If CALLBACK is provided, call it with the output string."
  (let ((buf (get-buffer-create nb-output-buffer))
        (process-environment (append '("CLICOLOR_FORCE=1" "TERM=xterm-256color")
                                     process-environment)))
    (with-current-buffer buf
      (read-only-mode -1)
      (erase-buffer))
    (if callback
        (set-process-sentinel
         (start-process "nb" buf nb-executable args)
         (lambda (proc _event)
           (when (eq (process-status proc) 'exit)
             (with-current-buffer buf
               (ansi-color-apply-on-region (point-min) (point-max))
               (nb--strip-escape-sequences))
             (funcall callback (with-current-buffer buf (buffer-string))))))
      (call-process nb-executable nil buf nil args)
      (with-current-buffer buf
        (ansi-color-apply-on-region (point-min) (point-max))
        (nb--strip-escape-sequences)
        (goto-char (point-min))
        (nb-output-mode))
      (pop-to-buffer buf))))

(defun nb--strip-escape-sequences ()
  "Remove remaining escape sequences from current buffer."
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\e([ABB0-2]" nil t)
      (replace-match ""))))

(defun nb--run-interactive (subcommand &optional prompt)
  "Run nb SUBCOMMAND with user input from PROMPT."
  (let ((args (read-string (or prompt (format "nb %s: " subcommand)))))
    (if (string-empty-p args)
        (nb--run subcommand)
      (nb--run (concat subcommand " " args)))))

;;; Interactive commands

;;;###autoload
(defun nb ()
  "Run nb (list notes and notebooks)."
  (interactive)
  (nb--run ""))

;;;###autoload
(defun nb-add ()
  "Run nb add."
  (interactive)
  (nb--run-interactive "add" "nb add (options/content): "))

;;;###autoload
(defun nb-archive ()
  "Run nb archive."
  (interactive)
  (nb--run-interactive "archive" "nb archive (notebook): "))

;;;###autoload
(defun nb-bookmark ()
  "Run nb bookmark."
  (interactive)
  (nb--run-interactive "bookmark" "nb bookmark (url/options): "))

;;;###autoload
(defun nb-copy ()
  "Run nb copy."
  (interactive)
  (nb--run-interactive "copy" "nb copy (source dest): "))

;;;###autoload
(defun nb-delete ()
  "Run nb delete."
  (interactive)
  (nb--run-interactive "delete" "nb delete (id/filename): "))

;;;###autoload
(defun nb-edit (id)
  "Edit nb item ID in Emacs buffer."
  (interactive "snb edit (id/filename): ")
  (let ((path (nb--get-path id)))
    (if path
        (find-file path)
      (message "Cannot find file for item %s" id))))

;;;###autoload
(defun nb-export ()
  "Run nb export."
  (interactive)
  (nb--run-interactive "export" "nb export (id path): "))

;;;###autoload
(defun nb-folders ()
  "Run nb folders."
  (interactive)
  (nb--run-interactive "folders" "nb folders (add/delete name): "))

;;;###autoload
(defun nb-git ()
  "Run nb git."
  (interactive)
  (nb--run-interactive "git" "nb git (command): "))

;;;###autoload
(defun nb-help ()
  "Run nb help."
  (interactive)
  (nb--run-interactive "help" "nb help (subcommand): "))

;;;###autoload
(defun nb-import ()
  "Run nb import."
  (interactive)
  (nb--run-interactive "import" "nb import (path/url): "))

;;;###autoload
(defun nb-list ()
  "Run nb list."
  (interactive)
  (nb--run-interactive "list" "nb list (options): "))

;;;###autoload
(defun nb-move ()
  "Run nb move."
  (interactive)
  (nb--run-interactive "move" "nb move (source dest): "))

;;;###autoload
(defun nb-notebooks ()
  "Run nb notebooks."
  (interactive)
  (nb--run-interactive "notebooks" "nb notebooks (options): "))

;;;###autoload
(defun nb-open ()
  "Run nb open."
  (interactive)
  (nb--run-interactive "open" "nb open (id/filename): "))

;;;###autoload
(defun nb-peek ()
  "Run nb peek."
  (interactive)
  (nb--run-interactive "peek" "nb peek (id/filename): "))

;;;###autoload
(defun nb-search ()
  "Run nb search."
  (interactive)
  (nb--run-interactive "search" "nb search (query): "))

;;;###autoload
(defun nb-show ()
  "Run nb show."
  (interactive)
  (nb--run-interactive "show" "nb show (id/filename): "))

;;;###autoload
(defun nb-sync ()
  "Run nb sync."
  (interactive)
  (nb--run "sync"))

;;;###autoload
(defun nb-todo ()
  "Run nb todo."
  (interactive)
  (nb--run-interactive "todo" "nb todo (add/do/undo options): "))

;;;###autoload
(defun nb-use ()
  "Run nb use."
  (interactive)
  (nb--run-interactive "use" "nb use (notebook): "))

;;; Keymap

(defvar nb-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") #'nb)
    (define-key map (kbd "a") #'nb-add)
    (define-key map (kbd "b") #'nb-bookmark)
    (define-key map (kbd "c") #'nb-copy)
    (define-key map (kbd "d") #'nb-delete)
    (define-key map (kbd "e") #'nb-edit)
    (define-key map (kbd "f") #'nb-folders)
    (define-key map (kbd "g") #'nb-git)
    (define-key map (kbd "h") #'nb-help)
    (define-key map (kbd "i") #'nb-import)
    (define-key map (kbd "l") #'nb-list)
    (define-key map (kbd "m") #'nb-move)
    (define-key map (kbd "n") #'nb-notebooks)
    (define-key map (kbd "o") #'nb-open)
    (define-key map (kbd "p") #'nb-peek)
    (define-key map (kbd "r") #'nb-archive)
    (define-key map (kbd "s") #'nb-search)
    (define-key map (kbd "S") #'nb-sync)
    (define-key map (kbd "t") #'nb-todo)
    (define-key map (kbd "u") #'nb-use)
    (define-key map (kbd "w") #'nb-show)
    (define-key map (kbd "x") #'nb-export)
    map)
  "Keymap for nb commands.")

;;;###autoload
(defvar nb-keymap-prefix (kbd "C-c n")
  "Prefix key for nb commands.")

;;;###autoload
(define-minor-mode nb-mode
  "Minor mode for nb.sh integration."
  :lighter " nb"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map nb-keymap-prefix nb-command-map)
            map)
  :global t)

(provide 'nb)
;;; nb.el ends here
