# Rollback: Seed
# Generated: 2020-02-22T17:26:35+04:00

# Models

# src\normanpkg\models.nim
import normanpkg/envutils

backendFromEnv()

dbFromEnv:
  type
    Person* = object
      name*: string
      age*: int

    Pet* = object
      ownerId* {.fk: Person.}: int


# Migration

withDb:
  transaction:
    var
      pets = getAll Pet
      persons = getAll Person

    for i in 0..high(pets):
      var pet = pets[i]
      delete pet

    for i in 0..high(persons):
      var person = persons[i]
      delete person
