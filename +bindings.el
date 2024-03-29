;;; +bindings.el -*- lexical-binding: t; -*-

(if IS-MAC (setq
             mac-right-command-modifier 'nil
             mac-command-modifier 'super
             mac-option-modifier 'meta
             mac-right-option-modifier 'nil
          ;;   mac-pass-control-to-system nil ;; what does this do?
             ))

(setq kill-whole-line t)

;; window management
(global-set-key (kbd "M-p") (kbd "C-- C-x o"))
(global-set-key (kbd "M-n") (kbd "C-x o"))
(global-set-key (kbd "M-j") 'windmove-down)
(global-set-key (kbd "M-k") 'windmove-up)
(global-set-key (kbd "M-h") 'windmove-left)
(global-set-key (kbd "M-l") 'windmove-right)

(global-set-key (kbd "<f12>") 'next-buffer)
(global-set-key (kbd "<f11>") 'previous-buffer)

(global-set-key (kbd "s-v") 'clipboard-yank)
(global-set-key (kbd "s-k") 'kill-current-buffer)
(global-set-key (kbd "s-e") 'eval-region)
(global-set-key (kbd "s-b") 'eval-buffer)
(global-set-key (kbd "s-c") 'ns-copy-including-secondary)
;;(global-set-key (kbd "s-r") 'recompile)
(global-set-key (kbd "s-,") 'previous-buffer)
(global-set-key (kbd "s-.") 'next-buffer)
;;(global-set-key (kbd "s-j") 'jump-to-register)

;;(fset 'my/shrink (kbd "C-u 39 C-x {"))

;;clipboard yank
(global-set-key (kbd "M-v") 'clipboard-yank)

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)

;(map! "C-x b"   #'counsel-buffer-or-recentf
;      "C-x C-b" #'counsel-switch-buffer)

;;Use +default/search-buffer for searching by default, I like the Swiper interface.
;;(map! "C-s" #'counsel-grep-or-swiper)
;;(map! "C-s" #'+default/search-buffer)

;; *** deadgrep
(use-package! deadgrep
:if (executable-find "rg")
:init
(map! "M-s" #'deadgrep)
:commands (deadgrep)
  )

;;Map C-c C-g to magit-status - I have too ingrained muscle memory for this keybinding.
;;(map! :after magit "C-c C-g" #'magit-status)

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

  (map! (:map smartparens-mode-map
     [C-M-a]   #'sp-beginning-of-sexp
     [C-M-e]   #'sp-end-of-sexp
     [C-M-f]   #'sp-forward-sexp
     [C-M-b]   #'sp-backward-sexp
     [C-M-k]   #'sp-kill-sexp
     [C-M-t]   #'sp-transpose-sexp

     [M-left]    #'sp-beginning-of-sexp
     [M-right]   #'sp-end-of-sexp
     [M-up]      #'sp-backward-up-sexp
     [M-down]    #'sp-backward-down-sexp
     [s-down]    #'sp-down-sexp
     [s-up]      #'sp-up-sexp
     [s-left]    #'sp-backward-sexp
     [s-right]   #'sp-forward-sexp
     [M-s-right] #'sp-next-sexp
     [M-s-left]  #'sp-previous-sexp
     [C-%]       #'zz/goto-match-paren
     )))


;; find-function-at-point gets bound to C-c l g p (grouped together with other “go to” functions bound by Doom)
;; and to C-c C-f (analog to the existing C-c f) for faster access.
(after! prog-mode
  (map! :map prog-mode-map "C-h C-f" #'find-function-at-point)
  (map! :map prog-mode-map
        :localleader
        :desc "Find function at point"
        "g p" #'find-function-at-point))
;; prelude defaults
;; Align your code in a pretty way.
(global-set-key (kbd "C-x \\") 'align-regexp)

;; Font size
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Window switching. (C-x o goes to the next window)
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1))) ;; back one

;; Indentation help
(global-set-key (kbd "C-^") 'crux-top-join-line)

;; Start proced in a similar manner to dired
(global-set-key (kbd "C-x p") 'proced)

;; Start eshell or switch to it if it's active.
(global-set-key (kbd "C-x m") 'eshell)

;; Start a new eshell even if one is active.
(global-set-key (kbd "C-x M") (lambda () (interactive) (eshell t)))

;; Start a regular shell if you prefer that.
(global-set-key (kbd "C-x M-m") 'shell)

;; If you want to be able to M-x without meta
(global-set-key (kbd "C-x C-m") 'smex)
;; replace zap-to-char functionality with the more powerful zop-to-char
(global-set-key (kbd "M-z") 'zop-up-to-char)
(global-set-key (kbd "M-Z") 'zop-to-char)

;; kill lines backward
(global-set-key (kbd "C-<backspace>") 'crux-kill-line-backwards)

(global-set-key [remap kill-whole-line] 'crux-kill-whole-line)

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") 'hippie-expand)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; toggle menu-bar visibility
(global-set-key (kbd "<f12>") 'menu-bar-mode)

(global-set-key (kbd "C-=") 'er/expand-region)

;; Magit creates some global keybindings by default
;; but it's a nice to complement them with this one
(global-set-key (kbd "C-c g") 'magit-file-dispatch)

;; recommended avy keybindings
(global-set-key (kbd "C-:") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g f") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)
(global-set-key (kbd "M-g e") 'avy-goto-word-0)

;;Replace the default goto-line keybindings with avy-goto-line, which is more flexible
(map! "M-g g" #'avy-goto-line)
(map! "M-g M-g" #'avy-goto-line)

;;Map a keybindings for counsel-outline, which allows easily navigating documents
(map! "M-g o" #'counsel-outline)

;; additional avy keybindings
(global-set-key (kbd "s-,") 'avy-goto-char)
(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "C-c v") 'avy-goto-word-or-subword-1)

;; improved window navigation with ace-window
(global-set-key (kbd "s-w") 'ace-window)
(global-set-key [remap other-window] 'ace-window)
;;(global-set-key (kbd "C-c c") 'org-capture)
;;(global-set-key (kbd "C-c a") 'org-agenda)

(provide '+bindings)
;;; +bindings.el ends here
