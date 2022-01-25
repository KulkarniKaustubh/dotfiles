;; Initial stuff
(setq inhibit-startup-message t) ; Remove startup message

(scroll-bar-mode -1)	; Disable the visible scroll bar
(tool-bar-mode -1)	; Disable the toolbar
(tooltip-mode -1)	; Disable tooltips
(set-fringe-mode 10)	; Give some breathing room

(menu-bar-mode -1)	; Disable the menu bar

;; ------------------------------------------------------------------

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

;; Enable line numbers in files
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes like shell mode
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; ------------------------------------------------------------------

;; Fix tab spaces with spaces and not tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

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

  ;; Override evil-search-forward with swiper
  (define-key evil-motion-state-map (kbd "/") 'swiper)

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
	 ("C-x x" . counsel-M-x)
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
  (load-theme 'doom-homage-black t))

;; Install rainbow delimiters (paranthesis highlighter)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Set up doom modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))  ; This isn't working for values below 25

;; Install magit
(use-package magit)

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
  :init
  :after evil
  :config
  (general-evil-setup t)

  (general-create-definer kaus/test-keys
    :states '(normal visual emacs)
    :keymaps 'override
    :prefix "SPC")

  (general-create-definer kaus/window-and-buffer-keys
    :states '(normal visual emacs)
    :keymaps 'override
    :prefix "SPC")

  (general-create-definer kaus/misc-keys
    :states '(normal visual emacs)
    :keymaps 'override
    :prefix "SPC")

  (general-create-definer kaus/help-keys
    :states '(normal visual emacs)
    :keymaps 'override
    :prefix "SPC")

  (kaus/test-keys
    "t"   '(counsel-load-theme :which-key "choose theme"))

  (kaus/window-and-buffer-keys
    ;; Buffer keys
    "bk"  '(kill-current-buffer :which-key "kill-current-buffer")
    "bb"  '(counsel-ibuffer :which-key "counsel-ibuffer")
    ","   '(counsel-ibuffer :which-key "counsel-ibuffer")

    ;; Evil window keys
    "wh"  '(evil-window-left :which-key "evil-window-left")
    "wj"  '(evil-window-down :which-key  "evil-window-down")
    "wk"  '(evil-window-up :which-key  "evil-window-up")
    "wl"  '(evil-window-right :which-key  "evil-window-right")

    "wH"  '(evil-window-move-far-left :which-key "evil-window-move-far-left")
    "wJ"  '(evil-window-move-very-down :which-key  "evil-window-move-very-down")
    "wK"  '(evil-window-move-very-up :which-key  "evil-window-move-very-up")
    "wL"  '(evil-window-move-far-right :which-key  "evil-window-move-far-right")

    "wv"  '(evil-window-vsplit :which-key  "evil-window-vsplit")
    "ws"  '(evil-window-hsplit :which-key  "evil-window-hsplit")

    "wc"  '(evil-window-delete :which-key "evil-window-delete")
    )

  (kaus/help-keys
    "h."     '(display-local-help :which-key "display-local-help")
    "hC"     '(describe-coding-system :which-key "describe-coding-system")
    "h C-\\" '(describe-input-method :which-key "describe-input-method")
    "h C-a"  '(about-emacs :which-key "about-emacs")
    "h C-c"  '(describe-copying :which-key "describe-copying")
    "h C-d"  '(view-emacs-debugging :which-key "macs-debugging")
    "h C-e"  '(view-external-packages :which-key "xternal-packages")
    "h C-f"  '(view-emacs-FAQ :which-key "macs-FAQ")
    "h C-h"  '(help-for-help :which-key "or-help")
    "h C-n"  '(view-emacs-news :which-key "macs-news")
    "h C-o"  '(describe-distribution :which-key "describe-distribution")
    "h C-p"  '(view-emacs-problems :which-key "macs-problems")
    "h C-s"  '(search-forward-help-for-help :which-key "or-help")
    "h C-t"  '(view-emacs-todo :which-key "view-emacs-todo")
    "h C-w"  '(describe-no-warranty :which-key "describe-no-warranty")
    "hF"     '(Info-goto-emacs-command-node :which-key "Info-goto-emacs-command-node")
    "hI"     '(describe-input-method :which-key "describe-input-method")
    "hK"     '(Info-goto-emacs-key-command-node :which-key "Info-goto-emacs-key-command-node")
    "hL"     '(describe-language-environment :which-key "describe-language-environment")
    "hP"     '(describe-package :which-key "describe-package")
    "h RET"  '(view-order-manuals :which-key "view-order-manuals")
    "hS"     '(info-lookup-symbol :which-key "info-lookup-symbol")
    "ha"     '(apropos-command :which-key "apropos-command")
    "hb"     '(describe-bindings :which-key "describe-bindings")
    "hc"     '(describe-key-briefly :which-key "describe-key-briefly")
    "hd"     '(apropos-documentation :which-key "apropos-documentation")
    "he"     '(view-echo-area-messages :which-key "view-echo-area-messages")
    "hf"     '(counsel-describe-function :which-key "counsel-describe-function")
    "hf"     '(describe-function :which-key "describe-function")
    "hg"     '(describe-gnu-project :which-key "describe-gnu-project")
    "hh"     '(view-hello-file :which-key "view-hello-file")
    "hi"     '(info :which-key "info")
    "hk"     '(describe-key :which-key "describe-key")
    "hk"     '(helpful-key :which-key "helpful-key")
    "hl"     '(view-lossage :which-key "view-lossage")
    "hm"     '(describe-mode :which-key "describe-mode")
    "hn"     '(view-emacs-news :which-key "view-emacs-news")
    "ho"     '(describe-symbol :which-key "describe-symbol")
    "hp"     '(finder-by-keyword :which-key "finder-by-keyword")
    "hq"     '(help-quit :which-key "help-quit")
    "hr"     '(info-emacs-manual :which-key "info-emacs-manual")
    "hs"     '(describe-syntax :which-key "describe-syntax")
    "ht"     '(help-with-tutorial :which-key "help-with-tutorial")
    "hv"     '(counsel-describe-variable :which-key "counsel-describe-variable")
    "hv"     '(describe-variable :which-key "describe-variable")
    "hw"     '(where-is :which-key "where-is")
    )
  
  (kaus/misc-keys
    "gg"  '(magit-status :which-key "magit-status")
    "ot"  '(vterm-toggle :which-key "vterm-toggle")
    "."   '(counsel-dired :which-key "counsel-dired")
    "RET" '(counsel-bookmark :which-key "counsel-bookmark")
    ))

;; Install vterm (emacs27+ required)
;; Before the following line, run:
;; sudo apt install cmake libtool libtool-bin 
(use-package vterm
  :init)

;; Install vterm toggle
;; Enable vterm to go at the bottom
(use-package vterm-toggle
  :init
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
