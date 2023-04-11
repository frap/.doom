;;; +coding.el  -*- lexical-binding: t; -*-

(global-subword-mode 1)    ; Iterate through CamelCase words

;;(setq forge-database-connector 'sqlite3)
;; calculator
;; every sane persion prefers radians and exact mode
(setq calc-angle-mode 'rad  ; radians are rad
      calc-symbolic-mode t) ; keeps expressions like \sqrt{2} irrational for as long as possible

(load! "+clojure")

(use-package! calctex
  :commands calctex-mode
  :init
  (add-hook 'calc-mode-hook #'calctex-mode)
  :config
  (setq calctex-additional-latex-packages "
\\usepackage[usenames]{xcolor}
\\usepackage{soul}
\\usepackage{adjustbox}
\\usepackage{amsmath}
\\usepackage{amssymb}
\\usepackage{siunitx}
\\usepackage{cancel}
\\usepackage{mathtools}
\\usepackage{mathalpha}
\\usepackage{xparse}
\\usepackage{arevmath}"
        calctex-additional-latex-macros
        (concat calctex-additional-latex-macros
                "\n\\let\\evalto\\Rightarrow"))
  (defadvice! no-messaging-a (orig-fn &rest args)
    :around #'calctex-default-dispatching-render-process
    (let ((inhibit-message t) message-log-max)
      (apply orig-fn args)))
  ;; Fix hardcoded dvichop path (whyyyyyyy)
   (let ((vendor-folder (concat (file-truename doom-local-dir)
                                "straight/"
                                (format "build-%s" emacs-version)
                                "/calctex/vendor/")))
     (setq calctex-dvichop-sty (concat vendor-folder "texd/dvichop")
           calctex-dvichop-bin (concat vendor-folder "texd/dvichop")))
   (unless (file-exists-p calctex-dvichop-bin)
     (message "CalcTeX: Building dvichop binary")
     (let ((default-directory (file-name-directory calctex-dvichop-bin)))
       (call-process "make" nil nil nil)))
  )

;; R
(after! ess-r-mode
  (appendq! +ligatures-extra-symbols
            '(:assign "⟵"
              :multiply "×"))
  (set-ligatures! 'ess-r-mode
    ;; Functional
    :def "function"
    ;; Types
    :null "NULL"
    :true "TRUE"
    :false "FALSE"
    :int "int"
    :floar "float"
    :bool "bool"
    ;; Flow
    :not "!"
    :and "&&" :or "||"
    :for "for"
    :in "%in%"
    :return "return"
    ;; Other
    :assign "<-"
    :multiply "%*%"))

