;;; ~/DOOMDIR/+editor.el -*- lexical-binding: t; -*-

(setq ispell-dictionary "en-AU")

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      auto-save-default t                         ; Nobody likes to lose work, I certainly don't
      truncate-string-ellipsis "…")               ; Unicode ellispis are nicer than "...", and also save /precious/ space


;;It’s nice to see ANSI colour codes displayed
(after! text-mode
  (add-hook! 'text-mode-hook
             ;; Apply ANSI color codes
             (with-silent-modifications
               (ansi-color-apply-on-region (point-min) (point-max)))))

;; doom turns off auto-save
(setq auto-save-default t
      make-backup-files t)

(modify-coding-system-alist 'file "" 'utf-8-unix)

;; yasnippet enable nested snippets
(setq yas-triggers-in-field t)


;; Disable trailing whitespaces in the minibuffer
(add-hook! '(minibuffer-setup-hook doom-popup-mode-hook)
  (setq-local show-trailing-whitespace nil))

(use-package! unfill
  :disabled t
  :defer t
  :bind
  ("M-q" . unfill-toggle)
  ("A-q" . unfill-paragraph))

;; (if IS-MAC)
;; (cua-mode +1)
;; (setq osx-clipboard-mode t)
;; ;; copy/paste between macOS and Emacs[[https://emacs.stackexchange.com/questions/48607/os-copy-paste-not-working-for-emacs-mac][post]]
;;  (setq select-enable-clipboard t)
;;  (setq interprogram-paste-function
;;  (lambda ()
;;    (shell-command-to-string "pbpaste")))
