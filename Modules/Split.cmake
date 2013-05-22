#
# For more info see this
# http://www.cmake.org/pipermail/cmake/2007-May/014222.html
#

macro(Split by dst src)
    string(REGEX REPLACE ";" "\\\\;" ${dst} ${src})
    string(REGEX REPLACE "${by}" ";" ${dst} ${${dst}})
endmacro(Split)

macro(SplitFile by dst srcFile)
    file(READ "${srcFile}" src)
    Split(by dst "${src}")
endmacro(SplitFile)