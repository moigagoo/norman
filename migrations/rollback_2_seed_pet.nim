import norm/sqlite


db("test.db", "", "", ""):
  type
    Person* = object
      name*: string
      age*: int

    Pet* = object
      ownerId* {.fk: Person.}: int

withDb:
  dropTable Pet
