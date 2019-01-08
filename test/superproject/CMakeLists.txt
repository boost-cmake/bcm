cmake_minimum_required (VERSION 3.5)
project(superproject)

find_package(BCM)
include(BCMRegisterSourcePackage)

bcm_register_source_package(simple)

add_subdirectory(../libbasicnamespace libbasicnamespace)
add_subdirectory(../libsimplenamespace libsimplenamespace)
