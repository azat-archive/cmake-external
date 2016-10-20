#
# Original: http://www.cmake.org/pipermail/cmake/2009-November/033397.html
#
macro(JoinArguments var)
  set(_var)
  foreach(_v ${${var}})
    set(_var "${_var} ${_v}")
  endforeach(_v ${${var}})
  string(STRIP "${_var}" _var)
  set(${var} "${_var}")
endmacro(JoinArguments)
