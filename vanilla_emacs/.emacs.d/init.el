;; Initial stuff
(setq inhibit-startup-message t) ; Remove startup message

(scroll-bar-mode -1)	; Disable the visible scroll bar
(tool-bar-mode -1)	; Disable the toolbar
(tooltip-mode -1)	; Disable tooltips
(set-fringe-mode 10)	; Give some breathing room

(menu-bar-mode -1)	; Disable the menu bar

;; ------------------------------------------------------------------

;; Make ESC or C-[ quit prompts to satisfy my addiction
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

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
   '("47db50ff66e35d3a440485357fb6acb767c100e135ccdf459060407f8baea7b2" "4b0e826f58b39e2ce2829fab8ca999bcdc076dec35187bf4e9a4b938cb5771dc" "da186cce19b5aed3f6a2316845583dbee76aea9255ea0da857d1c058ff003546" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" default))
 '(package-selected-packages
   '(vterm-toggle vterm evil-collection general smex helpful undo-tree counsel ivy-rich doom-themes which-key evil magit doom-modeline ivy use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ------------------------------------------------------------------
;;                     Package Installations
;; ------------------------------------------------------------------

;; Install evil mode
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; Install evil-collection
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

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
  (ivy-mode 1))   ; Run ivy by default

;; Run to load all icons after ivy
(use-package all-the-icons)

;; Install counsel
(use-package counsel
  :init (counsel-mode)
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
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

;; Install general
(use-package general
  :config
  ; (general-evil-setup t)
  (general-create-definer kaus/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (kaus/leader-keys
    "t"   '(:ignore t :which-key "toggles")
    "tt"  '(counsel-load-theme :which-key "choose theme")
    "gg"  '(magit-status :which-key "magit-status")
    "bk"  '(kill-current-buffer :which-key "kill-current-buffer")
    "ot"  '(vterm-toggle :which-key "vterm-toggle")
    "."   '(dired :which-key "dired")
    "RET" '(counsel-bookmark :which-key "counsel-bookmark")
    ))

;; Install vterm
(use-package vterm)
(use-package vterm-toggle
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (add-to-list 'display-buffer-alist
	       '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
	         (display-buffer-reuse-window display-buffer-at-bottom)
	         ;;(display-buffer-reuse-window display-buffer-in-direction)
	         ;;display-buffer-in-direction/direction/dedicated is added in emacs27
	         (direction . bottom)
	         (dedicated . t) ;dedicated is supported in emacs27
	         (reusable-frames . visible)
	         (window-height . 0.3))))