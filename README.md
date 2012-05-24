aml-mode
========

This is an AML mode for Emacs.

# Installation #
First, place the file 'aml-mode.el' somewhere on your load-path.

Second, add the following to your .emacs:

    (require 'aml-mode)
    (add-to-list 'auto-mode-alist '("\\.aml$" . aml-mode))


# Features #
AML mode is quite simple right now.  It currently has the following features:

## Syntax coloring ##

AML mode correctly understands AML's comment syntax, including nested
multi-line comments.

## Indentation ##

AML mode has indentation code heavily based on the simple indentation code in
haskell-mode. In other words, it indents the first line of the body of a
definition, and it can line up indented sub-elements with those above them.
