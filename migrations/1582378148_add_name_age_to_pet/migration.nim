import normanpkg/envutils
backendFromEnv()

when defined(verbose):
  import logging
  addHandler newConsoleLogger()

when defined(apply):
  import models

  withDb:
    transaction:
      addColumn Pet.name
      addColumn Pet.age

      for pet in mitems getAll(Pet):
        pet.name = "unnamed"
        update pet

elif defined(rollback):
  import "../1582377995_seed/models"

  withDb:
    dropUnusedColumns Pet
