bcm_test_link_libraries(simple)

if(NOT BUILD_TESTING)
    bcm_test_link_libraries(foo::non_existent)
endif()

bcm_test(NAME simpletest SOURCES test.cpp)
