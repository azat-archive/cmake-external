
#
# Git version
#

macro(GitVersion projectName)
    # Cleanup cache
    unset(${projectName}_GIT_VERSION CACHE)
    unset(${projectName}_GIT_SHA1 CACHE)

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

    # If don't have commits after tag, just replace SHA1 by tag name
    if ("${${projectName}_GIT_VERSION}" STREQUAL "")
        set(${projectName}_GIT_VERSION ${${projectName}_GIT_SHA1})
    endif()
    message(STATUS "Git version ${${projectName}_GIT_VERSION}")
endmacro(GitVersion)

macro(GitToDebVersion gitVersion)
    execute_process(
        COMMAND sh -c "echo ${${gitVersion}} | sed 's,^release-,,;s,-,+,;s,-,~,;' | sed 's/^v//'"
        OUTPUT_VARIABLE ${gitVersion}
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endmacro(GitToDebVersion)
