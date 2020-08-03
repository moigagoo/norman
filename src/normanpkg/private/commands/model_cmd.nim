import os
import strutils

import ../utils
include "../templates/model.nimf"


proc model*(name: string) =
  ## Generate a blank model.

  let
    modelName = name.toLowerAscii()
    modelFile = "src" / getAppName() / "models" / "$#.nim" % modelName

  echo "Creating blank model:"

  echo "\t$#" % modelFile
  modelFile.writeFile(getModelCode(modelName))
