include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Microsoft/cpprestsdk
    REF 6f602bee67b088a299d7901534af3bce6334ab38
    SHA512 747ade73ae63300a9063616982d45a3165f752a611a76a4bfdc5b678f0f9b8668e4fec21614641c42d2d6e1b43cf2c10c6439f8601d6c53e69c859a62a1f5259
    HEAD_REF master
    PATCHES
        disable-ssl-revocation.patch
        allow-compression-flag.patch
        remove-content-length-when-chunked.patch
        no-stream-length.patch
        tls_version.patch
        allow-setting-new-http-timeout.patch
        compression.patch
)

set(OPTIONS)
if(NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    SET(WEBSOCKETPP_PATH "${CURRENT_INSTALLED_DIR}/share/websocketpp")
    list(APPEND OPTIONS
        -DWEBSOCKETPP_CONFIG=${WEBSOCKETPP_PATH}
        -DWEBSOCKETPP_CONFIG_VERSION=${WEBSOCKETPP_PATH})
endif()

set(CPPREST_EXCLUDE_BROTLI ON)
if ("brotli" IN_LIST FEATURES)
    set(CPPREST_EXCLUDE_BROTLI OFF)
endif()

set(CPPREST_EXCLUDE_COMPRESSION ON)
if ("compression" IN_LIST FEATURES)
    set(CPPREST_EXCLUDE_COMPRESSION OFF)
endif()

set(CPPREST_EXCLUDE_WEBSOCKETS ON)
if("websockets" IN_LIST FEATURES)
    set(CPPREST_EXCLUDE_WEBSOCKETS OFF)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/Release
    PREFER_NINJA
    OPTIONS
        ${OPTIONS}
        -DBUILD_TESTS=OFF
        -DBUILD_SAMPLES=OFF
        -DCPPREST_EXCLUDE_BROTLI=ON
        -DCPPREST_EXCLUDE_COMPRESSION=OFF
        -DCPPREST_EXCLUDE_WEBSOCKETS=ON
        -DCPPREST_EXPORT_DIR=share/cpprestsdk
        -DWERROR=OFF
    OPTIONS_DEBUG
        -DCPPREST_INSTALL_HEADERS=OFF
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/share/cpprestsdk)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/share ${CURRENT_PACKAGES_DIR}/lib/share)

file(INSTALL
    ${SOURCE_PATH}/license.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/cpprestsdk RENAME copyright)

vcpkg_copy_pdbs()
