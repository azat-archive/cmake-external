include(AddCompilerFlags)

# @_options: compiler options for the new target (will be called releaselto)
#     example: -g3 -O3 -DNDEBUG
# @_relax: relax DT_NEEDED for linux
#
macro(SetupLTO _buildType _options _relax)
    string(TOUPPER "${_buildType}" _buildTypeUpper)

    if ("${CMAKE_SYSTEM_NAME}" MATCHES "Linux")
        if ("${_relax}" STREQUAL "RELAX")
            set(LINKER_FLAGS_RELEASELTO "-Wl,--as-needed -Wl,--allow-shlib-undefined")
        else()
            set(LINKER_FLAGS_RELEASELTO "-Wl,--as-needed -Wl,--no-undefined -Wl,--no-allow-shlib-undefined")
        endif()
        set(CMAKE_EXE_LINKER_FLAGS_RELEASELTO "${LINKER_FLAGS_RELEASELTO}")
        set(CMAKE_SHARED_LINKER_FLAGS_RELEASELTO "${LINKER_FLAGS_RELEASELTO}")
    endif()

    if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
        if ("${CMAKE_SYSTEM_NAME}" MATCHES "Linux")
             set(CMAKE_STATIC_LINKER_FLAGS_RELEASELTO
                 "--plugin /usr/lib/LLVMgold.so")
        endif()
        # XXX: not a nice solution
        if ("${_buildTypeUpper}" STREQUAL "RELEASELTO")
            set(CMAKE_C_ARCHIVE_FINISH "llvm-ranlib <TARGET>")
        else()
            set(CMAKE_C_ARCHIVE_FINISH "")
        endif()
        set(CMAKE_CXX_ARCHIVE_FINISH "${CMAKE_C_ARCHIVE_FINISH}")

        AddCompilerFlags(FAIL_ON_ERROR
                         BUILD_TYPE RELEASELTO
                         FLAGS ${_options} -flto
                         LANGUAGES C CXX)
    else()
        set(CMAKE_EXE_LINKER_FLAGS_RELEASELTO
            "${CMAKE_EXE_LINKER_FLAGS_RELEASELTO} -fwhole-program")

        # XXX: not a nice solution
        if ("${_buildTypeUpper}" STREQUAL "RELEASELTO")
            set(CMAKE_C_ARCHIVE_CREATE "gcc-ar cr <TARGET> <OBJECTS>")
            set(CMAKE_C_ARCHIVE_FINISH "gcc-ranlib <TARGET>")
        else()
            set(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> cr <TARGET> <OBJECTS>")
            set(CMAKE_C_ARCHIVE_FINISH "")
        endif()
        set(CMAKE_CXX_ARCHIVE_CREATE "${CMAKE_C_ARCHIVE_CREATE}")
        set(CMAKE_CXX_ARCHIVE_FINISH "${CMAKE_C_ARCHIVE_FINISH}")

        # Bug in gcc cgraph, for duplicated declarations of a given symbol
        # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61886
        add_definitions(-U_FORTIFY_SOURCE)

        AddCompilerFlags(FAIL_ON_ERROR
                         BUILD_TYPE RELEASELTO
                         FLAGS ${_options} -flto
                         OVERWRITE -flto
                         LANGUAGES C CXX)
    endif()
endmacro()
