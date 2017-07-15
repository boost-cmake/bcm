cmake_minimum_required (VERSION 3.5)
project(properties)

find_package(BCM)

include(BCMProperties)
include(BCMSetupVersion)
include(BCMDeploy)
include(BCMTest)

bcm_setup_version(VERSION 1.0)

add_library(simple INTERFACE)

bcm_install_targets(TARGETS simple INCLUDE include)
bcm_auto_export(TARGETS simple)
bcm_auto_pkgconfig(TARGET simple)

if(MSVC)
    add_compile_options(/we4541)
    add_compile_options(/we4530)
endif()

bcm_test_link_libraries(simple)

bcm_test(NAME simpletest SOURCES test.cpp)

bcm_test(NAME rttitest SOURCES test.cpp)
set_target_properties(rttitest PROPERTIES CXX_RTTI Off)

bcm_test(NAME exceptiontest SOURCES test.cpp)
set_target_properties(exceptiontest PROPERTIES CXX_EXCEPTIONS Off)

bcm_test(NAME statictest SOURCES test.cpp)
set_target_properties(statictest PROPERTIES CXX_STATIC_RUNTIME On)

bcm_test(NAME throw SOURCES throw.cpp COMPILE_ONLY WILL_FAIL)
set_target_properties(throw PROPERTIES CXX_EXCEPTIONS Off)

bcm_test(NAME throwpass SOURCES throw.cpp)
set_target_properties(throwpass PROPERTIES CXX_EXCEPTIONS On)

bcm_test(NAME rtti SOURCES rtti.cpp COMPILE_ONLY WILL_FAIL)
set_target_properties(rtti PROPERTIES CXX_RTTI Off)

bcm_test(NAME rttipass SOURCES rtti.cpp)
set_target_properties(rttipass PROPERTIES CXX_RTTI On)
