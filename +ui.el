;;; +ui.el -*- lexical-binding: t; -*-

;; disable line-numbers by default
(setq display-line-numbers-type nil)
;;(setq display-line-numbers-type 'relative)

;; I’d like some slightly nicer default buffer names
;;(setq doom-fallback-buffer-name "► Doom"
;;      +doom-dashboard-name "► Doom")

(setq evil-emacs-state-cursor `(box ,(doom-color 'violet)))

(when (display-graphic-p)


(setq doom-theme 'doom-one-light
      doom-font (font-spec :family "Iosevka Curly" :size 13)
      doom-big-font (font-spec :family "JetBrains Mono" :size 18)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 13)
      doom-unicode-font (font-spec :family "JuliaMono" :size 13)
      doom-serif-font (font-spec :family "IBM Plex Mono" :size 13)
      doom-modeline-height 15
      doom-font-increment 1
      initial-frame-alist '((left . 0) (width . 160) (height . 65))))



(use-package! corgi-stateline
  :config
  :disabled true
  (global-corgi-stateline-mode))

;; Update window divider in terminal
;; https://www.reddit.com/r/emacs/comments/3u0d0u/how_do_i_make_the_vertical_window_divider_more/
;; (unless (display-graphic-p)
;;   (setq evil-insert-state-cursor 'box)
;;   (defun my-change-window-divider ()
;;     (ignore-errors
;;       (let ((display-table (or buffer-display-table standard-display-table)))
;;         (set-display-table-slot display-table 5 ?│)
;;         ;; (set-window-display-table (selected-window) display-table)
;;         )))
;;   (add-hook 'window-configuration-change-hook #'my-change-window-divider))

(after! doom-modeline
  (setq doom-modeline-buffer-file-name-style 'truncate-with-project
        doom-modeline-major-mode-icon t
        ;; My mac vsplit screen won't fit
        doom-modeline-window-width-limit (- fill-column 10)))

(setq +workspaces-on-switch-project-behavior t)

;;(remove-hook 'doom-init-ui-hook #'blink-cursor-mode)

;; turn off some ligature
(plist-put! +ligatures-extra-symbols
  :and           nil
  :or            nil
  :for           nil
  :not           nil
  :true          nil
  :false         nil
  :int           nil
  :float         nil
  :str           nil
  :bool          nil
  :list          nil
)
(provide '+ui)
