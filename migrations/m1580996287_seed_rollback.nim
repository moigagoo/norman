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
    var pets = getAll Pet

    for i in 0..high(pets):
      var pet = pets[i]
      delete pet

  transaction:
    var persons = getAll Person

    for i in 0..high(persons):
      var person = persons[i]
      delete person
