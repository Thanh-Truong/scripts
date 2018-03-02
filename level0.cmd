@echo off
REM ===========================================
SET CLEAN_BRANCH=0
SET DEBUGGING=0
SET LEVEL0=level0
SET STARADMIN_BIN=%WORKING_DIRECTORY%\level1\bin\Debug
if "%LEVEL0"=="" set LEVEL0=level0
if "%WORKING_DIRECTORY%"=="" set WORKING_DIRECTORY=C:\Workspace\starcounter
REM ===========================================

if "%1"=="/?" goto help
if "%1"=="/clean" goto build_clean
if "%1"=="/build" goto build
if "%1"=="/debug" goto build_debug
if "%1"=="/test"  goto test
if "%1"=="/test_metalayer"  goto test_metalayer
if "%1"=="/test_cache"  goto test_cache
if "%1"=="" goto build
if "%1"=="/open" goto open_solution
if "%LEVEL0"=="" goto set_level_0
if "%1"=="/test_sql_regression"  goto test_sql_regression
if "%1"=="/test_rerun_failures"  goto test_rerun_failures
if "%1"=="/generate_all"  goto generate_all

:help
echo.
echo ================================================
echo build_level0 [optional]
echo.              to build in Debug mode
echo. [option]  
echo. /?         to display help message
echo. /clean     to regenerate BlueCmake solution
echo. /build     to build in Debug mode
echo. /debug     to build in Debug mode and set
echo             up for debugging
echo. /open      to open BlueStar
echo ================================================
goto ok

:set_level_0
echo.    Please set LEVEL0 
echo.    Examples    - set LEVEL0=level0 
echo.            or  - set LEVEL0=level0-issue-74
goto ok

:build_clean
pushd %WORKING_DIRECTORY%\%LEVEL0%
call cmake_vs.bat
popd
IF ERRORLEVEL 1 (
     goto error
) ELSE (
    goto build
)

:build
pushd %WORKING_DIRECTORY%\%LEVEL0%\cmake_vs
devenv BlueCmake.sln /Build Debug
popd
IF ERRORLEVEL 1 (
    goto error
) ELSE (
    goto ok
)

:test
pushd %WORKING_DIRECTORY%\%LEVEL0%\cmake_vs\src\tests\sqlprocessor_functest
REM taskkill /f /T /im scdata.exe
%STARADMIN_BIN%\staradmin kill all
REM waiting 3 pings (1s delay in between the two consecutive pings)
ping 127.0.0.1 -n 3 > nul
REM
ctest -C Debug -R sql -V
popd
IF ERRORLEVEL 1 (
    goto error
) ELSE (
   goto ok
)

:test_metalayer
pushd %WORKING_DIRECTORY%\%LEVEL0%\cmake_vs\src\tests\metalayer_functest
REM taskkill /f /T /im scdata.exe
%STARADMIN_BIN%\staradmin kill all
REM waiting 3 pings (1s delay in between the two consecutive pings)
ping 127.0.0.1 -n 3 > nul
REM
ctest -C Debug -V
popd
IF ERRORLEVEL 1 (
    goto error
) ELSE (
   goto ok
)

:test_sql_regression
pushd %WORKING_DIRECTORY%\%LEVEL0%\cmake_vs\src\tests\query_testing\data\sql_regression_testing
REM taskkill /f /T /im scdata.exe
%STARADMIN_BIN%\staradmin kill all
REM waiting 3 pings (1s delay in between the two consecutive pings)
ping 127.0.0.1 -n 3 > nul
REM
ctest -C Debug -V
popd
IF ERRORLEVEL 1 (
    goto error
) ELSE (
   goto ok
)

:test_rerun_failures
pushd %WORKING_DIRECTORY%\%LEVEL0%\cmake_vs\src\tests\query_testing\data\sql_regression_testing_rerun_failures
REM taskkill /f /T /im scdata.exe
%STARADMIN_BIN%\staradmin kill all
REM waiting 3 pings (1s delay in between the two consecutive pings)
ping 127.0.0.1 -n 3 > nul
REM
ctest -C Debug -V
popd
IF ERRORLEVEL 1 (
    goto error
) ELSE (
   goto ok
)


:test_cache
REM taskkill /f /T /im scdata.exe
%STARADMIN_BIN%\staradmin kill all
REM waiting 3 pings (1s delay in between the two consecutive pings)
ping 127.0.0.1 -n 3 > nul
pushd %WORKING_DIRECTORY%\%LEVEL0%\cmake_vs\src\tests\sql_query_cachetest
ctest -C Debug -R sql -V
IF ERRORLEVEL 1 (
    goto error
) ELSE (
  goto ok	
)	


:build_debug_ctest
pushd C:\temp\
del testapp1 /q
popd
copy C:\Utilities\*.bat %WORKING_DIRECTORY%\%LEVEL0%\msbuild\x64\Debug\ /Y
pushd %WORKING_DIRECTORY%\%LEVEL0%\msbuild\x64\Debug
call setup_testapp1.bat
call start_testapp1.bat
popd
IF ERRORLEVEL 1 (
    goto error
) ELSE (
    goto ok
)

:build_debug
taskkill /f /T /im scdata.exe
REM taskkill /f /im scdblog.exe
pushd %WORKING_DIRECTORY%\%LEVEL0%\msbuild\x64\Debug\
python ../../../src/tests/common_python_scripts/common_functest.py sqlprocessor_functest --prepare
popd
IF ERRORLEVEL 1 (
    goto error
) ELSE (
    goto ok
)

:open_solution
pushd %WORKING_DIRECTORY%\%LEVEL0%\cmake_vs
devenv BlueCmake.sln
popd
IF ERRORLEVEL 1 (
    goto error
) ELSE (
    goto ok
)

:generate_all
REM taskkill /f /T /im scdata.exe
%STARADMIN_BIN%\staradmin kill all
REM waiting 3 pings (1s delay in between the two consecutive pings)
ping 127.0.0.1 -n 3 > nul
pushd %WORKING_DIRECTORY%\%LEVEL0%\msbuild\x64\Debug
query_test_generator.exe "unique_example"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "codegen_string"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "comparison_queries"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "linked_list"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "numbers"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "qexample"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "simpleSelect_queries"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "simpleSelect_with_long_index_queries"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "simpleSelect_with_string_index_queries"
ping 127.0.0.1 -n 3 > nul
REM query_test_generator.exe "simpleSelect_with_ulong_index_queries"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "string_comparison_queries"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "test_querytype"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "folder_example/folder_example"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "parameter_examples/binary"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "parameter_examples/decimal"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "parameter_examples/double"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "parameter_examples/float"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "parameter_examples/long"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "parameter_examples/reference"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "parameter_examples/string"
ping 127.0.0.1 -n 3 > nul
query_test_generator.exe "parameter_examples/ulong"

IF ERRORLEVEL 1 (
    goto error
) ELSE (
  goto ok	
)

:error
EXIT /B 1

:ok
EXIT /B 0

