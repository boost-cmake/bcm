=============
BCMProperties
=============

This module defines several properties that can be used to control language features in C++.

--------------
CXX_EXCEPTIONS
--------------

This property can be used to enable or disable C++ exceptions. This can be applied at global, directory or target scope. At global scope this defaults to On.

--------
CXX_RTTI
--------

This property can be used to enable or disable C++ runtime type information. This can be applied at global, directory or target scope. At global scope this defaults to On.

------------------
CXX_STATIC_RUNTIME
------------------

This property can be used to enable or disable linking against the static C++ runtime. This can be applied at global, directory or target scope. At global scope this defaults to Off.

---------------------
INTERFACE_DESCRIPTION
---------------------

Description of the target.

-------------
INTERFACE_URL
-------------

An URL where people can get more information about and download the package.

-----------------------------
INTERFACE_PKG_CONFIG_REQUIRES
-----------------------------

A list of packages required by this package for pkgconfig. The versions of these packages may be specified using the comparison operators =, <, >, <= or >=.

-------------------------
INTERFACE_PKG_CONFIG_NAME
-------------------------

The name of the pkgconfig package for this target.
