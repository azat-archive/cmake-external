
include(CheckSymbolExists)

macro(FindIconv)
    unset(LIBRARY CACHE)
    find_library(LIBRARY NAMES iconv)

    #
    # Fix for iconv in libc
    # and some of darwins
    #
    add_definitions(-DLIBICONV_PLUG)

    if (LIBRARY)
        message(STATUS "Looking for iconv - found")
        set(HAVE_ICONV_IN_LIBICONV TRUE)
        #
        # For cmake object libraries
        # set_property(TARGET lib PROPERTY COMPILE_FLAGS "${ICONV_CMAKE_OBJECTS_FLAGS}")
        #
        set(ICONV_CMAKE_OBJECTS_FLAGS "-l${LIBRARY}")
        set(LIBS ${LIBS} ${LIBRARY})
    else (LIBRARY)
        check_symbol_exists(iconv_open iconv.h HAVE_ICONV_IN_LIBC)
        if (NOT HAVE_ICONV_IN_LIBC)
            message(FATAL_ERROR "Can't find iconv in libc and libiconv")
        else (NOT HAVE_ICONV_IN_LIBC)
            message(STATUS "Found iconv in libc")
        endif (NOT HAVE_ICONV_IN_LIBC)
    endif (LIBRARY)
endmacro(FindIconv)
