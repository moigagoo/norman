import os, osproc, strformat, sugar, terminal, algorithm

import cligen


const
  migrationsDir = "migrations"
  compiledMigrationsDir = migrationsDir / "bin"
  compilationCmd = &"nim c --verbosity:0 --hints:off --outdir:{compiledMigrationsDir} "


proc compile() =
  var compiledMigrationsCount: Natural

  let cmds = collect(newSeq):
    for path in walkFiles(migrationsDir / "*.nim"):
      compilationCmd & path

  proc updateCaption() =
    flushFile stdout
    eraseLine()
    stdout.write &"Compiled {compiledMigrationsCount}/{len(cmds)} migrations..."

  updateCaption()

  discard execProcesses(cmds, afterRunEvent = proc(i: int, p: Process) = (inc compiledMigrationsCount; updateCaption()))

  echo " " & "Done!"

proc apply() =
  var appliedMigrationsCount: Natural

  let bins = collect(newSeq):
    for path in walkFiles(compiledMigrationsDir / "*_apply*"):
      path

  proc updateCaption() =
    flushFile stdout
    eraseLine()
    stdout.write &"Applied {appliedMigrationsCount}/{len(bins)} migrations..."

  updateCaption()

  for bin in bins:
    discard execProcess bin
    inc appliedMigrationsCount
    updateCaption()

  echo " " & "Done!"

proc rollback(count: Natural = 1, all = false) =
  var rollbackedMigrationsCount: Natural

  var bins = collect(newSeq):
    for path in walkFiles(compiledMigrationsDir / "*_rollback*"):
      path

  reverse bins

  if not all:
    bins = bins[0..<count]

  proc updateCaption() =
    flushFile stdout
    eraseLine()
    stdout.write &"Rollbacked {rollbackedMigrationsCount}/{len(bins)} migrations..."

  updateCaption()

  for bin in bins:
    discard execCmd bin
    inc rollbackedMigrationsCount
    updateCaption()

  echo " " & "Done!"

# proc rollback(count: int) =
#   var migCount, compiledMigCount, rollbackedMigCount: Natural

#   for modulePath in walkFiles(migrationsDir / "*.nim"):
#     inc migCount

#   echo "Compiling migrations..."

#   createDir compiledMigrationsDir

#   var cmds: seq[string]

#   for modulePath in walkFiles(migrationsDir / "*.nim"):
#     let (_, name, _) = splitFile modulePath

#     cmds.add "nim c --verbosity:0 --hints:off -d:rollback -o:migrations/bin/rollback_$# $#" % [name, modulePath]

#   discard execProcesses(cmds, afterRunEvent = proc(idx: int, p: Process) = (inc compiledMigCount; echo "$#/$#" % [$compiledMigCount, $migCount]))

#   echo "Rolling back migrations..."

#   cmds.setLen 0

#   for binName in walkFiles(compiledMigrationsDir / "rollback_*"):
#     cmds.insert(binName, 0)

#   for cmd in cmds:
#     discard execProcess cmd
#     inc rollbackedMigCount
#     echo "$#/$#; $#" % [$rollbackedMigCount, $migCount, cmd]

#     if count > 0 and rollbackedMigCount == count:
#       break

# proc generate(msg: string) =
#   let
#     ts = utc now()
#     slug = msg.replace(" ", "_").toLowerAscii()

#   var lastMigration: string

#   for migPath in walkFiles(migrationsDir / "apply_*"):
#     lastMigration = migPath

#   copyFile(lastMigration, migrationsDir / "rollback_$#_$#.nim" % [$ts, slug])

#   copyFile("src/norman/models.nim", migrationsDir / "apply_$#_$#.nim" % [$ts, slug])

# proc init() =
#   echo "Create models.nim or models dir."

dispatchMulti([compile], [apply], [rollback])
