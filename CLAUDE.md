# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Emacs Lisp package that provides an Emacs interface for [nb.sh](https://nb.sh), a command line note-taking, bookmarking, and archiving application. The package allows users to invoke nb commands from within Emacs and open/edit nb items directly in Emacs buffers.

## File Structure

- `nb.el`: Single-file package containing all functionality (~310 lines)
- `README.md`: Japanese documentation with keybinding reference and nb.sh usage guide

## Architecture

### Core Components

1. **Command Execution (`nb--run`)**
   - Executes nb CLI commands via `call-process` or `start-process`
   - Sets `CLICOLOR_FORCE=1` and `TERM=xterm-256color` for color output
   - Handles ANSI color codes with `ansi-color-apply-on-region`
   - Displays output in dedicated `*nb*` buffer

2. **Output Buffer Mode (`nb-output-mode`)**
   - Custom major mode for displaying nb command output
   - Keybindings: `q` (quit), `RET` (open item at point), `n`/`p` (navigation)
   - Parses item IDs from output using regex `\\[\\([0-9]+\\)\\]`
   - Enables direct file access via `nb--get-path`

3. **Interactive Commands**
   - Each nb.sh subcommand has a corresponding Emacs command (e.g., `nb-add`, `nb-search`)
   - `nb-edit` special: opens nb items in Emacs instead of external editor
   - Global minor mode `nb-mode` with `C-c n` prefix for all commands

### Key Functions

- `nb--run`: Execute nb with arguments, display/process output
- `nb--run-interactive`: Prompt user for args then run command
- `nb--get-id-at-line`: Extract item ID from current line (e.g., "[8]")
- `nb--get-path`: Get file path for nb item using `nb show --path`
- `nb-output-open-at-point`: Open nb item at cursor in Emacs buffer

## Development Workflow

### Testing

This is an Emacs package with no automated tests. Test manually:

```bash
# Load package in Emacs
emacs -Q -l nb.el

# Or evaluate in Emacs
M-x eval-buffer
```

Then test commands interactively:
- `M-x nb-mode` to enable the minor mode
- `C-c n RET` to list notebooks
- `C-c n a` to add a note
- Navigate to output buffer and press RET on items to open them

### Package Requirements

- Emacs 25.1 or later
- nb.sh must be installed and in PATH (`nb-executable` customization available)
- Depends on built-in `ansi-color` library

### Installation Methods

Users can install by:
1. Loading directly: `(load-file "path/to/nb.el")` then `(nb-mode 1)`
2. Adding to `load-path` and using `(require 'nb)`
3. Via package managers (MELPA, etc.) when published

## Important Notes

- The package shells out to the `nb` CLI - it does not reimplement nb functionality
- ANSI escape sequences are processed to display colored output correctly
- Item IDs are parsed from nb output to enable `RET` to open files in Emacs
- `nb-edit` bypasses nb's external editor by directly opening the file path in Emacs
