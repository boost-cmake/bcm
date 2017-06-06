cmake_minimum_required (VERSION 2.8)
project(simple)

find_package(BCM)

include(BCMInstallTargets)
include(BCMPackageConfigHelpers)
include(BCMSetupVersion)
include(BCMTest)
include(BCMPkgConfig)

bcm_setup_version(VERSION 1.0 GENERATE_HEADER simpleversion.hpp)

add_library(simple INTERFACE)
target_compile_definitions(simple INTERFACE -DHAS_SIMPLE=1)
bcm_test_link_libraries(simple)

bcm_install_targets(TARGETS simple INCLUDE include)
bcm_auto_export(TARGETS simple)
bcm_auto_pkgconfig(TARGET simple)

bcm_test(NAME simpletest SOURCES test.cpp)

bcm_test(NAME simpletestcompile SOURCES compiletest.cpp COMPILE_ONLY)

bcm_test_header(NAME simpletestheader HEADER simple.h)

bcm_test_header(NAME simpleteststaticheader HEADER simple.h STATIC)

