;;; init.el --- Spacemacs Initialization File -*- no-byte-compile: t -*-
;;
;; Copyright (c) 2012-2024 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Prevent package loading at startup
(setq package-enable-at-startup nil)
(setq evil-want-keybinding nil)
;; reduce startup compilation warnings
(setq native-comp-async-jobs-number 1)
(setq doom-incremental-packages nil)

;; Suppress specific warnings
(setq warning-suppress-types '((evil-collection)))
(setq warning-minimum-level :error)

;; Add MELPA to package archives
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; Avoid garbage collection during startup
(defconst emacs-start-time (current-time))
(setq gc-cons-threshold 402653184 gc-cons-percentage 0.6)

;; Load core Spacemacs components
(load (concat (file-name-directory load-file-name) "core/core-load-paths")
      nil (not init-file-debug))
(load (concat spacemacs-core-directory "core-versions")
      nil (not init-file-debug))
(load (concat spacemacs-core-directory "core-dumper")
      nil (not init-file-debug))
(load (concat spacemacs-core-directory "core-compilation")
      nil (not init-file-debug))
(load spacemacs--last-emacs-version-file t (not init-file-debug))

;; Remove stale compiled core files
(when (or (not (string= spacemacs--last-emacs-version emacs-version))
          (> 0 (spacemacs//dir-byte-compile-state
                (concat spacemacs-core-directory "libs/"))))
  (spacemacs//remove-byte-compiled-files-in-dir spacemacs-core-directory))

;; Update saved Emacs version
(unless (string= spacemacs--last-emacs-version emacs-version)
  (spacemacs//update-last-emacs-version))

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  (let ((please-do-not-disable-file-name-handler-alist nil))
    (require 'core-spacemacs)
    (spacemacs/dump-restore-load-path)
    (configuration-layer/load-lock-file)
    (spacemacs/init)
    (configuration-layer/stable-elpa-init)
    (configuration-layer/load)
    (spacemacs-buffer/display-startup-note)
    (spacemacs/setup-startup-hook)
    (spacemacs/dump-eval-delayed-functions)
    (when (and dotspacemacs-enable-server (not (spacemacs-is-dumping-p)))
      (require 'server)
      (when dotspacemacs-server-socket-dir
        (setq server-socket-dir dotspacemacs-server-socket-dir))
      (unless (server-running-p)
        (message "Starting a server...")
        (server-start)))))

;; Configure org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/roam-notes/")
  (org-roam-dailies-directory "daily/")
  (org-roam-db-gc-threshold most-positive-fixnum)
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("p" "project" plain
      "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :project:\n")
      :unnarrowed t)
     ("r" "reference" plain
      "* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nYear: %^{Year}\n\n* Summary\n\n%?"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :reference:\n")
      :unnarrowed t)))
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n u" . org-roam-ui-mode))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies)
  (org-roam-db-autosync-mode))

;; Configure org-roam-ui
(use-package org-roam-ui
  :ensure t
  :after org-roam
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow t)
  (org-roam-ui-update-on-save t))
