# Simple target, that will just copy files to folder
macro(TargetCopy target dir)
    add_custom_target(${target} ALL COMMENT
        "Copying ${target} files to the ${dir}"
    )
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory "${dir}"
    )
    foreach(file ${ARGN})
        add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy "${file}" "${dir}"
        )
    endforeach()
endmacro(TargetCopy)

macro(TargetCopyDirectory target dst)
    add_custom_target(${target} ALL COMMENT
        "Copying ${target} directory to the ${dst}"
    )
    foreach(file ${ARGN})
        add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_directory "${file}" "${dst}"
        )
    endforeach()
endmacro(TargetCopyDirectory)
