## .. include:: ../README.rst

{.warning[UnusedImport]: off.}


import cligen
import dotenv

import normanpkg/private/commands/[init_cmd, migrate_cmd, undo_cmd]
from normanpkg/prelude import nil


initDotEnv().load()


when isMainModule:
  dispatchMulti([init], [migrate], [undo])
