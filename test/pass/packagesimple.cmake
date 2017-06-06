install_dir(${TEST_DIR}/libsimple TARGETS check)
install_dir(${TEST_DIR}/packagebasic TARGETS check)
install_dir(${TEST_DIR}/pkgconfigcheck TARGETS check CMAKE_ARGS -DPKG_CONFIG_MODULES=simple -DPKG_CONFIG_HEADER=simple.h)
install_dir(${TEST_DIR}/pkgconfigcheck TARGETS check CMAKE_ARGS -DPKG_CONFIG_MODULES=basic -DPKG_CONFIG_HEADER=basic.h)
