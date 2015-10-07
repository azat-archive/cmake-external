include(AddCompilerFlags)

# @args: compiler options for new targets
#     example: -g3
#
macro(SetupSanitizers)
    if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
        AddCompilerFlags(FAIL_ON_ERROR BUILD_TYPE SANITIZETHREAD
                         FLAGS ${ARGV} -fsanitize=thread
                         OVERWRITE -fsanitize=thread
                         LANGUAGES C CXX)
        AddCompilerFlags(FAIL_ON_ERROR BUILD_TYPE SANITIZEADDRESS
                         FLAGS "${ARGV} -fsanitize=address"
                         OVERWRITE -fsanitize=address
                         LANGUAGES C CXX)
        AddCompilerFlags(FAIL_ON_ERROR BUILD_TYPE SANITIZEMEMORY
                         FLAGS ${ARGV} -fsanitize=memory -fno-omit-frame-pointer
                         OVERWRITE -fsanitize=memory -fsanitize-memory-track-origins
                         LANGUAGES C CXX)
    else()
        AddCompilerFlags(FAIL_ON_ERROR BUILD_TYPE SANITIZETHREAD
                         FLAGS ${ARGV} "-fsanitize=thread -fPIC"
                         OVERWRITE "-fsanitize=thread -pie"
                         LANGUAGES C CXX)
        set(CMAKE_EXE_LINKER_FLAGS_SANITIZETHREAD "-pie")
        set(CMAKE_SHARED_LINKER_FLAGS_SANITIZETHREAD "-pie")

        AddCompilerFlags(FAIL_ON_ERROR BUILD_TYPE SANITIZEADDRESS
                         FLAGS ${ARGV} -fsanitize=address
                         OVERWRITE -fsanitize=address
                         LANGUAGES C CXX)
    endif()
endmacro()
