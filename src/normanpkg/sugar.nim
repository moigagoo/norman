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

template migrate*(body: untyped) =
  when defined(migrate):
    body

template undo*(body: untyped) =
  when defined(undo):
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

  addHandler newConsoleLogger(fmtStr="")

importBackend()

exportBackend()
