;;; packages.el --- Packages declarations
;;
;; Author:  NTBBloodbath <bloodbathalchemist@protonmail.com>
;; URL:     https://github.com/NTBBloodbath/bloodymacs
;; License: MIT
;;
;;; Code:

;; straight.el bootstrapping
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq straight-use-package-by-default t
      straight-fix-flycheck t
      use-package-always-ensure t)

(straight-use-package 'use-package)

;;; Packages declaration
;; Restart emacs for within emacs
(use-package restart-emacs
  :commands (restart-emacs)
  :bind
  (("C-x q" . restart-emacs)))
  ;; :config
  ;; NOTE: this is experimental, can cause visual bugs!
  ;; (setq restart-emacs-restore-frames t))

;; evil mode, I don't want to break my pinky
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (require 'evil)
  (evil-mode 1))
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Doom Emacs themes 'cause I can't live without doom-one
(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config))

;; undo-tree, we will surely want to recover past stuff
(use-package undo-tree
  :config
  (setq undo-tree-mode-lighter "")
  (require 'undo-tree)
  :hook (after-init . global-undo-tree-mode))

;; All we love icons
(use-package all-the-icons)

;; Statusline
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

;; Tabline
(use-package centaur-tabs
  :demand t
  :init
  (setq centaur-tabs-set-icons t
        centaur-tabs-set-modified-marker t
        centaur-tabs-style "bar"
        centaur-tabs-set-bar 'left
        centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-close-button "✕"
        centaur-tabs-modified-marker "•")
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))

;; Version control
(use-package magit
  :bind
  ("C-x g" . magit-status))

;; Emojis in buffers
(use-package emojify
  :hook (erc-mode . emojify-mode)
  :commands emojify-mode)

;; Autosave changed files, I'm too lazy to keep doing :w everytime
(use-package super-save
  :defer 1
  :diminish super-save-mode
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

;; Quickly comment lines
(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;; Automatically trim whitespaces
(use-package ws-butler
  :hook ((text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)))

;; Preserve minibuffer history
(use-package savehist
  :config
  (setq history-length 25)
  (savehist-mode 1))

;; Highlight TODO items
(use-package hl-todo
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(;; For things that need to be done, just not today.
          ("TODO" warning bold)
          ;; For problems that will become bigger problems later if not
          ;; fixed ASAP.
          ("FIXME" error bold)
          ;; For tidbits that are unconventional and not intended uses of the
          ;; constituent parts, and may break in a future update.
          ("HACK" font-lock-constant-face bold)
          ;; For things that were done hastily and/or hasn't been thoroughly
          ;; tested. It may not even be necessary!
          ("REVIEW" font-lock-keyword-face bold)
          ;; For especially important gotchas with a given implementation,
          ;; directed at another user other than the author.
          ("NOTE" success bold)
          ;; For things that just gotta go and will soon be gone.
          ("DEPRECATED" font-lock-doc-face bold)
          ;; For a known bug that needs a workaround
          ("BUG" error bold)
          ;; For warning about a problematic or misguiding code
          ("XXX" font-lock-constant-face bold))))

;; Indentation guides
(use-package highlight-indent-guides
  :init
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-character "│")
  :hook (('prog-mode-hook 'highlight-indent-guides-mode)))

;; Lua support
(use-package lua-mode
  :commands (lua-mode)
  :mode ("\\.lua\\'" . lua-mode)
  :config
  (setq lua-indent-level 2))

;; Markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :custom
  (markdown-command "multimarkdown"))

;; PDF viewer
(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install-noverify)

  (setq-default pdf-view-display-size 'fit-page)
  ;; Enable hiDPI support, but at the cost of memory! See politza/pdf-tools#51
  (setq pdf-view-use-scaling t
        pdf-view-use-imagemagick nil))

;; Code minimap like sublime text
(use-package minimap
  :defer t
  :bind (("C-x t m" . minimap-mode)
         ("<f5>"    . minimap-mode))
  :config
  (setq minimap-window-location 'right
        minimap-update-delay 0))

;; LSP
(use-package eglot
  :config
  (add-to-list 'eglot-server-programs '(c-mode "clangd"))
  (add-to-list 'eglot-ignored-server-capabilities :hoverProvider)
  :hook
  ((c-mode) . eglot-ensure))

;; Hover documentation
(use-package eldoc
  :straight nil
  :hook
  (eglot-connect . eldoc-mode))

(use-package eldoc-box
  :commands (eldoc-box-hover-at-point-mode)
  :hook
  (eldoc-mode . eldoc-box-hover-at-point-mode))

;; Completion
(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package company
  :diminish
  :hook
  (after-init . global-company-mode)
  :custom
  (company-idle-delay 0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; Smart pars
(use-package smartparens
  :hook (prog-mode . smartparens-mode))

;; Snippets
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))
(use-package yasnippet-snippets
  :after (yasnippet))

;; Rainbow pars
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Syntax checker
(use-package flycheck
  :init (global-flycheck-mode))

;; Git signs
(use-package git-gutter
  :straight git-gutter-fringe
  :diminish
  :hook ((text-mode . git-gutter-mode)
         (prog-mode . git-gutter-mode))
  :config
  (setq git-gutter:update-interval 2)
  (require 'git-gutter-fringe)
    ;; (set-face-foreground 'git-gutter-fr:added "LightGreen")
    (fringe-helper-define 'git-gutter-fr:added nil
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX")

    ;; (set-face-foreground 'git-gutter-fr:modified "LightGoldenrod")
    (fringe-helper-define 'git-gutter-fr:modified nil
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX")

    ;; (set-face-foreground 'git-gutter-fr:deleted "LightCoral")
    (fringe-helper-define 'git-gutter-fr:deleted nil
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX")

  ;; These characters are used in terminal mode
  (setq git-gutter:modified-sign "│")
  (setq git-gutter:added-sign "│")
  (setq git-gutter:deleted-sign "│"))

;; Tree explorer
(use-package treemacs
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-show-cursor                     t
          treemacs-show-hidden-files               t
          treemacs-silent-refresh                  t
          treemacs-width                           25
          treemacs-width-is-initially-locked       t)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("<f3>"        . treemacs)
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))
(use-package treemacs-evil
  :after (treemacs evil))

;; Terminal emulator
(use-package vterm
  :commands vterm
  :bind
  (:map global-map
        ("<f4>" . vterm)))

(provide 'packages)

;;; packages.el ends here
