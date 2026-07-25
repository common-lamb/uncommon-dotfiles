;;vim keybinds
(define-configuration buffer
		        ((default-modes
			       (pushnew 'nyxt/mode/vi:vi-normal-mode %slot-value%))))


;; zotero
(nyxt:define-nyxt-user-system-and-load "nyxt-user/nx-zotero-proxy"
				         :description "This proxy system saves us if nx-zotero fails to load.
					 Otherwise it will break all the config loading."
					   :depends-on ("nx-zotero"))
(define-configuration web-buffer
		         ((default-modes
			         (pushnew 'zotero-mode %slot-value%))))
(defvar *my-emacs-keymap* (make-keymap "my-emacs-map"))
(defvar *my-vi-keymap* (make-keymap "my-vi-map"))

(define-key *my-emacs-keymap* "C-c z" 'nx-zotero:save-current)
(define-key *my-vi-keymap* "y z" 'nx-zotero:save-current)
(define-mode my-mode
	                  nil
			               "Dummy mode for the custom key bindings in *my-keymap*."
				                    ((keyscheme-map
						                      (nkeymaps/core:make-keyscheme-map nyxt/keyscheme:emacs *my-emacs-keymap*
													                                                 nyxt/keyscheme:vi-normal *my-vi-keymap*))))
(define-configuration web-buffer
		                            "Enable this mode by default."
					                          ((default-modes (pushnew 'my-mode %slot-value%))))
