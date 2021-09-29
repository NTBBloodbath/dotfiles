;;; appearance.el -*- lexical-binding: t; -*-
;;
;; Author:  NTBBloodbath <bloodbathalchemist@protonmail.com>
;; URL:     https://github.com/NTBBloodbath/bloodymacs
;; License: MIT

;; Thanks, but no thanks
(setq inhibit-startup-message t)

(setq font-lock-maximum-decoration t
      color-theme-is-global t
      truncate-partial-width-windows nil)

(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1)   ; Disable the toolbar
(tooltip-mode -1)    ; Disable tooltips
(set-fringe-mode 10) ; Give some breathing room
(menu-bar-mode -1)   ; Disable the menu bar

;; I don't want a visible bell
(setq visible-bell nil)

;; Improve Scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq use-dialog-box nil) ;; Disable dialog boxes since they weren't working in Mac OSX

;; Frame Transparency
(set-frame-parameter (selected-frame) 'alpha '(96 . 96))
(add-to-list 'default-frame-alist '(alpha . (96 . 96)))

;;; Line Numbers and Format
;; Always display line and column numbers
(setq line-number-mode t)
(setq column-number-mode t)
(display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; Enable line numbers for some modes
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; Lines should be 100 characters wide
(setq fill-column 100)

;; Be carefull with opening files.. but here we are disabling the warn
(setq large-file-warning-threshold nil)
;; Symlinked files 
(setq vc-follow-symlinks t)

;; Highlight current line
(global-hl-line-mode 1)

;; Don't defer screen updates when performing operations
(setq redisplay-dont-pause t)

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (blink-cursor-mode -1))

;; Sweet window-splits
(defadvice split-window-right (after balance activate) (balance-windows))
(defadvice delete-window (after balance activate) (balance-windows))

;; Display real names for symlinks instead of their path
(setq find-file-visit-truename t)

;; Set the font face 
(set-face-attribute 'default nil 
                    :font "JetBrainsMono Nerd Font" 
                    :weight 'regular 
                    :height 120)

(provide 'appearance)
