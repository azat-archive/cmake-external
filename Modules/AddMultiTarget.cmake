macro(AddMultiTarget name)
    add_custom_target(${name} ALL
                      COMMENT "Build multi target ${name}"
                      DEPENDS ${ARGN})
endmacro(AddMultiTarget)
