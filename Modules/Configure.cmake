#
# TODO: rename
#

macro(Configure ARG1 ARG2)
    set(FILE "${ARG1}")
    set(MACRO "${ARG2}")

    file(APPEND "${FILE}" "#cmakedefine ${MACRO}\n")
endmacro(Configure)
