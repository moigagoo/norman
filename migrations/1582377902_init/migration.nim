import normanpkg/sugar


apply:
  import models

  withDb:
    transaction:
      createTables()


rollback:
  import models

  withDb:
    transaction:
      dropTables()
