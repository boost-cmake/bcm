option(BUILD_TESTING off)

include(CMakeParseArguments)
enable_testing()

if(NOT TARGET check)
    add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -C ${CMAKE_CFG_INTDIR} WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
endif()


if(NOT TARGET tests)
    add_custom_target(tests COMMENT "Build all tests.")
    add_dependencies(check tests)
endif()

if(NOT TARGET check-${PROJECT_NAME})
    add_custom_target(check-${PROJECT_NAME} COMMAND ${CMAKE_CTEST_COMMAND} -L ${PROJECT_NAME} --output-on-failure -C ${CMAKE_CFG_INTDIR} WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
endif()

if(NOT TARGET tests-${PROJECT_NAME})
    add_custom_target(tests-${PROJECT_NAME} COMMENT "Build all tests for ${PROJECT_NAME}.")
    add_dependencies(check-${PROJECT_NAME} tests-${PROJECT_NAME})
endif()

foreach(scope DIRECTORY TARGET)
    define_property(${scope} PROPERTY "BCM_TEST_DEPENDENCIES" INHERITED
        BRIEF_DOCS "Default test dependencies"
        FULL_DOCS "Default test dependencies"
    )
endforeach()

function(bcm_test_link_libraries)
    set_property(DIRECTORY APPEND PROPERTY BCM_TEST_DEPENDENCIES ${ARGN})
endfunction()

function(bcm_mark_as_test)
    foreach(TEST_TARGET ${ARGN})
        if (NOT BUILD_TESTING)
            set_target_properties(${TEST_TARGET}
                PROPERTIES EXCLUDE_FROM_ALL TRUE
            )
        endif()
        add_dependencies(tests ${TEST_TARGET})
        add_dependencies(tests-${PROJECT_NAME} ${TEST_TARGET})
    endforeach()
endfunction(bcm_mark_as_test)

function(bcm_test)
    set(options COMPILE_ONLY WILL_FAIL NO_TEST_LIBS)
    set(oneValueArgs NAME)
    set(multiValueArgs SOURCES CONTENT)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # TODO: Check if name exists

    set(SOURCES ${PARSE_SOURCES})
    if(PARSE_CONTENT)
        file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/generated-${PARSE_NAME}.cpp "${PARSE_CONTENT}")
        set(SOURCES ${CMAKE_CURRENT_BINARY_DIR}/generated-${PARSE_NAME}.cpp)
    endif()

    if(PARSE_COMPILE_ONLY)
        add_library(${PARSE_NAME} STATIC EXCLUDE_FROM_ALL ${SOURCES})
        add_test(NAME ${PARSE_NAME}
            COMMAND ${CMAKE_COMMAND} --build . --target ${PARSE_NAME} --config $<CONFIGURATION>
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
    else()
        add_executable(${PARSE_NAME} ${SOURCES})
        bcm_mark_as_test(${PARSE_NAME})
        if(WIN32)
            add_test(NAME ${PARSE_NAME} WORKING_DIRECTORY ${LIBRARY_OUTPUT_PATH} COMMAND ${PARSE_NAME}${CMAKE_EXECUTABLE_SUFFIX})
        else()
            add_test(NAME ${PARSE_NAME} COMMAND ${PARSE_NAME})
        endif()
    endif()
    if(PARSE_WILL_FAIL)
        set_tests_properties(${PARSE_NAME} PROPERTIES WILL_FAIL TRUE)
    endif()
    set_tests_properties(${PARSE_NAME} PROPERTIES LABELS ${PROJECT_NAME})
    if(NOT PARSE_NO_TEST_LIBS)
        target_link_libraries(${PARSE_NAME}
            $<TARGET_PROPERTY:BCM_TEST_DEPENDENCIES>
        )
    endif()
endfunction(bcm_test)

function(bcm_test_header)
    set(options STATIC NO_TEST_LIBS)
    set(oneValueArgs NAME HEADER)
    set(multiValueArgs)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(PARSE_STATIC)
        file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/header-main-include-${PARSE_NAME}.cpp 
            "#include <${PARSE_HEADER}>\nint main() {}\n"
        )
        file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/header-static-include-${PARSE_NAME}.cpp 
            "#include <${PARSE_HEADER}>\n"
        )
        bcm_test(NAME ${PARSE_NAME} SOURCES
            ${CMAKE_CURRENT_BINARY_DIR}/header-main-include-${PARSE_NAME}.cpp 
            ${CMAKE_CURRENT_BINARY_DIR}/header-static-include-${PARSE_NAME}.cpp
        )
    else()
        bcm_test(NAME ${PARSE_NAME} CONTENT
            "#include <${PARSE_HEADER}>\nint main() {}\n"
        )
    endif()
    set_tests_properties(${PARSE_NAME} PROPERTIES LABELS ${PROJECT_NAME})
    if(NOT PARSE_NO_TEST_LIBS)
        target_link_libraries(${PARSE_NAME}
            $<TARGET_PROPERTY:BCM_TEST_DEPENDENCIES>
        )
    endif()
endfunction(bcm_test_header)
