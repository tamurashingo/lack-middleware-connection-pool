#|
  This file is a part of lack-middleware-connection-pool project.
  Copyright (c) 2018 tamura shingo (tamura.shingo@gmail.com)
|#

(in-package :cl-user)
(defpackage lack-middleware-connection-pool-test-asd
  (:use :cl :asdf))
(in-package :lack-middleware-connection-pool-test-asd)

(defsystem lack-middleware-connection-pool-test
  :author "tamura shingo"
  :license "MIT"
  :depends-on (:lack-middleware-connection-pool
               :lack
               :lack-test
               :lack-request
               :prove
               :dbi)
  :components ((:module "t"
                :components
                ((:test-file "lack-middleware-connection-pool"))))
  :description "Test system for lack-middleware-connection-pool"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
