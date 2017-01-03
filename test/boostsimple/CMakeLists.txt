cmake_minimum_required (VERSION 2.8)
project(simple)

find_package(BCM)
include(BCMBoostPackage)

bcm_boost_package(simple 
    VERSION 1.0
)

bcm_add_test(NAME simpletest SOURCES test.cpp)

bcm_test_header(NAME simpletestheader HEADER simple.h)

bcm_test_header(NAME simpleteststaticheader HEADER simple.h STATIC)

