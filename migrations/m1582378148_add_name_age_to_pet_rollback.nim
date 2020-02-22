# Rollback: Add Name, Age to Pet
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


# Migration

withDb:
  dropUnusedColumns Pet
