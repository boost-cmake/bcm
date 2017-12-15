install_dir(${TEST_DIR}/simpletest CMAKE_ARGS -DENABLE_TESTING=Off)
test_check_package(NAME simple HEADER simple.h TARGET simple)
test_check_pkgconfig(NAME simple HEADER simple.h)
