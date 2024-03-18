;; Basic configs
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq inhibit-compacting-font-caches t) ; this is for general unicode issues in windows, see https://github.com/sabof/org-bullets/issues/11
;;(set-face-attribute 'default nil :family "Consolas" :height 100)
(setq sentence-end-double-space nil)
(setq mac-right-option-modifier nil) ; liberating AltGr

;; Better automatic file config
(make-directory "~/.tmp/emacs/auto-save/" t)
(setq auto-save-file-name-transforms '((".*" "~/.tmp/emacs/auto-save/" t)))
(setq backup-directory-alist '(("." . "~/.tmp/emacs/backup/")))
(setq backup-by-copying t)
;;(setq create-lockfiles nil) ; risks losing changes if 2 emacs instances open, and I tend to do it...
(setq custom-file (concat user-emacs-directory "custom.el")) ; emacs does not touch .emacs anymore with this
(load custom-file t)

;; Package mgmt initialization
(eval-when-compile
  (require 'package)
  (add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)
  (add-to-list 'package-archives (cons "org" "https://orgmode.org/elpa/") t)
  (package-initialize)
  (require 'use-package) ; we assume it is installed
  (require 'use-package-ensure) ; we assume it is installed
  (setq use-package-always-ensure t) ; ensures all assumptions BUT! forces repo contact at each startup to try install if a package doesnt exist
  )

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-at-time (format-time-string "%H:%M:%S" (time-add (current-time) 120)))) ; Update will happen 120 seconds after startup

;; Look & feel
(use-package better-defaults)
(use-package atom-one-dark-theme
  :config
  ;; Not only configuring this package but all gui, really
  (load-theme 'atom-one-dark t)
  (when (display-graphic-p)
    (tool-bar-mode -1)
    (scroll-bar-mode -1))
  (menu-bar-mode -1))

(use-package super-save
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t)
  (setq super-save-remote-files nil))

;; Completion helpers
(use-package helm)
(use-package projectile)
(use-package helm-projectile)

(ido-mode 1)
(ido-everywhere)
(setq ido-enable-flex-matching t)
;;(fido-mode)
;; highlight end-of-line spaces and end-of-file lines
(setq-default show-trailing-whitespace t)
(setq-default indicate-empty-lines t)

(use-package which-key
  ;;(which-key-setup-minibuffer)
  :config
  (which-key-setup-side-window-right-bottom)
  (setq which-key-idle-delay 0.05))

(use-package smart-tab)
(use-package smart-yank)

;; General programming
(use-package magit)
  ;; :config
  ;; (if (eq system-type 'windows-nt)
  ;;     (progn
  ;;       (setq exec-path (add-to-list 'exec-path "C:/Program Files/Git/bin"))
  ;;       (setenv "PATH" (concat "C:\\Program Files\\Git\\bin;" (getenv "PATH"))))))

(use-package git-gutter
  :init (global-git-gutter-mode t))

(use-package rainbow-delimiters
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; Programming lisp
(use-package flycheck-clj-kondo)
(use-package clojure-mode :config (require 'flycheck-clj-kondo))
(use-package clj-refactor)
(use-package cider)

(use-package dumb-jump
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read))

(use-package paredit
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'paredit-mode)
  (add-hook 'ielm-mode-hook #'paredit-mode)
  (add-hook 'lisp-mode-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode)
  ;(diminish 'paredit-mode "()")
  )

;; Programming python
(use-package exec-path-from-shell ; general use but added for finding python executable
  :if (memq window-system '(mac ns x))
  :config
  (setq exec-path-from-shell-variables '("PATH" "PYTHONPATH"))
  (exec-path-from-shell-initialize))
(use-package elpy
  :commands elpy-enable
  :init
  (setq python-shell-interpreter "jupyter"
        python-shell-interpreter-args "console --simple-prompt"
        python-shell-prompt-detect-failure-warning nil)
  (elpy-enable))

(use-package flycheck ; an improvement over the built-in flymake (autocompletion)
  :init
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode)) ; installed for python

;; Org mode
(use-package org
  :ensure org-plus-contrib
  :bind (:map global-map
              ("\C-cl" . org-store-link) ; to store links at any place
              ("\C-cc" . org-capture)
              ("\C-ca" . org-agenda))
  :init
  ;; Refiling options, from https://blog.aaronbieber.com/2017/03/19/organizing-notes-with-refile.htlm
  (setq org-refile-targets '((nil :maxlevel . 9)
                             (org-agenda-files :maxlevel . 9)))
  (setq org-refile-use-outline-path t)                  ; Show full paths for refiling
  (setq org-outline-path-complete-in-steps nil)         ; Refile in a single go
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  ;; Capture options
  (setq org-default-notes-file "C:\\Users\\aatienza\\Documents\\Org files/inbox.org")
  (setq org-log-done t) ; timestamps when something is moved to DONE
  ;; Other agenda options
  (setq org-agenda-skip-unavailable-files t) ; to avoid a warning at init
  (setq org-agenda-files (if (eq system-type 'windows-nt)
                             '("C:\\Users\\aatienza\\Documents\\Org files")
                           '("~/Org files"))
        org-agenda-start-on-weekday nil
        org-agenda-span 7
        org-agenda-start-day "-2d")
  (add-hook 'org-mode-hook
            (lambda ()
              (variable-pitch-mode 1)
              (set-face-attribute 'org-table nil :inherit 'fixed-pitch) ; override variable pitch for tables
              visual-line-mode))
  :config
  (setq org-special-ctrl-k t)
  (setq org-enforce-todo-dependencies t
        org-load-modules-maybe t
        org-enforce-todo-checkbox-dependencies t)
  (setq org-agenda-dim-blocked-tasks t)
  (setq org-startup-indented t
        org-src-tab-acts-natively t)
  (setq org-hide-emphasis-markers t
        org-fontify-done-headline t
        org-hide-leading-stars t
        org-pretty-entities t
        org-odd-levels-only nil)
  (add-hook 'after-init-hook '(lambda ()
                                (org-tags-view t "TODO=\"NEXT\"")
                                (delete-other-windows)))
  (add-to-list 'org-modules 'org-depend t)
  (setq org-todo-keywords '((sequence "TODO" "NEXT" "|" "DONE" "CANCELLED")))
  (setq org-capture-templates
      '(("t" "Todo" entry (file+headline "" "To Dos")
         "** TODO %?\n  %i\n  %a")
        ("n" "Nota" entry (file+headline "" "Notas")
         "** (título de nota)")
        ("r" "Reunion" entry (file+headline "" "Reuniones")
         "** (asunto de la reunión)\n*** Asistentes\n-\n*** Preguntas\n-\n*** Notas\n-\n*** Mis tareas\n**** TODO \n*** Delegado\n-\n" :clock-in t))))

;; (use-package ob-clojure
;;   :requires (org cider)
;;   :config
;;   (setq org-babel-clojure-backend 'cider))

(use-package org-drill
  :config
  (add-to-list 'org-modules 'org-drill t)
  (setq org-drill-save-buffers-after-drill-sessions-p nil)
  (setq org-drill-scope 'agenda))

(use-package org-bullets
  :custom
  (org-bullets-bullet-list '("◉" "○" "✸" "✿" "✜" "◆" "▶"))
  (org-ellipsis " ⤵")
  :hook (org-mode . org-bullets-mode))

(setq org-replace-disputed-keys t)
(windmove-default-keybindings) ; moving between windows (but clashes with org-mode todos and priorities, which I disabled in the line before)
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)
