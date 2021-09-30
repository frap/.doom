;;; +coding.el  -*- lexical-binding: t; -*-

(global-subword-mode 1)    ; Iterate through CamelCase words

;; tangle-om-save automatically runs org-babel-tangle upon saving any org-mode buffer, which means the resulting files will be automatically kept up to date.
(add-hook! org-mode :append
  (add-hook! after-save :append :local #'org-babel-tangle))

;; lsp-ui-sideline is redundant with eldoc and much more invasive
;; (setq lsp-ui-sideline-enable nil
;;       lsp-enable-symbol-highlighting nil)


(setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))

;; (defun cider-eval-n-defuns (n)
;;   "Evaluate N top-level forms, starting with the current one."
;;   (interactive "P")
;;   (cider-eval-region (car (bounds-of-thing-at-point 'defun))
;;                      (save-excursion
;;                        (dotimes (i (or n 2))
;;                          (end-of-defun))
;;                        (point))))

;; smartparens-strict-mode to enforce parenthesis to match. I map M-( to enclose the next expression as in paredit using a custom function.
;; Prefix argument can be used to indicate how many expressions to enclose instead of just 1. E.g. C-u 3 M-( will enclose the next 3 sexps.
;; (defun zz/sp-enclose-next-sexp (num)
;;   (interactive "p")
;;   (insert-parentheses (or num 1)))

;; (after! smartparens
;;   (add-hook! (clojure-mode
;;               emacs-lisp-mode
;;               lisp-mode
;;               cider-repl-mode
;;               racket-mode
;;               racket-repl-mode) :append #'smartparens-strict-mode)
;;   (add-hook! smartparens-mode :append #'sp-use-paredit-bindings)
;;   (map! :map (smartparens-mode-map smartparens-strict-mode-map)
;;     "M-(" #'zz/sp-enclose-next-sexp))


(use-package! smartparens
  :init
  (map! :map smartparens-mode-map
        "C-M-f" #'sp-forward-sexp
        "C-M-b" #'sp-backward-sexp
        "C-M-u" #'sp-backward-up-sexp
        "C-M-d" #'sp-down-sexp
        "C-M-p" #'sp-backward-down-sexp
        "C-M-n" #'sp-up-sexp
        "C-M-s" #'sp-splice-sexp
        "C-M-." #'sp-forward-slurp-sexp
        "C->" #'sp-forward-barf-sexp
        "C-M-," #'sp-backward-slurp-sexp
        "C-<" #'sp-backward-barf-sexp))

;; (use-package! clojure-mode
;;   :mode ("\\.edn\\'" . clojure-mode)
;; ;;  :bind ("C-c C-a" . cider-eval-n-defuns)
;;   :init
;; ;;  (setq nrepl-use-ssh-fallback-for-remote-hosts t
;; ;;        clojure-indent-style 'align-arguments)
;;   :config
;;   (defalias 'cquit 'cider-quit)
;;  ;; (require 'flycheck-clj-kondo)
;;    ;; ensure kondo is the first one
;;   ;;(dolist (checker '(clj-kondo-clj clj-kondo-cljs clj-kondo-cljc clj-kondo-edn))
;;   ;;  (setq flycheck-checkers (cons checker (delq checker flycheck-checkers))))

;;   ;;(define-key clojure-mode-map (kbd "C-:") 'hippie-expand-lines)
;;   ;;(define-key clojure-mode-map (kbd "C-\"") 'clojure-toggle-keyword-string)

;;   )

 (use-package! cider
   :init
 ;;  (setq cider-print-options
 ;;        '(("length" 80)
 ;;          ("level" 20)
 ;;          ("right-margin" 80))
 ;;        cider-save-file-on-load t)
   (setq cider-ns-refresh-show-log-buffer t
         cider-show-error-buffer t
         cider-font-lock-dynamically '(macro core function var deprecated)
         cider-prompt-for-symbol nil)
   :config
;;   (add-hook 'cider-mode-hook #'eldoc-mode)
;;   (add-hook 'cider-repl-mode-hook #'eldoc-mode)
   )

;; (use-package! clj-refactor
;;   :init
;;   (setq cljr-favor-prefix-notation nil
;;         cljr-favor-private-functions nil
;;         cljr-warn-on-eval nil
;;         cljr-eagerly-build-asts-on-startup nil
;;         cljr-clojure-test-declaration "[clojure.test :refer [deftest is testing]]"
;;         cljr-cljs-clojure-test-declaration cljr-clojure-test-declaration
;;         cljr-cljc-clojure-test-declaration cljr-clojure-test-declaration
;;         cljr-magic-require-namespaces
;;         '(("io" . "clojure.java.io")
;;           ("cs" . "clojure.set")
;;           ("string" . "clojure.string")
;;           ("walk" . "clojure.walk")
;;           ("zip" . "clojure.zip")
;;           ("time" . "clj-time.core")
;;           ("log" . "clojure.tools.logging")
;;           ("jdbc" . "next.jdbc")
;;           ("pp" . "clojure.pprint")
;;           ("json" . "cheshire.json")))
;;   :config
;;   ;;(add-hook 'cider-mode-hook 'clj-refactor-mode)
;;   )

;;  (cljr-add-keybindings-with-modifier "C-s-")
;;  (cljr-add-keybindings-with-prefix "C-c C-m")

;;  (define-key clj-refactor-map (kbd "C-x C-r") 'cljr-rename-file)

;;  (add-to-list 'cljr-project-clean-functions 'cleanup-buffer))

(use-package! clojure-snippets
   )

(use-package! kaocha-runner
  )


;;(add-hook!  prog-mode-hook #'smartparens-global-strict-mode)

(after! tramp
  (setenv "SHELL" "/bin/bash")
  (setq tramp-shell-prompt-pattern "\\(?:^\\|\\)[^]#$%>\n]*#?[]#$%>] *\\(�\\[[0-9;]*[a-zA-Z] *\\)*")
  ) ;; default + 


(after! python
  (setq conda-anaconda-home "/usr/local/Caskroom/miniforge/base"
        conda-env-home-directory "/usr/local/Caskroom/miniforge/base"))
