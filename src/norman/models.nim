import norm/sqlite
import models/[person, pet]


db("test.db", "", "", ""):
  type
    Person* = object
      name*: string
      age*: int

    Pet* = object
      ownerId* {.fk: Person.}: int
      name*: string
      age*: Natural


# dbFromTypes("test.db", "", "", "", [Person, Pet])
