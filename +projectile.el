;;; ../Dev/emacs/doom.d/+projectile.el -*- lexical-binding: t; -*-

(after! projectile
  (setq projectile-globally-ignored-file-suffixes
        '(".elc" ".pyc" ".o" ".snap" ".ttf" ".eot" ".woff" ".woff2" ".svg" ".png" ".jpg" ".gif"))
  )
