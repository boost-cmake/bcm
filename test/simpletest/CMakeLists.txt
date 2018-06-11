cmake_minimum_required (VERSION 3.5)
project(simple)

find_package(BCM)

include(BCMInstallTargets)
include(BCMDeploy)
include(BCMTest)
include(BCMSetupVersion)

bcm_setup_version(VERSION 1.0)

add_library(simple simple.cpp)
target_include_directories(simple PRIVATE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)

bcm_deploy(TARGETS simple INCLUDE include)

bcm_test(NAME simpletoptest SOURCES test.cpp)
target_link_libraries(simpletoptest simple)

bcm_add_test_subdirectory(test)

if(TARGET simpletest)
    message(FATAL_ERROR "simpletest was not added")
endif()

