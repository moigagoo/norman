# Apply: Seed
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
    for i in 1..10:
      discard insertId Person(name: "Bob " & $i, age: 20+i)

    for person in getAll(Person):
      for i in 1..3:
        discard insertId Pet(ownerId: person.id)
