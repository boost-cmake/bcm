cmake_minimum_required (VERSION 2.8)
project(simple)

find_package(BCM)

include(BCMInstallTargets)
include(BCMSetupVersion)
include(BCMTest)

bcm_setup_version(VERSION 1.0 GENERATE_HEADER simpleversion.hpp)

add_library(simple INTERFACE)
bcm_test_link_libraries(simple)

bcm_install_targets(TARGETS simple INCLUDE include)

bcm_add_test(NAME simpletest SOURCES test.cpp)

bcm_add_test(NAME simpletestcompile SOURCES compiletest.cpp COMPILE_ONLY)

bcm_test_header(NAME simpletestheader HEADER simple.h)

bcm_test_header(NAME simpleteststaticheader HEADER simple.h STATIC)

