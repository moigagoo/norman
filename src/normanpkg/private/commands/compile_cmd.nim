import os
import osproc
import strutils
import sugar

import ../utils


proc compile* =
  ## Compile migrations.

  let
    lastMig = if fileExists("migrations" / ".last"): readFile("migrations" / ".last") else: ""
    compileCmds = collect(newSeq):
      for migration in getMigrations():
        let migName = splitPath(migration).tail

        if migName > lastMig:
          "nim c -o:$# --outdir:$# --nimcache:$# $#" % [migName, "migrations" / "bin", "migrations" / "bin" / ".cache" / migName, migration / "migration.nim"]

  echo "Compiling migrations..."

  discard execProcesses(compileCmds, options = {poStdErrToStdOut})
