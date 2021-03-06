;; All my general key-bindings
(use-package general
  :init
  :after evil
  :config
  (general-def :states '(normal visual motion emacs) "SPC" nil)  ; Unbind SPC to work as a prefix
  (general-def :keymaps 'magit-mode-map "SPC" nil)  ; Unbind the magit bind for SPC
  (general-def :keymaps 'image-mode-map "SPC" nil)  ; Unbind the image mode map bind for SPC
  (general-def :states 'normal :keymaps 'dired-mode-map "SPC" nil)  ; Unbind the dired bind for SPC
  (general-def :states 'normal :keymaps 'help-mode-map "SPC" nil)  ; Unbind the help mode map bind for SPC
  (general-def :states 'normal :keymaps 'image-mode-map "SPC" nil)  ; Unbind the image mode map bind for SPC
  (general-evil-setup t)

  (general-create-definer kaus/test-keys
    :keymaps '(normal visual motion emacs)
    :prefix "SPC")

 (general-create-definer kaus/mode-map-keys
    :keymaps '(normal visual motion emacs)
    :prefix "SPC")

  (general-create-definer kaus/buffer-keys
    :keymaps '(normal visual motion emacs)
    :prefix "SPC")

  (general-create-definer kaus/plugin-keys
    :keymaps '(normal visual motion emacs))

  (general-create-definer kaus/misc-keys
    :keymaps '(normal visual motion emacs)
    :prefix "SPC")

  (kaus/test-keys
    "t"   '(counsel-load-theme :which-key "choose theme"))

  (kaus/mode-map-keys
   "h"   '(help-command :which-key "help-command")
   "w"   '(evil-window-map :which-key "evil-window-map")
   "TAB" '(perspective-map :which-key "perspective-map")
   )

  (kaus/buffer-keys
    "bk"  '(kill-current-buffer :which-key "kill-current-buffer")
    "q"   '(kill-current-buffer :which-key "kill-current-buffer")
    "bb"  '(counsel-ibuffer :which-key "counsel-ibuffer")
    ","   '(persp-ivy-switch-buffer :which-key "persp-ivy-switch-buffer")
    "bp"  '(previous-buffer :which-key "previous-buffer")
    "bn"  '(next-buffer :which-key "next-buffer")
    "s"   '(save-buffer :which-key "save-buffer")
    )

  (kaus/plugin-keys
   "C-c w"   '(whitespace-mode :which-key "whitespace-mode")
   "C-c p"   '(check-parens :which-key "check-parens")
   "C-c t"   '(delete-trailing-whitespace :which-key "delete-trailing-whitespace")
   "C-c C-c" '(move-to-window-line-top-bottom :which-key "move-to-window-line-top-bottom")
   "C-c r"   '(rg-dwim :which-key "rg-dwim")
   "C-c n t" '(neotree-show :which-key "neotree-show")
   )

  (kaus/misc-keys
    "gg"  '(magit-status :which-key "magit-status")
    "ot"  '(vterm-toggle :which-key "vterm-toggle")
    "."   '(counsel-find-file :which-key "counsel-find-file")
    "RET" '(counsel-bookmark :which-key "counsel-bookmark")
    "fr"  '(counsel-recentf :which-key "counsel-recentf")
    "bm"  '(bookmark-set :which-key "bookmark-set")
    ))

  (general-nmap "Y" (general-simulate-key "y $"
                    :name general-Y-simulates-y$
                    :docstring "Remaps Y to y$ like neovim"))
  (general-nmap "M-p" (general-simulate-key "o C-g p")) ;; Maps "M-p" to paste line below
