(in-package :cl-user)
(defpackage lack-middleware-connection-pool-test
  (:use :cl
        :prove
        :lack
        :lack.test
        :lack.request)
  (:shadowing-import-from :lack.test
                          :request))
(in-package :lack-middleware-connection-pool-test)

(plan 1)

(let ((conn (dbi:connect :mysql
                         :database-name "cptest"
                         :username "nobody"
                         :password "nobody")))
  (dbi-cp:do-sql conn "drop table if exists product")
  (dbi-cp:do-sql conn "create table product (id integer primary key, name varchar(20) not null, price integer not null)")
  (dbi-cp:do-sql conn "insert into product (id, name, price) values (1, 'NES', 14800)")
  (dbi-cp:commit conn)
  (dbi-cp:disconnect conn))



(defun select-count (conn)
  (let* ((query (dbi-cp:prepare conn "select count(*) as num from product"))
         (result (dbi-cp:execute query)))
    (getf (dbi-cp:fetch result) :|num|)))

(defun insert-product (conn id name price)
  (let* ((query (dbi-cp:prepare conn "insert into product (id, name, price) values (?, ?, ?)"))
         (result (dbi-cp:execute query id name price)))))


(subtest "connection pool middleware"
  (let ((app
         (builder
          (:connection-pool
           :driver-name :mysql
           :database-name "cptest"
           :username "nobody"
           :password "nobody")
          #'(lambda (env)
              (let* ((req (make-request env))
                     (conn (getf env :lack.db.connection)))
                `(200
                  (:content-type "text/text")
                  (,(if (eq :post (request-method req))
                        (prog1
                            (insert-product conn 2 "SNES" 25000)
                          (dbi-cp:commit conn))
                        (select-count conn)))))))))

    (diag "select count")
    (destructuring-bind (stattus headers body)
        (funcall app (generate-env "/"))
      (is body '(1)))

    (diag "insert")
    (destructuring-bind (stattus headers body)
        (funcall app (generate-env "/" :method :post)))

    (diag "select count")
    (destructuring-bind (stattus headers body)
        (funcall app (generate-env "/"))
      (is body '(2)))))

(lack.middleware.connection.pool:shutdown)
  
(finalize)
