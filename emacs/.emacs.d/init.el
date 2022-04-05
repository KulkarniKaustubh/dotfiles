;; Initial stuff
(setq inhibit-startup-message t) ; Remove startup message

(scroll-bar-mode -1)    ; Disable the visible scroll bar
(tool-bar-mode -1)      ; Disable the toolbar
(tooltip-mode -1)       ; Disable tooltips
(set-fringe-mode 10)    ; Give some breathing room

(menu-bar-mode -1)      ; Disable the menu bar

(global-auto-revert-mode t)   ; All buffers always in sync with no unsaved changes

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
(setq display-line-numbers-type 'relative)

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
 '(custom-safe-themes '(default))
 '(package-selected-packages
   '(perspective sudo-edit neotree smooth-scrolling company-tabnine rg restart-emacs blacken python-black ein impatient-mode iedit pyvenv rainbow-delimiters company flycheck lsp-ui lsp-mode golden-ratio vterm-toggle vterm general smex helpful undo-tree counsel ivy-rich doom-themes which-key magit doom-modeline ivy use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ------------------------------------------------------------------
;;                     Misc Package Configs
;; ------------------------------------------------------------------

(add-to-list 'exec-path "~/.local/bin")

;; Fixing dired
(setq dired-listing-switches "-lAX --group-directories-first")

;; Change recenter positions toggle order
(setq recenter-positions '(middle bottom top))

;; Disable narrow-to-region prompt
(put 'narrow-to-region 'disabled nil)

;; Enable tabs
(tab-bar-mode 1)

;; ------------------------------------------------------------------
;;                     Package Installations
;; ------------------------------------------------------------------

;; To restart emacs from within, restart-emacs
(use-package restart-emacs)

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
  (define-key evil-normal-state-map [delete] 'evil-delete-char)
  (define-key evil-insert-state-map [delete] 'delete-char)
  (setq evil-emacs-state-cursor '("yellow" box))
  (setq evil-normal-state-cursor '("#c792ea" box))
  (setq evil-insert-state-cursor '("#c792ea" bar))
  (setq evil-visual-state-cursor '("cyan" box))

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

;; Install swiper for searches
(use-package swiper)

;; Install ivy
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-partial)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         ("C-c C-c" . ivy-call)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :custom
  (ivy-use-virtual-buffers t)
  :config
  (setq ivy-wrap t) ;; Enable menu to cycle through
  (setq ivy-on-del-error-function 'ignore) ;; Stop backspace from closing ivy
  (setq ivy-virtual-abbreviate 'abbreviate)
  (ivy-mode 1))   ; Run ivy by default

;; Run to load all icons after ivy
(use-package all-the-icons)

;; Recentf always on
(use-package recentf
  :config
  (recentf-mode 1)
  (setq recentf-max-menu-items 50))

;; Install counsel
(use-package counsel
  :init
  :bind (("M-x" . counsel-M-x)
         ("C-x x" . counsel-M-x)
         ("C-x b" . counsel-switch-buffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1))

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
  :hook
  (git-commit-mode . evil-insert-state))

;; For merge conflicts, smerge-mode (in-built)
(use-package smerge-mode
  :init
  (setq smerge-command-prefix (kbd "C-c v")))

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

;; Install golden-ration for automatice resizing of windows
(use-package golden-ratio
  :config
  (golden-ratio-mode 1)
  (setq golden-ratio-auto-scale t)
  (setq golden-ratio-extra-commands
  (append golden-ratio-extra-commands
    '(evil-window-left
      evil-window-right
      evil-window-up
      evil-window-down))))

;; Install lsp
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :commands (lsp lsp-deferred)
  :hook
  (python-mode . lsp-deferred)
  :config
  (lsp-enable-which-key-integration t))

;; Install lsp ui
(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

;; For virtualenvironments, pyvenv
(use-package pyvenv
  :hook
  (python-mode . pyvenv-mode)
  :config
  (pyvenv-activate "~/Envs/lspenv")
  )

;; To display warnings/errors, flycheck
(use-package flycheck)

;; For auto completion, company mode
(use-package company
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
  :config
  (global-company-mode))

;; For smart completion using company and ML, company-tabnine
(use-package company-tabnine
  :config
  (setq company-show-numbers t)
  (add-to-list 'company-backends #'company-tabnine))

;; To edit multiple occurences of region simultaneously, iedit
(use-package iedit)

;; For workspaces, perspective
(use-package perspective
  :config
  (persp-mode 1))

(use-package impatient-mode
  :commands impatient-mode
  :hook
  (markdown-mode . impatient-mode)
  (markdown-mode . httpd-start)
  :config
  (defun impatient-github-markdown-filter (buffer)
    (princ
    (with-temp-buffer
        (let ((tmp (buffer-name)))
        (set-buffer buffer)
        (set-buffer (markdown tmp))
        (format "<!DOCTYPE html><html><title>Markdown preview</title><link rel=\"stylesheet\" href = \"https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/3.0.1/github-markdown.min.css\"/>
    <body><article class=\"markdown-body\" style=\"box-sizing: border-box;min-width: 200px;max-width: 980px;margin: 0 auto;padding: 45px;\">%s</article></body></html>" (buffer-string))))
    (current-buffer)))

    (defun github-markdown-preview ()
      "Github markdown preview."
      (interactive)
      (unless (process-status "httpd")
          (httpd-start))
      (impatient-mode)
      (imp-set-user-filter #'impatient-github-markdown-filter)
      (imp-visit-buffer))
  )

;; For jupyter notebooks, EIN
(use-package ein)

;; To highlight cursor postion after certain functions, pulse (in-built)
(use-package pulse
  :config
  (set-face-attribute 'pulse-highlight-start-face nil :background "gray") ;; Change pulse highlight color to gray
  (setq pulse-flag t)
  (defun pulse-line (&rest _)
    (pulse-momentary-highlight-one-line (point)))
  (dolist (command '(evil-scroll-down
                     evil-scroll-up
                     recenter-top-bottom
                     swiper
                     move-to-window-line-top-bottom
                     windmove-do-window-select
                     evil-paste-after))
    (advice-add command :after #'pulse-line)))

;; To format python code, black
(use-package blacken
  :config
  (setq blacken-line-length 79)
  :hook (python-mode . blacken-mode))

;; For quick searching, ripgrep (rg)
(use-package rg
  :config
  (setq rg-executable "rg") ;; use rg from PATH shell variable
  (setq rg-default-alias-fallback "everything")
  )

;; For auto smooth scrolling with a margin, smooth-scrolling
(use-package smooth-scrolling
  :config
  (setq smooth-scroll-margin 8)
  (smooth-scrolling-mode 1))

;; For a file-tree panel, neotree
(use-package neotree
  :config
  (doom-themes-neotree-config)
  (setq doom-themes-neotree-file-icons t)
  (setq neo-show-hidden-files t))

;; To save already opened and edited read-only files, sudo-edit
(use-package sudo-edit)

;; Load my general package key bindings
(load "~/.emacs.d/general_keys.el")
