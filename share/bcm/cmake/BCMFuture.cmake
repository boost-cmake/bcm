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
    message("add_library(${LIB} ${ARGN})")
    _add_library(${LIB} ${ARGN})
    set(ARG_LIST "${ARGN}")
    if("IMPORTED" IN_LIST ARG_LIST)
        message("IMPORTED: add_library(${LIB} ${ARGN})")
        if(CMAKE_FIND_PACKAGE_NAME)
            set_target_properties(${LIB} PROPERTIES
                INTERFACE_FIND_PACKAGE_NAME ${CMAKE_FIND_PACKAGE_NAME}
                INTERFACE_FIND_PACKAGE_REQUIRED ${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED
                INTERFACE_FIND_PACKAGE_QUIETLY ${CMAKE_FIND_PACKAGE_NAME}_FIND_QUIETLY
                INTERFACE_FIND_PACKAGE_EXACT ${CMAKE_FIND_PACKAGE_NAME}_FIND_EXACT
                INTERFACE_FIND_PACKAGE_VERSION ${CMAKE_FIND_PACKAGE_NAME}_FIND_VERSION
            )
        endif()
    endif()
endmacro()
