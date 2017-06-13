==========
BCMPackage
==========

----------------
bcm_find_package
----------------

.. program:: bcm_find_package

This works the same as cmake's ``find_package`` except in addition, it will keep track of the each call to ``bcm_find_package`` in the project. Functions like ``bcm_package`` and ``bcm_boost_package`` will include these dependencies automatically in cmake's package config that gets generated.

.. I don't understand why 'bcm_find_package' needs to do anything other than
   what the standard find_package does. Can't the targets exported by
   'find_package' carry all the "package config" information needed for '.pg'
   file generation?

-----------
bcm_package
-----------

.. program:: bcm_package

This setups a non-boost package in cmake. This is similar to ``bcm_boost_package`` but with extra flexibility as it does not have boost specific conventions. This function creates a library target that will be installed and exported. In addition, the target will be setup to auto-link for the tests.

.. "setup to auto-link for the tests". This is a bit unclear. Maybe say
   "Subsequent uses of 'bcm_test' will automatically include this target as a
   dependency" or something along these lines.

.. option:: <package-name>

The name of the package. This is both the name of the library target and the cmake package config that can be used with ``find_package(<package-name>)``.

.. This is inconsistent with 'bcm_boost_package' below. Why does Boost have to
   be special?

.. option:: VERSION <version>

Sets the version of the package.

.. option:: VERSION_HEADER <header>

This will parse the version from a header file. It will parse the macros defined in the header as ``<prefix>_<package-name>_VERSION_MAJOR``, ``<prefix>_<package-name>_VERSION_MINOR``, and ``<prefix>_<package-name>_VERSION_PATCH``. The ``prefix`` by default is the package name in all caps, but can be set using the ``VERSION_PREFIX`` option.

.. I'm a bit unsure about the above and following option. I think many codebases
   use their own "version header" format and hardcoding this one is a but
   unflexible.

.. option:: VERSION_PREFIX <prefix>

This sets the prefix that macros used to define the version will use.

.. option:: SOURCES <source-files>...

The source files to build the library.

.. option:: INCLUDE <directory>...

This sets the include directories for the package. Each include directory will be installed.

.. option:: NAMESPACE <namespace>

This is the namespace to be added to the exported targets.

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

This will parse the version from a header file. It will parse the macros defined in the header as ``BOOST_<package-name>_VERSION_MAJOR``, ``BOOST_<package-name>_VERSION_MINOR``, and ``BOOST_<package-name>_VERSION_PATCH``.

.. option:: SOURCES <source-files>...

The source files to build the library.

.. option:: DEPENDS <boost-dependencies>...

This specifies internal boost dependencies, that is, dependencies on other boost libraries. The libraries should not be prefixed with ``boost_`` nor ``boost::``.

.. Why not use 'boost::' here? This special casing will be unobvious for casual
   readers of code which uses this library.
