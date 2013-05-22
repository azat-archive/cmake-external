#
# GenerateDebianControl
#

include(Split)
include(JoinArguments)

macro(GenerateDebianControl src dst)
    Split("\n" srcLines "${src}")

    set(i 1)
    foreach (line IN LISTS srcLines)
        # Additional logics for non-first lines in
        # "debian/control"
        if (i GREATER 1)
            if (line STREQUAL "")
                set(line " .")
            else()
                set(line " ${line}")
            endif()
        endif()

        set(${dst} "${${dst}}${line}\n")

        math(EXPR i "${i}+1")
    endforeach()

    set(STRIP ${${dst}} ${dst})
endmacro(GenerateDebianControl)