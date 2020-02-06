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
    for i in 1..10:
      var person = Person(name: "Bob " & $i, age: 20+i)
      insert person
