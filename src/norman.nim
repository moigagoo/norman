## .. include:: ../README.rst

{.warning[UnusedImport]: off.}


import cligen
import dotenv

import normanpkg/private/commands/[migratecmd, undocmd]
from normanpkg/prelude import nil


initDotEnv().load()


when isMainModule:
  dispatchMulti([migrate], [undo])
