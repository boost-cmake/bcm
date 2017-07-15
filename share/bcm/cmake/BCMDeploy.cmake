
include(BCMPkgConfig)
include(BCMInstallTargets)
include(BCMExport)

function(bcm_deploy)
    set(options)
    set(oneValueArgs NAMESPACE COMPATIBILITY)
    set(multiValueArgs TARGETS INCLUDE)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}"  ${ARGN})

    bcm_install_targets(TARGETS ${PARSE_TARGETS} INCLUDE ${PARSE_INCLUDE})
    bcm_auto_pkgconfig(TARGET ${PARSE_TARGETS})
    bcm_auto_export(TARGETS ${PARSE_TARGETS} NAMESPACE ${PARSE_NAMESPACE} COMPATIBILITY ${PARSE_COMPATIBILITY})

endfunction()