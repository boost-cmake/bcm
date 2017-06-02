install_dir(${TEST_DIR}/libsimple)
install_dir(${TEST_DIR}/packagebasic)
install_dir(${TEST_DIR}/pkgconfigcheck CMAKE_ARGS -DPKG_CONFIG_MODULES=basic)
