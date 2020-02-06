import norm/sqlite


db("test.db", "", "", ""):
  type
    Person* = object
      name*: string
      age*: int

    Pet* = object
      ownerId* {.fk: Person.}: int


withDb:
  for person in mitems(getAll Person):
    delete person

  for pet in mitems(getAll Pet):
    delete pet
