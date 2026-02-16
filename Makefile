.PHONY: test clean

EMACS ?= emacs
BATCH = $(EMACS) -batch -Q -L . -L test

test:
	@echo "Running tests..."
	$(BATCH) -l test/nb-test.el -f ert-run-tests-batch-and-exit

test-interactive:
	@echo "Running tests in interactive mode..."
	$(EMACS) -Q -L . -L test -l test/nb-test.el -f ert

compile:
	@echo "Byte-compiling nb.el..."
	$(BATCH) -f batch-byte-compile nb.el

clean:
	@echo "Cleaning compiled files..."
	rm -f *.elc test/*.elc

help:
	@echo "Available targets:"
	@echo "  test              - Run all tests in batch mode"
	@echo "  test-interactive  - Run tests in interactive Emacs session"
	@echo "  compile           - Byte-compile nb.el"
	@echo "  clean             - Remove compiled files"
	@echo ""
	@echo "Set EMACS variable to use specific Emacs binary:"
	@echo "  make test EMACS=/path/to/emacs"
