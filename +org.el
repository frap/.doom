;;; ~/DOOMDIR/+org.el -*- lexical-binding: t; -*-

(add-hook! 'org-mode-hook #'+org-pretty-mode #'mixed-pitch-mode)


(add-hook! 'org-mode-hook (company-mode -1))
(add-hook! 'org-capture-mode-hook (company-mode -1))
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq
  org-directory "~/org/"
;;  org-use-property-inheritance t              ; it's convenient to have properties inherited
;;  org-list-allow-alphabetical t               ; have a. A. a) A) list bullets
  org-export-in-background t                  ; run export processes in external emacs process
;;  org-catch-invisible-edits 'smart            ; try not to accidently do weird stuff in invisible regions
;;  org-re-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"
  ;;-ellipsis " ▼ "
 org-ellipsis " ▾ "
 org-bullets-bullet-list '("·")
 org-tags-column -80
 org-agenda-files (ignore-errors (directory-files +org-dir t "\\.org$" t))
 ;;Enable logging of done tasks, and log stuff into the LOGBOOK drawer by default
 org-log-done 'time
 org-log-into-drawer t

 )


;; (after! org
;;         (require 'ob-clojure)
;;         (setq org-babel-clojure-backend 'cider)
;;         (require 'cider)
;;         )

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


;; (defun zz/adjust-org-company-backends ()
;;   (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
;;   (setq-local company-backends nil))
;; (add-hook! org-mode (zz/adjust-org-company-backends))
;; ;; Enable variable and visual line mode in Org mode by default.
;; (add-hook! org-mode :append
;;            #'visual-line-mode
;;            #'variable-pitch-mode)

(after! org
        (set-face-attribute 'org-link nil
                            :weight 'normal
                            :background nil)
        (set-face-attribute 'org-code nil
                            :foreground "#a9a1e1"
                            :background nil)
        (set-face-attribute 'org-date nil
                            :foreground "#5B6268"
                            :background nil)
        (set-face-attribute 'org-level-1 nil
                            :foreground "steelblue2"
                            :background nil
                            :height 1.2
                            :weight 'normal)
        (set-face-attribute 'org-level-2 nil
                            :foreground "slategray2"
                            :background nil
                            :height 1.0
                            :weight 'normal)
        (set-face-attribute 'org-level-3 nil
                            :foreground "SkyBlue2"
                            :background nil
                            :height 1.0
                            :weight 'normal)
        (set-face-attribute 'org-level-4 nil
                            :foreground "DodgerBlue2"
                            :background nil
                            :height 1.0
                            :weight 'normal)
        (set-face-attribute 'org-level-5 nil
                            :weight 'normal)
        (set-face-attribute 'org-level-6 nil
                            :weight 'normal)
        (set-face-attribute 'org-document-title nil
                            :foreground "SlateGray1"
                            :background nil
                            :height 1.75
                            :weight 'bold)
        (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕"))        )

(after! org
        (setq org-agenda-files
              '("~/org/gtd" "~/work/work.org.gpg" "~/org/")))

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
        (setq gas/org-agenda-directory "~/org/")
        (defconst gas-org-agenda-file (concat gas/org-agenda-directory "todo.org"))
        ;; set agenda files
        ;;(setq org-agenda-files (list gas/org-agenda-directory))
        ;; (setq org-agenda-files
        ;;      (find-lisp-find-files gas/org-agenda-directory "\.org$"))

        ;;((alist-get 'name +org-capture-frame-parameters) "❖ Capture") ;; ATM hardcoded in other places, so changing breaks stuff
        (setq +org-capture-fn
              (lambda ()
                (interactive)
                (set-window-parameter nil 'mode-line-format 'none)
                (org-capture)))

        ;; HACK Face specs fed directly to `org-todo-keyword-faces' don't respect
        ;;      underlying faces like the `org-todo' face does, so we define our own
        ;;      intermediary faces that extend from org-todo.
        (with-no-warnings
          (custom-declare-face '+org-todo-active  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
          (custom-declare-face '+org-todo-project '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
          (custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) "")
          (custom-declare-face '+org-todo-cancel  '((t (:inherit (bold error org-todo)))) ""))

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

        (setq  org-capture-templates '(("n" "Note" entry
                                        (file+olp+datetree "journal.org")
                                        "**** [ ] %U %?" :prepend t :kill-buffer t)
                                       ("t" "Tâches" entry
                                        (file+headline "todo.org" "Boîte de réception")
                                        "* [ ] %?\n%i" :prepend t :kill-buffer t)))
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
                            (quote (
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
                                               (org-agenda-ndays 5)
                                               (org-agenda-start-day "-1d")
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
                                               (org-agenda-span 'day)
                                               (org-agenda-ndays 3)
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
        ;;        org-gcal-client-secret "https://calendar.google.com/calendar/ical/agasson%40red-elvis.net/private-62c6600e3630e19e84be9564abceca94/basic.ics"
        ;;        org-gcal-file-alist
        ;;        '(("agasson@ateasystems.com" . "~/org/gtd/calendars/atea-cal.org")
        ;;          ;;("ateasystems.com_0ie21uc26j0a41g60b8f99mh1k@group.calendar.google.com" . "~/org/gtd/calendars/changecontrol-cal.org")
        ;;         )))
        ;;
        (use-package! org-roam
                      :after org
                      :init
                      ;; (setq org-roam-v2-ack t) ;; acknowledge v2 upgrade
                      :custom
                      (org-roam-completion-everywhere t)
                      (setq org-roam-directory "~/org/roam")
                      ;; :bind (;;("C-c n l" . org-roam-buffer-toggle)
                      ;;        ;;("C-c n f" . org-roam-node-find)
                      ;;        ;;("C-c n i" . org-roam-node-insert)
                      ;;        :map org-mode-map
                      ;;        ("C-M-i" . completion-at-point)
                      ;;        ;;:map org-roam-dailies-map
                      ;;        ;;("Y" . org-roam-dailies-capture-templates)
                      ;;        )
                      ;;:bind-keymap
                      ;;("C-c n d" . org-roam-dailies-map)
                      :config
                      ;; Let's set up some org-roam capture templates
                      (setq org-roam-capture-templates
                            '(("d" "default" plain  "%?"
                               :if-new (file+head "${slug}.org"
                                                  "#+title: ${title}\n#+date: %u\n#+lastmod: \n\n")
                               :immediate-finish t))
                            time-stamp-start "#\\+lastmod: [\t]*")

                      ;; And now we set necessary variables for org-roam-dailies
                      (setq org-roam-dailies-capture-templates
                            '(("d" "default" entry     "* %?"
                               :if-new (file+head "%<%Y-%m-%d>.org"
                                                  "#+title: %<%Y-%m-%d>\n\n"))))
                      )

        ;; (after! org-roam
        ;;   (add-hook 'after-init-hook 'org-roam-mode))

        (use-package! orgdiff
                      :defer t
                      :config
                      (defun +orgdiff-nicer-change-colours ()
                        (goto-char (point-min))
                        ;; Set red/blue based on whether chameleon is being used
                        (if (search-forward "%% make document follow Emacs theme" nil t)
                            (setq red  (substring (doom-blend 'red 'fg 0.8) 1)
                                  blue (substring (doom-blend 'blue 'teal 0.6) 1))
                          (setq red  "c82829"
                                blue "00618a"))
                        (when (and (search-forward "%DIF PREAMBLE EXTENSION ADDED BY LATEXDIFF" nil t)
                                   (search-forward "\\RequirePackage{color}" nil t))
                          (when (re-search-forward "definecolor{red}{rgb}{1,0,0}" (cdr (bounds-of-thing-at-point 'line)) t)
                            (replace-match (format "definecolor{red}{HTML}{%s}" red)))
                          (when (re-search-forward "definecolor{blue}{rgb}{0,0,1}" (cdr (bounds-of-thing-at-point 'line)) t)
                            (replace-match (format "definecolor{blue}{HTML}{%s}" blue)))))
                      (add-to-list 'orgdiff-latexdiff-postprocess-hooks #'+orgdiff-nicer-change-colours))

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
                      ;; :bind
                      ;; ("C-c n j" . org-journal-new-entry)
                      ;; ("C-c n t" . org-journal-today)
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
                       org-journal-date-prefix "#+title: "
                       org-journal-file-format "%Y-%m-%d.org"
                       org-journal-time-prefix "* "
                       org-journal-dir "~/org/roam/daily"
                       ;;     org-journal-skip-carryover-drawers (list "LOGBOOK")
                       ;;     ;;org-journal-carryover-items nil
                       org-journal-date-format "%a, %Y-%m-%d")
                      ;; (setq org-journal-enable-agenda-integration t)
                      )

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

;; (use-package! org-auto-tangle
;;   :defer t
;;   :hook (org-mode . org-auto-tangle-mode)
;;   :config
;;   (setq org-auto-tangle-default t))

(setq org-highlight-latex-and-related '(native script entities))
(require 'org-src)
(add-to-list 'org-src-block-faces '("latex" (:inherit default :extend t)))

;; (use-package! org-fragtog
;;   :hook (org-mode . org-fragtog-mode))

(setq org-format-latex-header "\\documentclass{article}
\\usepackage[usenames]{xcolor}

\\usepackage[T1]{fontenc}

\\usepackage{booktabs}

\\pagestyle{empty}             % do not remove
% The settings below are copied from fullpage.sty
\\setlength{\\textwidth}{\\paperwidth}
\\addtolength{\\textwidth}{-3cm}
\\setlength{\\oddsidemargin}{1.5cm}
\\addtolength{\\oddsidemargin}{-2.54cm}
\\setlength{\\evensidemargin}{\\oddsidemargin}
\\setlength{\\textheight}{\\paperheight}
\\addtolength{\\textheight}{-\\headheight}
\\addtolength{\\textheight}{-\\headsep}
\\addtolength{\\textheight}{-\\footskip}
\\addtolength{\\textheight}{-3cm}
\\setlength{\\topmargin}{1.5cm}
\\addtolength{\\topmargin}{-2.54cm}
% my custom stuff
\\usepackage[nofont,plaindd]{bmc-maths}
\\usepackage{arev}
")

;; (setq org-format-latex-options
;;       (plist-put org-format-latex-options :background "Transparent"))

(set-popup-rule! "^\\*Org Agenda" :side 'bottom :size 0.90 :select t :ttl nil)
(set-popup-rule! "^CAPTURE.*\\.org$" :side 'bottom :size 0.90 :select t :ttl nil)
;;(set-popup-rule! "^\\*org-brain" :side 'right :size 1.00 :select t :ttl nil)
(provide '+org)
;;; +org ends here
