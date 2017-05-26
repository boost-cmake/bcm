
include(CMakeParseArguments)
include(GNUInstallDirs)

function(bcm_generate_pkgconfig_file)
    set(options)
    set(oneValueArgs NAME LIB_DIR INCLUDE_DIR)
    set(multiValueArgs TARGETS CFLAGS LIBS REQUIRES)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(LIB_DIR ${CMAKE_INSTALL_LIBDIR})
    if(PARSE_LIB_DIR)
        set(LIB_DIR ${PARSE_LIB_DIR})
    endif()
    set(INCLUDE_DIR ${CMAKE_INSTALL_INCLUDEDIR})
    if(PARSE_INCLUDE_DIR)
        set(INCLUDE_DIR ${PARSE_INCLUDE_DIR})
    endif()

    set(LIBS)

    foreach(TARGET ${PARSE_TARGETS})
        get_property(TARGET_NAME TARGET ${PARSE_TARGET} PROPERTY NAME)
        get_property(TARGET_TYPE TARGET ${PARSE_TARGET} PROPERTY TYPE)
        if(NOT TARGET_TYPE STREQUAL "INTERFACE_LIBRARY")
            set(LIBS "${LIBS} -l${TARGET_NAME}")
        endif()
    endforeach()

    if(LIBS OR PARSE_LIBS)
        set(LIBS "Libs: -L\${libdir} ${LIBS} ${PARSE_LIBS}")
    endif()

    set(PKG_NAME ${PROJECT_NAME})
    if(PARSE_NAME)
        set(PKG_NAME ${PARSE_NAME})
    endif()

    file(WRITE ${PKGCONFIG_FILENAME}
"
prefix=${CMAKE_INSTALL_PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/${LIB_DIR}
includedir=\${exec_prefix}/${INCLUDE_DIR}
Name: ${PKG_NAME}
Version: ${PROJECT_VERSION}
Cflags: -I\${includedir} ${PARSE_CFLAGS}
${LIBS}
Requires: ${PARSE_REQUIRES}
"
  )

endfunction()
