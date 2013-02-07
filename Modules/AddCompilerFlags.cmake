
#
# Follow http://www.cmake.org/Wiki/CMakeMacroParseArguments convention
#
# AddCompilerFlags([FAIL_ON_ERROR ]FLAGS flag1 flag2 flagN LANGUAGES lang1 lang2)
#

# For CMAKE_PARSE_ARGUMENTS
cmake_minimum_required(VERSION 2.8)

include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

macro(AddCompilerFlags)
    CMAKE_PARSE_ARGUMENTS(
        COMPILER_FLAGS # Prefix
        "FAIL_ON_ERROR" # Options
        "" # One value arguments
        "FLAGS;LANGUAGES" # Multi value arguments
        ${ARGN}
    )

    foreach(FLAG ${COMPILER_FLAGS_FLAGS})
        string(REGEX REPLACE "[+/:= -]" "_" FLAG_ESC "${FLAG}")

        foreach(LANGUAGE ${COMPILER_FLAGS_LANGUAGES})
            set(FLAG_ESC "${LANGUAGE}_${FLAG_ESC}")
            # Check language
            if(LANGUAGE STREQUAL "C")
                check_c_compiler_flag(${FLAG} ${FLAG_ESC})
            elseif(LANGUAGE STREQUAL "CXX")
                check_c_compiler_flag(${FLAG} ${FLAG_ESC})
            else()
                message(FATAL_ERROR "Language ${LANGUAGE} not supported")
            endif()

            # Check return status
            if(${FLAG_ESC})
                if(LANGUAGE STREQUAL "C")
                    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FLAG}")
                elseif(LANGUAGE STREQUAL "CXX")
                    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FLAG}")
                endif()
            elseif(${COMPILER_FLAGS_FAIL_ON_ERROR})
                message(FATAL_ERROR "${FLAG} not supported for ${LANGUAGE}. Try to update compiler/linker. Or don't set FAIL_ON_ERROR")
            endif()
        endforeach(LANGUAGE ${COMPILER_FLAGS_LANGUAGES})
    endforeach(FLAG ${COMPILER_FLAGS_LANGUAGES})
endmacro(AddCompilerFlags)
