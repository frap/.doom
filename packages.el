;; -*- no-byte-compile: t; -*-
;; .doom.d/packages.el

;; Examples:
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)
(package! dired-narrow)
(package! deadgrep)
;;(package! org-gcal)
(package! company-posframe)

(package! doom-snippets :ignore t)
;; If you want to replace it with yasnippet's default snippets
(package! yasnippet-snippets)
(package! obtt :recipe (:host github :repo "timotheosh/obtt"))
;;(package! flycheck-clj-kondo)
;;(package! doct
;;  :recipe (:host github :repo "progfolio/doct")
;;  :pin "dabb30ebea866ef225b81561c8265d740b1e81c3")

(package! switch-buffer-functions)
(package! pcre2el)
(package! visual-regexp-steroids)
(package! elvish-mode)
(package! ob-elvish)
(package! graphviz-dot-mode)
(package! org-gtd)
(package! org-super-agenda)
(package! org-download)
(package! org-fc :recipe (:host github :repo "l3kn/org-fc"))
(package! org-clock-convenience :ignore t)
(package! nz-holidays)
(package! org-appear
  :recipe (:host github
           :repo "awth13/org-appear"))
(package! org-ol-tree
  :recipe (:host github
           :repo "Townk/org-ol-tree"))

(package! org-ml)
(package! org-ql)
(package! calctex :recipe (:host github :repo "johnbcoughlin/calctex"
                           :files ("*.el" "calctex/*.el" "calctex-contrib/*.el" "org-calctex/*.el" "vendor"))
  :pin "784cf911bc96aac0f47d529e8cee96ebd7cc31c9")
(package! orgdiff :recipe (:host github :repo "tecosaur/orgdiff"
                          ))
(package! org-fragtog :pin "479e0a1c3610dfe918d89a5f5a92c8aec37f131d")
;;(package! org-auto-tangle)
;;(package! winner)
;;(package! windmove)
(package! kaocha-runner)
(package! clojure-snippets)
(package! fennel-mode)
(package! groovy-mode)
(package! janet-mode)
(package! inf-janet
  :recipe (:host github :repo "velkyel/inf-janet"))

(package! magit-section)
;;(package! gitconfig-mode
;;	  :recipe (:host github :repo "magit/git-modes"
;;;			 :files ("gitconfig-mode.el")))
;;(package! gitignore-mode
;;	  :recipe (:host github :repo "magit/git-modes"
;;			 :files ("gitignore-mode.el")))

(package! graphviz-dot-mode)
(package! iedit)
(package! unfill)

;; Bugs

(package! cider :pin "8b3dabe")
;;(package! map :pin "896384b")
(package! map :pin "bb50dba")
