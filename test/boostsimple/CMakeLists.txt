cmake_minimum_required (VERSION 2.8.12)
project(simple)

find_package(BCM)
include(BCMPackage)
include(BCMPkgConfig)

bcm_boost_package(simple 
    VERSION 1.0
)
target_compile_definitions(boost_simple INTERFACE -DHAS_SIMPLE=1)
bcm_auto_pkgconfig()
bcm_test(NAME simpletest SOURCES test.cpp)

bcm_test_header(NAME simpletestheader HEADER simple.h)

bcm_test_header(NAME simpleteststaticheader HEADER simple.h STATIC)

