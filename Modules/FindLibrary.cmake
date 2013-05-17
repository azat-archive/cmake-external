#
# Follow http://www.cmake.org/Wiki/CMakeMacroParseArguments convention
#
# Usage: FindLibrary([FAIL_ON_ERROR] NAMES name1 [ name2 ...])
#

# For CMAKE_PARSE_ARGUMENTS
cmake_minimum_required(VERSION 2.8.3)

include(CMakeParseArguments)

function(FindLibrary)
    CMAKE_PARSE_ARGUMENTS(
        FIND_LIBRARY # Prefix
        "FAIL_ON_ERROR" # Options
        "" # One value arguments
        "NAMES" # Multi value arguments
        ${ARGN}
    )

    foreach(LIBRARY_NAME ${FIND_LIBRARY_NAMES})
        unset(LIBRARY_PATH CACHE)
        find_library(LIBRARY_PATH NAMES ${LIBRARY_NAME})

        if(LIBRARY_PATH)
            message(STATUS "Looking for ${LIBRARY_NAME} - found")

            # In global scope
            list(APPEND LIBS_LIST ${LIBRARY_PATH})
        else(LIBRARY_PATH)
            if(${FIND_LIBRARY_FAIL_ON_ERROR})
                message(FATAL_ERROR "Looking for ${LIBRARY_NAME} - not found")
            else()
                message(SEND_ERROR "Looking for ${LIBRARY_NAME} - not found")
            endif()
        endif(LIBRARY_PATH)
    endforeach()

    set(LIBS ${LIBS} ${LIBS_LIST} PARENT_SCOPE)
endfunction(FindLibrary)
