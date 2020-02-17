import os, osproc, strutils, times, parsecfg

import cligen


const
  migrationsPath = "migrations"
  binPath = migrationsPath / "bin"


proc compile() =
  echo "Compile migrations"

proc migrate(compile = false) =
  var migCount, compiledMigCount, appliedMigCount: Natural

  for modulePath in walkFiles(migrationsPath / "*.nim"):
    inc migCount

  echo "Compiling migrations..."

  createDir binPath

  var cmds: seq[string]

  for modulePath in walkFiles(migrationsPath / "*.nim"):
    let (_, name, _) = splitFile modulePath

    cmds.add "nim c --verbosity:0 --hints:off -d:apply -o:migrations/bin/apply_$# $#" % [name, modulePath]

  discard execProcesses(cmds, afterRunEvent = proc(idx: int, p: Process) = (inc compiledMigCount; echo "$#/$#" % [$compiledMigCount, $migCount]))

  echo "Applying migrations..."

  for binName in walkFiles(binPath / "apply_*"):
    discard execProcess binName
    inc appliedMigCount
    echo "$#/$#: $#" % [$appliedMigCount, $migCount, binName]

proc rollback(count: int) =
  var migCount, compiledMigCount, rollbackedMigCount: Natural

  for modulePath in walkFiles(migrationsPath / "*.nim"):
    inc migCount

  echo "Compiling migrations..."

  createDir binPath

  var cmds: seq[string]

  for modulePath in walkFiles(migrationsPath / "*.nim"):
    let (_, name, _) = splitFile modulePath

    cmds.add "nim c --verbosity:0 --hints:off -d:rollback -o:migrations/bin/rollback_$# $#" % [name, modulePath]

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

  var lastMigration: string

  for migPath in walkFiles(migrationsPath / "apply_*"):
    lastMigration = migPath

  copyFile(lastMigration, migrationsPath / "rollback_$#_$#.nim" % [$ts, slug])

  copyFile("src/norman/models.nim", migrationsPath / "apply_$#_$#.nim" % [$ts, slug])

proc init() =
  echo "Create models.nim or models dir."

let
  conf = loadConfig("norman.nimble")
  srcDir = conf.getSectionValue("", "srcDir")

echo srcDir

dispatchMulti([migrate], [rollback], [gen], [init], [compile])
