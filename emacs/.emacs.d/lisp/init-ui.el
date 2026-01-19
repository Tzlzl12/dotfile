(use-package ace-window
  :ensure t
  :bind (("C-x o" . "ace-window")))

(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode)
  :custom
  (undo-tree-auto-save-history nil)
  :bind ("C-x C-h u" . hydra-uodo-tree/body)
  :hydra (hydra-undo-tree (:hint nil)
			  "_p_:undo _n_: redo _s_: save _l_: load"
			  ("p" undo-tree-undo)
			  ("n" undo-tree-redo)
			  ("s" undo-tree-save-history)
			  ("l" undo-tree-load-history)
			  ("u" undo-tree-visualize "visualize" :color blue)
			  ("q" nil "quit" :color:blue)))
(smart-mode-line
 :ensure t
 :init (sml/setup))

(provide 'init-ui)
