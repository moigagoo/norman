import os
import osproc
import strutils

import compile_cmd
import ../utils


proc migrate*(compile = false, verbose = false) =
  ## Apply migrations.

  if compile:
    compile()

  let lastMig = if fileExists("migrations" / ".last"): readFile("migrations" / ".last") else: ""

  echo "Applying migrations:"

  for migration in getMigrations():
    let migName = splitPath(migration).tail

    if migName > lastMig:
      echo "\t$#" % migration

      let (outp, errC) = execCmdEx("nim c -r $# -o:$# --outdir:$# --nimcache:$# $#" % [if verbose: "-d:verbose" else: "", migName, "migrations" / "bin", "migrations" / "bin" / ".cache" / migName, migration / "migration.nim"])

      if errC == 0:
        writeFile("migrations" / ".last", migName)

      if verbose or errC != 0:
        echo outp
