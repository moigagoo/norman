import os
import algorithm


proc getMigrations*: seq[string] =
  for migration in walkFiles("migrations/*.nim"):
    result.add migration

  sort result
