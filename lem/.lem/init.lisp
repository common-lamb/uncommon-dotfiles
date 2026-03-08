(format t "in lem rc")

;; show completion list instantly
(add-hook *prompt-after-activate-hook*
          (lambda ()
            (call-command 'lem/prompt-window::prompt-completion nil)))
(add-hook *prompt-deactivate-hook*
          (lambda ()
            (lem/completion-mode:completion-end)))

;; Start in vi-mode
(lem-vi-mode:vi-mode)

;; OCICL
#-ocicl
(let ((init (uiop:native-namestring "~/.local/share/ocicl/ocicl-runtime.lisp")))
  (when (probe-file init)
    (load init)))

#+ocicl
(defun ocicl-runtime-set-registry (&key (target-dir (user-homedir-pathname)) (strict nil))
  "
sets asdf:initialize-source-registry to target-dir and ~/common-lisp/
strict sets ocicl:*local-only*

usage:
clone any systems into common-lisp
symlink any local asd files into common-lisp
call this fun to register
call asdf:load-system :my.system

result:
ocicl will find and prioritize(maybe) systems in ~/common-lisp/
pull any required systems to ./ocicl/ in target-dir
asdf will compile where needed
"
  (asdf:initialize-source-registry ;; &&& asdf docs say this is naughty
   (list :source-registry
         (list :directory (probe-file target-dir))
         (list :tree (uiop:native-namestring "~/common-lisp"))
         :inherit-configuration))
  ;; if package exports change between compilations
  ;; the default (:warn t) causes asdf to error with no restarts
  ;; mandating errors provides restart options
  (setf *on-package-variance* '(:error t))
  ;; when t no global or parent ocicl.csv used
  (setf ocicl-runtime:*local-only* strict)
  ;; return as set
  asdf:*source-registry-parameter*)

(ocicl-runtime-set-registry)

;; cl-mcp server startup
(asdf:load-system :cl-mcp)

(defun cl-mcp-server-start ()
  "Start the cl-mcp TCP server"
  (when (null cl-mcp:*http-server*)
    (progn
      (cl-mcp:start-http-server :port (uiop:getenv "cl_mcp_port"))
      (format t "~%cl-mcp server started on: ~A ~%" cl-mcp:*http-server-port*)
      (cl-mcp/src/fs:fs-set-project-root (namestring (uiop:getcwd)))
      (format t "~%cl-mcp:fs-set-project-root set at: ~A ~%" (uiop:getcwd))
      (force-output)))

(cl-mcp-server-start)

;; lem-mcp server startup
;; (lem:mcp-server-start)
