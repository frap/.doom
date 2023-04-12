;;; +keys.el -*- lexical-binding: t; -*-
(when IS-MAC (setq
             mac-right-command-modifier 'nil
             mac-command-modifier 'super
             mac-option-modifier 'meta
             mac-right-option-modifier 'nil
          ;;   mac-pass-control-to-system nil ;; what does this do?
             ))

(setq kill-whole-line t)

;; Distinguish C-i from TAB
(when (display-graphic-p)
  (define-key input-decode-map "\C-i" [C-i])
  (map! "<C-i>" #'evil-jump-forward))

(map!
 ;; overrides other minor mode keymaps (just for non-evil)
 (:map override ;; general-override-mode-map
  "M-q"   (if (daemonp) #'delete-frame #'save-buffers-kill-terminal)
  "M-p"   (λ! (projectile-invalidate-cache nil) (projectile-find-file))
  "M-y"   #'+default/yank-pop
  "C-]"   #'yas-expand
  "C-'"   #'toggle-input-method
  "<xterm-paste>" #'xterm-paste-with-delete-region
  "C-S-j" #'evil-scroll-line-down
  "C-S-k" #'evil-scroll-line-up
  "C-S-n" #'dap-next
  "M-;"   #'+my/insert-semicolon-at-the-end-of-this-line
  "C-M-;" #'+my/delete-semicolon-at-the-end-of-this-line)
 ;; Conflict with vertico
 :g "C-SPC" nil :g "C-@" nil
 "M-`"   #'other-frame
 "C-M-o" #'other-frame
 ;; fix OS window/frame navigation/manipulation keys
 "M-w" #'delete-window
 "M-W" #'delete-frame
 ;;"M-n" #'+default/new-buffer
 "M-N" #'make-frame
 "C-M-f" #'toggle-frame-fullscreen
 "M-t" #'transpose-words
 "M-i" #'display-which-function
 :gn "C-t" nil
 ;; Restore OS undo, save, copy, & paste keys (without cua-mode, because
 ;; it imposes some other functionality and overhead we don't need)
 "M-z" #'undo
 "M-Z" #'redo
 "M-c" (if (featurep 'evil) #'evil-yank #'copy-region-as-kill)
 "M-v" #'yank-with-delete-region
 ;;"M-s" #'evil-write-all
 ;; frame-local font scaling
 "M-0" #'doom/reset-font-size
 "M-=" #'doom/increase-font-size
 "M--" #'doom/decrease-font-size
 ;; Conventional text-editing keys & motions
 "M-a" #'mark-whole-buffer
 :gni [M-RET]    #'+default/newline-below
 :gni [M-S-RET]  #'+default/newline-above
 :gi  [M-backspace] #'backward-kill-word
 :gi  [M-left]      #'backward-word
 :gi  [M-right]     #'forward-word
 ;; Searching
 (:when (featurep! :completion vertico)
  "M-f" #'consult-line
  "C-s" #'consult-line)
 (:when (featurep! :completion ivy)
  "M-f" #'swiper
  "C-s" #'swiper)
 "M-e"    #'persp-switch-to-buffer
 ;; "C-M-p"  #'+ivy/project-search-specific-files
 ;; Help
 "C-h h"   nil
 "C-h m" #'describe-mode
 "C-h C-k" #'find-function-on-key
 "C-h C-f" #'find-function-at-point
 "C-h C-v" #'find-variable-at-point
 "<f8>"    #'describe-mode
 ;; Comment
 "M-/" (cmd! (save-excursion (comment-line 1)))
 :n "M-/" #'evilnc-comment-or-uncomment-lines
 :v "M-/" #'evilnc-comment-operator
 ;; Others
 :m [tab] nil
 "C-M-\\" #'indent-region-or-buffer
 "M-m"    #'kmacro-call-macro
 )

(if (display-graphic-p)
    (map!
     ;; M-[ does not work in terminal
     "M-[" #'better-jumper-jump-backward
     "M-]" #'better-jumper-jump-forward)
  (map!
   :g "<mouse-4>" #'evil-scroll-line-up
   :g "<mouse-5>" #'evil-scroll-line-down
   ))

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
;;clipboard yank
(global-set-key (kbd "M-v") 'clipboard-yank)

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") 'hippie-expand)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "C-c C-g") 'magit-status)
;; toggle menu-bar visibility
(global-set-key (kbd "<f12>") 'menu-bar-mode)

(global-set-key (kbd "C-=") 'er/expand-region)

;; recommended avy keybindings
(global-set-key (kbd "C-:") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g f") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)
(global-set-key (kbd "M-g e") 'avy-goto-word-0)

;; additional avy keybindings
(global-set-key (kbd "s-,") 'avy-goto-char)
(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "C-c v") 'avy-goto-word-or-subword-1)

;; improved window navigation with ace-window
(global-set-key (kbd "s-w") 'ace-window)
(global-set-key [remap other-window] 'ace-window)
;; *** deadgrep
(use-package! deadgrep
:if (executable-find "rg")
:init
(map! "M-s" #'deadgrep)
:commands (deadgrep))

;;visual-regexp-steroids provides sane regular expressions and visual incremental search.
(use-package! visual-regexp-steroids
  :defer 3
  :config
  (require 'pcre2el)
  (setq vr/engine 'pcre2el)
  (map! "C-c s r" #'vr/replace)
  (map! "C-c s q" #'vr/query-replace))

(provide '+keys)
