include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(OUT_SOURCE_PATH SOURCE_PATH
    REPO "SRombauts/SQLiteCpp"
    REF 01cf6f2d2adf2a7b71a420f2c91446364a9ada1e
    HEAD_REF master
    SHA512 723a3932fc59509cfd7740d7e35ef9e4398588d4088581d2ed50a65aeec76508b7796dae0f4a9c0c629bd4ac8db8ca3a69094121f2f0317ed1c68f459356964e
    PATCHES
        0002-utf16.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DSQLITECPP_RUN_CPPLINT=OFF
        -DSQLITECPP_RUN_CPPCHECK=OFF
        -DSQLITECPP_INTERNAL_SQLITE=OFF
        -DSQLITE_ENABLE_COLUMN_METADATA=OFF
        -DSQLITECPP_INTERNAL_SQLITE=OFF
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/SQLiteCpp)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/sqlitecpp RENAME copyright)
