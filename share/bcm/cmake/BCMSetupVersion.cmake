
set(BCM_HEADER_VERSION_TEMPLATE_FILE "${CMAKE_CURRENT_LIST_DIR}/version.hpp")

macro(bcm_set_parent VAR)
    set(${VAR} ${ARGN} PARENT_SCOPE)
    set(${VAR} ${ARGN})
endmacro()

function(bcm_setup_version)
    set(options)
    set(oneValueArgs VERSION GENERATE_HEADER PARSE_HEADER PREFIX NAME COMPATIBILITY)
    set(multiValueArgs)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    string(TOUPPER ${PROJECT_NAME} PREFIX)

    if(PARSE_PREFIX)
        set(PREFIX ${PARSE_PREFIX})
    endif()

    string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)
    set(PACKAGE_NAME ${PROJECT_NAME})
    if(PARSE_NAME)
        set(PACKAGE_NAME ${PARSE_NAME})
    endif()

    string(TOUPPER ${PACKAGE_NAME} PACKAGE_NAME_UPPER)
    string(TOLOWER ${PACKAGE_NAME} PACKAGE_NAME_LOWER)

    set(CONFIG_NAME ${PACKAGE_NAME_LOWER}-config)

    set(LIB_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR})
    set(CONFIG_PACKAGE_INSTALL_DIR ${LIB_INSTALL_DIR}/cmake/${PACKAGE_NAME_LOWER})

    set(VERSION_CONFIG_FILE "${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_NAME}-version.cmake")

    if(PARSE_VERSION)
        bcm_set_parent(PROJECT_VERSION ${PARSE_VERSION})
        bcm_set_parent(${PROJECT_NAME}_VERSION ${PROJECT_VERSION})
        string(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+.*" "\\1" _version_MAJOR "${PROJECT_VERSION}")
        string(REGEX REPLACE "^[0-9]+\\.([0-9]+)\\.[0-9]+.*" "\\1" _version_MINOR "${PROJECT_VERSION}")
        string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" _version_PATCH "${PROJECT_VERSION}")
        foreach(level MAJOR MINOR PATCH)
            bcm_set_parent(${PROJECT_NAME}_VERSION_${level} ${_version_${level}})
            bcm_set_parent(PROJECT_VERSION_${level} ${_version_${level}})
        endforeach()
    elseif(PARSE_PARSE_HEADER)
        foreach(level MAJOR MINOR PATCH)
            file(STRINGS ${PARSE_PARSE_HEADER}
                         _define_${level}
                         REGEX "#define ${PREFIX}_VERSION_${level}")
            string(REGEX MATCH "([0-9]+)" _version_${level} "${_define_${level}}")
            # TODO: Check if it is empty
            bcm_set_parent(${PROJECT_NAME}_VERSION_${level} ${_version_${level}})
            bcm_set_parent(PROJECT_VERSION_${level} ${_version_${level}})
        endforeach()
        bcm_set_parent(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
        bcm_set_parent(${PROJECT_NAME}_VERSION ${PROJECT_VERSION})
    endif()
    # TODO: Get version from the project

    if(PARSE_GENERATE_HEADER)
        configure_file("${BCM_HEADER_VERSION_TEMPLATE_FILE}" "${PARSE_GENERATE_HEADER}")
        install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${PARSE_GENERATE_HEADER}" DESTINATION include)
    endif()

    set(COMPATIBILITY_ARG SameMajorVersion)
    if(PARSE_COMPATIBILITY)
        set(COMPATIBILITY_ARG ${PARSE_COMPATIBILITY})
    endif()
    write_basic_config_version_file(
        ${VERSION_CONFIG_FILE}
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY ${COMPATIBILITY_ARG}
    )

    install(FILES
        ${VERSION_CONFIG_FILE}
        DESTINATION
        ${CONFIG_PACKAGE_INSTALL_DIR})

endfunction()
