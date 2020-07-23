import logging


when defined(verbose):
  addHandler(newConsoleLogger(fmtStr = ""))


template migrate*(body: untyped): untyped =
  ## Wrapper for the migration code. Executed if the migration is compiled without ``undo`` flag.

  when not defined(undo):
    body

template undo*(body: untyped): untyped =
  ## Wrapper for the migration undo code. Executed if the migration is compiled with ``undo`` flag.

  when defined(undo):
    body
