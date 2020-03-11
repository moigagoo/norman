## Norman, a migration manager for Norm.

import strutils
import os, osproc
import parsecfg
import times
import sugar
import algorithm

import cligen

import normanpkg/private/[consts, utils]


var pkgDir: string


proc init() =
  ## Init model structure.

  createDir(pkgDir)

  (pkgDir/mdlFile).writeFile mdlTmpl

  echo "Models file created: $#." % (pkgDir/mdlFile)

  createDir(pkgDir/mdlDir)

  echo "Models directory created: $#." % (pkgDir/mdlDir)

  cfgFile.writeFile(cfgTmpl)

  echo "Config file created: $#." % cfgFile

  createDir(mgrDir)

  (mgrDir/lstFile).writeFile("")

  echo "Migration directory created: $#." % mgrDir


proc generate(message: string) =
  ## Generate a migration from the current model state.

  let
    timestamp = now().toTime().toUnix()
    slug = slugified message
    newMgrDir = mgrDir / "$#_$#" % [$timestamp, slug]
    lstMdlImpPath =
      if (let mgrNames = getMgrNames(); len(mgrNames) > 0):
        '"' & "../$#/models" % mgrNames[^1] & '"'
      else:
        "models"

  createDir(mgrDir)

  createDir(newMgrDir)

  echo "New migration directory created in $#." % (newMgrDir)

  copyFile(pkgDir/mdlFile, newMgrDir/mdlFile)

  copyDir(pkgDir/mdlDir, newMgrDir/mdlDir)

  echo "Current models copied to $# and $#." % [newMgrDir/mdlFile, newMgrDir/mdlDir]

  (newMgrDir/mgrFile).writeFile(mgrTmpl % lstMdlImpPath)

  echo "New migration template created in $#." % (newMgrDir/mgrFile)

proc apply(verbose = false) =
  ## Apply migrations.

  createDir(mgrDir/binDir)

  let
    lstMgrName = readFile(mgrDir/lstFile)
    mgrNames = collect(newSeq):
      for mgrName in getMgrNames():
        if mgrName > lstMgrName:
          mgrName

  if len(mgrNames) == 0:
    echo "No migrations to apply."

    return

  var
    binPaths, cmplCmds: seq[string]
    cmplCount: Natural
    cmplFailIdxs: seq[int]

  for mgrName in mgrNames:
    let
      cacheDirPath = mgrDir / binDir / applyPfx & mgrName & cacheSfx
      binPath = mgrDir / binDir / applyPfx & mgrName
      cmplCmd = [cmplCmdTmpl % [cacheDirPath, binPath], (if verbose: verboseFlag else: ""), applyFlag, mgrDir/mgrName/mgrFile].join(" ")

    binPaths.add binPath

    cmplCmds.add cmplCmd

  proc updCmplMsg() =
    updTermMsg("Compiling migrations: $#/$#" % [$cmplCount, $len(mgrNames)])

  discard execProcesses(
    cmplCmds,
    options = {poStdErrToStdOut},
    beforeRunEvent = (idx: int) => updCmplMsg(),
    afterRunEvent = (idx: int, p: Process) => (if peekExitCode(p) != 0: cmplFailIdxs.add idx; inc cmplCount; updCmplMsg())
  )

  echo ". Done!"

  if len(cmplFailIdxs) > 0:
    echo "Compilation failed:"

    for idx in cmplFailIdxs:
      echo "\t$#" % mgrNames[idx]

    return

  for idx, binPath in binPaths:
    if not verbose:
      updTermMsg("Applying migrations: $#/$#" % [$(idx+1), $len(mgrNames)])

    let (output, exitCode) = execCmdEx(binPath)

    if exitCode != 0:
      echo ".\nMigration failed: $#" % mgrNames[idx]

      echo output

      return

    (mgrDir/lstFile).writeFile(mgrNames[idx])

  echo ". Done!"

proc rollback(n: Positive = 1, all = false, verbose = false) =
  ## Rollback ``n``or all migrations.

  createDir(mgrDir/binDir)

  var count: Natural

  let
    lstMgrName = readFile(mgrDir/lstFile)
    appliedMgrNames = collect(newSeq):
      for mgrName in reversed getMgrNames():
        if mgrName <= lstMgrName:
          mgrName
    mgrNames = if all: appliedMgrNames else: appliedMgrNames[0..<n]

  if len(mgrNames) == 0:
    echo "No migrations to rollback."

    return

  var
    binPaths, cmplCmds: seq[string]
    cmplCount: Natural
    cmplFailIdxs: seq[int]

  for mgrName in mgrNames:
    let
      cacheDirPath = mgrDir / binDir / rollbackPfx & mgrName & cacheSfx
      binPath = mgrDir / binDir / rollbackPfx & mgrName
      cmplCmd = [cmplCmdTmpl % [cacheDirPath, binPath], (if verbose: verboseFlag else: ""), rollbackFlag, mgrDir/mgrName/mgrFile].join(" ")

    binPaths.add binPath

    cmplCmds.add cmplCmd

  proc updCmplMsg() =
    updTermMsg("Compiling migrations: $#/$#" % [$cmplCount, $len(mgrNames)])

  discard execProcesses(
    cmplCmds,
    options = {poStdErrToStdOut},
    beforeRunEvent = (idx: int) => updCmplMsg(),
    afterRunEvent = (idx: int, p: Process) => (if peekExitCode(p) != 0: cmplFailIdxs.add idx; inc cmplCount; updCmplMsg())
  )

  echo ". Done!"

  if len(cmplFailIdxs) > 0:
    echo "Compilation failed:"

    for idx in cmplFailIdxs:
      echo "\t$#" % mgrNames[idx]

    return

  for idx, binPath in binPaths:
    if not verbose:
      updTermMsg("Rollbacking migrations: $#/$#" % [$(idx+1), $len(mgrNames)])

    let (output, exitCode) = execCmdEx(binPath)

    if exitCode != 0:
      echo ".\nMigration failed: $#" % mgrNames[idx]

      echo output

      return

    (mgrDir/lstFile).writeFile(if idx < high(appliedMgrNames): appliedMgrNames[idx+1] else: "")

  echo ". Done!"


when isMainModule:
  let nimbleFile = findNimbleFile()

  if len(nimbleFile) == 0:
    quit(".nimble file not found. Please run Norman inside a package.")

  let
    cfg = loadConfig(nimbleFile)
    srcDir = cfg.getSectionValue("", "srcDir")
    pkgName = splitFile(nimbleFile).name

  pkgDir = srcDir / pkgName

  dispatchMulti([init], [generate], [apply], [rollback])
