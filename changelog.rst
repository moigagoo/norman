*********
Changelog
*********

-   [!]—backward incompatible change
-   [+]—new feature
-   [f]—bugfix
-   [r]—refactoring
-   [t]—test suite improvement

2.1.8 (April 19, 2022)
======================

-   [f] Update dotenv.


2.1.7 (November 18, 2020)
=========================

-   [r] Update requirements, clean up Docker files, minor code formatting.


2.1.6 (August 8, 2020)
======================

-   [+] Wrap queries in migration templates in transactions.


2.1.5 (August 5, 2020)
======================

-   [f] Fix ``undo`` command.


2.1.4 (August 5, 2020)
======================

-   [+] Improve blank migration template.


2.1.3 (August 4, 2020)
======================

-   [+] Add ``--compile`` flag to ``norman migrate`` command.


2.1.2 (August 4, 2020)
======================

-   [+] Require Nim 1.2.6 instead of the development version.


2.1.1 (August 4, 2020)
======================

-   [+] Add ``compile`` command to precompile migrations in parallel before execution.


2.1.0 (August 3, 2020)
======================

-   [!][+] Store model state in migrations to ensure that the correct model state is applied.
-   [f] All migrations would apply the latest model state instead of the model state they were created for.
-   [r] Remove redundant parens in init procs.


2.0.0 (July 26, 2020)
=====================

-   [r] Complete rewrite to match Norm 2.


1.0.2 (March 13, 2020)
======================

-   [f] Require Norm >= 1.1.2.


1.0.1 (March 13, 2020)
======================

-   [f] Fixed issue with ``importBackend`` not exporting the imported backend making it unusable in moduled importing ``models``.


1.0.0 (March 12, 2020)
======================

-   🎉 Initial release.
