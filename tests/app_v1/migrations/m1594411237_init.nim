import normanpkg/sugar as norman

import app/db_backend


addLogging()


migrate:
  import app/models/user

  withDb:
    db.createTables(newUser(""))

undo:
  let qry = "DROP TABLE IF EXISTS User"

  withDb:
    debug qry
    db.exec sql qry
