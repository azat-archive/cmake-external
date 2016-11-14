
#
# Git version
#

macro(GitVersion projectName)
    # Cleanup cache
    unset(${projectName}_GIT_VERSION CACHE)
    unset(${projectName}_GIT_SHA1 CACHE)

    execute_process(
        COMMAND git describe
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE ${projectName}_GIT_VERSION
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
        COMMAND git log -n1 --pretty=%h
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE ${projectName}_GIT_SHA1
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
        COMMAND git rev-parse --abbrev-ref HEAD
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE ${projectName}_GIT_BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )


    # If don't have commits after tag, just replace SHA1 by tag name
    if ("${${projectName}_GIT_VERSION}" STREQUAL "")
        set(${projectName}_GIT_VERSION ${${projectName}_GIT_SHA1})
    endif()
    message(STATUS "Git version ${${projectName}_GIT_VERSION}")
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
