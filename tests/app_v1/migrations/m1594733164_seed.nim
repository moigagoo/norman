import strutils
import sugar

include normanpkg/prelude

import app/db_backend
import app/models/user


migrate:
  withDb:
    for i in 1..10:
      discard newUser("user$#@example.com" % $i).dup:
        db.insert

undo:
  withDb:
    discard @[newUser("")].dup:
      db.select("1")
      db.delete
