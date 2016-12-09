#
# Follow http://www.cmake.org/Wiki/CMakeMacroParseArguments convention
#
# Usage: FindLibrary([FAIL_ON_ERROR] [RESULT ALL_WAS_FOUND] NAMES name1 [ name2 ...])
#
# Example:
# {code}
# FindLibrary(RESULT ${PROJECT_NAME}_LIBS_FOUND
#             NAMES c)
# if(NOT ${${PROJECT_NAME}_LIBS_FOUND})
#     message(WARNING
#             "=================================\n"
#             "${PROJECT_NAME} will not builded.\n"
#             "================================="
#     )
#     return(1)
# endif()
# {/code}
#

# For CMAKE_PARSE_ARGUMENTS
cmake_minimum_required(VERSION 2.8.3)

include(CMakeParseArguments)

function(FindLibrary)
    CMAKE_PARSE_ARGUMENTS(
        FIND_LIBRARY # Prefix
        "FAIL_ON_ERROR;STATIC" # Options
        "RESULT" # One value arguments
        "NAMES" # Multi value arguments
        ${ARGN}
    )

    if(NOT ${FIND_LIBRARY_RESULT} STREQUAL "")
        set(${FIND_LIBRARY_RESULT} 1 PARENT_SCOPE)
    endif()
    foreach(LIBRARY_NAME ${FIND_LIBRARY_NAMES})
        unset(LIBRARY_PATH CACHE)

        if (${FIND_LIBRARY_STATIC})
            set(_FIND_LIBRARY_LIBRARY_SUFFIXES_ORIG ${CMAKE_FIND_LIBRARY_SUFFIXES})
            set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
        endif()
        find_library(LIBRARY_PATH NAMES ${LIBRARY_NAME})
        if (${FIND_LIBRARY_STATIC})
            set(CMAKE_FIND_LIBRARY_SUFFIXES ${_FIND_LIBRARY_LIBRARY_SUFFIXES_ORIG})
        endif()

        if(LIBRARY_PATH)
            message(STATUS "Looking for ${LIBRARY_NAME} - found")

            # In global scope
            list(APPEND LIBS_LIST ${LIBRARY_PATH})
        else(LIBRARY_PATH)
            if(NOT ${FIND_LIBRARY_RESULT} STREQUAL "")
                set(${FIND_LIBRARY_RESULT} 0 PARENT_SCOPE)
            endif()

            if(${FIND_LIBRARY_FAIL_ON_ERROR})
                message(FATAL_ERROR "Looking for ${LIBRARY_NAME} - not found")
            else()
                message(WARNING "Looking for ${LIBRARY_NAME} - not found")
            endif()
        endif(LIBRARY_PATH)
    endforeach()

    set(LIBS ${LIBS} ${LIBS_LIST} PARENT_SCOPE)
endfunction(FindLibrary)
