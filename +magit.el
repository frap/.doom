;;; packge -- my magit config ./Dev/emacs/doom.d/+magit.el -*- lexical-binding: t; -*-
;;; Commentary
(map! :after magit "C-c g" #'magit-status)

(after! magit
  (setq magit-save-repository-buffers nil
        magit-branch-prefer-remote-upstream '("master" "main")
        git-commit-style-convention-checks nil
        magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-wip-after-apply-mode t)
  ;;(magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))
  (magit-wip-before-change-mode t))

(after! forge
  ;; TEMP
  ;; (setq ghub-use-workaround-for-emacs-bug 'force)
)
;; magit-todos uses hl-todo-keywords
(custom-theme-set-faces! doom-theme
  `(hl-todo :foreground ,(doom-color 'bg)))
(after! hl-todo
  (setq hl-todo-color-background t
        hl-todo-keyword-faces
        `(("TODO"  . ,(doom-color 'orange))
          ("HACK"  . ,(doom-color 'orange))
          ("TEMP"  . ,(doom-color 'orange))
          ("DONE"  . ,(doom-color 'green))
          ("NOTE"  . ,(doom-color 'green))
          ("DONT"  . ,(doom-color 'red))
          ("DEBUG"  . ,(doom-color 'red))
          ("FAIL"  . ,(doom-color 'red))
          ("FIXME" . ,(doom-color 'red))
          ("XXX"   . ,(doom-color 'blue))
          ("XXXX"  . ,(doom-color 'blue)))))

;; (after! magit
;;   (setq
;;     git-commit-summary-max-length 999
;;     git-commit-fill-column 999

;;     magit-push-always-verify nil
;;     ;;magit-popup-show-common-commands nil
;;     magit-auto-revert-mode t
;;     magit-revert-buffers 1
;;     magit-commit-show-diff nil
;;     ; magit-display-buffer-function 'magit-display-buffer-fullcolumn-most-v1
;;     magit-diff-refine-hunk 'all
;;   ;;  magit-delete-by-moving-to-trash nil
;;     magit-revision-use-gravatar-kludge t)

;;   (remove-hook 'git-commit-finish-query-functions
;;                'git-commit-check-style-conventions)
;;   (remove-hook 'server-switch-hook
;;                'magit-commit-diff)
;;   (add-hook 'git-commit-setup-hook 'turn-off-auto-fill t))
