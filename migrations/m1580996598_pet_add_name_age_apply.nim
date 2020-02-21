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
      name*: string
      age*: Natural

withDb:
  transaction:
    addColumn Pet.name
    addColumn Pet.age

    for pet in mitems getAll(Pet):
      pet.name = "unnamed"
      update pet
