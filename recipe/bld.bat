set build_type=release

if not exist %LIBRARY_BIN% mkdir %LIBRARY_BIN%

:: Use VS 2015 MSBuild
set PATH=%PROGRAMFILES(x86)%\MSBuild\14.0\Bin;%PATH%
set VCTargetsPath=%PROGRAMFILES(x86)%\MSBuild\Microsoft.Cpp\v4.0\V140\

:: Generate GPSBabel.vcxproj and GPSBabel.vcxproj.filters
qmake -tp vc GPSBabel.pro
if %errorlevel% neq 0 exit /b %errorlevel%

:: Build project with
:: devenv GPSBabel.vcxproj /build "Release|x64"
msbuild GPSBabel.vcxproj /nologo /maxcpucount /p:configuration=%build_type% /p:platform=x64 /target:build
if %errorlevel% neq 0 exit /b %errorlevel%

:: Install
copy %build_type%\GPSBabel.exe %LIBRARY_BIN%\
if %errorlevel% neq 0 exit /b %errorlevel%

exit 0
