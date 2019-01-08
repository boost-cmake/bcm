
function(bcm_register_source_package NAME)
    set(options)
    set(oneValueArgs EXTRA)
    set(multiValueArgs)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}"  ${ARGN})

    set(EXTRA)
    if(PARSE_EXTRA)
        set(EXTRA "include(${PARSE_EXTRA})")
    endif()

    set(${NAME}_DIR ${CMAKE_BINARY_DIR}/_bcm_ignore_packages_/${NAME} CACHE PATH "")
    file(WRITE ${${NAME}_DIR}/${NAME}Config.cmake "${EXTRA}")
endfunction()

