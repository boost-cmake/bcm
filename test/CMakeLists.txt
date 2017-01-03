
include(CMakeParseArguments)

function(create_basic_test NAME)
    file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/tests/${NAME})

    set(CURRENT_DIR ${CMAKE_CURRENT_BINARY_DIR}/tests/${NAME})

    string(CONFIGURE "${ARGN}" COMMANDS @ONLY)
    add_custom_target(${NAME} ${COMMANDS} WORKING_DIRECTORY ${CURRENT_DIR})
    add_test(NAME ${NAME} 
        COMMAND ${CMAKE_COMMAND} --build . --target ${NAME} --config $<CONFIGURATION> 
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
endfunction()

function(create_test)
    set(options WILL_FAIL)
    set(oneValueArgs NAME)
    set(multiValueArgs BUILDS)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(USR_DIR @CURRENT_DIR@/local-usr)

    set(COMMANDS)

    message("install: ${CMAKE_SOURCE_DIR}/share")
    list(APPEND COMMANDS COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/share ${USR_DIR})
    foreach(BUILD ${PARSE_BUILDS})
        set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${BUILD})
        set(BUILD_DIR @CURRENT_DIR@/${BUILD}-build)
        list(APPEND COMMANDS COMMAND ${CMAKE_COMMAND} -H${SRC_DIR} -B${BUILD_DIR} -DCMAKE_PREFIX_PATH="${USR_DIR}" -DCMAKE_INSTALL_PREFIX=${USR_DIR})
        list(APPEND COMMANDS COMMAND ${CMAKE_COMMAND} --build ${BUILD_DIR})
        list(APPEND COMMANDS COMMAND ${CMAKE_COMMAND} --build ${BUILD_DIR} --target check)
        list(APPEND COMMANDS COMMAND ${CMAKE_COMMAND} --build ${BUILD_DIR} --target install)
    endforeach()
    list(APPEND COMMANDS COMMAND ${CMAKE_COMMAND} -E remove_directory ${USR_DIR})
    foreach(BUILD ${PARSE_BUILDS})
        set(BUILD_DIR @CURRENT_DIR@/${BUILD}-build)
        list(APPEND COMMANDS COMMAND ${CMAKE_COMMAND} -E remove_directory ${BUILD_DIR})
    endforeach()

    create_basic_test(${PARSE_NAME} ${COMMANDS})

    if(PARSE_WILL_FAIL)
        set_tests_properties(${PARSE_NAME} PROPERTIES WILL_FAIL TRUE)
    endif()

endfunction()

create_test(NAME simple BUILDS libsimple basicapp)
create_test(NAME boostsimple BUILDS boostsimple boostbasic)
create_test(NAME basic BUILDS libsimple libbasic)
create_test(NAME simplenamespace BUILDS libsimplenamespace libbasic)
create_test(NAME simplecustomname BUILDS libsimplecustomname libbasic)
create_test(NAME parseversion BUILDS parseversion)
