(use-package mwim
  :ensure t
  :bind
  (("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line)))

(use-package avy
  :ensure t
  :bind
  (("C-j C-SPC" . avy-goto-char-timer)))
