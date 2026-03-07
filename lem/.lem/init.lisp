(format t "in lem rc")
;; Start in vi-mode
(lem-vi-mode:vi-mode)
;; lem-mcp server startup
(lem:mcp-server-start)

;; cl-mcp server startup
(asdf:load-system :cl-mcp)

(defun cl-mcp-server-start ()
  "Start the cl-mcp TCP server"
  (when (null cl-mcp:*http-server*)
    (progn
      (cl-mcp:start-http-server :port (uiop:getenv "cl_mcp_port"))
      (format t "~%cl-mcp server started on: ~A ~%" cl-mcp:*http-server-port*)
      (force-output))))

(cl-mcp-server-start)

;; show completion list instantly
(add-hook *prompt-after-activate-hook*
          (lambda ()
            (call-command 'lem/prompt-window::prompt-completion nil)))
(add-hook *prompt-deactivate-hook*
          (lambda ()
            (lem/completion-mode:completion-end)))
