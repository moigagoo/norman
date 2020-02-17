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
    transaction:
      for i in 1..10:
        discard insertId Person(name: "Bob " & $i, age: 20+i)

      for person in getAll(Person):
        for i in 1..3:
          discard insertId Pet(ownerId: person.id)


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
    transaction:
      for person in mitems(getAll Person):
        delete person

      for pet in mitems(getAll Pet):
        delete pet
