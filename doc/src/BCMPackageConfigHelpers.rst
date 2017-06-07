=======================
BCMPackageConfigHelpers
=======================

This provides helpers functions for creating config files that can be included by other projects to find and use a package. 

---------------------------------
bcm_configure_package_config_file
---------------------------------

.. program:: bcm_configure_package_config_file

This works similiar to ``configure_package_config_file`` from cmake, except it provides in addition a ``find_dependency`` function.

.. option:: <input> <output>

The ``<input>`` and ``<output>`` arguments are the input and output file, the same way as in ``configure_file()``.

.. option:: NO_SET_AND_CHECK_MACRO

Don't genereate the ``set_and_check`` macro.

.. option:: NO_CHECK_REQUIRED_COMPONENTS_MACRO

Don't generate ``_CHECK_REQUIRED_COMPONENTS`` macro.

.. option:: INSTALL_DESTINATION <path>

The ``<path>`` given to ``INSTALL_DESTINATION`` must be the destination where the cmake config file will be installed to.

.. option:: PATH_VARS <var>...

The variables ``<var>...`` given as ``PATH_VARS`` are the variables which contain install destinations.  For each of them the macro will create a helper variable ``PACKAGE_<var...>``.  These helper variables can be used in the cmake config file for setting the installed location. They are calculated by ``bcm_configure_package_config_file`` so that they are always relative to the installed location of the package.  This works both for relative and also for absolute locations.

---------------
bcm_auto_export
---------------

.. program:: bcm_auto_export

This generates a simple cmake config file that includes the exported targets.

.. option:: EXPORT

This specifies an export file. By default, the export file will be named ``${PROJECT_NAME}-targets``.

.. option:: DEPENDS PACKAGE <package-name>...

This will search for these dependent packages in the cmake package config that is generated.

.. option:: INCLUDE <cmake-files>...

The is a list of additional cmake files that will be included in the cmake package config. This will be included after the dependencies have been included, but before the exported targets are included.

.. option:: NAMESPACE <namespace>

This is the namespace to add to the targets that are exported.

.. option:: COMPATIBILITY <compatibility>

This uses the version compatibility specified by cmake version config.

.. option:: NAME <name>

This is the name to use for the package config file. By default, this uses the project name, but this parameter can override it.

.. option:: TARGETS <target>...

The generated config will set ``<package>_LIBRARIES`` to the list of targets listed.


