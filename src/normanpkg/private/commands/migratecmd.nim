import os
import osproc
import strutils

import ../utils


proc migrate*(verbose = false) =
  ## Apply migrations.

  let lastMig = if fileExists("migrations" / ".last"): readFile("migrations" / ".last") else: ""

  echo "Applying migrations:"

  for migration in getMigrations():
    let migName = splitFile(migration).name

    if migName > lastMig:
      echo "\t$#" % migration

      let (outp, errC) = execCmdEx("nim $# r $#" % [if verbose: "-d:verbose" else: "", migration])

      if errC == 0:
        writeFile("migrations" / ".last", splitFile(migration).name)

      if verbose or errC != 0:
        echo outp
