import os, osproc, strutils, times

import cligen


const
  migrationsPath = "migrations"
  binPath = migrationsPath / "bin"


proc migrate() =
  var migCount, compiledMigCount, appliedMigCount: Natural

  for modulePath in walkFiles(migrationsPath / "apply_*"):
    inc migCount

  echo "Compiling migrations..."

  createDir binPath

  var cmds: seq[string]

  for modulePath in walkFiles(migrationsPath / "apply_*"):
    let (_, name, _) = splitFile modulePath

    cmds.add "nim c --verbosity:0 --hints:off --out:migrations/bin/$# $#" % [name, modulePath]

  discard execProcesses(cmds, afterRunEvent = proc(idx: int, p: Process) = (inc compiledMigCount; echo "$#/$#" % [$compiledMigCount, $migCount]))

  echo "Applying migrations..."

  for binName in walkFiles(binPath / "apply_*"):
    discard execProcess binName
    inc appliedMigCount
    echo "$#/$#: $#" % [$appliedMigCount, $migCount, binName]

proc rollback(count: int) =
  var migCount, compiledMigCount, rollbackedMigCount: Natural

  for modulePath in walkFiles(migrationsPath / "rollback_*"):
    inc migCount

  echo "Compiling migrations..."

  createDir binPath

  var cmds: seq[string]

  for modulePath in walkFiles(migrationsPath / "rollback_*"):
    let (_, name, _) = splitFile modulePath

    cmds.add "nim c --verbosity:0 --hints:off --out:migrations/bin/$# $#" % [name, modulePath]

  discard execProcesses(cmds, afterRunEvent = proc(idx: int, p: Process) = (inc compiledMigCount; echo "$#/$#" % [$compiledMigCount, $migCount]))

  echo "Rolling back migrations..."

  cmds.setLen 0

  for binName in walkFiles(binPath / "rollback_*"):
    cmds.insert(binName, 0)

  for cmd in cmds:
    discard execProcess cmd
    inc rollbackedMigCount
    echo "$#/$#; $#" % [$rollbackedMigCount, $migCount, cmd]

    if count > 0 and rollbackedMigCount == count:
      break

proc gen(msg: string) =
  let
    ts = now().toTime().toUnix()
    slug = msg.replace(" ", "_").toLowerAscii()

  copyFile("src/norman/models.nim", migrationsPath / "apply_$#_$#.nim" % [$ts, slug])

  var lastMigration: string

  for migPath in walkFiles(migrationsPath / "apply_*"):
    lastMigration = migPath

  copyFile(lastMigration, migrationsPath / "rollback_$#_$#.nim" % [$ts, slug])


dispatchMulti([migrate], [rollback], [gen])
