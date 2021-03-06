;;; +bindings.el -*- lexical-binding: t; -*-

(if IS-MAC (setq
             mac-right-command-modifier 'super
             mac-command-modifier 'super
             mac-option-modifier 'meta
             mac-left-option-modifier 'meta
             mac-right-option-modifier 'hyper
             ))


(map! "C-x b"   #'counsel-buffer-or-recentf
      "C-x C-b" #'counsel-switch-buffer)

;;Use +default/search-buffer for searching by default, I like the Swiper interface.
;;(map! "C-s" #'counsel-grep-or-swiper)
(map! "C-s" #'+default/search-buffer)

;; *** deadgrep
(use-package! deadgrep
:if (executable-find "rg")
:init
(map! "M-s" #'deadgrep)
:commands (deadgrep)
  )

;;Map C-c C-g to magit-status - I have too ingrained muscle memory for this keybinding.
(map! :after magit "C-c C-g" #'magit-status)

;;visual-regexp-steroids provides sane regular expressions and visual incremental search.
(use-package! visual-regexp-steroids
  :defer 3
  :config
  (require 'pcre2el)
  (setq vr/engine 'pcre2el)
  (map! "C-c s r" #'vr/replace)
  (map! "C-c s q" #'vr/query-replace))

;; I normally use C-/ for undo and Emacs doesn’t have a separate “redo” action, so I map C-? (in my keyboard, the same combination + Shift) for redo.
(after! undo-fu
  (map! :map undo-fu-mode-map "C-?" #'undo-fu-only-redo))

;;Replace the default goto-line keybindings with avy-goto-line, which is more flexible
(map! "M-g g" #'avy-goto-line)
(map! "M-g M-g" #'avy-goto-line)

;;Map a keybindings for counsel-outline, which allows easily navigating documents
(map! "M-g o" #'counsel-outline)

;;vi % key, which jumps to the parenthesis, bracket or brace which matches the one below the cursor.
(after! smartparens
  (defun zz/goto-match-paren (arg)
    "Go to the matching paren/bracket, otherwise (or if ARG is not
    nil) insert %.  vi style of % jumping to matching brace."
    (interactive "p")
    (if (not (memq last-command '(set-mark
                                  cua-set-mark
                                  zz/goto-match-paren
                                  down-list
                                  up-list
                                  end-of-defun
                                  beginning-of-defun
                                  backward-sexp
                                  forward-sexp
                                  backward-up-list
                                  forward-paragraph
                                  backward-paragraph
                                  end-of-buffer
                                  beginning-of-buffer
                                  backward-word
                                  forward-word
                                  mwheel-scroll
                                  backward-word
                                  forward-word
                                  mouse-start-secondary
                                  mouse-yank-secondary
                                  mouse-secondary-save-then-kill
                                  move-end-of-line
                                  move-beginning-of-line
                                  backward-char
                                  forward-char
                                  scroll-up
                                  scroll-down
                                  scroll-left
                                  scroll-right
                                  mouse-set-point
                                  next-buffer
                                  previous-buffer
                                  previous-line
                                  next-line
                                  back-to-indentation
                                  doom/backward-to-bol-or-indent
                                  doom/forward-to-last-non-comment-or-eol
                                  )))
        (self-insert-command (or arg 1))
      (cond ((looking-at "\\s\(") (sp-forward-sexp) (backward-char 1))
            ((looking-at "\\s\)") (forward-char 1) (sp-backward-sexp))
            (t (self-insert-command (or arg 1))))))
  (map! "%" 'zz/goto-match-paren))


;; find-function-at-point gets bound to C-c l g p (grouped together with other “go to” functions bound by Doom)
;; and to C-c C-f (analog to the existing C-c f) for faster access.
(after! prog-mode
  (map! :map prog-mode-map "C-h C-f" #'find-function-at-point)
  (map! :map prog-mode-map
        :localleader
        :desc "Find function at point"
    "g p" #'find-function-at-point))

(provide '+bindings)
;;; +bindings.el ends here
