include(CMakeParseArguments)

macro(GitVersion)
    cmake_parse_arguments(GIT_VERSION
        "FALLBACK" # Options
        "ABBREV;PREFIX" # One value arguments
        "" # Multi value arguments
        ${ARGN})

    if (${GIT_VERSION_ABBREV})
        set(GIT_VERSION_ABBREV "--abbrev=${GIT_VERSION_ABBREV}")
    endif()

    # Cleanup cache
    unset(${GIT_VERSION_PREFIX}VERSION CACHE)
    unset(${GIT_VERSION_PREFIX}SHA1    CACHE)

    execute_process(
        COMMAND git describe ${GIT_VERSION_ABBREV}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE ${GIT_VERSION_PREFIX}VERSION
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
        COMMAND git log --no-show-signature ${GIT_VERSION_ABBREV} -n1 --pretty=%h
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE ${GIT_VERSION_PREFIX}SHA1
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
        COMMAND git rev-parse --abbrev-ref HEAD
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE ${GIT_VERSION_PREFIX}BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    # If don't have commits after tag, just replace SHA1 by tag name
    if ((${GIT_VERSION_FALLBACK}) AND ("${${GIT_VERSION_PREFIX}VERSION}" STREQUAL ""))
        set(${GIT_VERSION_PREFIX}VERSION ${${GIT_VERSION_PREFIX}SHA1})
    endif()
    message(STATUS "Git version ${${GIT_VERSION_PREFIX}VERSION}")
endmacro(GitVersion)

macro(GitToDebVersion gitVersion)
    execute_process(
        COMMAND sh -c "echo ${${gitVersion}} | sed 's,^release-,,;s,-,+,;s,-,~,;' | sed 's/^v//'"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE ${gitVersion}
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endmacro(GitToDebVersion)

macro(GitVersionToMajorMinor projectName version)
    # Install defaults, to avoid errors while compiling
    set(${projectName}_VERSION_MAJOR 0)
    set(${projectName}_VERSION_MINOR 0)

    set(major ${version})
    set(minor ${version})

    string(REGEX REPLACE "^v([0-9]+)\\..*" "\\1" major ${major})
    string(REGEX REPLACE "^v[0-9]+\\.([0-9]+)(-|$).*" "\\1" minor ${minor})
    if (${major} GREATER 0)
        set(${projectName}_VERSION_MAJOR ${major})
    endif()
    if (${minor} GREATER 0)
        set(${projectName}_VERSION_MINOR ${minor})
    endif()
endmacro()
