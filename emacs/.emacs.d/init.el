(when (< emacs-major-version 29)
  (error "This config is supported version 29 and newer, current version: %s" emacs-major-version))

;;提升阈值,直到启动完成后恢复 
(setq gc-cons-threshold (* 64 1024 1024))
(add-hook 'emacs-startup-hook (lambda () (setq gc-cons-threshold(* 8 1024 1024) ) ))

(setq confirm-kill-emacs #'yes-or-no-p) ;

(require 'package)
(setq package-archives '(()))
(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
			 ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package hydra
  :ensure t)
(use-package use-package-hydra
  :ensure t
  :after hydra)

;; 加载模块(config module path)
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;; import 
(require 'init-completion)
(require 'init-ui)
(require 'init-editor)
;; 设置中文输入,使用内置输入法 
(setopt default-input-method "chinese-py")
;; 优化与LSP等子进程间的通讯
(setopt read-process-output-max (* 1024 1024))
(set-language-environment "UTF-8")

(setopt inhibit-startup-screen t)       ; 禁用欢迎界面 
(setopt initial-scratch-message nil)    ; 保持scratch干净
(setopt sentence-end-double-space nil)  ; 现代句尾排版 
(setopt use-short-answers t)            ; y/n代替yes/no
(setopt ring-bell-function 'ignore)     ; 静音
(setopt make-backup-files nil)

(add-hook 'prog-mode-hook #'hs-minor-mode)

(when (display-graphic-p)
  (add-to-list 'default-frame-alist '(width . 80))
  (add-to-list 'default-frame-alist '(height . 25))
  ;; 隐藏UI元素 
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode -1)
  )
;; 自动重载 
(global-auto-revert-mode t)
(setopt auto-revert-use-notify t)

;; 历史和状态保持
(savehist-mode t)     ; 记录输入历史 
(save-place-mode t)   ; 记住上次光标位置 
; (recentf-mode t)      ; 记录最近打开的文件

(when (>= emacs-major-version 30)
  (which-key-mode 1)    ; which-key
  (add-hook 'prog-mode-hook #'completion-preview-mode) ; 行内补全预览 
  (pixel-scroll-precision-mode t)    ; 平滑像素滚动
  (setopt treesit-font-lock-level 4) ; 代码高亮
  (setq major-mode-remap-alist '(
				 (python-mode . python-ts-mode)
				 (rust-mode . rust-ts-mode)
				 (c-mode . c-ts-mode)
				 )))
;; 括号配对和高亮 
(electric-pair-mode t)
(show-paren-mode t)

;; 使用垂直补全流(switch to vertico) 
; (fido-vertical-mode 1)
; (setopt icomplete-delay-completions-threshold 0) ; 设置延迟 
;; 增搜索模式, 支持模糊匹配和前缀匹配
; (setopt completion-styles '(flex initials substring basic))

(column-number-mode t)
;; 为编程模式设置相对行号 
(setopt display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

; (load-theme 'modus-vivendi t)

; 设置默认英文字体 
(set-face-attribute 'default nil :family "Maple Mono" :height 140)
; 设置默认中文字体 
; (set-fontset-font t 'han (font-spec : family ""))


(provide 'init)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ace-window consult hydra marginalia orderless undo-tree
		use-package-hydra vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
