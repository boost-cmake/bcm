cmake_minimum_required (VERSION 2.8.12)
project(basic)

find_package(BCM)
include(BCMPackage)
include(BCMPkgConfig)

bcm_boost_package(basic 
    VERSION 1.0
    DEPENDS
        simple
    SOURCES
        lib/basic.cpp
)
bcm_auto_pkgconfig()
bcm_test(NAME basictest SOURCES test.cpp)

bcm_test_header(NAME basictestheader HEADER basic.h)

bcm_test_header(NAME basicteststaticheader HEADER basic.h STATIC)

