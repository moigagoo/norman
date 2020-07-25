import os
import algorithm
import strutils
import sugar


proc getMigrations*: seq[string] =
  ## List migration file in "migrations" directory, sorted A -> z.

  for migration in walkFiles("migrations/*.nim"):
    result.add migration

  sort result

proc getAppName*: string =
  ## Get the app name from the .nimble file name.

  for nimbleFile in walkFiles("*.nimble"):
    return splitFile(nimbleFile).name

proc getSlug*(str: string): string =
  ## Get a slug for a given string.

  let clnChars = collect(newSeq):
    for chr in str:
      if chr in IdentChars + Whitespace:
        chr

  clnChars.join().normalize().splitWhitespace().join("_")
