
include(CMakeParseArguments)
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.13)
    message(AUTHOR_WARNING "Your project already requires a version of CMake that includes the find_dependency macro via the CMakeFindDependencyMacro module. You should use CMakePackageConfigHelpers instead of bcmPackageConfigHelpers.")
endif()

function(bcm_configure_package_config_file _inputFile _outputFile)
  set(options NO_SET_AND_CHECK_MACRO NO_CHECK_REQUIRED_COMPONENTS_MACRO)
  set(oneValueArgs INSTALL_DESTINATION )
  set(multiValueArgs PATH_VARS )

  cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}"  ${ARGN})

  if(PARSE_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to CONFIGURE_PACKAGE_CONFIG_FILE(): \"${PARSE_UNPARSED_ARGUMENTS}\"")
  endif()

  if(NOT PARSE_INSTALL_DESTINATION)
    message(FATAL_ERROR "No INSTALL_DESTINATION given to CONFIGURE_PACKAGE_CONFIG_FILE()")
  endif()

  if(IS_ABSOLUTE "${PARSE_INSTALL_DESTINATION}")
    set(absInstallDir "${PARSE_INSTALL_DESTINATION}")
  else()
    set(absInstallDir "${CMAKE_INSTALL_PREFIX}/${PARSE_INSTALL_DESTINATION}")
  endif()

  file(RELATIVE_PATH PACKAGE_RELATIVE_PATH "${absInstallDir}" "${CMAKE_INSTALL_PREFIX}" )

  foreach(var ${PARSE_PATH_VARS})
    if(NOT DEFINED ${var})
      message(FATAL_ERROR "Variable ${var} does not exist")
    else()
      if(IS_ABSOLUTE "${${var}}")
        string(REPLACE "${CMAKE_INSTALL_PREFIX}" "\${PACKAGE_PREFIX_DIR}"
                        PACKAGE_${var} "${${var}}")
      else()
        set(PACKAGE_${var} "\${PACKAGE_PREFIX_DIR}/${${var}}")
      endif()
    endif()
  endforeach()

  get_filename_component(inputFileName "${_inputFile}" NAME)

  set(PACKAGE_INIT "
####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() (bcm variant) #######
####### Any changes to this file will be overwritten by the next CMake run            #######
####### The input file was ${inputFileName}                                           #######

get_filename_component(PACKAGE_PREFIX_DIR \"\${CMAKE_CURRENT_LIST_DIR}/${PACKAGE_RELATIVE_PATH}\" ABSOLUTE)
")

  if("${absInstallDir}" MATCHES "^(/usr)?/lib(64)?/.+")
    # Handle "/usr move" symlinks created by some Linux distros.
    set(PACKAGE_INIT "${PACKAGE_INIT}
# Use original install prefix when loaded through a \"/usr move\"
# cross-prefix symbolic link such as /lib -> /usr/lib.
get_filename_component(_realCurr \"\${CMAKE_CURRENT_LIST_DIR}\" REALPATH)
get_filename_component(_realOrig \"${absInstallDir}\" REALPATH)
if(_realCurr STREQUAL _realOrig)
  set(PACKAGE_PREFIX_DIR \"${CMAKE_INSTALL_PREFIX}\")
endif()
unset(_realOrig)
unset(_realCurr)
")
  endif()

  if(NOT PARSE_NO_SET_AND_CHECK_MACRO)
    set(PACKAGE_INIT "${PACKAGE_INIT}
macro(set_and_check _var _file)
  set(\${_var} \"\${_file}\")
  if(NOT EXISTS \"\${_file}\")
    message(FATAL_ERROR \"File or directory \${_file} referenced by variable \${_var} does not exist !\")
  endif()
endmacro()

include(CMakeFindDependencyMacro OPTIONAL RESULT_VARIABLE _CMakeFindDependencyMacro_FOUND)
if (NOT _CMakeFindDependencyMacro_FOUND)
    macro(find_dependency dep)
        if (NOT \${dep}_FOUND)
            set(bcm_fd_version)
            if (\${ARGC} GREATER 1)
                set(bcm_fd_version \${ARGV1})
            endif()
            set(bcm_fd_exact_arg)
            if(\${CMAKE_FIND_PACKAGE_NAME}_FIND_VERSION_EXACT)
                set(bcm_fd_exact_arg EXACT)
            endif()
            set(bcm_fd_quiet_arg)
            if(\${CMAKE_FIND_PACKAGE_NAME}_FIND_QUIETLY)
                set(bcm_fd_quiet_arg QUIET)
            endif()
            set(bcm_fd_required_arg)
            if(\${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED)
                set(bcm_fd_required_arg REQUIRED)
            endif()
            find_package(\${dep} \${bcm_fd_version}
                \${bcm_fd_exact_arg}
                \${bcm_fd_quiet_arg}
                \${bcm_fd_required_arg}
            )
            string(TOUPPER \${dep} cmake_dep_upper)
            if (NOT \${dep}_FOUND AND NOT \${cmake_dep_upper}_FOUND)
                set(\${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE \"\${CMAKE_FIND_PACKAGE_NAME} could not be found because dependency \${dep} could not be found.\")
                set(\${CMAKE_FIND_PACKAGE_NAME}_FOUND False)
                return()
            endif()
            set(bcm_fd_version)
            set(bcm_fd_required_arg)
            set(bcm_fd_quiet_arg)
            set(bcm_fd_exact_arg)
        endif()
    endmacro()
endif()

")
  endif()


  if(NOT PARSE_NO_CHECK_REQUIRED_COMPONENTS_MACRO)
    set(PACKAGE_INIT "${PACKAGE_INIT}
macro(check_required_components _NAME)
  foreach(comp \${\${_NAME}_FIND_COMPONENTS})
    if(NOT \${_NAME}_\${comp}_FOUND)
      if(\${_NAME}_FIND_REQUIRED_\${comp})
        set(\${_NAME}_FOUND FALSE)
      endif()
    endif()
  endforeach()
endmacro()
")
  endif()

  set(PACKAGE_INIT "${PACKAGE_INIT}
####################################################################################")

  configure_file("${_inputFile}" "${_outputFile}" @ONLY)

endfunction()

set(_bcm_tmp_list_marker "@@__bcm_tmp_list_marker__@@")

function(bcm_list_split LIST ELEMENT OUTPUT_LIST)
    string(REPLACE ";" ${_bcm_tmp_list_marker} TMPLIST "${${LIST}}")
    string(REPLACE "${_bcm_tmp_list_marker}${ELEMENT}${_bcm_tmp_list_marker}" ";" TMPLIST "${TMPLIST}")
    string(REPLACE "${ELEMENT}${_bcm_tmp_list_marker}" "" TMPLIST "${TMPLIST}")
    string(REPLACE "${_bcm_tmp_list_marker}${ELEMENT}" "" TMPLIST "${TMPLIST}")
    set(LIST_PREFIX _bcm_list_split_${OUTPUT_LIST}_SUBLIST)
    set(count 0)
    set(result)
    foreach(SUBLIST ${TMPLIST})
        string(REPLACE ${_bcm_tmp_list_marker} ";" TMPSUBLIST "${SUBLIST}")
        math(EXPR count "${count}+1")
        set(${LIST_PREFIX}_${count} "${TMPSUBLIST}" PARENT_SCOPE)
        list(APPEND result ${LIST_PREFIX}_${count})
    endforeach()
    set(${OUTPUT_LIST} "${result}" PARENT_SCOPE)
endfunction()

function(bcm_write_package_template_function FILENAME NAME)
    string(REPLACE ";" " " ARGS "${ARGN}")
    file(APPEND ${FILENAME}
"
${NAME}(${ARGS})
")
endfunction()

function(bcm_auto_export)
    set(options)
    set(oneValueArgs NAMESPACE EXPORT NAME COMPATIBILITY DATA_DIR)
    set(multiValueArgs TARGETS DEPENDS DEPS_INCLUDE)

    cmake_parse_arguments(PARSE "${options}" "${oneValueArgs}" "${multiValueArgs}"  ${ARGN})

    string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)
    set(PACKAGE_NAME ${PROJECT_NAME})
    if(PARSE_NAME)
        set(PACKAGE_NAME ${PARSE_NAME})
    endif()

    string(TOUPPER ${PACKAGE_NAME} PACKAGE_NAME_UPPER)
    string(TOLOWER ${PACKAGE_NAME} PACKAGE_NAME_LOWER)

    set(TARGET_FILE ${PROJECT_NAME_LOWER}-targets)
    if(PARSE_EXPORT)
        set(TARGET_FILE ${PARSE_EXPORT})
    endif()
    set(CONFIG_NAME ${PACKAGE_NAME_LOWER}-config)
    set(TARGET_VERSION ${PROJECT_VERSION})

    set(LIB_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR})
    set(INCLUDE_INSTALL_DIR ${CMAKE_INSTALL_INCLUDEDIR})
    set(CONFIG_PACKAGE_INSTALL_DIR ${LIB_INSTALL_DIR}/cmake/${PACKAGE_NAME_LOWER})
    if(PARSE_DATA_DIR)
        set(DATA_INSTALL_DIR ${PARSE_DATA_DIR})
        set(DATA_INSTALL_DIR_ARG DATA_INSTALL_DIR)
    endif()

    set(CONFIG_TEMPLATE "${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_NAME_LOWER}-config.cmake.in")

    file(WRITE ${CONFIG_TEMPLATE} "
@PACKAGE_INIT@
    ")

    foreach(NAME ${PACKAGE_NAME} ${PACKAGE_NAME_UPPER} ${PACKAGE_NAME_LOWER})
        bcm_write_package_template_function(${CONFIG_TEMPLATE} set_and_check ${NAME}_INCLUDE_DIR "@PACKAGE_INCLUDE_INSTALL_DIR@")
        bcm_write_package_template_function(${CONFIG_TEMPLATE} set_and_check ${NAME}_INCLUDE_DIRS "@PACKAGE_INCLUDE_INSTALL_DIR@")
        bcm_write_package_template_function(${CONFIG_TEMPLATE} set_and_check ${NAME}_LIB_DIR "@PACKAGE_LIB_INSTALL_DIR@")
        if(PARSE_DATA_DIR)
            bcm_write_package_template_function(${CONFIG_TEMPLATE} set_and_check ${NAME}_DATA_DIR "@PACKAGE_DATA_INSTALL_DIR@")
        endif()
    endforeach()

    if(PARSE_DEPENDS)
        bcm_list_split(PARSE_DEPENDS PACKAGE DEPENDS_LIST)
        foreach(DEPEND ${DEPENDS_LIST})
            bcm_write_package_template_function(${CONFIG_TEMPLATE} find_dependency ${${DEPEND}})
        endforeach()
    endif()

    foreach(INCLUDE ${PARSE_DEPS_INCLUDE})
        install(FILES ${INCLUDE} DESTINATION ${CONFIG_PACKAGE_INSTALL_DIR})
        get_filename_component(INCLUDE_BASE ${INCLUDE} NAME)
        bcm_write_package_template_function(${CONFIG_TEMPLATE} include "\${CMAKE_CURRENT_LIST_DIR}/${INCLUDE_BASE}")
    endforeach()

    if(PARSE_TARGETS)
        # Compute targets imported name
        set(EXPORT_LIB_TARGETS)
        foreach(TARGET ${PARSE_TARGETS})
            get_target_property(TARGET_NAME ${TARGET} EXPORT_NAME)
            if(NOT TARGET_NAME)
                get_target_property(TARGET_NAME ${TARGET} NAME)
            endif()
            set(EXPORT_LIB_TARGET_${TARGET} ${PARSE_NAMESPACE}${TARGET_NAME})
            list(APPEND EXPORT_LIB_TARGETS ${EXPORT_LIB_TARGET_${TARGET}})
        endforeach()
        # Export custom properties
        set(EXPORT_PROPERTIES)
        foreach(TARGET ${PARSE_TARGETS})
            foreach(PROPERTY INTERFACE_PKG_CONFIG_NAME)
                set(PROP "$<TARGET_PROPERTY:${TARGET},${PROPERTY}>")
                set(EXPORT_PROPERTIES "${EXPORT_PROPERTIES}
$<$<BOOL:${PROP}>:set_target_properties(${EXPORT_LIB_TARGET_${TARGET}} PROPERTIES ${PROPERTY} ${PROP})>
")
            endforeach()
        endforeach()
        bcm_write_package_template_function(${CONFIG_TEMPLATE} include "\${CMAKE_CURRENT_LIST_DIR}/${TARGET_FILE}.cmake")
        bcm_write_package_template_function(${CONFIG_TEMPLATE} include "\${CMAKE_CURRENT_LIST_DIR}/properties-${TARGET_FILE}.cmake")
        foreach(NAME ${PACKAGE_NAME} ${PACKAGE_NAME_UPPER} ${PACKAGE_NAME_LOWER})
            bcm_write_package_template_function(${CONFIG_TEMPLATE} set ${NAME}_LIBRARIES ${EXPORT_LIB_TARGETS})
            bcm_write_package_template_function(${CONFIG_TEMPLATE} set ${NAME}_LIBRARY ${EXPORT_LIB_TARGETS})
        endforeach()
    endif()

    file(GENERATE OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/properties-${TARGET_FILE}.cmake CONTENT "${EXPORT_PROPERTIES}")
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/properties-${TARGET_FILE}.cmake DESTINATION ${CONFIG_PACKAGE_INSTALL_DIR})

    bcm_configure_package_config_file(
        ${CONFIG_TEMPLATE}
        ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_NAME}.cmake
        INSTALL_DESTINATION ${CONFIG_PACKAGE_INSTALL_DIR}
        PATH_VARS LIB_INSTALL_DIR INCLUDE_INSTALL_DIR ${DATA_INSTALL_DIR_ARG}
    )
    set(COMPATIBILITY_ARG SameMajorVersion)
    if(PARSE_COMPATIBILITY)
        set(COMPATIBILITY_ARG ${PARSE_COMPATIBILITY})
    endif()
    write_basic_package_version_file(
        ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_NAME}-version.cmake
        VERSION ${TARGET_VERSION}
        COMPATIBILITY ${COMPATIBILITY_ARG}
    )

    set(NAMESPACE_ARG)
    if(PARSE_NAMESPACE)
        set(NAMESPACE_ARG "NAMESPACE;${PARSE_NAMESPACE}")
    endif()
    install( EXPORT ${TARGET_FILE}
        DESTINATION
        ${CONFIG_PACKAGE_INSTALL_DIR}
        ${NAMESPACE_ARG}
    )

    install( FILES
        ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_NAME}.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_NAME}-version.cmake
        DESTINATION
        ${CONFIG_PACKAGE_INSTALL_DIR})

endfunction()

