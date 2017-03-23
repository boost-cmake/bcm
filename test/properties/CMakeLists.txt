cmake_minimum_required (VERSION 2.8)
project(properties)

find_package(BCM)

include(BCMProperties)
include(BCMPackage)
include(BCMTest)

bcm_package(simple
    VERSION 1.0
    INCLUDE include
)

bcm_add_test(NAME simpletest SOURCES test.cpp)

bcm_add_test(NAME rttitest SOURCES test.cpp)
set_target_properties(rttitest PROPERTIES CXX_RTTI Off)

bcm_add_test(NAME exceptiontest SOURCES test.cpp)
set_target_properties(exceptiontest PROPERTIES CXX_EXCEPTIONS Off)

bcm_add_test(NAME statictest SOURCES test.cpp)
set_target_properties(statictest PROPERTIES CXX_STATIC_RUNTIME On)

bcm_add_test(NAME throw SOURCES throw.cpp COMPILE_ONLY WILL_FAIL)
set_target_properties(throw PROPERTIES CXX_EXCEPTIONS Off)

bcm_add_test(NAME throwpass SOURCES throw.cpp)
set_target_properties(throwpass PROPERTIES CXX_EXCEPTIONS On)

bcm_add_test(NAME rtti SOURCES rtti.cpp COMPILE_ONLY WILL_FAIL)
set_target_properties(rtti PROPERTIES CXX_RTTI Off)

bcm_add_test(NAME rttipass SOURCES rtti.cpp)
set_target_properties(rttipass PROPERTIES CXX_RTTI On)
