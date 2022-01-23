;; Initial stuff
(setq inhibit-startup-message t) ; Remove startup message

(scroll-bar-mode -1)	; Disable the visible scroll bar
(tool-bar-mode -1)	; Disable the toolbar
(tooltip-mode -1)	; Disable tooltips
(set-fringe-mode 10)	; Give some breathing room

(menu-bar-mode -1)	; Disable the menu bar

;; (load-theme 'wombat)	; Load up a theme on startup for emacs

;; ------------------------------------------------------------------

;; Make ESC or C-[ quit prompts to satisfy my addiction
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

;; Enable the use SPC as a prefix in emacs
;; (general-def :states '(normal motion emacs) "SPC" nil)

;; Stop cursor from jumping to the center while scrolling
(setq scroll-conservatively 101)  ; A value above 100 prevents redisplaying to the center

;; ------------------------------------------------------------------

;; Initialize package resources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ------------------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (doom-themes which-key evil magit doom-modeline ivy use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ------------------------------------------------------------------
;;			Package Installations
;; ------------------------------------------------------------------

;; Install swiper
(use-package swiper)

;; Install ivy
(use-package ivy
  :ensure t
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))	; Run ivy by default

;; Install evil mode
(use-package evil
  :ensure t	; Install evil if not installed
  :config
  (define-key evil-motion-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-normal-state-map (kbd "SPC b k") 'kill-current-buffer)
  ;; (setq evil-want-C-u-scroll )
  (evil-mode 1))
  ;;(global-set-key (kbd "C-u") 'evil-scroll-up)  ; Run evil mode by default

;; Install doom themes
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; If nil, bold is universally disabled
        doom-themes-enable-italic t) ; If nil, italics is universally disabled
  (load-theme 'doom-one t))

;; Set up doom modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25)) ; This isn't working for values below 25

;; To make doom modeline height smaller
;; (defun my-doom-modeline--font-height ()
;;   "Calculate the actual char height of the mode-line."
;;   (+ (frame-char-height) 0.95)))
;; (advice-add #'doom-modeline--font-height :override #'my-doom-modeline--font-height)

;; Install magit
(use-package magit
  :ensure t
  :config
  (define-key evil-normal-state-map (kbd "SPC g g") 'magit-status))

;; Install which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode 1))
