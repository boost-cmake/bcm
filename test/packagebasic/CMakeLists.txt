cmake_minimum_required (VERSION 2.8.12)
project(basic)

find_package(BCM)
include(BCMPackage)
include(BCMPkgConfig)
bcm_find_package(simple)

bcm_package(basic 
    VERSION 1.0
    INCLUDE include
    SOURCES
        main.cpp
)
target_link_libraries(basic simple)
# set_property(TARGET basic APPEND PROPERTY INTERFACE_PKG_CONFIG_REQUIRES simple)
bcm_auto_pkgconfig()

bcm_test(NAME basictest SOURCES test.cpp)
bcm_test_header(NAME basictestheader HEADER basic.h)
bcm_test_header(NAME basicteststaticheader HEADER basic.h STATIC)

