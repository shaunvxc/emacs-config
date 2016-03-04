;; for emacs 24.3, the below is required or calls to 'loop' will throw errors
(require 'cl)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

;; (require 'package)
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.org/packages/") t)

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; git commit package
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elpa/")
;; (require 'git-commit)
;; (setq git-commit-fill-column-summary 72)

;; speedbar package-- allows for a project explorer type pane
(require 'sr-speedbar)

;; summon the speedbar with C-c t
(global-set-key [(ctrl c) (t)] 'sr-speedbar-toggle)

;; any syntax highlight theme lives here..
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(require 'midnight)
(midnight-delay-set 'midnight-delay "4:30am")

;; unset the annoying minimize keybinding
(global-unset-key (kbd "C-z"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes (quote ("cf08ae4c26cacce2eebff39d129ea0a21c9d7bf70ea9b945588c1c66392578d1" "e707d8881f53535f1cbbfc70d81cf5a7cd23eefe271b084bf4ff0bd21dfd0311" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(inhibit-startup-screen nil)
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; favorite theme I've found so far
;;(load-theme 'tomorrow-night-eighties t)
(load-theme 'dark-mint t)
;; ;;; Set background to be transparent
(set-frame-parameter (selected-frame) 'alpha '(96 96))
(add-to-list 'default-frame-alist '(alpha 96 96))

;;; show line nums
(require 'linum)
(global-linum-mode 1)

;; autocomplete
(require 'auto-complete)
(ac-config-default)

;;; smooth scroll
(setq scroll-conservatively 10000)

;; prevent mouse scrolling from sucking ass
(setq mouse-wheel-scroll-amount '(0.07))
(setq mouse-wheel-progressive-speed nil)

;; turn the friggan beep noise off!
(setq ring-bell-function 'ignore)

;; Emacs will not automatically add new lines
(setq next-line-add-newlines nil)

;; prevent too much line wrapping...
'(fill-column 1000)

;; Start maximised (cross-platf)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; ;;; Nice size for the default window
;; (defun get-default-height ()
;;        (/ (- (display-pixel-height) 120)
;;           (frame-char-height)))

;; (add-to-list 'default-frame-alist '(width . 140))
;; (add-to-list 'default-frame-alist (cons 'height (get-default-height)))

;; markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;; hide toolbar
(tool-bar-mode -1)

(when (eq system-type 'darwin)
  (setq mac-option-modifier 'control) ; was alot
  (setq mac-command-modifier 'meta)
  (setq ns-function-modifier 'alt) ;fn is control -- was control

  (global-set-key (kbd "<home>") 'move-beginning-of-line)
  (global-set-key (kbd "<end>") 'move-end-of-line)
   ;; sets fn-delete to be right-delete
  (global-set-key [kp-delete] 'delete-char))

; other window
(global-set-key [C-tab] 'other-window)

(global-auto-revert-mode t)

;; remove errant white space at the ends of file
(defun squeeze-file ()
  (interactive)
  (delete-trailing-whitespace)
  (delete-trailing-blank-lines))

;; remove any whitespace at the ends of lines
(defun delete-trailing-blank-lines ()
  "Deletes all blank lines at the end of the file, even the last one"
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines)
      (let ((trailnewlines (abs (skip-chars-backward "\n\t"))))
        (if (> trailnewlines 0)
            (progn
              (delete-char trailnewlines)))))))

;;; maps the key-binding for the above function that removes all white space
(global-set-key [(ctrl x) (w)] 'squeeze-file)

;; delete selection mode
(delete-selection-mode 1)

;;; insert break point
(fset 'insert_bpt
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("import pdb;pdb.set_trace()" 0 "%d")) arg)))

;; map break-point macro to C-x p
(global-set-key [(ctrl x) (p)] 'insert_bpt)

;; comment or uncomment blocks
(global-set-key [(ctrl c) (c)] 'comment-or-uncomment-region)
(global-set-key (kbd"C-X SPC") 'pop-global-mark)

;; function to fix brace alignment in c# mode
(fset 'fix_cs_braces
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([18 123 67108896 18 41 right backspace 32 right 5 down] 0 "%d")) arg)))

;; map curly brace alignment macro to C-c f
(global-set-key [(ctrl c) (f)] 'fix_cs_braces)

;; ansi-term should run bash by default
(setq explicit-shell-file-name "/bin/bash")

;; keybinding for arrows
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; sets the default directory as the home directory-- this doesn't fucking work.
(getenv "HOME")
(setq default-directory "~/")
(cd "~/Development/")

;; syntax highlighting for c#
(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

;; allow narrowing
(put 'narrow-to-region 'disabled nil)

(fset 'toggle-pdb
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([19 112 100 98 59 112 100 98 right 1 67108896 5 134217848 99 111 109 109 101 110 116 tab 111 114 tab return 5 down up down 1] 0 "%d")) arg)))

(fset 'toggle-all-pdb
    (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([134217831 134217831 49 return 134217777 48 48 48 48 48 134217848 116 111 103 tab 112 100 tab return 1 1 1] 0 "%d")) arg)))

(global-set-key [(ctrl x) (t)] 'toggle-all-pdb)

;; magit configs
(require 'magit)
;; magit status map
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
(global-set-key (kbd "C-x M-l") 'magit-log)

(require 'magit-gh-pulls)
(add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)


;; (setq magit-display-buffer-function
;;       (lambda (buffer)
;;         (display-buffer
;;          buffer (if (and (derived-mode-p 'magit-mode)
;;                          (memq (with-current-buffer buffer major-mode)
;;                                '(magit-process-mode
;;                                  magit-revision-mode
;;                                  ;; magit-diff-mode
;;                                  magit-stash-mode
;;                                  magit-status-mode)))
;;                     nil
;;                   '(display-buffer-same-window)))))

;; (setq split-height-threshold 0)
;; (setq split-width-threshold nil)

;; (setq split-height-threshold 100)
;; (setq split-width-threshold 80)


(setq split-height-threshold 80)
(setq split-width-threshold 100)

(defun split-window-prefer-vertically (window)
  "If there's only one window (excluding any possibly active
         minibuffer), then split the current window vertically."
  (if (and (one-window-p t)
	   (not (active-minibuffer-window)))
      (let ((split-width-threshold nil))
	(split-window-sensibly window))
    (split-window-sensibly window)))

(setq split-window-preferred-function 'split-window-prefer-vertically)

(add-to-list 'display-buffer-alist
                 '(".*COMMIT_EDITMSG". ((display-buffer-pop-up-window) .
                                        ((inhibit-same-window . t)))))

;; font for all unicode characters
(set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend)
