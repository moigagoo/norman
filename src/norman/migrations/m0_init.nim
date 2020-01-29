import logging
addHandler newConsoleLogger()

import norm/sqlite


when defined(apply):
  db("test.db", "", "", ""):
    type
      Person* = object
        name*: string
        age*: int

      Pet* = object
        ownerId* {.fk: Person.}: int

  withDb:
    createTables(force=true)


elif defined(rollback):
  db("test.db", "", "", ""):
    type
      Person* = object
        name*: string
        age*: int

      Pet* = object
        ownerId* {.fk: Person.}: int

  withDb:
      dropTables()
