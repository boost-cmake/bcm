cmake_minimum_required (VERSION 2.8)
project(simple)
set(simple_VERSION 1.0)

find_package(BCM)

include(BCMInstallTargets)
include(BCMTest)

add_library(simple INTERFACE)

bcm_install_targets(TARGETS simple INCLUDE include)

bcm_add_test(NAME simpletest SOURCES test.cpp)
target_link_libraries(simpletest simple)

