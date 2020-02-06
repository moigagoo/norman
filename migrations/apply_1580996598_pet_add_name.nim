import norm/sqlite


db("test.db", "", "", ""):
  type
    Person* = object
      name*: string
      age*: int

    Pet* = object
      ownerId* {.fk: Person.}: int
      name*: string


withDb:
  addColumn Pet.name

  transaction:
    for pet in mitems getAll(Pet):
      pet.name = "unnamed"
      update pet
