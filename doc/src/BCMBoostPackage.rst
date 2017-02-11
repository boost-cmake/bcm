===============
BCMBoostPackage
===============

-----------------
bcm_boost_package
-----------------

.. program:: bcm_boost_package

This setups a boost package in cmake. It creates a library target that will be installed. The target will be exported and it will be in the ``boost::`` namespace. In addition, the target will be setup to auto-link for the tests.

.. option:: <package-name>

The name of the boost package. The corresponding cmake package config can be used with ``find_package(boost_<package-name>)``.

.. option:: VERSION <version>

Sets the version of the package.

.. option:: VERSION_HEADER <header>

This will parse the version from a header file. It parses it from the macros defined in the header as ``BOOST_<package-name>_VERSION_MAJOR``, ``BOOST_<package-name>_VERSION_MINOR``, and ``BOOST_<package-name>_VERSION_PATCH``.

.. option:: SOURCES <source-files>...

The source files to build the library.

.. option:: DEPENDS <boost-dependencies>...

This specifies the internal boost dependecies, that is, dependencies on other boost libraries. The libraries should not be prefixed with ``boost_`` nor ``boost::``.

.. option:: EXTERNAL_DEPENDS PACKAGE <dependencies>...

This specifies external ``find_package`` dependencies.
