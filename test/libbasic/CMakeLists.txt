cmake_minimum_required (VERSION 3.5)
project(basic)

find_package(BCM)

include(BCMInstallTargets)
include(BCMDeploy)
include(BCMTest)
include(BCMSetupVersion)

bcm_setup_version(VERSION 1.0)

find_package(simple REQUIRED)
add_library(basic main.cpp)
target_link_libraries(basic simple)

bcm_deploy(TARGETS basic)

bcm_test(NAME basictest SOURCES test.cpp)
target_link_libraries(basictest basic)

