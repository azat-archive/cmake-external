#
# Helpers for cmake lists
#
macro(ListRemovePattern ListName Pattern)
    foreach (_ListIterator ${${ListName}})
        if (${_ListIterator} MATCHES ${Pattern})
            list(REMOVE_ITEM ${ListName} ${_ListIterator})
        endif()
    endforeach()
endmacro()
