*************************************************
Norman: Scaffolder and Migration Manager for Norm
*************************************************

.. image:: https://travis-ci.com/moigagoo/norman.svg?branch=develop
    :alt: Build Status
    :target: https://travis-ci.com/moigagoo/norman

.. image:: https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble.png
    :alt: Nimble
    :target: https://nimble.directory/pkg/norman


**Norman** is a scaffolder and migration manager for `Norm ORM <https://norm.nim.town>`__.

Norman provides a CLI tool to manage migrations and a ``normanpkg/prelude`` module that helps writing migrations.

*   `Repo <https://github.com/moigagoo/norman>`__

    -   `Issues <https://github.com/moigagoo/norman/issues>`__
    -   `Pull requests <https://github.com/moigagoo/norman/pulls>`__

*   `Sample app <https://github.com/moigagoo/shopapp>`__
*   `API index <theindex.html>`__
*   `Changelog <https://github.com/moigagoo/norman/blob/develop/changelog.rst>`__


Quickstart
==========

1.  Install Norman with `Nimble <https://github.com/nim-lang/nimble>`_:

.. code-block::

    $ nimble install -y norman

2.  Add Norman to your .nimble file:

.. code-block:: nim

    requires "norman >= 2.1.0"


Note for Nim 2.0 users
----------------------

If you are using Nim 2.0 or later, you might need to enable ``deepcopy`` support in your project's ``nim.cfg`` or ``config.nims`` file:

.. code-block::

    deepcopy:on


Usage
=====

1.  Create a blank Nimble package with ``nimble init``. Choose package type "binary".

2.  Run ``norman init`` inside the package directory:

.. code-block::

    $ norman init
    Creating folders and files:
        migrations
        migrations/config.nims
        src/foo/models
        src/foo/db_backend.nim
        .env

3.  Add your first model with ``norman model``:

.. code-block::

    $ norman model -n user
    Creating blank model:
        src/foo/models/user.nim

4.  Open the model in your favorite editor and add fields to it:

.. code-block:: nim

    import norm/model


    type
      User* = ref object of Model

    func newUser*: User =
      User()

⏬⏬⏬

.. code-block:: nim

    import norm/model


    type
      User* = ref object of Model
        email*: string

    func newUser*(email: string): User =
      User(email: email)

    func newUser*: User =
      newUser("")


5.  Generate a migration for the new model with ``norman generate``:

.. code-block::

    $ norman generate -i user
    Creating blank migration:
        migrations/1595536838_init_user/migration.nim
    Copying models:
        src/foo/models


6.  Apply migrations with ``norman migrate``:

.. code-block::

    $ norman migrate
    Applying migrations:
        migrations/1595536838_init_user

This creates the table for your new model.

7.  Generate a migration with ``norman generate``:

.. code-block::

    $ norman generate -m "seed users"
    Creating blank migration:
        migrations/1595537495_seed_users/migration.nim
    Copying models:
        src/foo/models

8.  Edit the migration to actually insert rows into the DB:

.. code-block:: nim

    include normanpkg/prelude

    import foo/db_backend


    migrate:
      withDb:
        db.transaction:
          let qry = """ALTER TABLE "Table" ADD COLUMN column TYPE NOT NULL DEFAULT value"""

          debug qry
          db.exec sql qry

    undo:
      withDb:
        db.transaction:
          let qry = """ALTER TABLE "Table" DROP COLUMN column"""

          debug qry
          db.exec sql qry


⏬⏬⏬

.. code-block:: nim

    include normanpkg/prelude

    import strutils
    import sugar

    import foo/db_backend
    import models/user


    migrate:
      withDb:
        db.transaction:
          for i in 1..10:
            discard newUser("user$#@example.com" % $i).dup:
              db.insert

    undo:
      withDb:
        db.transaction:
          discard @[newUser()].dup:
            db.select("1")
            db.delete

9.  Apply the new migration:

.. code-block::

    $ norman migrate
    Applying migrations:
        migrations/1595537495_seed_users

10. To undo the last applied migration, run ``norman undo``:

.. code-block::

    $ norman undo

    Undoing migration:
        migrations/1595537495_seed_users


Troubleshooting
===============

"Error: cannot open file: normanpkg/prelude"
--------------------------------------------

If you see this error, it is likely that you are using ``nimble setup`` (project isolation) but haven't re-run it after adding ``norman`` to your dependencies.

**Solution:** Run ``nimble setup`` again in your project root.

.. code-block::

    $ nimble setup

This updates ``nimble.paths`` to include ``norman``, allowing migrations to find it.

If the error persists or you need to manually configure paths, ensure ``migrations/config.nims`` includes ``nimble.paths`` correctly:

.. code-block:: nim

    when fileExists("$projectDir/../../nimble.paths"):
      include "$projectDir/../../nimble.paths"

And ensure the path to your source is correct:

.. code-block:: nim

    switch("path", "$projectDir/../../src")

"Error: 'deepcopy' support has to be enabled"
---------------------------------------------

If you are using Nim 2.0 or newer, you must enable ``deepcopy`` for migrations to work.
Add this line to your ``migrations/config.nims``:

.. code-block:: nim

    switch("deepcopy", "on")
