include normanpkg/prelude 

import app/db_backend


migrate:
  withDb:
    discard "Your migration code goes here."

undo:
  withDb:
    discard "Your undo migration code goes here."
