when defined(apply):
  import norman/envutils

  backendFromEnv()

  dbFromEnv:
    type
      Person* = object
        name*: string
        age*: int

      Pet* = object
        ownerId* {.fk: Person.}: int

  withDb:
    createTables(force=true)


elif defined(rollback):
  import norman/envutils

  backendFromEnv()

  dbFromEnv:
    type
      Person* = object
        name*: string
        age*: int

      Pet* = object
        ownerId* {.fk: Person.}: int

  withDb:
      dropTables()
