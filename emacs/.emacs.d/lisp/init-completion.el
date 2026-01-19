(use-package vertico
  :ensure t
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-compiletion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))

(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)
	 ("C-x b" . consult-buffer)
	 ("M-y" . consult-yank-pop)))
(provide 'init-completion)
