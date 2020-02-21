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
    for i in 1..10:
      discard insertId Person(name: "Bob " & $i, age: 20+i)

    for person in getAll(Person):
      for i in 1..3:
        discard insertId Pet(ownerId: person.id)
