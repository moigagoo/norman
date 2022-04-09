{.warning[UnusedImport]: off.}


import cligen
import dotenv

import normanpkg/private/commands/[
  init_cmd,
  migrate_cmd,
  undo_cmd,
  model_cmd,
  generate_cmd,
  compile_cmd
]
from normanpkg/prelude import nil


try:
  load()
except:
  discard


when isMainModule:
  dispatchMulti([init], [migrate], [undo], [model], [generate], [compile])

