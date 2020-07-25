import os
import times
import strutils

import ../utils
include "../templates/migrations/blank.nimf"


proc generate*(message: string) =
  ## Generate a blank migration.

  let migFile = "migrations" / "m$#_$#.nim" % [$now().utc().toTime().toUnix(), getSlug(message)]

  echo "Creating blank migration:"
  echo "\t$#" % migFile

  migFile.writeFile(getBlankMigCode(getAppName()))
