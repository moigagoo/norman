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
        name*: string

  withDb:
    addColumn Pet.name

  withDb:
    transaction:
      for pet in mitems getAll(Pet):
        pet.name = "undefined"
        update pet


elif defined(rollback):
  db("test.db", "", "", ""):
    type
      Person* = object
        name*: string
        age*: int

      Pet* = object
        ownerId* {.fk: Person.}: int

  withDb:
    dropUnusedColumns Pet
