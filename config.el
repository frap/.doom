
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(if IS-MAC
  (setq
    user-full-name "Andrés Gasson"
    user-mail-address "agasson@red-elvis.net"
    github-account-name "frap")
  (setq
    user-full-name "atearoot"
    user-mail-address "support@ateasystems.com"))


;(setq-default
; delete-by-moving-to-trash t                      ; Delete files to trash
; window-combination-resize t                      ; take new window space from all other windows (not just current)
; x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq default-directory "~")

;; Global settings
;(setq! show-paren-mode 1
;       doom-scratch-initial-major-mode t)

;; default is in .emacs.d and can be deleted -- used for gpg
(setq!
  auth-sources '("~/.authinfo.gpg")
  auth-source-cache-expiry nil) ; default is 7200 (2h)


;(setq display-line-numbers-type 'relative)

;; I’d like some slightly nicer default buffer names
;;(setq doom-fallback-buffer-name "► Doom"
;;      +doom-dashboard-name "► Doom")

;; Load Personalised bindings
(load! "+bindings")
;(load! "+functions")
;; Theme related things
(load! "+ui")

(load! "+coding")

;; Editor add aka ANSI codes
(load! "+editor")

;;gas org customisations
;(load! "+org")
;; disable org-mode's auto wrap
;(remove-hook 'org-mode-hook 'auto-fill-mode)
;; mu4e setup
;;
;(if IS-MAC
;  (load! "+mail"))

;; Which key - make it pop up faster
(setq which-key-idle-delay 0.5) ;; I need the help, I really do


(setq search-highlight t
      search-whitespace-regexp ".*?"
      isearch-lax-whitespace t
      isearch-regexp-lax-whitespace nil
      isearch-lazy-highlight t
      isearch-lazy-count t
      lazy-count-prefix-format " (%s/%s) "
      lazy-count-suffix-format nil
      isearch-yank-on-move 'shift
      isearch-allow-scroll 'unlimited)


(after! dired
  (setq dired-listing-switches "-aBhl  --group-directories-first"
        dired-dwim-target t
        dired-recursive-copies (quote always)
        dired-recursive-deletes (quote top)))

(use-package! dired-narrow
  :commands (dired-narrow-fuzzy)
  :init
  (map! :map dired-mode-map
        :desc "narrow" "/" #'dired-narrow-fuzzy))

;; Reuse dired buffers
(put 'dired-find-alternate-file 'disabled nil)
