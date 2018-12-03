(in-package :cl-user)
(defpackage lack.middleware.connection.pool
  (:use :cl)
  (:export :*lack-middleware-connection-pool*
           :shutdown))
(in-package :lack.middleware.connection.pool)

(defparameter *CONNECTION-POOL* nil)

(defparameter *lack-middleware-connection-pool*
  (lambda (app &rest params &key driver-name database-name username password initial-size max-size)
    ;; remove driver-name for dbi-cp argument
    (remf params :driver-name)
    (setf *CONNECTION-POOL* (apply #'dbi-cp:make-dbi-connection-pool driver-name params))
    (lambda (env)
      (let ((conn (dbi-cp:get-connection *CONNECTION-POOL*)))
        (setf (getf env :lack.db.connection) conn)
        (handler-bind ((error (lambda ()
                                (dbi-cp:rollback conn)
                                (dbi-cp:disconnect conn))))
          (prog1
              (funcall app env)
            (dbi-cp:disconnect conn)))))))

(defun shutdown ()
  "disconnect all connections"
  (dbi-cp:shutdown *CONNECTION-POOL*)
  (setf *CONNECTION-POOL* nil))
