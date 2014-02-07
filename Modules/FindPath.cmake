# For CMAKE_PARSE_ARGUMENTS
cmake_minimum_required(VERSION 2.8.3)

include(CMakeParseArguments)

#
# Default find_path() works like this:
# if any of NAMES are found, it return success,
# while this version return success only if all NAMES found.
#
function(FindPath)
    # TODO: support other args
    CMAKE_PARSE_ARGUMENTS(
        FIND_PATH # Prefix
        "FATAL_ERROR" # Options
        "RESULT" # One value arguments
        "NAMES;PATHS" # Multi value arguments
        ${ARGN}
    )

    foreach(NAME ${FIND_PATH_NAMES})
        unset(PATH_VAR CACHE)
        find_path(PATH_VAR NAME ${NAME} PATHS ${FIND_PATH_PATHS})

        if(NOT "${PATH_VAR}" STREQUAL "PATH_VAR-NOTFOUND")
            message(STATUS "Looking for ${NAME} - found")
        else()
            if(NOT ${FIND_PATH_RESULT} STREQUAL "")
                set(${FIND_PATH_RESULT} 0 PARENT_SCOPE)
            endif()

            if(${FIND_PATH_FAIL_ON_ERROR})
                message(FATAL_ERROR "Looking for ${NAME} - not found")
            else()
                message(WARNING "Looking for ${NAME} - not found")
            endif()
        endif()
    endforeach()
endfunction(FindPath)

