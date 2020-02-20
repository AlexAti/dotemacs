(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(setq mac-right-option-modifier nil) ; liberating AltGr

(require 'package)
(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)
(add-to-list 'package-archives (cons "org" "https://orgmode.org/elpa/") t)
(package-initialize)

(require 'use-package) ; we assume it is installed
(require 'use-package-ensure) ; we assume it is installed
(setq use-package-always-ensure t) ; from now on all assumptions will be ensured

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package super-save
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t)
  (setq super-save-remote-files nil))

(use-package  helm)
(use-package  projectile)
(use-package  helm-projectile)

(use-package  clojure-mode)
(use-package  clj-refactor)
(use-package  cider)

(use-package  magit)
(use-package  git-gutter
  :init (global-git-gutter-mode t))

(use-package  better-defaults)
(use-package atom-one-dark-theme
  :config
  ;; Not only configuring this package but all gui, really
  (load-theme 'atom-one-dark t)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (setq initial-buffer-choice
        (lambda ()
          (org-agenda-list 1)
          (get-buffer "Org Agenda*"))))

(use-package rainbow-delimiters
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))
(use-package paredit)
(use-package smart-tab)
(use-package smart-yank)
(use-package parinfer
  :bind (:map parinfer-mode-map
         ("M-r" . parinfer-raise-sexp)
         ("<tab>" . parinfer-smart-tab:dwim-right-or-complete)
         ("S-<tab>" . parinfer-smart-tab:dwim-left)
         ("C-," . parinfer-toggle-mode))
  :init ; before load
  (require 'ediff)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq parinfer-lighters '(" Parinfer:Ind" . " Parinfer:Par"))
  (setq parinfer-extensions '(defaults smart-tab smart-yank paredit))
  (setq parinfer-auto-switch-indent-mode-when-closing t)
  :hook (clojure-mode
	 emacs-lisp-mode
	 common-lisp-mode
	 lisp-mode)
  :config ; after load
  (parinfer-strategy-add 'default 'newline-and-indent)
  (parinfer-strategy-add 'instantly
    '(parinfer-smart-tab:dwim-right-or-complete
      parinfer-smart-tab:dwim-left)))

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
  (setq org-agenda-files '("C:\\Users\\aatienza\\Documents\\Org files")
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
  (add-to-list 'org-modules 'org-drill t)
  (add-to-list 'org-modules 'org-depend t)
  (setq org-todo-keywords '((sequence "TODO" "NEXT" "|" "DONE" "CANCELLED"))))

(setq inhibit-compacting-font-caches t)
;; this is for general unicode issues in windows, not only for org-bullets
;; see https://github.com/sabof/org-bullets/issues/11for more details

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-info org-irc org-mhe org-rmail org-w3m org-drill org-depend)))
 '(package-selected-packages
   (quote
    (org-drill elpy parinfer smart-yank smart-tab pretty-parens atom-one-dark-theme better-defaults magit clj-refactor clojure-mode helm-projectile projectile helm auto-package-update use-package-ensure-system-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
