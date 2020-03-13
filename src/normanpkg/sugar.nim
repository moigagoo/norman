## Syntactic sugar for model definitions and migrations


{.used.}


import macros


const
  dbBackend* {.strdefine.}: string = ""
  dbConnection* {.strdefine.}: string = ""
  dbUser* {.strdefine.}: string = ""
  dbPassword* {.strdefine.}: string = ""
  dbDatabase* {.strdefine.}: string = ""


macro importBackend*() =
  ## Generate the code to import and export Norm backend defined in the project config.

  newStmtList().add(
    newNimNode(nnkImportStmt).add(
      infix(
        ident "norm",
        "/",
        ident dbBackend
      )
    ),
    newNimNode(nnkExportStmt).add(
      ident dbBackend
    )
  )

template migrate*(body: untyped) =
  ## Migrate block for migrations.

  when defined(migrate):
    body

template undo*(body: untyped) =
  ## Undo block for migrations.

  when defined(undo):
    body

macro models*(body: untyped) =
  ## Model definition block.

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
