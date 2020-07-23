include normanpkg/prelude

import app/db_backend
import app/models/customer


migrate:
  withDb:
    db.createTables(newCustomer())

undo:
  let qry = """DROP TABLE IF EXISTS "Customer""""

  withDb:
    debug qry
    db.exec sql qry
