#
# TODO: rename
#

cmake_minimum_required(VERSION 2.8.3)
include(CMakeParseArguments)

macro(Configure)
    CMAKE_PARSE_ARGUMENTS(
        CONFIGURE # Prefix
        "VAL;STRING_VAL" # Options
        "FILE" # One value arguments
        "DEFINES" # Multi value arguments
        ${ARGN}
    )

    foreach(DEFINE ${CONFIGURE_DEFINES})
        if (${CONFIGURE_STRING_VAL})
            file(APPEND "${CONFIGURE_FILE}" "#cmakedefine ${DEFINE} \"@${DEFINE}@\"\n")
        elseif (${CONFIGURE_VAL})
            file(APPEND "${CONFIGURE_FILE}" "#cmakedefine ${DEFINE} @${DEFINE}@\n")
        else()
            file(APPEND "${CONFIGURE_FILE}" "#cmakedefine ${DEFINE}\n")
        endif()
    endforeach()
endmacro(Configure)
