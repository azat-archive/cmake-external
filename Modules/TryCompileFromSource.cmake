#
# Based on https://github.com/InsightSoftwareConsortium/DCMTK/blob/master/CMake/dcmtkTryCompile.cmake
#

macro(TryCompileFromSource VAR MESSAGE SOURCE)
	set(TRY_COMPILE_FROM_SOURCE "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/src.cxx")

	message(STATUS "Checking whether ${MESSAGE}")
	file(WRITE "${TRY_COMPILE_FROM_SOURCE}" "${SOURCE}\n")
	try_compile(${VAR}
			${CMAKE_BINARY_DIR}
			${TRY_COMPILE_FROM_SOURCE}
			OUTPUT_VARIABLE OUTPUT
			${ARGN})

	if(${VAR})
		message(STATUS "Checking whether ${MESSAGE} -- yes")
		set(${VAR} "${MESSAGE}")
		file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
			"${MESSAGE} passed with the following output:\n"
			"${OUTPUT}\n")
	else(${VAR})
		message(STATUS "Checking whether ${MESSAGE} -- no")
		set(${VAR} "")
		file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
			"${MESSAGE} failed with the following output:\n"
			"${OUTPUT}\n")
	endif(${VAR})
endmacro(TryCompileFromSource)
