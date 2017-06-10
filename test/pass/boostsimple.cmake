install_dir(${TEST_DIR}/boostsimple TARGETS check)
install_dir(${TEST_DIR}/boostbasic TARGETS check)
test_check_pkgconfig(NAME boost_simple HEADER simple.h)
test_check_pkgconfig(NAME boost_basic HEADER basic.h)
