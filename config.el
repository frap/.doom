;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
 (defconst IS-WORK (string-match "AG006C" (getenv "USER")))

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(if IS-MAC
  (setq
    user-full-name "Andrés Gasson"
    user-mail-address "gas@troveplatform.co.nz"
    github-account-name "frap"))
(if IS-WORK
  (setq
    user-full-name "Gas"
    user-mail-address "george.gasson@troveplatform.co.nz"))



;(setq-default
; delete-by-moving-to-trash t                      ; Delete files to trash
; window-combination-resize t                      ; take new window space from all other windows (not just current)
; x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq default-directory "~")
(setenv "XDG_CONFIG_DIR" "~/.config")

;; default is in .emacs.d and can be deleted -- used for gpg
(setq!
  auth-sources '("~/.local/state/authinfo.gpg")
  auth-source-cache-expiry nil) ; default is 7200 (2h)

;; Load Personalised bindings
;(load! "+functions")
;; Theme related things
;;(load! "+ui")
(load! "+projectile")
(load! "+parens")
(load! "+bindings")
(load! "+magit")
(load! "+prog")
(load! "+ui")
;;(load! "+cursors")

;
;; Editor add aka ANSI codes
(load! "+editor")

;;gas org customisations
;;(load! "+org")
;; mu4e setup
;;
;(if IS-MAC
;  (load! "+mail"))

;; Which key - make it pop up faster
(setq which-key-idle-delay 0.5) ;; I need the help, I really do


;;(setq search-highlight t
;;      search-whitespace-regexp ".*?"
;;      isearch-lax-whitespace t
;;      isearch-regexp-lax-whitespace nil
;;      isearch-lazy-highlight t
;;      isearch-lazy-count t
;;      lazy-count-prefix-format " (%s/%s) "
;;      lazy-count-suffix-format nil
;;      isearch-yank-on-move 'shift
;;      isearch-allow-scroll 'unlimited)


;;(after! dired
 ;; (setq dired-listing-switches "-aBhl  --group-directories-first"
 ;;       dired-dwim-target t
 ;;       dired-recursive-copies (quote always)
;;        dired-recursive-deletes (quote top)))

;;(use-package! dired-narrow
;;  :commands (dired-narrow-fuzzy)
;;  :init
;;  (map! :map dired-mode-map
;;        :desc "narrow" "/" #'dired-narrow-fuzzy))

;; Reuse dired buffers
;;(put 'dired-find-alternate-file 'disabled nil)
