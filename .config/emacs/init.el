;;; init.el -*- lexical-binding: t; -*-
;;
;; Author:  NTBBloodbath <bloodbathalchemist@protonmail.com>
;; URL:     https://github.com/NTBBloodbath/bloodymacs
;; License: MIT

;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Garbage collection
(setq gc-cons-threshold (* 50 1000 1000))

;; Don’t compact font caches during GC.
(setq inhibit-compacting-font-caches t)

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Set path to extra files (dependencies)
(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))
(setq site-lisp-dir
      (expand-file-name "site-lisp" user-emacs-directory))

;; Set up load-path variable
(add-to-list 'load-path settings-dir)
(add-to-list 'load-path site-lisp-dir)

;; Appearance, 'cause we don't want a ugly editor
(require 'appearance)

;; Saner defaults, we don't want to suffer strange stuff
(require 'defaults)

;; Package management
(require 'packages)

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4b6b6b0a44a40f3586f0f641c25340718c7c626cbf163a78b5a399fbe0226659" "f7fed1aadf1967523c120c4c82ea48442a51ac65074ba544a5aefc5af490893b" "835868dcd17131ba8b9619d14c67c127aa18b90a82438c8613586331129dda63" "7eea50883f10e5c6ad6f81e153c640b3a288cd8dc1d26e4696f7d40f754cc703" "47db50ff66e35d3a440485357fb6acb767c100e135ccdf459060407f8baea7b2" "8621edcbfcf57e760b44950bb1787a444e03992cb5a32d0d9aec212ea1cd5234" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
