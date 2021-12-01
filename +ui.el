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

(if IS-MAC
  (setq
   doom-font (font-spec :family "Iosevka Term SS04" :size 16 :weight 'light)
   doom-variable-pitch-font (font-spec :family "SF Pro Text" )
    doom-unicode-font (font-spec :family "Fira Code" :size 12)
    doom-big-font (font-spec :family "Iosevka Term SS04" :size 36)
    ;;doom-theme 'doom-acario-light
    doom-theme 'doom-flatwhite
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


;; delete the theme defaults
;;(delq! t custom-theme-load-path)

;; All themes are safe to load
(setq custom-safe-themes t)

;; make default modify orange not red!
;(custom-set-faces!
;  '(doom-modeline-buffer-modified :foreground "orange"))

;; UTF-8 is default encoding remove it form modeline
(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)



;; counsel-buffer shows duplicated entries
(defun zz/counsel-buffer-or-recentf-candidates ()
  "Return candidates for `counsel-buffer-or-recentf'."
  (require 'recentf)
  (recentf-mode)
  (let ((buffers
         (delq nil
               (mapcar (lambda (b)
                         (when (buffer-file-name b)
                           (abbreviate-file-name (buffer-file-name b))))
                       (delq (current-buffer) (buffer-list))))))
    (append
     buffers
     (cl-remove-if (lambda (f) (member f buffers))
                   (counsel-recentf-candidates)))))

(advice-add #'counsel-buffer-or-recentf-candidates
  :override #'zz/counsel-buffer-or-recentf-candidates)

;; switch-buffer-functions allows us to update recentf buffer-list
(use-package! switch-buffer-functions
  :after recentf
  :preface
  (defun my-recentf-track-visited-file (_prev _curr)
    (and buffer-file-name
         (recentf-add-file buffer-file-name)))
  :init
  (add-hook 'switch-buffer-functions #'my-recentf-track-visited-file))

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

(setq doom-modeline-enable-word-count t)

(cua-mode +1)
(setq osx-clipboard-mode t)
;; copy/paste between macOS and Emacs[[https://emacs.stackexchange.com/questions/48607/os-copy-paste-not-working-for-emacs-mac][post]]
 (setq select-enable-clipboard t)
 (setq interprogram-paste-function
 (lambda ()
   (shell-command-to-string "pbpaste")))
