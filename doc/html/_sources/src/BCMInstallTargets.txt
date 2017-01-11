=================
BCMInstallTargets
=================

-------------------
bcm_install_targets
-------------------

.. program:: bcm_install_targets

This install the targets specified. It will also install a corresponding cmake package config(which can be found with ``find_package``) to link against the library targets. 

.. option:: TARGETS <target-name>...

The name of targets to install.

.. option:: INCLUDE <directory>...

Installs include directories. It also makes the include directory available for targets to be installed.

.. option:: DEPENDS PACKAGE <package-name>...

This will search for these dependent packages in the cmake package config that is generated.

.. option:: NAMESPACE <namespace>

This is the namespace add to the targets that are exported.

.. option:: COMPATIBILITY <compatibility>

This is version compatibility specified by cmake version config.

.. option:: NAME <name>

This is the name to use for the package config file. By default, this uses the project name, but this parameter can override it.


