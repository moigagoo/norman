import os
import times
import strutils

import ../utils
include "../templates/migrations/blank.nimf"
include "../templates/migrations/init.nimf"


proc generate*(message = "", init = "") =
  ## Generate a blank migration.

  let
    ts = now().utc().toTime().toUnix()
    migSlug =
      if len(init) > 0: "$#_init_$#" % [$ts, init]
      elif len(message) > 0: "$#_$#" % [$ts, getSlug(message)]
      else: $ts
    appName = getAppName()
    modDir = "src" / appName / "models"
    migDir = "migrations" / migSlug
    migFile = migDir / "migration.nim"

  echo "Creating blank migration:"
  echo "\t$#" % migFile
  createDir(migDir)
  migFile.writeFile(if len(init) == 0: getBlankMigCode(appName) else: getInitMigCode(appName, init))

  echo "Copying models:"
  echo "\t$#" % modDir
  createDir(migDir / "models")
  modDir.copyDir(migDir / "models")
