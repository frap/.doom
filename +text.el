;;; +text.el -*- lexical-binding: t; -*-

(after! text-mode
  (setq-hook! 'text-mode-hook truncate-lines nil tab-width 2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ORG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-directory (expand-file-name "~/logseq")
      org-agenda-directory (expand-file-name "~/dev/work/agenda")
      org-agenda-files (list org-agenda-directory)
      org-ellipsis " ▼ "
      org-hide-emphasis-markers t
      org-babel-python-command "python3"
      ;; The standard unicode characters are usually misaligned depending on the
      ;; font. This bugs me. Markdown #-marks for headlines are more elegant.
      org-bullets-bullet-list '("#"))

(after! org-agenda
  ;; https://old.reddit.com/r/emacs/comments/hnf3cw/my_orgmode_agenda_much_better_now_with_category/
  (setq org-agenda-category-icon-alist
        `(("work" ,(list (all-the-icons-material "work")) nil nil :ascent center)
          ("chore" ,(list (all-the-icons-material "home")) nil nil :ascent center)
          ("events" ,(list (all-the-icons-material "event")) nil nil :ascent center)
          ("todo" ,(list (all-the-icons-material "check_box")) nil nil :ascent center)
          ("solution" ,(list (all-the-icons-material "done")) nil nil :ascent center)
          ("birthday" ,(list (all-the-icons-material "cake")) nil nil :ascent center)
          ("anniversary" ,(list (all-the-icons-material "favorite")) nil nil :ascent center))))


(after! org
  (setq org-capture-templates
        '(("t" "Personal todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* TODO %?\n%i" :prepend t :kill-buffer t)
          ("n" "Personal notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i" :prepend t :kill-buffer t)

          ;; Will use {project-root}/{todo,notes,changelog}.org, unless a
          ;; {todo,notes,changelog}.org file is found in a parent directory.
          ("p" "Templates for projects")
          ("pt" "Project todo" entry       ; {project-root}/todo.org
           (file+headline +org-capture-project-todo-file "Inbox")
           "* TODO %?\n%i" :prepend t :kill-buffer t)
          ("pn" "Project notes" entry      ; {project-root}/notes.org
           (file+headline +org-capture-project-notes-file "Inbox")
           "* TODO %?\n%i" :prepend t :kill-buffer t)
          ("pc" "Project changelog" entry  ; {project-root}/changelog.org
           (file+headline +org-capture-project-notes-file "Unreleased")
           "* TODO %?\n%i" :prepend t :kill-buffer t)))

  (setq org-log-into-drawer "LOGBOOK")


  ;; Schedule/deadline popup with default time
  (defvar org-default-time "10:30"
    "The default time for deadlines.")

  (defun advise-org-default-time (func arg &optional time)
    (let ((old-time (symbol-function #'org-read-date)))
      (cl-letf (((symbol-function #'org-read-date)
                 #'(lambda (&optional a b c d default-time f g)
                     (let ((default-time (or default-time
                                             org-default-time)))
                       (apply old-time a b c d f default-time g)
                       ))))
        (apply func arg time))))

  (advice-add #'org-deadline :around #'advise-org-default-time)
  (advice-add #'org-schedule :around #'advise-org-default-time))

(after! ox-pandoc
  (setq org-pandoc-options-for-revealjs '((variable . "highlight-theme=github")
                                          (variable . "theme=white"))))

(provide '+text)
