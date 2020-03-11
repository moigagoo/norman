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

  echo "Created models file, models directory, config file, and migrations directory:"

  echo "\t$#" % pkgDir/mdlFile

  createDir(pkgDir/mdlDir)

  echo "\t$#" % pkgDir/mdlDir

  cfgFile.writeFile(cfgTmpl)

  echo "\t$#" % cfgFile

  createDir(mgrDir)

  (mgrDir/lstFile).writeFile("")

  echo "\t$#" % mgrDir


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

  echo "Created migration directory, model backup, and migration template:"

  echo "\t$#" % newMgrDir

  copyFile(pkgDir/mdlFile, newMgrDir/mdlFile)

  copyDir(pkgDir/mdlDir, newMgrDir/mdlDir)

  echo "\t$#" % newMgrDir/mdlFile

  echo "\t$#" % newMgrDir/mdlDir

  (newMgrDir/mgrFile).writeFile(mgrTmpl % lstMdlImpPath)

  echo "\t$#" % newMgrDir/mgrFile

proc migrate(verbose = false) =
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
      cacheDirPath = mgrDir / binDir / mgrPfx & mgrName & cacheSfx
      binPath = mgrDir / binDir / mgrPfx & mgrName
      cmplCmd = [cmplCmdTmpl % [cacheDirPath, binPath], (if verbose: verboseFlag else: ""), mgrFlag, mgrDir/mgrName/mgrFile].join(" ")

    binPaths.add binPath

    cmplCmds.add cmplCmd

  proc updCmplMsg() =
    updTermMsg("Compiled migrations: $#/$#." % [$cmplCount, $len(mgrNames)])

  discard execProcesses(
    cmplCmds,
    options = {poStdErrToStdOut},
    beforeRunEvent = (idx: int) => updCmplMsg(),
    afterRunEvent = (idx: int, p: Process) => (if peekExitCode(p) != 0: cmplFailIdxs.add idx; inc cmplCount; updCmplMsg())
  )

  if len(cmplFailIdxs) > 0:
    echo "\nFailed:"

    for idx in cmplFailIdxs:
      echo "\t$#" % mgrNames[idx]

    return

  echo "\nApplied migrations:"

  for idx, binPath in binPaths:
    echo "\t$#" % mgrNames[idx]

    let (output, exitCode) = execCmdEx(binPath)

    if exitCode != 0:
      echo ".\nFailed: $#" % mgrNames[idx]

      echo output.indent(2, "\t")

      return

    if verbose:
      echo output.indent(2, "\t")

    (mgrDir/lstFile).writeFile(mgrNames[idx])

proc undo(n: Positive = 1, all = false, verbose = false) =
  ## Undo ``n``or all migrations.

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
    echo "No migrations to undo."

    return

  var
    binPaths, cmplCmds: seq[string]
    cmplCount: Natural
    cmplFailIdxs: seq[int]

  for mgrName in mgrNames:
    let
      cacheDirPath = mgrDir / binDir / undoPfx & mgrName & cacheSfx
      binPath = mgrDir / binDir / undoPfx & mgrName
      cmplCmd = [cmplCmdTmpl % [cacheDirPath, binPath], (if verbose: verboseFlag else: ""), undoFlag, mgrDir/mgrName/mgrFile].join(" ")

    binPaths.add binPath

    cmplCmds.add cmplCmd

  proc updCmplMsg() =
    updTermMsg("Compiled migrations: $#/$#." % [$cmplCount, $len(mgrNames)])

  discard execProcesses(
    cmplCmds,
    options = {poStdErrToStdOut},
    beforeRunEvent = (idx: int) => updCmplMsg(),
    afterRunEvent = (idx: int, p: Process) => (if peekExitCode(p) != 0: cmplFailIdxs.add idx; inc cmplCount; updCmplMsg())
  )

  if len(cmplFailIdxs) > 0:
    echo "\nFailed:"

    for idx in cmplFailIdxs:
      echo "\t$#" % mgrNames[idx]

    return

  echo "\nUndone migrations:"

  for idx, binPath in binPaths:
    echo "\t$#" % mgrNames[idx]

    let (output, exitCode) = execCmdEx(binPath)

    if exitCode != 0:
      echo ".\nFailed: $#" % mgrNames[idx]

      echo output.indent(2, "\t")

      return

    if verbose:
      echo output.indent(2, "\t")

    (mgrDir/lstFile).writeFile(if idx < high(appliedMgrNames): appliedMgrNames[idx+1] else: "")


when isMainModule:
  let nimbleFile = findNimbleFile()

  if len(nimbleFile) == 0:
    quit(".nimble file not found. Please run Norman inside a package.")

  let
    cfg = loadConfig(nimbleFile)
    srcDir = cfg.getSectionValue("", "srcDir")
    pkgName = splitFile(nimbleFile).name

  pkgDir = srcDir / pkgName

  dispatchMulti([init], [generate], [migrate], [undo])
