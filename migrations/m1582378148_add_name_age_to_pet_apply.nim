# Apply: Add Name, Age to Pet
# Generated: 2020-02-22T17:29:08+04:00

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
      name*: string
      age*: Natural


# Migration

withDb:
  transaction:
    addColumn Pet.name
    addColumn Pet.age

    for pet in mitems getAll(Pet):
      pet.name = "unnamed"
      update pet
