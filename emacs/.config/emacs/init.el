(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MINIMAL UI

(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(scroll-bar-mode -1)
(delete-selection-mode t)

(column-number-mode 1)
(show-paren-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)
(global-hl-line-mode 0)

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default compilation-scroll-output t)

(setq visible-bell 0)
(setq bell-volume 0)
(setq ring-bell-function 'flash-mode-line)

(defun flash-mode-line ()
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq use-dialog-box nil)
(setq global-auto-revert-non-file-buffers t)

(add-to-list 'write-file-functions 'delete-trailing-whitespace)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(set-face-attribute 'default nil :height 160)
(set-frame-font "FiraCode Nerd Font Medium" nil t)

(defalias 'yes-or-no-p 'y-or-n-p)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOM FUNCTIONS

(defun insert-current-date () (interactive)
  (insert (shell-command-to-string "echo -n $(date +%Y-%m-%d)")))

(defun insert-current-unix-timestamp () (interactive)
  (insert (shell-command-to-string "echo -n $(date +%s)")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MOVEMENT & EDITING

(setq search-default-mode 'char-fold-to-regexp)
(setq isearch-wrap-pause 'no)

(global-set-key [home] 'move-beginning-of-line)
(global-set-key [end]  'move-end-of-line)

(define-key global-map [C-home] 'beginning-of-buffer)
(define-key global-map [C-end]  'end-of-buffer)

(setq next-line-add-newlines nil)

(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(defun clone-line ()
  (interactive)
  (kill-whole-line)
  (yank)
  (yank)
  (previous-line))

(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (previous-line 2))

(defun move-line-down ()
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))

(global-set-key (kbd "C-c C-c")    'clone-line)
(global-set-key (kbd "C-S-<up>")   'move-line-up)
(global-set-key (kbd "C-S-<down>") 'move-line-down)

(global-set-key
 (kbd "C-c C-i")
 (lambda ()
   (interactive)
   (manual-entry (current-word))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DIRED

(if (eq system-type 'darwin)
    (setq dired-listing-switches "-lahB")
    (setq dired-listing-switches "-lahB --group-directories-first"))

(global-set-key (kbd "C-x C-d") 'dired)
(global-set-key (kbd "C-x d")   'dired-jump)

(when (eq system-type 'darwin)
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (global-set-key [kp-delete] 'delete-char)) ;; sets fn-delete to be right-delete

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MINI-BUFFER HISTORY

(setq history-length 25)
(savehist-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGES

(use-package recentf
  :bind ("C-x C-r" . recentf-open-files)
  :init
  (setq recentf-auto-cleanup 'never
        recentf-max-saved-items 1000
        recentf-save-file (concat user-emacs-directory ".recentf"))
  (global-set-key (kbd "C-x C-r") 'recentf-open-files)
  :config
  (recentf-mode t))

(use-package ido
  :bind ("M-i" . ido-goto-symbol)
  :config
  (setq ido-enable-flex-matching t
        ido-everywhere t
        ido-use-virtual-buffers t
        ido-use-filename-at-point 'guess
        ido-create-new-buffer 'always)
  (ido-mode t))

(use-package tron-legacy-theme
  :ensure t
  :init
  (setq tron-legacy-theme-dark-fg-bright-comments t
        tron-legacy-theme-vivid-cursor nil
        tron-legacy-theme-softer-bg t)
  :config
  (load-theme 'tron-legacy t)
  (set-background-color "#000000"))

(use-package ido-completing-read+
  :ensure t
  :init
  (setq ido-enable-flex-matching t
        ido-everywhere t
        ido-use-filename-at-point 'guess
        ido-create-new-buffer 'always)
  (global-set-key (kbd "M-i") 'ido-goto-symbol)
  :config
  (ido-mode t)
  (ido-everywhere t)
  (ido-ubiquitous-mode t))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :init
  (setq magit-display-buffer-function
        #'magit-display-buffer-fullframe-status-v1)
  (setq magit-completing-read-function 'magit-ido-completing-read))

(use-package which-key
  :ensure t
  :init
  (which-key-setup-minibuffer)
  (setq which-key-show-early-on-c-h t)
  :config
  (which-key-mode))

(use-package helpful
  :ensure t
  :init
  (global-set-key (kbd "C-h f")   #'helpful-callable)
  (global-set-key (kbd "C-h v")   #'helpful-variable)
  (global-set-key (kbd "C-h k")   #'helpful-key)
  (global-set-key (kbd "C-h x")   #'helpful-command)
  (global-set-key (kbd "C-c C-d") #'helpful-at-point))

(use-package company
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.3)
  (global-company-mode t))

(with-eval-after-load 'company
  (define-key company-active-map
              (kbd "TAB")
              #'company-complete-common-or-cycle)
  (define-key company-active-map
              (kbd "<backtab>")
              (lambda ()
                (interactive)
                (company-complete-common-or-cycle -1))))

(use-package org
  :ensure t
  :config
  (setq-default org-startup-indented t
                org-pretty-entities t
                org-use-sub-superscripts "{}"
                org-hide-emphasis-markers t
                org-startup-with-inline-images t
                org-image-actual-width '(300)))
