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

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq use-dialog-box nil)
(setq global-auto-revert-non-file-buffers t)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq visible-bell nil
      ring-bell-function 'flash-mode-line)
(defun flash-mode-line ()
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))

(if (eq system-type 'darwin)
    (set-face-attribute 'default nil :height 160)
    (set-face-attribute 'default nil :height 120))
(set-frame-font "FiraCode Nerd Font Medium" nil t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MOVEMENT & EDITING

(global-set-key [home] 'move-beginning-of-line)
(global-set-key [end]  'move-end-of-line)

(define-key global-map [C-home] 'beginning-of-buffer)
(define-key global-map [C-end]  'end-of-buffer)

(setq next-line-add-newlines nil)

(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(global-set-key
 (kbd "C-c C-i")
 (lambda ()
   (interactive)
   (manual-entry (current-word))))

(defun clone-line ()
  (interactive)
  (kill-whole-line)
  (yank)
  (yank)
  (previous-line))

(global-set-key (kbd "C-c C-c") 'clone-line)

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
;; IDO MODE

(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)
(global-set-key (kbd "M-i") 'ido-goto-symbol)
(ido-mode t)

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

(use-package magit
  :ensure t
  :init
  :config
  )

(use-package which-key
  :ensure t
  :init
  (which-key-setup-minibuffer)
  (setq which-key-show-early-on-C-h t)
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
