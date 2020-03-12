**************************************
Norman: The Migration Manager for Norm
**************************************

.. image:: https://travis-ci.com/moigagoo/norman.svg?branch=develop
    :alt: Build Status
    :target: https://travis-ci.com/moigagoo/norman

.. image:: https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble.png
    :alt: Nimble
    :target: https://nimble.directory/pkg/norman


**Norman** is a migration manager for `Norm ORM <https://moigagoo.github.io/norm/norm.html>`__.

Norman provides a CLI tool to manage migrations and a ``normanpkg/sugar`` module used in migrations.

-   `Repo <https://github.com/moigagoo/norman>`__
    -   `Issues <https://github.com/moigagoo/norman/issues>`__
    -   `Pull requests <https://github.com/moigagoo/norman/pulls>`__
-   `Sample app <https://github.com/moigagoo/norm-sample-webapp>`__
-   `API index <theindex.html>`__
-   `Changelog <https://github.com/moigagoo/norman/blob/develop/changelog.rst>`__


Quickstart
==========

1.  Install Norman with `Nimble <https://github.com/nim-lang/nimble>`_:

.. code-block::

    $ nimble install norman

2.  Add Norman to your .nimble file:

.. code-block:: nim

    requires "norman"

**Note:** Norman requires the development version of Nim.


Usage
=====

1.  Go to your Nimble package directory and run ``norman init``:

.. code-block::

    $ cd myapp
    $ norman init
    Created models file, models directory, config file, and migrations directory:
            src/myapp/models.nim
            src/myapp/models
            config.nims
            migrations

-   ``models.nim`` is the models entrypoint module. Import it in your app whenever you need to access the DB.

    You can either keep all your models in this file under ``db`` macro, or distrubute them across ``models/*`` submodules and aggregate them with ``dbFromTypes``.

    Initially, a placeholder model Model is defined in it to demonstrate how you can define your actual models.

-   ``models`` is the models submodules directory. Initially, it's empty.
-   ``config.nim`` is the project config file. Use it to set the DB backend and credentials across your project.

    By default, it's set to use ``sqlite`` and ``database.db``.

-   ``migrations`` is the directory where your project migrations are stored. Initially empty.

2.  Generate your first migration with ``norman generate``:

.. code-block::

    $ norman generate -m "init db"
    Created migration directory, model backup, and migration template:
            migrations/1583931473_init_db
            migrations/1583931473_init_db/models.nim
            migrations/1583931473_init_db/models
            migrations/1583931473_init_db/migration.nim

In Norman terms, migration is a directory inside ``migrations`` that contains three things:

-   the desired models state
-   the code to get there
-   the code to undo those changes

The model state is stored the same way it's stored in your app: as ``models.nim`` and ``models``.

The migration code is stored in a file called ``migration.nim``, in ``apply`` and ``rollback`` blocks.

Migration names are prefixed with creation timestamps to ensure sequential application.

3.  Apply the migrations from ``migrations`` directory with ``norman migrate``:

.. code-block::

    $ norman migrate
    Compiled migrations: 1/1.
    Applied migrations:
            1583931473_init_db

4.  To undo a migration, run ``norman undo``:

.. code-block::

    $ norman undo
    Compiled migrations: 1/1.
    Undone migrations:
            1583931473_init_db

5.  Whenever you modify your models, go to 2.

For full usage, run ``norman help``:

.. code-block::

    This is a multiple-dispatch command.  Top-level --help/--help-syntax
    is also available.  Usage is like:
        norman {SUBCMD} [subcommand-opts & args]
    where subcommand syntaxes are as follows:

      init [optional-params]
        Init model structure.
      Options(opt-arg sep :|=|spc):
          -h, --help         print this cligen-erated help
          --help-syntax      advanced: prepend,plurals,..

      generate [required&optional-params]
        Generate a migration from the current model state.
      Options(opt-arg sep :|=|spc):
          -h, --help                         print this cligen-erated help
          --help-syntax                      advanced: prepend,plurals,..
          -m=, --message=  string  REQUIRED  set message

      migrate [optional-params]
        Apply migrations.
      Options(opt-arg sep :|=|spc):
          -h, --help                  print this cligen-erated help
          --help-syntax               advanced: prepend,plurals,..
          -v, --verbose  bool  false  set verbose

      undo [optional-params]
        Undo ``n``or all migrations.
      Options(opt-arg sep :|=|spc):
          -h, --help                  print this cligen-erated help
          --help-syntax               advanced: prepend,plurals,..
          -n=, --n=      int   1      set n
          -a, --all      bool  false  set all
          -v, --verbose  bool  false  set verbose
