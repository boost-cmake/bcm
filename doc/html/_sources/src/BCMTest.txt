=======
BCMTest
=======

----------------
bcm_mark_as_test
----------------

.. program:: bcm_mark_as_test

This marks the target as a test, so it will be built with the ``tests`` target. If ``BUILD_TESTING`` is set to off then the target will not be built as part of the all target.

-----------------------
bcm_test_link_libraries
-----------------------

.. program:: bcm_test_link_libraries

This is the libraries to be linked the tests targets that are created.

------------
bcm_add_test
------------

.. program:: bcm_add_test

This adds a test to ran or compiled.

.. option:: SOURCES <source-files>...

Source files to be compiled for the tests.

.. option:: CONTENT <content>

This a string that will be used to create a test to compiled and/or ran.

.. option:: NAME <name>

Name of the test.

.. option:: COMPILE_ONLY

This just compiles the test. By default, tests are ran.

.. option:: WILL_FAIL

Specifies that the test will fail.

.. option:: NO_TEST_LIBS

This won't link in the libraries specified by ``bcm_test_link_libraries``

---------------
bcm_test_header
---------------

.. program:: bcm_test_header

This creates a test to test the include of a header.

.. option:: NAME <name>

Name of the test.

.. option:: HEADER <header-file>

The header to include.

.. option:: STATIC

Rather than just test the include, using ``STATIC`` option will test the include across translation units. This helps check for incorrect include guards and duplicate symbols.

.. option:: NO_TEST_LIBS

This won't link in the libraries specified by ``bcm_test_link_libraries``


