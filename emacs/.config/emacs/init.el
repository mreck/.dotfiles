(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MINIMAL UI

(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(save-place-mode 1)
(global-auto-revert-mode 1)

(setq visible-bell 0)
(setq bell-volume 0)
(setq ring-bell-function 'ignore)
(setq ring-bell-function 'flash-mode-line)
(defun flash-mode-line ()
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq use-dialog-box nil)
(setq global-auto-revert-non-file-buffers t)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(if (eq system-type 'darwin)
    (set-face-attribute 'default nil :height 160)
    (set-face-attribute 'default nil :height 120))
(set-frame-font "FiraCode Nerd Font Medium" nil t)

(defalias 'yes-or-no-p 'y-or-n-p)

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
;; RECENT FILES

(recentf-mode 1)
(setq recentf-max-menu-items 50)
(setq recentf-max-saved-items 50)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MINI-BUFFER HISTORY

(setq history-length 25)
(savehist-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOM VARIABLES FILE

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGES

(use-package tron-legacy-theme
  :ensure t
  :init
  (setq tron-legacy-theme-dark-fg-bright-comments t)
  (setq tron-legacy-theme-vivid-cursor nil)
  (setq tron-legacy-theme-softer-bg t)
  :config
  (load-theme 'tron-legacy t)
  (set-background-color "#000"))

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
