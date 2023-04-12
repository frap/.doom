;;; ~/.doom.d/+ui.el -*- lexical-binding: t; -*-
(add-to-list 'default-frame-alist
             '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist
             '(ns-appearance . light))

(setq baby-blue '("#d2ecff" "#d2ecff" "brightblue"))
;;(display-time-mode 1)                             ; Enable time in the mode-line
;;(setq display-time-day-and-date t)                ;
;;(unless (equal "Battery status not available"
;;               (battery))
;;  (display-battery-mode 1))                       ; On laptops it's nice to know how much power you have

(tool-bar-mode -1)
;; Font and Screen setup
(let ((alternatives '("doom-emacs-bw-light.svg"
                      "doom-emacs-flugo-slant_out_purple-small.png"
                      "doom-emacs-flugo-slant_out_bw-small.png")))
   (setq fancy-splash-image
        (concat doom-private-dir "banners/"
                (nth (random (length alternatives)) alternatives))))
(setq +doom-dashboard-menu-sections (cl-subseq +doom-dashboard-menu-sections 0 2))

(setq
     ;; splash image
    +doom-dashboard-banner-dir (concat doom-private-dir "banners/")
    +doom-dashboard-banner-file "black-hole.png"
    +doom-dashboard-banner-padding '(0 . 1))

(if IS-MAC
  (setq
   doom-font (font-spec :family "Jetbrains Mono" :size 14 :weight 'light)
   doom-variable-pitch-font (font-spec :family "Iosevka Aile" )
    doom-unicode-font (font-spec :family "Fira Code" :size 12)
    doom-big-font (font-spec :family "Iosevka Slab" :size 24)
    ;;doom-theme 'doom-acario-light
    doom-theme 'modus-vivendi ;;'doom-flatwhite
    ;; splash image
    +doom-dashboard-banner-dir (concat doom-private-dir "banners/")
    +doom-dashboard-banner-file "black-hole.png"
    +doom-dashboard-banner-padding '(0 . 1)

    ;; screen size
    default-frame-alist '((left . 0) (width . 163) (fullscreen . fullheight))
    ;;initial-frame-alist '((fullscreen . maximized))
    ;; subsequent frames arew fullheight but not fullwidth
    ;;default-frame-alist '((fullscreen . fullheight))
  ))

(when (or IS-LINUX  (equal (window-system) nil))
  (and
    (bind-key "C-<down>" #'+org/insert-item-below)
    (setq
      doom-font (font-spec :family "Fira Code" :size 16)
      doom-big-font (font-spec :family "Input Mono" :size 20)
      doom-theme 'doom-ayu-light

      initial-frame-alist '((top . 1) (left . 1) (width . 114) (height . 37))
      )))

;; conditional load mixed-pitch mode
(defvar mixed-pitch-modes '(org-mode LaTeX-mode markdown-mode gfm-mode Info-mode)
  "Modes that `mixed-pitch-mode' should be enabled in, but only after UI initialisation.")
(defun init-mixed-pitch-h ()
  "Hook `mixed-pitch-mode' into each mode in `mixed-pitch-modes'.
Also immediately enables `mixed-pitch-modes' if currently in one of the modes."
  (when (memq major-mode mixed-pitch-modes)
    (mixed-pitch-mode 1))
  (dolist (hook mixed-pitch-modes)
    (add-hook (intern (concat (symbol-name hook) "-hook")) #'mixed-pitch-mode)))
;;(add-hook 'doom-init-ui-hook #'init-mixed-pitch-h)

;; apply mixed pitch with a serif face instead of default
(autoload #'mixed-pitch-serif-mode "mixed-pitch"
  "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch." t)

(after! mixed-pitch
  (defface variable-pitch-serif
    '((t (:family "serif")))
    "A variable-pitch face with serifs."
    :group 'basic-faces)
  (setq mixed-pitch-set-height t)
  (setq variable-pitch-serif-font (font-spec :family "Alegreya" :size 27))
  (set-face-attribute 'variable-pitch-serif nil :font variable-pitch-serif-font)
  (defun mixed-pitch-serif-mode (&optional arg)
    "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch."
    (interactive)
    (let ((mixed-pitch-face 'variable-pitch-serif))
      (mixed-pitch-mode (or arg 'toggle)))))
;; Harfbuzz is currently used in Emacs, we’ll be missing out on the following Alegreya ligatures
;;(set-char-table-range composition-function-table ?f '(["\\(?:ff?[fijlt]\\)" 0 font-shape-gstring]))
;;(set-char-table-range composition-function-table ?T '(["\\(?:Th\\)" 0 font-shape-gstring]))


;; delete the theme defaults
;;(delq! t custom-theme-load-path)

;; All themes are safe to load
(setq custom-safe-themes t)

;; make default modify orange not red!
;(custom-set-faces!
;  '(doom-modeline-buffer-modified :foreground "orange"))

;; UTF-8 is default encoding remove it from modeline
(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)


(setq doom-modeline-enable-word-count t)


;; window title
;;; I’d like to have just the buffer name, then if applicable the project folder
;; (setq frame-title-format
;;       '(""
;;         (:eval
;;          (if (s-contains-p org-roam-directory (or buffer-file-name ""))
;;              (replace-regexp-in-string ".*/[0-9]*-?" "🢔 " buffer-file-name)
;;            "%b"))
;;         (:eval
;;          (let ((project-name (projectile-project-name)))
;;            (unless (string= "-" project-name)
;;              (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))


;; Feature `windmove' provides keybindings S-left, S-right, S-up, and
;; S-down to move between windows. This is much more convenient and
;; efficient than using the default binding, C-x o, to cycle through
;; all of them in an essentially unpredictable order.
(use-package! windmove
  ;:disabled
  :demand t
  :config

  (windmove-default-keybindings)

  ;; Introduced in Emacs 27:

  (when (fboundp 'windmove-display-default-keybindings)
    (windmove-display-default-keybindings))

  (when (fboundp 'windmove-delete-default-keybindings)
    (windmove-delete-default-keybindings)))

;; Feature `winner' provides an undo/redo stack for window
;; configurations, with undo and redo being C-c left and C-c right,
;; respectively. (Actually "redo" doesn't revert a single undo, but
;; rather a whole sequence of them.) For instance, you can use C-x 1
;; to focus on a particular window, then return to your previous
;; layout with C-c left.
(use-package! winner
  ;:disabled

 :demand t
 :config
 ; (map! :map winner-mode-map
 ;      "<M-right>" #'winner-redo
 ;      "<M-left>" #'winner-undo)
 (winner-mode +1))

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



