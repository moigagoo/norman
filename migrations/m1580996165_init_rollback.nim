when defined(verbose):
  import logging

  addHandler newConsoleLogger()

import normanpkg/envutils

backendFromEnv()

dbFromEnv:
  type
    Person* = object
      name*: string
      age*: int

    Pet* = object
      ownerId* {.fk: Person.}: int

withDb:
    dropTables()
