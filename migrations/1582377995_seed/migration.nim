import normanpkg/envutils
backendFromEnv()

when defined(verbose):
  import logging
  addHandler newConsoleLogger()

when defined(apply):
  import models

  withDb:
    transaction:
      for i in 1..10:
        discard insertId Person(name: "Bob " & $i, age: 20+i)

      for person in getAll(Person):
        for i in 1..3:
          discard insertId Pet(ownerId: person.id)

elif defined(rollback):
  import "../1582377902_init/models"

  withDb:
    transaction:
      var
        pets = getAll Pet
        persons = getAll Person

      for i in 0..high(pets):
        var pet = pets[i]
        delete pet

      for i in 0..high(persons):
        var person = persons[i]
        delete person
