import os
import algorithm


proc getMigrations*: seq[string] =
  ## List migration file in "migrations" directory, sorted A -> z.

  for migration in walkFiles("migrations/*.nim"):
    result.add migration

  sort result

proc getAppName*: string =
  ## Get the app name from the .nimble file name.

  for nimbleFile in walkFiles("*.nimble"):
    return splitFile(nimbleFile).name
