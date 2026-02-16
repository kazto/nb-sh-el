;;; nb-test.el --- Tests for nb.el -*- lexical-binding: t; -*-

;; Author: TAKAHASHI Kazto
;; URL: https://github.com/kazto/nb-sh-el

;;; Commentary:

;; ERT tests for nb.el

;;; Code:

(require 'ert)
(require 'nb)

;;; Tests for ID extraction

(ert-deftest nb-test-get-id-at-line-basic ()
  "Test extracting ID from a typical nb list output line."
  (with-temp-buffer
    (insert "[8] example.md · \"Example Note\"")
    (goto-char (point-min))
    (should (string= (nb--get-id-at-line) "8"))))

(ert-deftest nb-test-get-id-at-line-multiple-digits ()
  "Test extracting multi-digit ID."
  (with-temp-buffer
    (insert "[123] long-note.md · \"Long Note\"")
    (goto-char (point-min))
    (should (string= (nb--get-id-at-line) "123"))))

(ert-deftest nb-test-get-id-at-line-with-prefix ()
  "Test extracting ID when there's text before the bracket."
  (with-temp-buffer
    (insert "  [42] note.md")
    (goto-char (point-min))
    (should (string= (nb--get-id-at-line) "42"))))

(ert-deftest nb-test-get-id-at-line-no-id ()
  "Test that nil is returned when no ID is found."
  (with-temp-buffer
    (insert "This line has no ID")
    (goto-char (point-min))
    (should (null (nb--get-id-at-line)))))

(ert-deftest nb-test-get-id-at-line-first-match ()
  "Test that only the first ID is returned when multiple brackets exist."
  (with-temp-buffer
    (insert "[5] note.md [not-an-id]")
    (goto-char (point-min))
    (should (string= (nb--get-id-at-line) "5"))))

;;; Tests for escape sequence stripping

(ert-deftest nb-test-strip-escape-sequences-basic ()
  "Test removing escape sequences from buffer."
  (with-temp-buffer
    (insert "text\e(A more text")
    (nb--strip-escape-sequences)
    (should (string= (buffer-string) "text more text"))))

(ert-deftest nb-test-strip-escape-sequences-multiple ()
  "Test removing multiple escape sequences."
  (with-temp-buffer
    (insert "foo\e(A bar\e(B baz\e(0")
    (nb--strip-escape-sequences)
    (should (string= (buffer-string) "foo bar baz"))))

(ert-deftest nb-test-strip-escape-sequences-no-sequences ()
  "Test that plain text is unchanged."
  (with-temp-buffer
    (insert "plain text without sequences")
    (nb--strip-escape-sequences)
    (should (string= (buffer-string) "plain text without sequences"))))

;;; Tests for output buffer mode

(ert-deftest nb-test-output-mode-keymap ()
  "Test that nb-output-mode keymap is set up correctly."
  (should (keymapp nb-output-mode-map))
  (should (eq (lookup-key nb-output-mode-map "q") #'nb-output-quit))
  (should (eq (lookup-key nb-output-mode-map (kbd "RET")) #'nb-output-open-at-point))
  (should (eq (lookup-key nb-output-mode-map "n") #'next-line))
  (should (eq (lookup-key nb-output-mode-map "p") #'previous-line)))

(ert-deftest nb-test-output-mode-buffer-read-only ()
  "Test that nb-output-mode sets buffer to read-only."
  (with-temp-buffer
    (nb-output-mode)
    (should buffer-read-only)))

(ert-deftest nb-test-output-mode-major-mode ()
  "Test that nb-output-mode sets the correct major mode."
  (with-temp-buffer
    (nb-output-mode)
    (should (eq major-mode 'nb-output-mode))
    (should (string= mode-name "nb-output"))))

;;; Tests for command map

(ert-deftest nb-test-command-map-keys ()
  "Test that nb-command-map has expected key bindings."
  (should (keymapp nb-command-map))
  (should (eq (lookup-key nb-command-map (kbd "RET")) #'nb))
  (should (eq (lookup-key nb-command-map "a") #'nb-add))
  (should (eq (lookup-key nb-command-map "b") #'nb-bookmark))
  (should (eq (lookup-key nb-command-map "c") #'nb-copy))
  (should (eq (lookup-key nb-command-map "d") #'nb-delete))
  (should (eq (lookup-key nb-command-map "e") #'nb-edit))
  (should (eq (lookup-key nb-command-map "f") #'nb-folders))
  (should (eq (lookup-key nb-command-map "g") #'nb-git))
  (should (eq (lookup-key nb-command-map "h") #'nb-help))
  (should (eq (lookup-key nb-command-map "i") #'nb-import))
  (should (eq (lookup-key nb-command-map "l") #'nb-list))
  (should (eq (lookup-key nb-command-map "m") #'nb-move))
  (should (eq (lookup-key nb-command-map "n") #'nb-notebooks))
  (should (eq (lookup-key nb-command-map "o") #'nb-open))
  (should (eq (lookup-key nb-command-map "p") #'nb-peek))
  (should (eq (lookup-key nb-command-map "r") #'nb-archive))
  (should (eq (lookup-key nb-command-map "s") #'nb-search))
  (should (eq (lookup-key nb-command-map "S") #'nb-sync))
  (should (eq (lookup-key nb-command-map "t") #'nb-todo))
  (should (eq (lookup-key nb-command-map "u") #'nb-use))
  (should (eq (lookup-key nb-command-map "w") #'nb-show))
  (should (eq (lookup-key nb-command-map "x") #'nb-export)))

;;; Tests for customization variables

(ert-deftest nb-test-custom-executable-default ()
  "Test that nb-executable has correct default value."
  (should (string= nb-executable "nb")))

(ert-deftest nb-test-custom-output-buffer-default ()
  "Test that nb-output-buffer has correct default value."
  (should (string= nb-output-buffer "*nb*")))

;;; Tests for interactive commands

(ert-deftest nb-test-commands-are-interactive ()
  "Test that all main nb commands are interactive."
  (should (commandp 'nb))
  (should (commandp 'nb-add))
  (should (commandp 'nb-archive))
  (should (commandp 'nb-bookmark))
  (should (commandp 'nb-copy))
  (should (commandp 'nb-delete))
  (should (commandp 'nb-edit))
  (should (commandp 'nb-export))
  (should (commandp 'nb-folders))
  (should (commandp 'nb-git))
  (should (commandp 'nb-help))
  (should (commandp 'nb-import))
  (should (commandp 'nb-list))
  (should (commandp 'nb-move))
  (should (commandp 'nb-notebooks))
  (should (commandp 'nb-open))
  (should (commandp 'nb-peek))
  (should (commandp 'nb-search))
  (should (commandp 'nb-show))
  (should (commandp 'nb-sync))
  (should (commandp 'nb-todo))
  (should (commandp 'nb-use)))

;;; Tests for minor mode

(ert-deftest nb-test-mode-lighter ()
  "Test that nb-mode has correct lighter."
  (with-temp-buffer
    (nb-mode 1)
    ;; Check that the mode is enabled
    (should nb-mode)))

(ert-deftest nb-test-mode-keymap-prefix ()
  "Test that nb-mode prefix key is set correctly."
  (should (equal nb-keymap-prefix (kbd "C-c n"))))

;;; Integration tests (require nb command to be installed)

(ert-deftest nb-test-get-path-mock ()
  "Test nb--get-path with mocked shell command."
  (cl-letf (((symbol-function 'shell-command-to-string)
             (lambda (_cmd) "/path/to/note.md\n"))
            ((symbol-function 'file-exists-p)
             (lambda (_path) t)))
    (should (string= (nb--get-path "1") "/path/to/note.md"))))

(ert-deftest nb-test-get-path-nonexistent ()
  "Test nb--get-path returns nil for nonexistent file."
  (cl-letf (((symbol-function 'shell-command-to-string)
             (lambda (_cmd) "/nonexistent/note.md\n"))
            ((symbol-function 'file-exists-p)
             (lambda (_path) nil)))
    (should (null (nb--get-path "999")))))

(provide 'nb-test)
;;; nb-test.el ends here
