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
  transaction:
    for person in mitems(getAll Person):
      delete person

    for pet in mitems(getAll Pet):
      delete pet
