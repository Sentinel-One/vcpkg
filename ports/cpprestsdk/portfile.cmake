include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Microsoft/cpprestsdk
    REF b94bc32ff84e815ba44c567f6fe4af5f5f6b3048
    SHA512 be02fd492a40c8a162376d7291f7551ddc908e6f4476ddd76902dba175d71079124e574265c4b5882c77cfae9e40763f4c27c08dbbcb5ff7a57a94ed430a2ab2 
    HEAD_REF master
    PATCHES
        disable-ssl-revocation.patch
        allow-compression-flag.patch
        remove-content-length-when-chunked.patch
        no-stream-length.patch
        tls_version.patch
        allow-setting-new-http-timeout.patch
        compression.patch
        local_address.patch
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
