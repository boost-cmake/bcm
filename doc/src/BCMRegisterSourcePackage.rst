========================
BCMRegisterSourcePackage
========================

---------------------------
bcm_register_source_package
---------------------------

.. program:: bcm_register_source_package

This will register a package that will be integrated into the build. It will ignore a package so that subsequent calls to `find_package` will be treated as found. This is useful in the superproject of integrated builds because it will ignore the ``find_package`` calls to a dependency becaue the targets are already provided by ``add_subdirectory``.

.. option:: NAME

The name of the package to ignore.

.. option:: EXTRA

If there is extra cmake to be included(especially if ``find_package`` defines its own variables) then this can be used to include such cmake files when ``find_package`` is called.
