import norm/sqlite
import person


dbTypes:
  type
    Pet* = object
      ownerId* {.fk: Person.}: int
      name*: string
      age*: Natural