(setq
   projectile-project-search-path '("~/Dev/"))

;; tangle-on-save automatically runs org-babel-tangle upon saving any org-mode buffer, which means the resulting files will be automatically kept up to date.
;;(add-hook! org-mode :append
;;  (add-hook! after-save :append :local #'org-babel-tangle))

;; lsp-ui-sideline is redundant with eldoc and much more invasive
(setq lsp-ui-sideline-enable nil
      lsp-enable-symbol-highlighting nil)


(setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))

(defun zz/sp-enclose-next-sexp (num)
   (interactive "p")
   (insert-parentheses (or num 1)))

 (after! smartparens
   (add-hook! (clojure-mode
               emacs-lisp-mode
               lisp-mode
               cider-repl-mode
               racket-mode
               racket-repl-mode) :append #'smartparens-strict-mode)
   (add-hook! smartparens-mode :append #'sp-use-paredit-bindings)
   (map! :map (smartparens-mode-map smartparens-strict-mode-map)
     "M-(" #'zz/sp-enclose-next-sexp))


;; (use-package! smartparens
;;   :init
;;   (map! :map smartparens-mode-map
;;         "C-M-f" #'sp-forward-sexp
;;         "C-M-b" #'sp-backward-sexp
;;         "C-M-u" #'sp-backward-up-sexp
;;         "C-M-d" #'sp-down-sexp
;;         "C-M-p" #'sp-backward-down-sexp
;;         "C-M-n" #'sp-up-sexp
;;         "C-M-s" #'sp-splice-sexp
;;         "C-M-." #'sp-forward-slurp-sexp
;;         "C->" #'sp-forward-barf-sexp
;;         "C-M-," #'sp-backward-slurp-sexp
;;         "C-<" #'sp-backward-barf-sexp))

(after! tramp
  (setenv "SHELL" "/bin/bash")
  (setq tramp-shell-prompt-pattern "\\(?:^\\|\\)[^]#$%>\n]*#?[]#$%>] *\\(�\\[[0-9;]*[a-zA-Z] *\\)*")
  ) ;; default + 


(defconst IS-MAC-M1 (string-match-p "arch64" system-configuration))
(after! python
  (setq conda-anaconda-home (substitute-in-file-name "${HOMEBREW_PREFIX}/Caskroom/miniforge/base")
        conda-env-home-directory
        (substitute-in-file-name "${HOMEBREW_PREFIX}/Caskroom/miniforge/base")))

(defun zz/org-if-str (str &optional desc)
  (when (org-string-nw-p str)
    (or (org-string-nw-p desc) str)))

(defun zz/org-macro-hsapi-code (module &optional func desc)
  (org-link-make-string
   (concat "https://www.hammerspoon.org/docs/"
           (concat module (zz/org-if-str func (concat "#" func))))
   (or (org-string-nw-p desc)
       (format "=%s="
               (concat module
                       (zz/org-if-str func (concat "." func)))))))

(defun zz/org-macro-keys-code-outer (str)
  (mapconcat (lambda (s)
               (concat "~" s "~"))
             (split-string str)
             (concat (string ?\u200B) "+" (string ?\u200B))))
(defun zz/org-macro-keys-code-inner (str)
  (concat "~" (mapconcat (lambda (s)
                           (concat s))
                         (split-string str)
                         (concat (string ?\u200B) "-" (string ?\u200B)))
          "~"))
(defun zz/org-macro-keys-code (str)
  (zz/org-macro-keys-code-inner str))

(defun zz/org-macro-luadoc-code (func &optional section desc)
  (org-link-make-string
   (concat "https://www.lua.org/manual/5.3/manual.html#"
           (zz/org-if-str func section))
   (zz/org-if-str func desc)))

(defun zz/org-macro-luafun-code (func &optional desc)
  (org-link-make-string
   (concat "https://www.lua.org/manual/5.3/manual.html#"
           (concat "pdf-" func))
   (zz/org-if-str (concat "=" func "()=") desc)))

(after! prog-mode
  (map! :map prog-mode-map "C-h C-f" #'find-function-at-point)
  (map! :map prog-mode-map
        :localleader
        :desc "Find function at point"
        "g p" #'find-function-at-point))

(use-package! graphviz-dot-mode)

(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
(put 'dockerfile-image-name 'safe-local-variable #'stringp)

(defun plain-pipe-for-process () (setq-local process-connection-type nil))
(add-hook 'compilation-mode-hook 'plain-pipe-for-process)

(use-package! emacs-everywhere
  :config
  (setq emacs-everywhere-major-mode-function #'org-mode))

(after! epa
  (set 'epg-pinentry-mode nil)
  (setq epa-file-encrypt-to '("gas@tuatara.red")))

(use-package! iedit
  :defer
  :config
  (set-face-background 'iedit-occurrence "Magenta")
  :bind
  ("C-;" . iedit-mode))

(defmacro zz/measure-time (&rest body)
  "Measure the time it takes to evaluate BODY."
  `(let ((time (current-time)))
     ,@body
     (float-time (time-since time))))


;; fennel-mode
;; (use-package! fennel-mode
;;   :straight (:host nil :repo "https://git.sr.ht/~technomancy/fennel-mode")
;;   :hook ((fennel-mode fennel-repl-mode) . common-lisp-modes-mode)
;;   :bind ( :map fennel-mode-map
;;           ("C-c C-k" . eval-each-sexp)
;;           ("M-." . xref-find-definitions)
;;           ("M-," . xref-pop-marker-stack))
;;   :config
;;   (dolist (sym '(global local var))
;;     (put sym 'fennel-indent-function 1))
;;   (defvar org-babel-default-header-args:fennel '((:results . "silent")))
;;   (defun org-babel-execute:fennel (body _params)
;;     "Evaluate a block of Fennel code with Babel."
;;     (save-window-excursion
;;       (unless (bufferp fennel-repl--buffer)
;;         (fennel-repl nil))
;;       (let ((inferior-lisp-buffer fennel-repl--buffer))
;;         (lisp-eval-string body))))
;;   :init
;;   (defun eval-each-sexp ()
;;     "Evaluate each s-expression in the buffer consequentially.
;; If prefix ARG specified, call `fennel-reload' function.  If
;; double prefix ARG specified call `fennel-reload' function and ask
;; for the module name."
;;     (interactive)
;;     (save-excursion
;;       (save-restriction
;;         (goto-char (point-min))
;;         (while (save-excursion
;;                  (search-forward-regexp "[^[:space:]]." nil t))
;;           (forward-sexp)
;;           (when (and (not (nth 4 (syntax-ppss)))
;;                      (looking-back "." 1))
;;             (lisp-eval-last-sexp)))))
;;     (when fennel-mode-switch-to-repl-after-reload
;;       (switch-to-lisp t))))
