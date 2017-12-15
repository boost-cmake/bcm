bcm_test_link_libraries(simple)

bcm_test(NAME simpletest SOURCES test.cpp)

if(WILL_FAIL_TEST)
    message(FATAL_ERROR "Test failed in test subdirectory")
endif()
