macro(FindIconv)
	unset(LIBRARY CACHE)
	find_library(LIBRARY NAMES iconv)

	if (LIBRARY)
		message(STATUS "Looking for iconv - found")
		set(HAVE_ICONV_IN_LIBICONV TRUE)
		set(LIBS ${LIBS} ${LIBRARY})
	else (LIBRARY)
	    #
	    # Fix for iconv in libc
	    #
	    add_definitions(-DLIBICONV_PLUG)

		check_symbol_exists(iconv_open iconv.h HAVE_ICONV_IN_LIBC)
		if (NOT HAVE_ICONV_IN_LIBC)
			message(FATAL_ERROR "Can't find iconv in libc and libiconv")
		else (HAVE_ICONV_IN_LIBC)
			message("Found iconv in libc")
		endif (HAVE_ICONV_IN_LIBC)
	endif (LIBRARY)
endmacro(FindIconv)