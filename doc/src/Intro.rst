
==========
Motivation
==========

This provides cmake modules that can be re-used by boost and other dependencies. It provides modules to reduce the boilerplate for installing, versioning, setting up package config, and creating tests.

.. It isn't immediately clear what this is going to provide for the user.
   Perhaps something like this: BCM provides CMake functions for building and
   releasing software packages. It is a simplification of CMake's builtin
   functions and additionally incorporates pkg-config support.

.. This section should be expanded as well. Perhaps with a side-by-side
   comparison of the CMake way of doing things in comparison to the BCM way.

=====
Usage
=====

The modules can be installed using standard cmake install::

    mkdir build
    cd build
    cmake ..
    cmake --build . --target install

Once installed, the modules can be used by using ``find_package`` and then including the appropriate module::

    find_package(BCM)
    include(BCMPackage)

========
Overview
========

------------------------
Building a boost library
------------------------

The BCM modules provide some high-level cmake functions to take care of all the cmake boilerplate needed to build, install and configuration setup. To setup a simple boost library we can do::

    cmake_minimum_required (VERSION 3.0)
    project(Boost.Config)
    
    find_package(BCM)
    include(BCMPackage)
    include(BCMPkgConfig)
    
    bcm_boost_package(config
        VERSION 1.61.0
    )

    bcm_auto_pkgconfig()

.. The above snippet is mysterious for folks not accustomed to this library.
   Where are the '.cpp' files being added? Where are the include files? What
   do these functions do?

This sets up the Boost.Config cmake with the version ``1.61.0``. More importantly the user can now install the library, like this::

    mkdir build
    cd build
    cmake ..
    cmake --build . --target install

And then the user can build with Boost.Config using cmake's ``find_package``::

    project(foo)

    find_package(boost_config)
    add_executable(foo foo.cpp)
    target_link_libraries(foo boost::config)

Or if the user isn't using cmake, then ``pkg-config`` can be used instead::

    g++ `pkg-config boost_config --cflags --libs` foo.cpp

.. Very nice!

------------
Dependencies
------------

For dependencies on other boost libraries, they can be listed with the ``DEPENDS`` argument::

    bcm_boost_package(core
        VERSION 1.61.0
        DEPENDS
            assert
            config
    )

.. This is interesting. I like the reduction in boilerplate, but I question the
   choice to go in such a different direction from the standard CMake way of
   doing things. It strikes me as a possibly leaky abstraction where folks will
   have a mix of code which uses both the CMake way and the BCM way; maintainers
   will have to be familiar with both.

This will call ``find_package`` for the dependency and link it in the library. This structured this way to be able to support superbuilds(ie building all libraries together) in the future.

-----
Tests
-----

The BCM modules provide functions for creating tests that integrate into cmake's ctest infrastructure. All tests can be built and ran using ``make check``. The ``bcm_test`` function can add a test to be ran::

    bcm_test(NAME config_test_c SOURCES config_test_c.c)

.. 'that' should be 'which' in the first sentence in the above paragraph I'm
   pretty sure.

This will compile the ``SOURCES`` and run them. Also, there is no need to link in the ``boost_config``, as ``bcm_test`` will automatically link it in for us. Also, tests can be specified as compile-only or as expected to fail::

    bcm_test(NAME test_thread_fail1 SOURCES threads/test_thread_fail1.cpp COMPILE_ONLY WILL_FAIL)

.. Nice!
