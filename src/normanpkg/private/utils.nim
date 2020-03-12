import os
import strutils
import sugar
import algorithm
import terminal

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

proc getMgrNames*(): seq[string] =
  ## Get a sorted list of migration names that come after ``after``.

  let mgrs = collect(newSeq):
    for path in walkDirs(mgrDir/"*"):
      if (let dirName = splitPath(path).tail; dirName != binDir):
        dirName

  sorted mgrs

proc updTermMsg*(msg: string) =
  ## Update terminal message.

  eraseLine()
  flushFile stdout
  stdout.write(msg)
