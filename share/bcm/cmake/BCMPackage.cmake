
include(BCMInstallTargets)
include(BCMPackageConfigHelpers)
include(BCMSetupVersion)
include(BCMTest)
include(BCMProperties)

function(bcm_mark_as_package TARGET)
    set_property(GLOBAL PROPERTY BCM_PACKAGE_TARGET ${TARGET})
endfunction()

# TODO: Make this a global property
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
    set(multiValueArgs SOURCES INCLUDE)

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
        foreach(INCLUDE ${PARSE_INCLUDE})
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
        TARGETS ${PACKAGE}
        INCLUDE ${PARSE_INCLUDE} 
    )
    bcm_auto_export(
        NAME ${PACKAGE} 
        TARGETS ${PACKAGE}
        NAMESPACE ${PARSE_NAMESPACE}
        DEPENDS ${DEPENDS_PACKAGES}
    )
    bcm_test_link_libraries(${PACKAGE})
    bcm_mark_as_package(${PACKAGE})

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
        TARGETS boost_${PACKAGE} 
        INCLUDE include 
    )
    bcm_auto_export(
        NAME boost_${PACKAGE} 
        NAMESPACE boost::
        TARGETS boost_${PACKAGE} 
        DEPENDS ${DEPENDS_PACKAGES}
    )
    bcm_test_link_libraries(boost_${PACKAGE})
    bcm_mark_as_package(boost_${PACKAGE})

endfunction()
