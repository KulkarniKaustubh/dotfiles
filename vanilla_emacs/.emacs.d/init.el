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

;; Stop cursor from jumping to the center while scrolling
(setq scroll-conservatively 101)  ; A value above 100 prevents redisplaying to the center

;; Enable the use SPC as a prefix in emacs
;; (general-def :states '(normal motion emacs) "SPC" nil)

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

;; Enable line numbers in files
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes like shell mode
(dolist (mode '(org-mode-hook
                term-mode-hook
  		shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; ------------------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("47db50ff66e35d3a440485357fb6acb767c100e135ccdf459060407f8baea7b2" "4b0e826f58b39e2ce2829fab8ca999bcdc076dec35187bf4e9a4b938cb5771dc" "da186cce19b5aed3f6a2316845583dbee76aea9255ea0da857d1c058ff003546" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" default)))
 '(package-selected-packages
   (quote
    (smex helpful undo-tree counsel ivy-rich doom-themes which-key evil magit doom-modeline ivy use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ------------------------------------------------------------------
;;			Package Installations
;; ------------------------------------------------------------------

;; Install evil mode
(use-package evil
  :config
  (define-key evil-motion-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-normal-state-map (kbd "SPC b k") 'kill-current-buffer)
  ;; overwrite 'evil-search-forward search with swiper 
  (define-key evil-normal-state-map (kbd "/") 'swiper)
  ;; (setq evil-want-C-u-scroll )
  (evil-mode 1))
  ;;(global-set-key (kbd "C-u") 'evil-scroll-up)  ; Run evil mode by default

;; Fix evil-mode redo with undo tree
(use-package undo-tree
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1))

;; Install swiper
(use-package swiper)

;; Install ivy
(use-package ivy
  :diminish
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

;; Install counsel
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ;; ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

;; Install smart M-x
(use-package smex)

;; Install ivy-rich, provides details in ivy
(use-package ivy-rich
  :init (ivy-rich-mode))

;; Install doom themes
(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; If nil, bold is universally disabled
        doom-themes-enable-italic t) ; If nil, italics is universally disabled
  (load-theme 'doom-palenight t))

;; Install rainbow delimiters (paranthesis highlighter)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Set up doom modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))  ; This isn't working for values below 25
  ;; :config
  ;; (setq doom-modeline-height 25)) 

;; To make doom modeline height smaller
;; (defun my-doom-modeline--font-height ()
;;   "Calculate the actual char height of the mode-line."
;;   (+ (frame-char-height) 0.95)))
;; (advice-add #'doom-modeline--font-height :override #'my-doom-modeline--font-height)

;; Install magit
(use-package magit
  :config
  (define-key evil-normal-state-map (kbd "SPC g g") 'magit-status))

;; Install which-key
(use-package which-key
  :init (which-key-mode))

;; Install helpful
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))
