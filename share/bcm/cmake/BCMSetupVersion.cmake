
set(BCM_HEADER_VERSION_TEMPLATE_FILE "${CMAKE_CURRENT_LIST_DIR}/version.hpp")

function(bcm_setup_version)
    set(options)
    set(oneValueArgs VERSION GENERATE_HEADER PARSE_HEADER PREFIX)
    set(multiValueArgs)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    string(TOUPPER ${PROJECT_NAME} PREFIX)

    if(PARSE_PREFIX)
        set(PREFIX ${PARSE_PREFIX})
    endif()

    if(PARSE_VERSION)
        set(PROJECT_VERSION ${PARSE_VERSION} PARENT_SCOPE)
        set(${PROJECT_NAME}_VERSION ${PROJECT_VERSION} PARENT_SCOPE)
        string(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+.*" "\\1" ${PROJECT_NAME}_VERSION_MAJOR "${PROJECT_VERSION}" PARENT_SCOPE)
        string(REGEX REPLACE "^[0-9]+\\.([0-9]+)\\.[0-9]+.*" "\\1" ${PROJECT_NAME}_VERSION_MINOR "${PROJECT_VERSION}" PARENT_SCOPE)
        string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" ${PROJECT_NAME}_VERSION_PATCH "${PROJECT_VERSION}" PARENT_SCOPE)
        foreach(level MAJOR MINOR PATCH)
            set(PROJECT_VERSION_${level} ${${PROJECT_NAME}_VERSION_${level}} PARENT_SCOPE)
        endforeach()
    elseif(PARSE_PARSE_HEADER)
        foreach(level MAJOR MINOR PATCH)
            file(STRINGS ${PARSE_PARSE_HEADER}
                         _define_${level}
                         REGEX "#define ${PREFIX}_${level}_VERSION")
            string(REGEX MATCH "([0-9]+)" _version_${level} "${_define_${level}}")
            # TODO: Check if it is empty
            set(${PROJECT_NAME}_VERSION_${level} ${_version_${level}} PARENT_SCOPE)
            set(PROJECT_VERSION_${level} ${${PROJECT_NAME}_VERSION_${level}} PARENT_SCOPE)
        endforeach()
        set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}" PARENT_SCOPE)
        set(${PROJECT_NAME}_VERSION ${PROJECT_VERSION} PARENT_SCOPE)
    endif()
    # TODO: Get version from the project

    if(PARSE_GENERATE_HEADER)
        configure_file("${BCM_HEADER_VERSION_TEMPLATE_FILE}" "${PARSE_GENERATE_HEADER}")
        install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${PARSE_GENERATE_HEADER}" DESTINATION include)
    endif()

endfunction()