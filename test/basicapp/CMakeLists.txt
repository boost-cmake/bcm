cmake_minimum_required (VERSION 2.8)
project(basicapp)
set(basicapp_VERSION 1.0)

find_package(BCM)

include(BCMInstallTargets)
include(BCMTest)

find_package(simple)
add_executable(basicapp main.cpp)
target_link_libraries(basicapp simple)

bcm_install_targets(TARGETS basicapp)
# install(TARGETS basicapp DESTINATION bin)

bcm_add_test(NAME basciapptest SOURCES main.cpp)
target_link_libraries(basciapptest simple)

