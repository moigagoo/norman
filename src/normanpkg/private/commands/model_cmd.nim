import os
import times
import strutils

import ../utils
include "../templates/model.nimf"
include "../templates/migrations/init.nimf"


proc model*(name: string) =
  ## Generate a blank model and init migration.

  let
    modelName = name.toLowerAscii()
    modelFile = "src" / getAppName() / "models" / "$#.nim" % modelName
    migFile = "migrations" / "m$#_init_$#.nim" % [$now().utc().toTime().toUnix(), modelName]

  echo "Creating blank model and init migration:"

  echo "\t$#" % modelFile
  modelFile.writeFile(getModelCode(modelName))

  echo "\t$#" % migFile
  migFile.writeFile(getInitMigCode(getAppName(), modelName))
