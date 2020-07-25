**********************************
Norman: Migration Manager for Norm
**********************************

.. image:: https://travis-ci.com/moigagoo/norman.svg?branch=develop
    :alt: Build Status
    :target: https://travis-ci.com/moigagoo/norman

.. image:: https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble.png
    :alt: Nimble
    :target: https://nimble.directory/pkg/norman


**Norman** is a migration manager for `Norm ORM <https://moigagoo.github.io/norm/norm.html>`__.

Norman provides a CLI tool to manage migrations and a ``normanpkg/prelude`` module that helps writing migrations.

*   `Repo <https://github.com/moigagoo/norman>`__

    -   `Issues <https://github.com/moigagoo/norman/issues>`__
    -   `Pull requests <https://github.com/moigagoo/norman/pulls>`__

*   `Sample app <https://github.com/moigagoo/shop-api>`__
*   `API index <theindex.html>`__
*   `Changelog <https://github.com/moigagoo/norman/blob/develop/changelog.rst>`__


Quickstart
==========

1.  Install Norman with `Nimble <https://github.com/nim-lang/nimble>`_:

.. code-block::

    $ nimble install -y norman

2.  Add Norman to your .nimble file:

.. code-block:: nim

    requires "norman"

**Note:** Norman requires the development version of Nim.


Usage
=====

1.  Create a black Nimble package with ``nimble init``. Choose package type "binary".

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
    Creating blank model and init migration:
        src/foo/models/user.nim
        migrations/m1595536838_init_user.nim

4.  Open the model in your favorite editor and add fields to it:

.. code-block:: nim

    import norm/model


    type
      User* = ref object of Model

    func newUser*(): User =
      newUser(email = "")

⏬⏬⏬

.. code-block:: nim

    import norm/model


    type
      User* = ref object of Model
        email*: string

    func newUser*(email: string): User =
      User(email: email)

    func newUser*(): User =
      newUser("")


5.  Apply migrations with ``norman migrate``:

.. code-block:: language

    $ norman migrate
    Applying migrations:
        migrations/m1595536838_init_user.nim

    This creates the table for your new model.

6.  Generate a migration with ``norman generate``:

.. code-block::

    $ norman generate -m "seed users"
    Creating blank migration:
        migrations/m1595537495_seed_users.nim

7.  Edit the migration to actually insert rows into the DB:

.. code-block:: nim

    include normanpkg/prelude

    import foo/db_backend


    migrate:
      withDb:
        discard "Your migration code goes here."

    undo:
      withDb:
        discard "Your undo migration code goes here."


⏬⏬⏬

.. code-block:: nim

    include normanpkg/prelude

    import strutils
    import sugar

    import foo/db_backend
    import foo/models/user


    migrate:
      withDb:
        for i in 1..10:
          discard newUser("user$#@example.com" % $i).dup:
            db.insert

    undo:
      withDb:
        discard @[newUser()].dup:
          db.select("1")
          db.delete

8.  Apply the new migration:

.. code-block::

    $ norman migrate
    Applying migrations:
        migrations/m1595537495_seed_users.nim

9.  To undo the last applied migration, run ``norman undo``:

.. code-block::

    $ norman undo

    Undoing migration:
        migrations/m1595537495_seed_users.nim
