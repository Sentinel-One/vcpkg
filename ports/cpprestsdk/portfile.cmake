include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Microsoft/cpprestsdk
    REF f940d5510ef3b724a1995f160b401f597301f6d4
    SHA512 17b3e7a0146d1f3e39388c136a20a7bd56f2a08cb8967b2ac6090834e2353a2a3ef7a1828d255b3514b934ad2bd916201bcc80809f005f4dd88cef43b63b388c
    HEAD_REF master
)

set(OPTIONS)
if(NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    SET(WEBSOCKETPP_PATH "${CURRENT_INSTALLED_DIR}/share/websocketpp")
    list(APPEND OPTIONS
        -DWEBSOCKETPP_CONFIG=${WEBSOCKETPP_PATH}
        -DWEBSOCKETPP_CONFIG_VERSION=${WEBSOCKETPP_PATH})
endif()

set(CPPREST_EXCLUDE_WEBSOCKETS ON)
if("websockets" IN_LIST FEATURES)
    set(CPPREST_EXCLUDE_WEBSOCKETS OFF)
endif()

set(CPPREST_EXCLUDE_BROTLI ON)
if ("brotli" IN_LIST FEATURES)
    set(CPPREST_EXCLUDE_BROTLI OFF)
endif()

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/disable-ssl-revocation.patch" "${CMAKE_CURRENT_LIST_DIR}/allow-compression-flag.patch" "${CMAKE_CURRENT_LIST_DIR}/remove-content-length-when-chunked.patch" "${CMAKE_CURRENT_LIST_DIR}/no-stream-length.patch" "${CMAKE_CURRENT_LIST_DIR}/tls_version.patch"
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/Release
    PREFER_NINJA
    OPTIONS
        ${OPTIONS}
        -DBUILD_TESTS=OFF
        -DBUILD_SAMPLES=OFF
        -DCPPREST_EXCLUDE_WEBSOCKETS=ON
        -DCPPREST_EXCLUDE_COMPRESSION=OFF
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
