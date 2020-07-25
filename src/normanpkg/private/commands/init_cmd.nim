import os
import strutils

import ../utils
include "../templates/db_backend.nimf"
include "../templates/config.nimf"
include "../templates/env.nimf"


type
  Backend* = enum
    sqlite, postgres

proc init*(backend: Backend = sqlite) =
  ## Scaffold folders and configs for migrations.

  let appName = getAppName()

  echo "Creating folders and files:"

  let migDir = "migrations"
  echo "\t$#" % migDir
  createDir(migDir)

  let cfgFile = migDir / "config.nims"
  echo "\t$#" % cfgFile
  cfgFile.writeFile(getConfigCode())

  let modelsDir = "src" / appName / "models"
  echo "\t$#" % modelsDir
  createDir(modelsDir)

  let dbBackendFile = "src" / appName / "db_backend.nim"
  echo "\t$#" % dbBackendFile
  dbBackendFile.writeFile(getDbBackendCode($backend))

  let envFile = ".env"
  echo "\t$#" % envFile
  envFile.writeFile case backend
    of sqlite: getSqliteEnvCode(appName)
    of postgres: getPostgresEnvCode(appName)
