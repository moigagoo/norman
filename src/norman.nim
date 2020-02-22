import os, osproc, strutils, strformat, times, sugar, terminal, algorithm, parsecfg

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

proc generate(message: string) =
  createDir migrationsDir

  proc slugify(s: string): string =
    let cleanS = collect(newSeq):
      for c in s:
        if c in IdentChars+Whitespace:
          c

    cleanS.join().normalize().splitWhitespace().join("_")

  let
    now = now()
    ts = now.toTime().toUnix()
    slug = slugify(message)
    applyMigrationPath = migrationsDir / &"m{ts}_{slug}_apply.nim"
    rollbackMigrationPath = migrationsDir / &"m{ts}_{slug}_rollback.nim"

  var rollbackMigration = &"""
# Rollback: {message}
# Generated: {now}
"""

  var latestApplyMigrationPath: string

  for path in walkFiles(migrationsDir/"*_apply*"):
    latestApplyMigrationPath = path

  if len(latestApplyMigrationPath) > 0:
    for line in lines(latestApplyMigrationPath):
      if line == "# Migration":
        break

      elif line.startsWith("# Apply") or line.startsWith("# Generated"):
        continue

      rollbackMigration.add line&"\n"

  rollbackMigration.add """
# Migration

withDb:
  transaction:
    discard "put the migration code here"
"""

  rollbackMigrationPath.writeFile rollbackMigration

  var applyMigration = &"""
# Apply: {message}
# Generated: {now}

# Models

"""

  var srcDir, pkgName: string

  for path in walkFiles("*.nimble"):
    pkgName = splitFile(path).name

    srcDir = loadConfig(path).getSectionValue("", "srcDir")

    break

  for path in walkDirs(srcDir/pkgName&"*"):
    for model in walkFiles(path/"models"/"*.nim"):
      applyMigration.add &"""
# {model}
{readFile(model)}
"""

    for modelsFile in walkFiles(path/"models.nim"):
      applyMigration.add &"""
# {modelsFile}
{readFile(modelsFile)}
"""

      break

    break

  applyMigration.add """

# Migration

withDb:
  transaction:
    discard "put the migration code here"
"""

  applyMigrationPath.writeFile applyMigration

  echo &"""
Generated migrations:
- {applyMigrationPath}
- {rollbackMigrationPath}

Edit them to add the actual migration logic."""

# proc init() =
#   echo "Create models.nim or models dir."

dispatchMulti([compile], [apply], [rollback], [generate])
