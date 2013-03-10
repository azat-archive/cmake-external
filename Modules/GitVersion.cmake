
#
# Git version
#

macro(GitVersion projectName)
    execute_process(
        COMMAND git describe
        OUTPUT_VARIABLE ${projectName}_GIT_VERSION
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
        COMMAND git log -n1 --pretty=%h
        OUTPUT_VARIABLE ${projectName}_GIT_SHA1
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(${projectName}_VERSION "${${projectName}_GIT_VERSION}")

    # If don't have commits after tag, just replace SHA1 by tag name
    if ("${${projectName}_VERSION}" STREQUAL "")
        set(${projectName}_VERSION ${${projectName}_GIT_SHA1})
    endif()
    message(STATUS "Git version ${${projectName}_VERSION}")
endmacro(GitVersion)
