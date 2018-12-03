# Lack-Middleware-Connection-Pool 
[![Build Status](https://travis-ci.org/tamurashingo/lack-middleware-connection-pool.svg?branch=master)](https://travis-ci.org/tamurashingo/lack-middleware-connection-pool)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)

CL-DBI Connection Pool for Lack

## Usage

### initialize

```common-lisp
(lack:builder
  (:connection-pol
   :driver-name :mysql
   :database-name "test"
   :username "root"
   :password "password")
  *app*)
```

### in app

```common-lisp
(lambda (env)
  (let* ((conn (getf env :lack.db.connection))
         (query (dbi-cp:prepare conn "select username from users where valid_flag = ?"))
         (result (dbi-cp:execute conn "1")))
    (loop for row = (dbi-cp:fetch result)
          while row
          ....
```

## Installation

This library will be available on Quicklisp when ready for use.

## Author

* tamura shingo (tamura.shingo@gmail.com)

## Copyright

Copyright (c) 2018 tamura shingo (tamura.shingo@gmail.com)

## License

Licensed under the MIT License.
