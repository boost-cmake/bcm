cmake_minimum_required (VERSION 2.8)
project(basic)

find_package(BCM)
include(BCMPackage)
include(BCMGeneratePkgConfigFile)
bcm_find_package(simple)

bcm_package(basic 
    VERSION 1.0
    INCLUDE include
    SOURCES
        main.cpp
)
target_link_libraries(basic simple)
bcm_auto_pkgconfig(basic REQUIRES simple)

bcm_test(NAME basictest SOURCES test.cpp)
bcm_test_header(NAME basictestheader HEADER basic.h)
bcm_test_header(NAME basicteststaticheader HEADER basic.h STATIC)

