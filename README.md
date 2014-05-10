
CMake modules
============

    - AddCompilerFlags (Follow http://www.cmake.org/Wiki/CMakeMacroParseArguments convention)
        AddCompilerFlags([FAIL_ON_ERROR][FORCE] [RESULT ALL_WAS_FOUND] [BUILD_TYPE Release|Debug ]FLAGS flag1 flag2 flagN LANGUAGES C CXX)

    - AddFilesGlobRecursiveToList
    - FindLibrary (Follow http://www.cmake.org/Wiki/CMakeMacroParseArguments convention)
        FindLibrary ([FAIL_ON_ERROR] NAMES name1 [ name2 ...])
    - FindPath (...)
    - FindIconv (look in libc and for libiconv)
    - GitVersion
    - GitToDebVersion
    - GitVersionToMajorMinor
    - JoinArguments - breaking overly long lines without creating a list
    - TryCompileFromSource - try compiling from source code, instead of file.

    - GenerateDebianControl - generate "debian/contol" file for debian packages.
    - Split - split strings (handle _correct_ new lines and semicolons)
    - SplitFile - same as Split() but read from file

    - Configure - use this for configure_file()
        Configure([VAL | STRING_VAL] FILE to DEFINES def1 def2)

TODO
====
    Take a look at - http://www.cmake.org/Wiki/CMakeMacroParseArguments

