import os, macros


macro backendFromEnv*() =
  newNimNode(nnkImportStmt).add(
    infix(
      ident "norm",
      "/",
      ident getEnv("NORN_BACKEND", "sqlite")
    )
  )

macro dbFromEnv*(body: untyped): untyped =
  newCall(
    ident"db",
    newStrLitNode getEnv("NORM_CONN"),
    newStrLitNode getEnv("NORM_USER"),
    newStrLitNode getEnv("NORM_PASS"),
    newStrLitNode getEnv("NORM_DB"),
    body
  )
