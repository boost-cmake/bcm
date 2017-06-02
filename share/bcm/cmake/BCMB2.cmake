
include(BCMTest)

function(bcm_b2_generate_test_line OUTPUT NAME TYPE)
    set(TEST_SUFFIX)
    get_property(WILL_FAIL TEST ${NAME} WILL_FAIL)
    if(WILL_FAIL)
        set(TEST_SUFFX "-fail")
    endif()
    set(${OUTPUT} "${TYPE}${TEST_SUFFIX} $<JOIN:$<TARGET_PROPERTY:${NAME},SOURCES>, > : : : ;" PARENT_SCOPE)
endfunction()

function(bcm_b2_generate_test_jam OUTPUT)
    get_property(RUN_TESTS GLOBAL PROPERTY BCM_SOURCE_RUN_TESTS)
    get_property(COMPILE_TESTS GLOBAL PROPERTY BCM_SOURCE_COMPILE_TESTS)
    set(CONTENT)
    foreach(RUN_TEST ${RUN_TESTS})
        bcm_b2_generate_test_line(EXE_TEST ${RUN_TEST} run)
        set(CONTENT "${CONTENT}\n${EXE_TEST}")
    endforeach()
    foreach(COMPILE_TEST ${COMPILE_TESTS})
        bcm_b2_generate_test_line(EXE_TEST ${COMPILE_TEST} compile)
        set(CONTENT "${CONTENT}\n${EXE_TEST}")
    endforeach()

    file(GENERATE OUTPUT ${OUTPUT} INPUT "
import testing ;

${CONTENT}

") 
endfunction()
