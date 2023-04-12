;;; +ui.el -*- lexical-binding: t; -*-


;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Iosevka Curly" :size 12 :weight 'light)
 ;;     doom-variable-pitch-font (font-spec :family "Hack Nerd Font Mono" :size 13))


(setq evil-emacs-state-cursor `(box ,(doom-color 'violet)))

(when (display-graphic-p)

  ;; calculate the font size based on display-pixel-height
  (setq resolution-factor (eval (/ (x-display-pixel-height) 1080.0)))
  (setq doom-theme 'doom-ephemeral
        doom-font (font-spec :family "JetBrains Mono" :size (eval (round (* 13 resolution-factor))))
        doom-big-font (font-spec :family"Isoveka Curly" :size (eval (round (* 18 resolution-factor))))
        doom-variable-pitch-font (font-spec :family "Overpass" :size (eval (round (* 13 resolution-factor))))
        doom-unicode-font (font-spec :family "JuliaMono" :size (eval (round (* 13 resolution-factor))))
        doom-serif-font (font-spec :family "IBM Plex Mono" :size (eval (round (* 13 resolution-factor))) :weight 'light)
        doom-modeline-height (eval (round (* 14 resolution-factor)))
        doom-font-increment 1
        initial-frame-alist '((left .0) (width . 160) (height . 65))))



(use-package! corgi-stateline
  :config
  :disabled true
  (global-corgi-stateline-mode))

;; Update window divider in terminal
;; https://www.reddit.com/r/emacs/comments/3u0d0u/how_do_i_make_the_vertical_window_divider_more/
(unless (display-graphic-p)
  (setq evil-insert-state-cursor 'box)
  (defun my-change-window-divider ()
    (ignore-errors
      (let ((display-table (or buffer-display-table standard-display-table)))
        (set-display-table-slot display-table 5 ?│)
        ;; (set-window-display-table (selected-window) display-table)
        )))
  (add-hook 'window-configuration-change-hook #'my-change-window-divider))

(after! doom-modeline
  (setq doom-modeline-buffer-file-name-style 'truncate-with-project
        doom-modeline-major-mode-icon t
        ;; My mac vsplit screen won't fit
        doom-modeline-window-width-limit (- fill-column 10)))

(setq +workspaces-on-switch-project-behavior t)

(remove-hook 'doom-init-ui-hook #'blink-cursor-mode)

;; disable line-numbers by default
(setq display-line-numbers-type nil)

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
