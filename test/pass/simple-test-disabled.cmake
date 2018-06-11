install_dir(${TEST_DIR}/simpletest CMAKE_ARGS -DCMAKE_ENABLE_TESTS=Off)
test_check_package(NAME simple HEADER simple.h TARGET simple)
test_check_pkgconfig(NAME simple HEADER simple.h)
