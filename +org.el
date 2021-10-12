;;; ~/DOOMDIR/+org.el -*- lexical-binding: t; -*-

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq
  org-directory "~/org/"
;;  org-use-property-inheritance t              ; it's convenient to have properties inherited
;;  org-list-allow-alphabetical t               ; have a. A. a) A) list bullets
;;org-export-in-background t                  ; run export processes in external emacs process
;;  org-catch-invisible-edits 'smart            ; try not to accidently do weird stuff in invisible regions
;;  org-re-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"
  org-ellipsis " ▼ "

 )


(after! org
        (require 'ob-clojure)
        (setq org-babel-clojure-backend 'cider)
        (require 'cider)
        )
;; what is doct?
;; (use-package! doct
;;               :commands (doct))

;;Enable logging of done tasks, and log stuff into the LOGBOOK drawer by default
(after! org
   (setq org-log-done 'time)
   (setq org-log-into-drawer t))

;; Use the special C-a, C-e and C-k definitions for Org, which enable some special behavior in headings.
(after! org
   (setq org-special-ctrl-a/e t)
   (setq org-special-ctrl-k t))

;;Enable Speed Keys, which allows quick single-key commands when the cursor is placed on a heading.
(after! org
  (setq org-use-speed-commands
        (lambda ()
          (and (looking-at org-outline-regexp)
            (looking-back "^\**")))))

(add-hook! org-mode (electric-indent-local-mode -1))

(defun zz/adjust-org-company-backends ()
  (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
  (setq-local company-backends nil))
(add-hook! org-mode (zz/adjust-org-company-backends))
;; Enable variable and visual line mode in Org mode by default.
(add-hook! org-mode :append
           #'visual-line-mode
           #'variable-pitch-mode)

(add-hook! org-mode :append #'org-appear-mode)

;; (after! org-capture
;;   (defun org-capture-select-template-prettier (&optional keys)
;;   "Select a capture template, in a prettier way than default
;; Lisp programs can force the template by setting KEYS to a string."
;;   (let ((org-capture-templates
;;          (or (org-contextualize-keys
;;               (org-capture-upgrade-templates org-capture-templates)
;;               org-capture-templates-contexts)
;;              '(("t" "Tâche" entry (file+headline "" "Tâches")
;;                 "* TODO %?\n  %u\n  %a")))))
;;     (if keys
;;         (or (assoc keys org-capture-templates)
;;             (error "Aucun modèle de capture mentionné par \"%s\" les clés" keys))
;;       (org-mks org-capture-templates
;;                "Sélectionnez un modèle de capture\n━━━━━━━━━━━━━━━━━━━━━━━━━"
;;                "Clé de modèle: "
;;                `(("q" ,(concat (all-the-icons-octicon "stop" :face 'all-the-icons-red :v-adjust 0.01) "\tAbort")))))))
;;   (advice-add 'org-capture-select-template :override #'org-capture-select-template-prettier)

;;   (defun org-mks-pretty (table title &optional prompt specials)
;;     "Select a member of an alist with multiple keys. Prettified.

;; TABLE is the alist which should contain entries where the car is a string.
;; There should be two types of entries.

;; 1. prefix descriptions like (\"a\" \"Description\")
;;    This indicates that `a' is a prefix key for multi-letter selection, and
;;    that there are entries following with keys like \"ab\", \"ax\"…

;; 2. Select-able members must have more than two elements, with the first
;;    being the string of keys that lead to selecting it, and the second a
;;    short description string of the item.

;; The command will then make a temporary buffer listing all entries
;; that can be selected with a single key, and all the single key
;; prefixes.  When you press the key for a single-letter entry, it is selected.
;; When you press a prefix key, the commands (and maybe further prefixes)
;; under this key will be shown and offered for selection.

;; TITLE will be placed over the selection in the temporary buffer,
;; PROMPT will be used when prompting for a key.  SPECIALS is an
;; alist with (\"key\" \"description\") entries.  When one of these
;; is selected, only the bare key is returned."
;;     (save-window-excursion
;;       (let ((inhibit-quit t)
;;              (buffer (org-switch-to-buffer-other-window "*Org Select*"))
;;              (prompt (or prompt "Sélectionner: "))
;;              case-fold-search
;;              current)
;;         (unwind-protect
;;           (catch 'exit
;;             (while t
;;               (setq-local evil-normal-state-cursor (list nil))
;;               (erase-buffer)
;;               (insert title "\n\n")
;;               (let ((des-keys nil)
;;                      (allowed-keys '("\C-g"))
;;                      (tab-alternatives '("\s" "\t" "\r"))
;;                      (cursor-type nil))
;;                 ;; Populate allowed keys and descriptions keys
;;                 ;; available with CURRENT selector.
;;                 (let ((re (format "\\`%s\\(.\\)\\'"
;;                             (if current (regexp-quote current) "")))
;;                        (prefix (if current (concat current " ") "")))
;;                   (dolist (entry table)
;;                     (pcase entry
;;                       ;; Description.
;;                       (`(,(and key (pred (string-match re))) ,desc)
;;                         (let ((k (match-string 1 key)))
;;                           (push k des-keys)
;;                           ;; Keys ending in tab, space or RET are equivalent.
;;                           (if (member k tab-alternatives)
;;                             (push "\t" allowed-keys)
;;                             (push k allowed-keys))
;;                           (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) (propertize "›" 'face 'font-lock-comment-face) "  " desc "…" "\n")))
;;                       ;; Usable entry.
;;                       (`(,(and key (pred (string-match re))) ,desc . ,_)
;;                         (let ((k (match-string 1 key)))
;;                           (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) "   " desc "\n")
;;                           (push k allowed-keys)))
;;                       (_ nil))))
;;                 ;; Insert special entries, if any.
;;                 (when specials
;;                   (insert "─────────────────────────\n")
;;                   (pcase-dolist (`(,key ,description) specials)
;;                     (insert (format "%s   %s\n" (propertize key 'face '(bold all-the-icons-red)) description))
;;                     (push key allowed-keys)))
;;                 ;; Display UI and let user select an entry or
;;                 ;; a sub-level prefix.
;;                 (goto-char (point-min))
;;                 (unless (pos-visible-in-window-p (point-max))
;;                   (org-fit-window-to-buffer))
;;                 (let ((pressed (org--mks-read-key allowed-keys prompt)))
;;                   (setq current (concat current pressed))
;;                   (cond
;;                     ((equal pressed "\C-g") (user-error "Abort"))
;;                     ;; Selection is a prefix: open a new menu.
;;                     ((member pressed des-keys))
;;                     ;; Selection matches an association: return it.
;;                     ((let ((entry (assoc current table)))
;;                        (and entry (throw 'exit entry))))
;;                     ;; Selection matches a special entry: return the
;;                     ;; selection prefix.
;;                     ((assoc current specials) (throw 'exit current))
;;                     (t (error "No entry available")))))))
;;           (when buffer (kill-buffer buffer))))))
;;   (advice-add 'org-mks :override #'org-mks-pretty)
;;   (setq +org-capture-uni-units (split-string (f-read-text "~/Sync/org/.study-units")))
;;   (setq +org-capture-recipies  "~/Sync/org/recipies.org")

;;   (defun +doct-icon-declaration-to-icon (declaration)
;;     "Convert :icon declaration to icon"
;;     (let ((name (pop declaration))
;;           (set  (intern (concat "all-the-icons-" (plist-get declaration :set))))
;;           (face (intern (concat "all-the-icons-" (plist-get declaration :color))))
;;           (v-adjust (or (plist-get declaration :v-adjust) 0.01)))
;;       (apply set `(,name :face ,face :v-adjust ,v-adjust))))

;;   (defun +doct-iconify-capture-templates (groups)
;;     "Add declaration's :icon to each template group in GROUPS."
;;     (let ((templates (doct-flatten-lists-in groups)))
;;       (setq doct-templates (mapcar (lambda (template)
;;                                      (when-let* ((props (nthcdr (if (= (length template) 4) 2 5) template))
;;                                                  (spec (plist-get (plist-get props :doct) :icon)))
;;                                        (setf (nth 1 template) (concat (+doct-icon-declaration-to-icon spec)
;;                                                                       "\t"
;;                                                                       (nth 1 template))))
;;                                      template)
;;                                    templates))))

;;   (setq doct-after-conversion-functions '(+doct-iconify-capture-templates))

;;   (add-transient-hook! 'org-capture-select-template
;;     (setq org-capture-templates
;;           (doct `(("Tâche personnelle" :keys "t"
;;                    :icon ("checklist" :set "octicon" :color "green")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Boîte de réception"
;;                    :type entry
;;                    :template ("* TODO %?"
;;                               "%i %a")
;;                    )
;;                   ("Note personnelle" :keys "n"
;;                    :icon ("sticky-note-o" :set "faicon" :color "green")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Boîte de réception"
;;                    :type entry
;;                    :template ("* %?"
;;                               "%i %a")
;;                    )
;;                   ("Étude" :keys "u"
;;                    :icon ("graduation-cap" :set "faicon" :color "purple")
;;                    :file +org-capture-todo-file
;;                    :headline "Études"
;;                    :unit-prompt ,(format "%%^{Unit|%s}" (string-join +org-capture-uni-units "|"))
;;                    :prepend t
;;                    :type entry
;;                    :children (("Test" :keys "t"
;;                                :icon ("timer" :set "material" :color "red")
;;                                :template ("* TODO [#C] %{unit-prompt} %? :uni:tests:"
;;                                           "SCHEDULED: %^{Test date:}T"
;;                                           "%i %a"))
;;                               ("Assignment" :keys "a"
;;                                :icon ("library_books" :set "material" :color "orange")
;;                                :template ("* TODO [#B] %{unit-prompt} %? :uni:assignments:"
;;                                           "DEADLINE: %^{Due date:}T"
;;                                           "%i %a"))
;;                               ("Lecture" :keys "l"
;;                                :icon ("keynote" :set "fileicon" :color "orange")
;;                                :template ("* TODO [#C] %{unit-prompt} %? :uni:lecture:"
;;                                           "%i %a"))
;;                               ("Miscellaneous task" :keys "u"
;;                                :icon ("list" :set "faicon" :color "yellow")
;;                                :template ("* TODO [#D] %{unit-prompt} %? :uni:"
;;                                           "%i %a"))))
;;                   ("Email" :keys "e"
;;                    :icon ("envelope" :set "faicon" :color "blue")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Inbox"
;;                    :type entry
;;                    :template ("* TODO %^{type|reply to|contact} %\\3 %? :email:"
;;                               "Send an email %^{urgency|soon|ASAP|anon|at some point|eventually} to %^{recipiant}"
;;                               "about %^{topic}"
;;                               "%U %i %a"))
;;                   ("Intéressante" :keys "i"
;;                    :icon ("eye" :set "faicon" :color "lcyan")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Intéressante"
;;                    :type entry
;;                    :template ("* [ ] %{desc}%? :%{i-type}:"
;;                               "%i %a")
;;                    :children (("Webpage" :keys "w"
;;                                :icon ("globe" :set "faicon" :color "green")
;;                                :desc "%(org-cliplink-capture) "
;;                                :i-type "read:web"
;;                                )
;;                               ("Article" :keys "a"
;;                                :icon ("file-text" :set "octicon" :color "yellow")
;;                                :desc ""
;;                                :i-type "read:reaserch"
;;                                )
;;                               ("\tRecipie" :keys "r"
;;                                :icon ("spoon" :set "faicon" :color "dorange")
;;                                :file +org-capture-recipies
;;                                :headline "Unsorted"
;;                                :template "%(org-chef-get-recipe-from-url)"
;;                                )
;;                               ("Information" :keys "i"
;;                                :icon ("info-circle" :set "faicon" :color "blue")
;;                                :desc ""
;;                                :i-type "read:info"
;;                                )
;;                               ("Idée" :keys "I"
;;                                :icon ("bubble_chart" :set "material" :color "silver")
;;                                :desc ""
;;                                :i-type "idea"
;;                                )))
;;                   ("Tâches" :keys "k"
;;                    :icon ("inbox" :set "octicon" :color "yellow")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Boîte de réception"
;;                    :type entry
;;                    :template ("* TODO %? %^G%{extra}"
;;                               "%i %a")
;;                    :children (("Tâche Générale" :keys "k"
;;                                :icon ("inbox" :set "octicon" :color "yellow")
;;                                :extra ""
;;                                )
;;                               ("Tâche avec date limite" :keys "d"
;;                                :icon ("timer" :set "material" :color "orange" :v-adjust -0.1)
;;                                :extra "\nDEADLINE: %^{Deadline:}t"
;;                                )
;;                               ("Tâche Planifiée" :keys "s"
;;                                :icon ("calendar" :set "octicon" :color "orange")
;;                                :extra "\nSCHEDULED: %^{Start time:}t"
;;                                )
;;                               ))
;;                   ("Projet" :keys "p"
;;                    :icon ("repo" :set "octicon" :color "silver")
;;                    :prepend t
;;                    :type entry
;;                    :headline "Boîte de réception"
;;                    :template ("* %{time-or-todo} %?"
;;                               "%i"
;;                               "%a")
;;                    :file ""
;;                    :custom (:time-or-todo "")
;;                    :children (("Projet-local tâche" :keys "t"
;;                                :icon ("checklist" :set "octicon" :color "green")
;;                                :time-or-todo "TODO"
;;                                :file +org-capture-project-todo-file)
;;                               ("Project-local note" :keys "n"
;;                                :icon ("sticky-note" :set "faicon" :color "yellow")
;;                                :time-or-todo "%U"
;;                                :file +org-capture-project-notes-file)
;;                               ("Project-local changelog" :keys "c"
;;                                :icon ("list" :set "faicon" :color "blue")
;;                                :time-or-todo "%U"
;;                                :heading "Unreleased"
;;                                :file +org-capture-project-changelog-file))
;;                    )
;;                   ("\tModèles centralisés pour les projets"
;;                    :keys "o"
;;                    :type entry
;;                    :prepend t
;;                    :template ("* %{time-or-todo} %?"
;;                               "%i"
;;                               "%a")
;;                    :children (("Projet tâche"
;;                                :keys "t"
;;                                :prepend nil
;;                                :time-or-todo "TODO"
;;                                :heading "Tâches"
;;                                :file +org-capture-central-project-todo-file)
;;                               ("Projet note"
;;                                :keys "n"
;;                                :time-or-todo "%U"
;;                                :heading "Notes"
;;                                :file +org-capture-central-project-notes-file)
;;                               ("Projet changelog"
;;                                :keys "c"
;;                                :time-or-todo "%U"
;;                                :heading "Unreleased"
;;                                :file +org-capture-central-project-changelog-file))
;;                     ))))))

(after! org
  (setq org-agenda-files
        '("~/org/gtd" "~/work/work.org.gpg" "~/org/")))

(defun zz/add-file-keybinding (key file &optional desc)
  (let ((key key)
        (file file)
        (desc desc))
    (map! :desc (or desc file)
          key
          (lambda () (interactive) (find-file file)))))

(zz/add-file-keybinding "C-c z w" "~/work/work.org.gpg" "work.org")
(zz/add-file-keybinding "C-c z i" "~/org/ideas.org" "ideas.org")
(zz/add-file-keybinding "C-c z p" "~/org/projects.org" "projects.org")
(zz/add-file-keybinding "C-c z d" "~/org/diary.org" "diary.org")

;; downloads
(setq org-attach-id-dir "attachments/")

(defun zz/org-download-paste-clipboard (&optional use-default-filename)
  (interactive "P")
  (require 'org-download)
  (let ((file
         (if (not use-default-filename)
             (read-string (format "Filename [%s]: "
                                  org-download-screenshot-basename)
                          nil nil org-download-screenshot-basename)
           nil)))
    (org-download-clipboard file)))

(after! org
  (setq org-download-method 'directory)
  (setq org-download-image-dir "images")
  (setq org-download-heading-lvl nil)
  (setq org-download-timestamp "%Y%m%d-%H%M%S_")
  (setq org-image-actual-width 300)
  (map! :map org-mode-map
        "C-c l a y" #'zz/org-download-paste-clipboard
        "C-M-y" #'zz/org-download-paste-clipboard))

(map! :after counsel :map org-mode-map
      "C-c l l h" #'counsel-org-link)

(after! counsel
  (setq counsel-outline-display-style 'title))

(after! org-id
  ;; Do not create ID if a CUSTOM_ID exists
  (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id))

(defun zz/make-id-for-title (title)
  "Return an ID based on TITLE."
  (let* ((new-id (replace-regexp-in-string "[^[:alnum:]]" "-" (downcase title))))
    new-id))

(defun zz/org-custom-id-create ()
  "Create and store CUSTOM_ID for current heading."
  (let* ((title (or (nth 4 (org-heading-components)) ""))
         (new-id (zz/make-id-for-title title)))
    (org-entry-put nil "CUSTOM_ID" new-id)
    (org-id-add-location new-id (buffer-file-name (buffer-base-buffer)))
    new-id))

(defun zz/org-custom-id-get-create (&optional where force)
  "Get or create CUSTOM_ID for heading at WHERE.
If FORCE is t, always recreate the property."
  (org-with-point-at where
    (let ((old-id (org-entry-get nil "CUSTOM_ID")))
      ;; If CUSTOM_ID exists and FORCE is false, return it
      (if (and (not force) old-id (stringp old-id))
          old-id
        ;; otherwise, create it
        (zz/org-custom-id-create)))))

;; Now override counsel-org-link-action
(after! counsel
  (defun counsel-org-link-action (x)
    "Insert a link to X.
X is expected to be a cons of the form (title . point), as passed
by `counsel-org-link'.
If X does not have a CUSTOM_ID, create it based on the headline
title."
    (let* ((id (zz/org-custom-id-get-create (cdr x))))
      (org-insert-link nil (concat "#" id) (car x)))))

;; ORG config
(after! org
  ;;(require 'find-lisp)
  ;; set org file directory
  (setq gas/org-agenda-directory "~/org/gtd/")
  (defconst gas-org-agenda-file (concat gas/org-agenda-directory "todo.org"))
  ;; set agenda files
  ;;(setq org-agenda-files (list gas/org-agenda-directory))
 ;; (setq org-agenda-files
  ;;      (find-lisp-find-files gas/org-agenda-directory "\.org$"))

  (setf (alist-get 'height +org-capture-frame-parameters) 15)
  (alist-get 'name +org-capture-frame-parameters) "❖ Capture") ;; ATM hardcoded in other places, so changing breaks stuff
  (setq +org-capture-fn
        (lambda ()
          (interactive)
          (set-window-parameter nil 'mode-line-format 'none)
          (org-capture)))

  (setq org-todo-keywords
    '((sequence
        "TODO(t)"  ; A task that needs doing & is ready to do
        "PROJ(p)"  ; A project, which usually contains other tasks
        "SUIV(s)"  ; A task that is in progress
        "ATTE(w)"  ; Something external is holding up this task
        "SUSP(h)"  ; This task is paused/on hold because of me
        "|"
        "FINI(d)"  ; Task successfully completed
        "KILL(k)") ; Task was cancelled, aborted or is no longer applicable
       (sequence
         "[ ](T)"   ; A task that needs doing
         "[-](S)"   ; Task is in progress
         "[?](W)"   ; Task is being held up or paused
         "|"
         "[X](D)")  ; Task was completed
         (sequence
           "|"
           "OKAY(o)"
           "YES(y)"
           "NO(n)"))
    org-todo-keyword-faces
    '(("[-]"   . +org-todo-active)
       ("SUIV" . +org-todo-active)
       ("[?]"  . +org-todo-onhold)
       ("ATTE" . +org-todo-onhold)
       ("SUSP" . +org-todo-onhold)
       ("PROJ" . +org-todo-project)
       ("NO"   . +org-todo-cancel)
       ("KILL" . +org-todo-cancel)))
;  (setq org-capture-templates
;        `(("i" "inbox" entry (file ,(concat gas/org-agenda-directory "inbox.org"))
 ;          "* TODO %?")
 ;         ("e" "email" entry (file+headline ,(concat gas/org-agenda-directory "emails.org") "Emails")
 ;              "* TODO [#A] Reply: %a :@maison:@bureau:"
;               :immediate-finish t)
;          ("c" "org-protocol-capture" entry (file ,(concat gas/org-agenda-directory "inbox.org"))
;               "* TODO [[%:link][%:description]]\n\n %i"
;               :immediate-finish t)
;          ("w" "Weekly Review" entry (file+olp+datetree ,(concat gas/org-agenda-directory "reviews.org"))
;           (file ,(concat gas/org-agenda-directory "templates/weekly_review.org")))
;           ))


(setq-default org-tag-alist (quote (("@errand"     . ?e)
                                    ("@bureau"    . ?o)
                                    ("@maison"    . ?h)
                                    ("important"  . ?i)
                                    ("urgent"     . ?u)

                                    (:newline)
                                    ("ATTENDRE"  . ?w)
                                    ("SUSPENDUÉ" . ?h)
                                    ("ANNULÉ"    . ?c)
                                    ("RÉUNION"   . ?m)
                                    ("TÉLÉPHONE" . ?p)
                                    ("french"    . ?f)
                                    ("spanish"   . ?s))))

 (setq  org-highest-priority ?A
   org-default-priority ?C
   org-lowest-priority  ?D)

  (setq org-fast-tag-selection-single-key nil)

 (defvar gas/org-agenda-bulk-process-key ?f
   "Default key for bulk processing inbox items.")

 (defun gas/org-process-inbox ()
   "Called in org-agenda-mode, processes all inbox items."
   (interactive)
   (org-agenda-bulk-mark-regexp "inbox:")
   (gas/bulk-process-entries))

 (defvar gas/org-current-effort "1:00"
   "Current effort for agenda items.")

 (defun gas/my-org-agenda-set-effort (effort)
   "Set the effort property for the current headline."
   (interactive
    (list (read-string (format "Effort [%s]: " gas/org-current-effort) nil nil gas/org-current-effort)))
   (setq gas/org-current-effort effort)
   (org-agenda-check-no-diary)
   (let* ((hdmarker (or (org-get-at-bol 'org-hd-marker)
                        (org-agenda-error)))
          (buffer (marker-buffer hdmarker))
          (pos (marker-position hdmarker))
          (inhibit-read-only t)
          newhead)
     (org-with-remote-undo buffer
       (with-current-buffer buffer
         (widen)
         (goto-char pos)
         (org-show-context 'agenda)
         (funcall-interactively 'org-set-effort nil gas/org-current-effort)
         (end-of-line 1)
         (setq newhead (org-get-heading)))
       (org-agenda-change-all-lines newhead hdmarker))))

 (defun gas/org-agenda-process-inbox-item ()
   "Process a single item in the org-agenda."
   (org-with-wide-buffer
    (org-agenda-set-tags)
    (org-agenda-priority)
    (call-interactively 'gas/my-org-agenda-set-effort)
    (org-agenda-refile nil nil t)))

;; (defun gas/bulk-process-entries ()
;;   (if (not (null org-agenda-bulk-marked-entries))
;;       (let ((entries (reverse org-agenda-bulk-marked-entries))
;;             (processed 0)
;;             (skipped 0))
;;         (dolist (e entries)
;;           (let ((pos (text-property-any (point-min) (point-max) 'org-hd-marker e)))
;;             (if (not pos)
;;                 (progn (message "Skipping removed entry at %s" e)
;;                        (cl-incf skipped))
;;               (goto-char pos)
;;               (let (org-loop-over-headlines-in-active-region) (funcall 'gas/org-agenda-process-inbox-item))
;;               ;; `post-command-hook' is not run yet.  We make sure any
;;               ;; pending log note is processed.
;;               (when (or (memq 'org-add-log-note (default-value 'post-command-hook))
;;                         (memq 'org-add-log-note post-command-hook))
;;                 (org-add-log-note))
;;               (cl-incf processed))))
;;         (org-agenda-redo)
;;         (unless org-agenda-persistent-marks (org-agenda-bulk-unmark-all))
;;         (message "Acted on %d entries%s%s"
;;                  processed
;;                  (if (= skipped 0)
;;                      ""
;;                    (format ", skipped %d (disappeared before their turn)"
;;                            skipped))
;;                  (if (not org-agenda-persistent-marks) "" " (kept marked)")))))

(defun gas/org-inbox-capture ()
  (interactive)
  "Capture a task in agenda mode."
  (org-capture nil "i"))

(setq org-agenda-bulk-custom-functions `((,gas/org-agenda-bulk-process-key gas/org-agenda-process-inbox-item)))
;;
(map! :map org-agenda-mode-map
      "i" #'org-agenda-clock-in
      "r" #'gas/org-process-inbox
      "R" #'org-agenda-refile
      "c" #'gas/org-inbox-capture)
(defvar gas/organisation-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")
(defun gas/set-todo-state-next ()
  "Visit each parent task and change NEXT states to TODO"
  (org-todo "SUIV"))


(add-hook 'org-clock-in-hook 'gas/set-todo-state-next 'append)

(use-package! org-clock-convenience
              :bind (:map org-agenda-mode-map
                     ("<S-up>" . org-clock-convenience-timestamp-up)
                     ("<S-down>" . org-clock-convenience-timestamp-down)
                     ("o" . org-clock-convenience-fill-gap)
                     ("e" . org-clock-convenience-fill-gap-both)))

;; (use-package! org-super-agenda
;;   :after org-agenda
;;   :config
;;   (setq org-super-agenda-groups '((:auto-dir-name t)))
;;   (org-super-agenda-mode))

(use-package! org-archive
  :after org
  :config
  (setq org-archive-location "archive.org::datetree/"))

(after! org-clock
  (setq org-clock-persist t)
  (org-clock-persistence-insinuate))

;; (use-package! org-gtd
;;   :after org
;;   :config
;;   ;; where org-gtd will put its files. This value is also the default one.
;;   (setq org-gtd-directory "~/org/gtd/")
;;   ;; package: https://github.com/Malabarba/org-agenda-property
;;   ;; this is so you can see who an item was delegated to in the agenda
;;   (setq org-agenda-property-list '("DELEGATED_TO"))
;;   ;; I think this makes the agenda easier to read
;;   (setq org-agenda-property-position 'next-line)
;;   ;; package: https://www.nongnu.org/org-edna-el/
;;   ;; org-edna is used to make sure that when a project task gets DONE,
;;   ;; the next TODO is automatically changed to NEXT.
;;   (setq org-edna-use-inheritance t)
;;   (org-edna-load)
;;   :bind
;;   (("C-c d c" . org-gtd-capture) ;; add item to inbox
;;    ("C-c d a" . org-agenda-list) ;; see what's on your plate today
;;    ("C-c d p" . org-gtd-process-inbox) ;; process entire inbox
;;    ("C-c d n" . org-gtd-show-all-next) ;; see all NEXT items
;;    ;; see projects that don't have a NEXT item
;;    ("C-c d s" . org-gtd-show-stuck-projects)
;;    ;; the keybinding to hit when you're done editing an item in the
;;    ;; processing phase
;;    ("C-c d f" . org-gtd-clarify-finalize)))

;; (after! (org-gtd org-capture)
;;   (add-to-list 'org-capture-templates
;;                '("i" "GTD item"
;;                  entry
;;                  (file (lambda () (org-gtd--path org-gtd-inbox-file-basename)))
;;                  "* %?\n%U\n\n  %i"
;;                  :kill-buffer t))
;;   (add-to-list 'org-capture-templates
;;                '("l" "GTD item with link to where you are in emacs now"
;;                  entry
;;                  (file (lambda () (org-gtd--path org-gtd-inbox-file-basename)))
;;                  "* %?\n%U\n\n  %i\n  %a"
;;                  :kill-buffer t))
;;   (add-to-list 'org-capture-templates
;;                '("m" "GTD item with link to current Outlook mail message"
;;                  entry
;;                  (file (lambda () (org-gtd--path org-gtd-inbox-file-basename)))
;;                  "* %?\n%U\n\n  %i\n  %(org-mac-outlook-message-get-links)"
;;                  :kill-buffer t)))

;; (defadvice! +zz/load-org-gtd-before-capture (&optional goto keys)
;;     :before #'org-capture
;;     (require 'org-capture)
;;     (require 'org-gtd))

;; (use-package! org-superstar
;;    :config
;;    (setq  org-superstar-todo-bullet-alist
;;        '(("TODO" . 9744)
;;          ("[ ]"  . 9744)
;;          ("FINI" . 9745)
;;          ("[X]"  . 9745))))

(use-package! org-agenda
              :init
              (map! "<f1>" #'gas/switch-to-agenda)
                                        ;  (setq org-agenda-block-separator nil
                                        ;        org-agenda-start-with-log-mode t)
              (defun gas/switch-to-agenda ()
                (interactive)
                (org-agenda nil " "))
              :config
                                        ;  (setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)" )
              (setq org-agenda-custom-commands
                    (quote ((""
                             (
                              (org-agenda-skip-scheduled-if-done nil)
                              (org-agenda-time-leading-zero nil)
                              (org-agenda-timegrid-use-ampm nil)
                              (org-agenda-skip-timestamp-if-done t)
                              (org-agenda-skip-deadline-if-done t)
                              (org-agenda-start-day "+0d")
                              (org-agenda-span 2)
                              (org-agenda-overriding-header "⚡ Calendrier")
                              (org-agenda-repeating-timestamp-show-all nil)
                              (org-agenda-remove-tags t)
                              (org-agenda-prefix-format "   %i %?-2 t%s")
                              ;; (org-agenda-prefix-format "  %-3i  %-15b%t %s")
                              ;; (concat "  %-3i  %-15b %t%s" org-agenda-hidden-separator))
                              ;; (org-agenda-todo-keyword-format " ☐ ")
                              (org-agenda-todo-keyword-format "")
                              (org-agenda-time)
                              (org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈ Now")
                              (org-agenda-scheduled-leaders '("" ""))
                              (org-agenda-deadline-leaders '("Deadline: " "Deadline: "))
                              (org-agenda-time-grid (quote ((today require-timed remove-match) () "      " "┈┈┈┈┈┈┈┈┈┈┈┈┈")))))
                            ("N" "Notes" tags "NOTE"
                             ((org-agenda-overriding-header "Notes")
                              (org-tags-match-list-sublevels t)))
                            ("h" "Habitudes" tags-todo "STYLE=\"habit\""
                             ((org-agenda-overriding-header "Habitudes")
                              (org-agenda-sorting-strategy
                               '(todo-state-down priority-down category-keep))))
                            ("e" "Eisenhower Matrix"
                             ((agenda ""
                                      ((org-agenda-overriding-header "Calendrier Eisenhower:")
                                       (org-agenda-show-log t)
                                       (org-agenda-log-mode-items '(clock state))
                                       (org-agenda-category-filter-preset '("-Habitudes"))
                                       (org-agenda-span 5)
                                       (org-agenda-start-on-weekday t)
                                       ;;            (org-agenda-ndays 5)
                                       ;;            (org-agenda-start-day "-2d")
                                       (org-deadline-warning-days 30)))
                              (tags-todo  "+important+urgent\!FINI"
                                          ((org-agenda-overriding-header "Tâches importantes et urgentes")
                                           (org-tags-match-list-sublevels nil)))
                              (tags-todo  "+important-urgent"
                                          ((org-agenda-overriding-header "Tâches importantes mais non urgentes")
                                           (org-tags-match-list-sublevels nil)))
                              (tags-todo "-important+urgent"
                                         ((org-agenda-overriding-header "Tâches urgentes mais sans importance")
                                          (org-tags-match-list-sublevels nil)))
                              (tags-todo "-important-urgent/!TODO"
                                         ((org-agenda-overriding-header "Tâches non importantes ni urgentes")
                                          (org-agenda-category-filter-preset '("-Habitudes"))
                                          (org-tags-match-list-sublevels nil)))
                              (tags-todo "VALUE"
                                         ((org-agenda-overriding-header "Valeurs")
                                          (org-tags-match-list-sublevels nil)))
                              ))
                            (" " "Agenda"
                             ((agenda ""
                                      ((org-agenda-overriding-header "Calendrier d'aujourd'hui:")
                                       (org-agenda-show-log t)
                                       (org-agenda-log-mode-items '(clock state))
                                       ;;   (org-agenda-span 'day)
                                       ;;   (org-agenda-ndays 3)
                                       (org-agenda-start-on-weekday nil)
                                       (org-agenda-start-day "-d")
                                       (org-agenda-todo-ignore-deadlines nil)))
                              (tags-todo "+important"
                                         ((org-agenda-overriding-header "Tâches Importantes à Venir")
                                          (org-tags-match-list-sublevels nil)))
                              (tags-todo "-important"
                                         ((org-agenda-overriding-header "Tâches de Travail")
                                          (org-agenda-category-filter-preset '("-Habitudes"))
                                          (org-agenda-sorting-strategy
                                           '(todo-state-down priority-down))))
                              (tags "REFILE"
                                    ((org-agenda-overriding-header "Tâches à la Représenter")
                                     (org-tags-match-list-sublevels nil))))))))
)

(after! org-agenda
        ;; (setq org-agenda-prefix-format
        ;;       '((agenda . " %i %-12:c%?-12t% s")
        ;;         ;; Indent todo items by level to show nesting
        ;;         (todo . " %i %-12:c%l")
        ;;         (tags . " %i %-12:c")
        ;;         (search . " %i %-12:c")))
        (setq org-agenda-include-diary t)
        (setq  gas/keep-clock-running nil))

(use-package! holidays
  :after org-agenda
  :config
  (require 'nz-holidays)
   (setq holiday-general-holidays nil)
   (setq holiday-christian-holidays nil)
   (setq holiday-hebrew-holidays nil)
   (setq holiday-islamic-holidays nil)
   (setq holiday-bahai-holidays nil)
   (setq holiday-oriental-holidays nil)

   (setq calendar-holidays (append calendar-holidays holiday-nz-holidays))
  )
;;(use-package! org-gcal
;;  :after '(auth-source-pass password-store)
;;  :config
;;  (setq org-gcal-client-id "887865341451-orrpnv3cu0fnh8hdtge77sv6csqilqtu.apps.googleusercontent.com"
;;        org-gcal-client-secret "WmOGOCr_aWPJSqmwXHV-29bv"
;;        org-gcal-file-alist
;;        '(("agasson@ateasystems.com" . "~/org/gtd/calendars/atea-cal.org")
;;          ;;("ateasystems.com_0ie21uc26j0a41g60b8f99mh1k@group.calendar.google.com" . "~/org/gtd/calendars/changecontrol-cal.org")
;;         )))
;;
(use-package! org-roam
  :after org
  :init
  ;;(setq org-roam-v2-ack t)
  :custom
  (setq org-roam-directory "~/org/roam")
  (org-roam-completion-everywhere t)
  :bind (:map org-mode-map
         ("C-M-i" . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-templates))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  )

(use-package! org-fc
  :after org
  :commands org-fc-hydra/body
         :bind ("C-c n r p" . org-fc-hydra/body)
              :defer t
              :config
              (require 'org-fc-hydra)
              (org-fc-directories '("~/org/spaced-repetition/"))
              (add-to-list 'org-fc-custom-contexts
                           '(french-cards . (:filter (tag "french")))))

(use-package! org-journal
  :after org
   :bind
   ("C-c n j" . org-journal-new-entry)
   ("C-c n t" . org-journal-today)
   :config
  ;; (defun org-journal-file-header-func (time)
  ;; "Custom function to create journal header."
  ;; (concat
  ;;   (pcase org-journal-file-type
  ;;     (`daily "#+TITLE: Daily Journal\n#+STARTUP: showeverything")
  ;;     (`weekly "#+TITLE: Weekly Journal\n#+STARTUP: folded")
  ;;     (`monthly "#+TITLE: Monthly Journal\n#+STARTUP: folded")
  ;;     (`yearly "#+TITLE: Yearly Journal\n#+STARTUP: folded"))))

  ;;   (setq org-journal-file-header 'org-journal-file-header-func)
     (setq
  ;;     ;;org-journal-date-prefix "#+TITLE: "
       org-journal-file-format "%Y-%m-%d.org"
       org-journal-dir "~/org/roam/daily"
  ;;     org-journal-skip-carryover-drawers (list "LOGBOOK")
  ;;     ;;org-journal-carryover-items nil
       org-journal-date-format "%A, %d %B %Y")
     (setq org-journal-enable-agenda-integration t)
     )


(use-package! obtt
  :after org
  :init
  (setq! obtt-templates-dir
      (concat
        (if (boundp 'doom-private-dir)
          doom-private-dir
          user-emacs-directory)
        "obtt")
      obtt-seed-name ".obtt")
    :config
    (setq! obtt-project-directory (concat (getenv "HOME") "/Dev/clj" )))

  (when (not (file-directory-p obtt-templates-dir))
    (make-directory obtt-templates-dir))
     ;;   (add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))

);; end of after! org

(after! org
   (appendq! +ligatures-extra-symbols
             `(:checkbox      "☐"
               :pending       "◼"
               :checkedbox    "☑"
               :list_property "∷"
               :results       "🠶"
               :property      "☸"
               :properties    "⚙"
               :end           "∎"
               :options       "⌥"
               :title         "𝙏"
               :subtitle      "𝙩"
               :author        "𝘼"
               :date          "𝘿"
               :latex_header  "⇥"
               :latex_class   "🄲"
               :beamer_header "↠"
               :begin_quote   "❮"
               :end_quote     "❯"
               :begin_export  "⯮"
               :end_export    "⯬"
               :begin_src     "↦"
               :end_src       "⇤"
               :priority_a   ,(propertize "⚑" 'face 'all-the-icons-red)
               :priority_b   ,(propertize "⬆" 'face 'all-the-icons-orange)
               :priority_c   ,(propertize "■" 'face 'all-the-icons-yellow)
               :priority_d   ,(propertize "⬇" 'face 'all-the-icons-green)
               :priority_e   ,(propertize "❓" 'face 'all-the-icons-blue)
               :em_dash       "—"))

         (set-ligatures! 'org-mode
           :merge t
           :checkbox      "[ ]"
           :pending       "[-]"
           :checkedbox    "[X]"
           :list_property "::"
           :results       "#+results:"
           :property      "#+property:"
           :property      ":PROPERTIES:"
           :end           ":END:"
           :options       "#+options:"
           :title         "#+title:"
           :subtitle      "#+subtitle:"
           :author        "#+author:"
           :date          "#+date:"
           :latex_class   "#+latex_class:"
           :latex_header  "#+latex_header:"
           :beamer_header "#+beamer_header:"
           :begin_quote   "#+begin_quote"
           :end_quote     "#+end_quote"
           :begin_export  "#+begin_export"
           :end_export    "#+end_export"
           :begin_src     "#+begin_src"
           :end_src       "#+end_src"
           :priority_a    "[#A]"
           :priority_b    "[#B]"
           :priority_c    "[#C]"
           :priority_d    "[#D]"
           :priority_e    "[#E]"
           :em_dash       "---")
         ;;         (plist-put +ligatures-extra-symbols :name "⁍")      ; or › could be good?
         )

(use-package! org-ol-tree
  :after org)

(use-package! org-ml
  :after org)

(use-package! org-ql
  :after org)

(defun zz/headings-with-tags (file tags)
  (string-join
   (org-ql-select file
     `(tags-local ,@tags)
     :action '(let ((title (org-get-heading 'no-tags 'no-todo)))
                (concat "- "
                        (org-link-make-string
                         (format "file:%s::*%s" file title)
                         title))))
   "\n"))

(defun zz/headings-with-current-tags (file)
  (let ((tags (s-split ":" (cl-sixth (org-heading-components)) t)))
    (zz/headings-with-tags file tags)))

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(provide '+org)
;;; +org ends here
