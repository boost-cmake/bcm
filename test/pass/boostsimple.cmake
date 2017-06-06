install_dir(${TEST_DIR}/boostsimple TARGETS check)
install_dir(${TEST_DIR}/boostbasic TARGETS check)
install_dir(${TEST_DIR}/pkgconfigcheck TARGETS check CMAKE_ARGS -DPKG_CONFIG_MODULES=boost_simple -DPKG_CONFIG_HEADER=simple.h)
install_dir(${TEST_DIR}/pkgconfigcheck TARGETS check CMAKE_ARGS -DPKG_CONFIG_MODULES=boost_basic -DPKG_CONFIG_HEADER=basic.h)
