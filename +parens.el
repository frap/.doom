;;; ../Dev/emacs/doom.d/+parens.el -*- lexical-binding: t; -*-
;; Global settings
(setq! show-paren-mode 1
    ;;   doom-scratch-initial-major-mode t
       )

(after! smartparens
  (sp-pair "(" ")" :wrap "C-c (")
  (sp-pair "[" "]" :wrap "C-c [")
  (sp-pair "{" "}" :wrap "C-c {")
  (sp-pair "<" ">" :wrap "C-c \<")
  (sp-pair "'" "'" :wrap "C-c \'")
  (sp-pair "\"" "\"" :wrap "C-c \"")
  (sp-pair "`" "`" :wrap "C-c `")
  )
