## .. include:: ../README.rst

{.warning[UnusedImport]: off.}


import os
import osproc
import strutils
import algorithm

import cligen
import dotenv

from normanpkg/sugar import nil


initDotEnv().load()


proc getMigrations(): seq[string] =
  for migration in walkFiles("migrations/*.nim"):
    result.add migration

  sort result


proc migrate(verbose = false) =
  ## Apply migrations.

  let migrations = getMigrations()

  echo "Applying $# migrations:" % $len(migrations)

  for migration in migrations:
    echo "- $#" % migration

    let (outp, errC) = execCmdEx("nim $# r $#" % [if verbose: "-d:verbose" else: "", migration])

    if errC == 0:
      writeFile("migrations" / ".last", splitFile(migration).name)

    if verbose:
      echo outp

proc undo(verbose = false) =
  ## Undo the last applied migration.

  let
    migrations = getMigrations()
    lastMig = readFile("migrations" / ".last")

  for i in countdown(high(migrations), 0):
    let
      migration = migrations[i]
      migName = splitFile(migration).name

    if migName <= lastMig:
      echo "Undoing migration: $#" % migration

      let (outp, errC) = execCmdEx("nim -d:undo $# r $#" % [if verbose: "-d:verbose" else: "", migration])

      if errC == 0:
        if i == 0:
          writeFile("migrations" / ".last", "")
        else:
          writeFile("migrations" / ".last", splitFile(migrations[i - 1]).name)

      if verbose:
        echo outp

      return


when isMainModule:
  dispatchMulti([migrate], [undo])
