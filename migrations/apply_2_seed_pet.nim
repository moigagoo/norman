import norm/sqlite


db("test.db", "", "", ""):
  type
    Person* = object
      name*: string
      age*: int

    Pet* = object
      ownerId* {.fk: Person.}: int

withDb:
  transaction:
    for person in getAll(Person):
      for i in 1..3:
        var pet = Pet(ownerId: person.id)
        insert pet
