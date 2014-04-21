
#
# Follow http://www.cmake.org/Wiki/CMakeMacroParseArguments convention
#
# AddCompilerFlags([FAIL_ON_ERROR FORCE ][BUILD_TYPE Release|Debug ]FLAGS flag1 flag2 flagN LANGUAGES lang1 lang2)
#

# For CMAKE_PARSE_ARGUMENTS
cmake_minimum_required(VERSION 2.8.3)

include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)
include(CMakeParseArguments)

macro(AddCompilerFlags)
    CMAKE_PARSE_ARGUMENTS(
        COMPILER_FLAGS # Prefix
        "FAIL_ON_ERROR;FORCE" # Options
        "BUILD_TYPE" # One value arguments
        "FLAGS;LANGUAGES" # Multi value arguments
        ${ARGN}
    )

    string(TOUPPER "${CMAKE_BUILD_TYPE}" __BUILD_TYPE_UPPER__)
    string(TOUPPER "${COMPILER_FLAGS_BUILD_TYPE}" __FLAGS_BUILD_TYPE_UPPER__)

    if (NOT "${COMPILER_FLAGS_BUILD_TYPE}" STREQUAL "")
        set(COMPILER_FLAGS_BUILD_TYPE "_${COMPILER_FLAGS_BUILD_TYPE}")
    endif()

    foreach(FLAG ${COMPILER_FLAGS_FLAGS})
        if (NOT ${COMPILER_FLAGS_FORCE} AND
            NOT "${__BUILD_TYPE_UPPER__}" MATCHES "${__FLAGS_BUILD_TYPE_UPPER__}")
            break()
        endif()

        # Hack for clang, that will fail build with -rdynamic
        # only with -Werror
        if ("${FLAG}" STREQUAL "-rdynamic")
            set(FLAG_TO_CHECK "${FLAG} -Werror")
        else()
            set(FLAG_TO_CHECK "${FLAG}")
        endif()

        string(REGEX REPLACE "[+/:= -]" "_" FLAG_ESC "${FLAG}")

        foreach(LANGUAGE ${COMPILER_FLAGS_LANGUAGES})
            set(FLAG_ESC "${LANGUAGE}_${FLAG_ESC}")

            # This is a workaround for "--coverage" flag.
            set(CMAKE_REQUIRED_LIBRARIES "${FLAG}")
            # Check language
            if("${LANGUAGE}" STREQUAL "C")
                check_c_compiler_flag(${FLAG_TO_CHECK} ${FLAG_ESC})
            elseif("${LANGUAGE}" STREQUAL "CXX")
                check_cxx_compiler_flag(${FLAG_TO_CHECK} ${FLAG_ESC})
            else()
                message(FATAL_ERROR "Language ${LANGUAGE} not supported")
            endif()
            set(CMAKE_REQUIRED_LIBRARIES "")

            # Check return status
            if(${FLAG_ESC})
                if("${LANGUAGE}" STREQUAL "C")
                    set(CMAKE_C_FLAGS${COMPILER_FLAGS_BUILD_TYPE} "${CMAKE_C_FLAGS${COMPILER_FLAGS_BUILD_TYPE}} ${FLAG}")
                elseif("${LANGUAGE}" STREQUAL "CXX")
                    set(CMAKE_CXX_FLAGS${COMPILER_FLAGS_BUILD_TYPE} "${CMAKE_CXX_FLAGS${COMPILER_FLAGS_BUILD_TYPE}} ${FLAG}")
                endif()
            elseif(${COMPILER_FLAGS_FAIL_ON_ERROR})
                message(FATAL_ERROR "${FLAG} not supported for ${LANGUAGE}. Try to update compiler/linker. Or don't set FAIL_ON_ERROR")
            endif()
        endforeach(LANGUAGE ${COMPILER_FLAGS_LANGUAGES})
    endforeach(FLAG ${COMPILER_FLAGS_LANGUAGES})
endmacro(AddCompilerFlags)
