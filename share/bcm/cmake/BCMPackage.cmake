
include(BCMInstallTargets)
include(BCMSetupVersion)
include(BCMTest)

if(NOT DEFINED _bcm_public_packages)
    set(_bcm_public_packages)
endif()

macro(bcm_find_package)
    find_package(${ARGN})
    list(APPEND _bcm_find_package "${ARGN}")
endmacro()

function(bcm_package PACKAGE)
    set(options)
    set(oneValueArgs VERSION VERSION_HEADER VERSION_PREFIX NAMESPACE)
    set(multiValueArgs SOURCES INCLUDES)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(PARSE_VERSION)
        bcm_setup_version(VERSION ${PARSE_VERSION})
    elseif(PARSE_VERSION_HEADER)
        if(PARSE_VERSION_PREFIX)
            set(PREFIX ${PARSE_VERSION_PREFIX})
        else()
            string(TOUPPER ${PACKAGE} PREFIX)
        endif()
        bcm_setup_version(PARSE_HEADER ${PARSE_VERSION_HEADER} PREFIX ${PREFIX})
    endif()

    if(PARSE_SOURCES)
        add_library(${PACKAGE} ${PARSE_SOURCES})
        foreach(INCLUDE ${PARSE_INCLUDES})
            target_include_directories(${PACKAGE} PRIVATE include)
        endforeach()
    else()
        add_library(${PACKAGE} INTERFACE)
    endif()

    set(DEPENDS_PACKAGES)

    foreach(PACKAGE ${_bcm_public_packages})
        list(APPEND DEPENDS_PACKAGES PACKAGE ${PACKAGE})
    endforeach()

    bcm_install_targets(
        NAME ${PACKAGE} 
        NAMESPACE ${PARSE_NAMESPACE}
        TARGETS ${PACKAGE} 
        INCLUDE ${PARSE_INCLUDES} 
        DEPENDS ${DEPENDS_PACKAGES}
    )
    bcm_test_link_libraries(${PACKAGE})

endfunction()

function(bcm_boost_package PACKAGE)
    set(options)
    set(oneValueArgs VERSION VERSION_HEADER)
    set(multiValueArgs SOURCES DEPENDS)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(PARSE_VERSION)
        bcm_setup_version(VERSION ${PARSE_VERSION})
    elseif(PARSE_VERSION_HEADER)
        string(TOUPPER BOOST_${PACKAGE} PREFIX)
        bcm_setup_version(PARSE_HEADER ${PARSE_VERSION_HEADER} PREFIX ${PREFIX})
    endif()

    if(PARSE_SOURCES)
        add_library(boost_${PACKAGE} ${PARSE_SOURCES})
        target_include_directories(boost_${PACKAGE} PRIVATE include)
    else()
        add_library(boost_${PACKAGE} INTERFACE)
    endif()
    add_library(boost::${PACKAGE} ALIAS boost_${PACKAGE})
    set_property(TARGET boost_${PACKAGE} PROPERTY EXPORT_NAME ${PACKAGE})

    set(DEPENDS_PACKAGES)

    foreach(PACKAGE ${_bcm_public_packages})
        list(APPEND DEPENDS_PACKAGES PACKAGE ${PACKAGE})
    endforeach()

    foreach(DEPEND ${PARSE_DEPENDS})
        find_package(boost_${DEPEND} REQUIRED)
        target_link_libraries(boost_${PACKAGE} boost::${DEPEND})
        list(APPEND DEPENDS_PACKAGES PACKAGE boost_${DEPEND} REQUIRED)
    endforeach()

    bcm_install_targets(
        NAME boost_${PACKAGE} 
        NAMESPACE boost::
        TARGETS boost_${PACKAGE} 
        INCLUDE include 
        DEPENDS ${DEPENDS_PACKAGES}
    )
    bcm_test_link_libraries(boost_${PACKAGE})

endfunction()
