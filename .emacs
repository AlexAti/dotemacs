(require 'package)
(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)
(package-initialize)

(require 'use-package) ; we assume it is installed
(require 'use-package-ensure) ; we assume it is installed
(setq use-package-always-ensure t) ; from now on all assumptions will be ensured

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

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

(use-package elpy
  :commands elpy-enable
  :init ;(with-eval-after-load 'python
          (elpy-enable))

(use-package org
  :bind (:map global-map
              ("\C-cl" . org-store-link) ; to store links at any place
              ("\C-ca" . org-agenda))
  :init
  (setq org-log-done t) ; timestamps when something is moved to DONE
  (setq org-agenda-files '("C:\\Users\\aatienza\\Documents\\Org files")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (elpy parinfer smart-yank smart-tab pretty-parens atom-one-dark-theme better-defaults magit clj-refactor clojure-mode helm-projectile projectile helm auto-package-update use-package-ensure-system-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
