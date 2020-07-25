import os
import osproc
import strutils

import ../utils


proc undo*(verbose = false) =
  ## Undo the last applied migration.

  let
    migrations = getMigrations()
    lastMig = if fileExists("migrations" / ".last"): readFile("migrations" / ".last") else: ""

  for i in countdown(high(migrations), 0):
    let
      migration = migrations[i]
      migName = splitFile(migration).name

    if migName <= lastMig:
      echo "Undoing migration:"
      echo "\t$#" % migration

      let (outp, errC) = execCmdEx("nim -d:undo $# r $#" % [if verbose: "-d:verbose" else: "", migration])

      if errC == 0:
        if i == 0:
          writeFile("migrations" / ".last", "")
        else:
          writeFile("migrations" / ".last", splitFile(migrations[i - 1]).name)

      if verbose or errC != 0:
        echo outp

      return
