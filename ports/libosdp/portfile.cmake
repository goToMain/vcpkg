# Download release from goToMain/libosdp
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO goToMain/libosdp
    REF "v${VERSION}"
    SHA512 7b6a72bd8bedcfb6822b731f6ac0245b04d75eefc764ef28698d0604511f32f2ae97e11a706e1992fef8553fbef790319eb4f86ca9420363ec3e235ec3407f83
    HEAD_REF master
    PATCHES
        cmake_fix.patch
)

# Download the utils submodule and copy it into it's place
vcpkg_from_github(
    OUT_SOURCE_PATH UTILS_SOURCE_PATH
    REPO goToMain/c-utils
    REF "d295048d0362674e2a4b489b689d029b8f1f3d01"
    SHA512 a0902a504fe6ffd1ce0f32d0a16decf0e113d1211d19e63f4fb539082254769f0a6484414a49f52956e45ed802b2c2f8430e87a06c24ac84205421cdffb4d3f0
    HEAD_REF master
)
file(REMOVE_RECURSE "${SOURCE_PATH}/utils")
file(COPY "${UTILS_SOURCE_PATH}/" DESTINATION "${SOURCE_PATH}/utils")

# Main commands
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS -DCONFIG_OSDP_LIB_ONLY=ON
)
vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Move cmake configs
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/libosdp)

# Remove duplicate files
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Install license
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

# Install usage file
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
