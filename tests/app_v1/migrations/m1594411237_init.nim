include normanpkg/prelude

import app/db_backend


migrate:
  import app/models/user

  withDb:
    db.createTables(newUser(""))

undo:
  let qry = "DROP TABLE IF EXISTS User"

  withDb:
    debug qry
    db.exec sql qry
