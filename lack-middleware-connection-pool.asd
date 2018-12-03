#|
  This file is a part of lack-middleware-connection-pool project.
  Copyright (c) 2018 tamura shingo (tamura.shingo@gmail.com)
|#

#|
  CL-DBI Connection Pool for Lack

  Author: tamura shingo (tamura.shingo@gmail.com)
|#

(in-package :cl-user)
(defpackage lack-middleware-connection-pool-asd
  (:use :cl :asdf))
(in-package :lack-middleware-connection-pool-asd)

(defsystem lack-middleware-connection-pool
  :version "0.1"
  :author "tamura shingo"
  :license "MIT"
  :depends-on (:cl-dbi-connection-pool)
  :components ((:module "src"
                :components
                ((:file "lack-middleware-connection-pool"))))
  :description "CL-DBI Connection Pool for Lack"
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op lack-middleware-connection-pool-test))))
