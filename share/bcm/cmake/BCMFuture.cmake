define_property(TARGET PROPERTY "INTERFACE_FIND_PACKAGE_NAME"
    BRIEF_DOCS "The package name that was searched for to create this target"
    FULL_DOCS "The package name that was searched for to create this target"
)

define_property(TARGET PROPERTY "INTERFACE_FIND_PACKAGE_REQUIRED"
    BRIEF_DOCS "true if REQUIRED option was given"
    FULL_DOCS "true if REQUIRED option was given"
)

define_property(TARGET PROPERTY "INTERFACE_FIND_PACKAGE_QUIETLY"
    BRIEF_DOCS "true if QUIET option was given"
    FULL_DOCS "true if QUIET option was given"
)

define_property(TARGET PROPERTY "INTERFACE_FIND_PACKAGE_EXACT"
    BRIEF_DOCS "true if EXACT option was given"
    FULL_DOCS "true if EXACT option was given"
)

define_property(TARGET PROPERTY "INTERFACE_FIND_PACKAGE_VERSION"
    BRIEF_DOCS "full requested version string"
    FULL_DOCS "full requested version string"
)

macro(add_library LIB)
    _add_library(${LIB} ${ARGN})
    set(ARG_LIST "${ARGN}")
    if("IMPORTED" IN_LIST ARG_LIST)
        if(CMAKE_FIND_PACKAGE_NAME)
            set_target_properties(${LIB} PROPERTIES INTERFACE_FIND_PACKAGE_NAME ${CMAKE_FIND_PACKAGE_NAME})
            foreach(TYPE REQUIRED QUIETLY EXACT VERSION)
                if(${CMAKE_FIND_PACKAGE_NAME}_FIND_${TYPE})
                    set_target_properties(${LIB} PROPERTIES INTERFACE_FIND_PACKAGE_${TYPE} ${${CMAKE_FIND_PACKAGE_NAME}_FIND_${TYPE})
                endif()
            endforeach()
        endif()
    endif()
endmacro()
