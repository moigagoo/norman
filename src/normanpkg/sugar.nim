import macros


const
  dbBackend* {.strdefine.}: string = ""
  dbConnection* {.strdefine.}: string = ""
  dbUser* {.strdefine.}: string = ""
  dbPassword* {.strdefine.}: string = ""
  dbDatabase* {.strdefine.}: string = ""


macro importBackend() =
  newNimNode(nnkImportStmt).add(
    infix(
      ident "norm",
      "/",
      ident dbBackend
    )
  )

macro exportBackend() =
  newNimNode(nnkExportStmt).add(
    ident dbBackend
  )

template apply*(body: untyped) =
  when defined(apply):
    body

template rollback*(body: untyped) =
  when defined(rollback):
    body

macro models*(body: untyped) =
  newCall(
    ident"db",
    newStrLitNode dbConnection,
    newStrLitNode dbUser,
    newStrLitNode dbPassword,
    newStrLitNode dbDatabase,
    body
  )

when defined(verbose):
  import logging

  addHandler newConsoleLogger()

importBackend()

exportBackend()
