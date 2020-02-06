import os, osproc, strutils

import cligen


proc migrate() =
  var migCount, compiledMigCount, appliedMigCount: Natural

  for modulePath in walkFiles("migrations/apply_*"):
    inc migCount

  echo "Compiling migrations..."

  createDir "migrations" / "bin"

  var cmds: seq[string]

  for modulePath in walkFiles("migrations/apply_*"):
    let (_, name, _) = splitFile modulePath

    cmds.add "nim c --verbosity:0 --hints:off --out:migrations/bin/$# $#" % [name, modulePath]

  discard execProcesses(cmds, afterRunEvent = proc(idx: int, p: Process) = (inc compiledMigCount; echo "$#/$#" % [$compiledMigCount, $migCount]))

  echo "Applying migrations..."

  for binName in walkFiles("migrations/bin/apply_*"):
    discard execProcess binName
    inc appliedMigCount
    echo "$#/$#: $#" % [$appliedMigCount, $migCount, binName]

proc rollback(count: int) =
  var migCount, compiledMigCount, rollbackedMigCount: Natural

  for modulePath in walkFiles("migrations/rollback_*"):
    inc migCount

  echo "Compiling migrations..."

  createDir "migrations" / "bin"

  var cmds: seq[string]

  for modulePath in walkFiles("migrations/rollback_*"):
    let (_, name, _) = splitFile modulePath

    cmds.add "nim c --verbosity:0 --hints:off --out:migrations/bin/$# $#" % [name, modulePath]

  discard execProcesses(cmds, afterRunEvent = proc(idx: int, p: Process) = (inc compiledMigCount; echo "$#/$#" % [$compiledMigCount, $migCount]))

  echo "Rolling back migrations..."

  cmds.setLen 0

  for binName in walkFiles("migrations/bin/rollback_*"):
    cmds.insert(binName, 0)

  for cmd in cmds:
    discard execProcess cmd
    inc rollbackedMigCount
    echo "$#/$#; $#" % [$rollbackedMigCount, $migCount, cmd]

    if count > 0 and rollbackedMigCount == count:
      break


dispatchMulti([migrate], [rollback])
