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

*   `Sample app <https://github.com/moigagoo/norm-sample-webapp>`__
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

4.  Apply migrations with ``norman migrate``:

.. code-block:: language

    $ norman migrate
    Applying migrations:
        migrations\m1595536838_init_user.nim
