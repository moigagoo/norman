import os
import strutils
import sugar
import algorithm

import consts


proc findNimbleFile*(): string =
  ## Find the .nimble file in the current directory and return the path to it.

  for path in walkFiles("*.nimble"):
    return path

proc slugified*(msg: string): string =
  ## Return a slugified version of ``message``.

  let msgClean = collect(newSeq):
    for chr in msg:
      if chr in IdentChars+Whitespace:
        chr

  msgClean.join().normalize().splitWhitespace().join("_")

proc findLatestMigration*(): string =
  ## Return the path to the latest migration in the migration folder.

  let mgrs = collect(newSeq):
    for path in walkDirs(mgrDir/"*"):
      if (let dirName = splitPath(path).tail; dirName != "bin"):
        dirName

  if len(mgrs) > 0:
    result = (sorted mgrs)[^1]
