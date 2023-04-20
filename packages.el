;; -*- no-byte-compile: t; -*-
;; .doom.d/packages.el


(package! dired-narrow)

;;(package! org-gcal)
;;(package! org-clock-convenience :ignore t)
(package! company-posframe)

;;(package! doom-snippets :ignore t)
;; If you want to replace it with yasnippet's default snippets
;;(package! yasnippet-snippets)
;;(package! obtt :recipe (:host github :repo "timotheosh/obtt"))
;;(package! doct
;;  :recipe (:host github :repo "progfolio/doct")
;;  :pin "dabb30ebea866ef225b81561c8265d740b1e81c3")

(package! switch-buffer-functions)
(package! pcre2el)
(package! visual-regexp-steroids)
;;(package! elvish-mode)
;;(package! ob-elvish)
(package! graphviz-dot-mode)

;;(package! org-gtd)
;;(package! org-super-agenda)
;;(package! org-download)
;;(package! org-fc :recipe (:host github :repo "l3kn/org-fc"))
;;(package! org-clock-convenience :ignore t)

;; (package! nz-holidays)
;; (package! org-appear
;;   :recipe (:host github
;;            :repo "awth13/org-appear"))
;; (package! org-ol-tree
;;   :recipe (:host github
;;            :repo "Townk/org-ol-tree"))

;; (package! org-ml)
;; (package! org-ql)

;; (package! org-auto-tangle)

(package! kaocha-runner)
(package! clojure-snippets)
(package! clj-ns-name
  :recipe (:host github :repo "corgi-emacs/clj-ns-name" :files ("clj-ns-name.el")))
;;(package! walkclj
;;  :recipe (:host :repo "corgi-emacs/walkclj" :files ("walkclj.el")))
(package! pprint-to-buffer
  :recipe (:host github :repo "plexus/plexmacs" :files ("pprint-to-buffer/pprint-to-buffer.el")))
(package! fennel-mode)
(package! groovy-mode)
(package! janet-mode)
(package! inf-janet
  :recipe (:host github :repo "velkyel/inf-janet"))
(package! python-black)

;;(package! magit-section)

(package! graphviz-dot-mode)
(package! iedit)
(package! unfill)
(package! selected)
(package! phi-search)
(package! phi-search-mc)
(package! ace-mc)
(package! mc-extras)

(package! ripgrep)
(package! rg)
(package! deadgrep)
;; bugs
;;(package! cider :pin "8b3dabe")
;;(package! map :pin "bb50dba")
;;(package! gitconfig-mode
;;	  :recipe (:host github :repo "magit/git-modes"
;;			 :files ("gitconfig-mode.el")))
;;(package! gitignore-mode
;;	  :recipe (:host github :repo "magit/git-modes"
;;			 :files ("gitignore-mode.el")))
;;(package! calctex :recipe (:host github :repo "johnbcoughlin/calctex"
;;                           :files ("*.el" "calctex/*.el" "calctex-contrib/*.el" "org-calctex/*.el" "vendor"))
;;  :pin "784cf911bc96aac0f47d529e8cee96ebd7cc31c9")
(package! orgdiff :recipe (:host github :repo "tecosaur/orgdiff" ))
(package! org-fragtog :pin "479e0a1c3610dfe918d89a5f5a92c8aec37f131d")
(package! zop-to-char)
;;(package! crux)
(package! rego-mode)

(package! format-all)
(package! which-func)
