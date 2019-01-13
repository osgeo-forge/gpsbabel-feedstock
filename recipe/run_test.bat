REM @echo off
set "compare=diff -u -b -w"

REM Otherwise, time tag is always wrong
REM Ref: testio
set GPSBABEL_FREEZE_TIME=y

REM GPX (from testo.d/gpx.test)

del /F /Q %TEMP%\gl.gpx %TEMP%\gpx.wpt
gpsbabel -i geo -f geocaching.loc -o gpsman -F %TEMP%\gm.gm -o gpsutil -F %TEMP%\gu.wpt
gpsbabel -i geo -f geocaching.loc -o gpx -F %TEMP%\gl.gpx
gpsbabel -i gpx -f %TEMP%\gl.gpx -o gpsutil -F %TEMP%\gpx.wpt
%compare% %TEMP%\gpx.wpt %TEMP%\gu.wpt
if %errorlevel% neq 0 exit /b %errorlevel%

del /F /Q %TEMP%\gtrnctr_power.gpx
gpsbabel -i gtrnctr -f reference\track\gtrnctr_power.tcx -o gpx,garminextensions=1 -F %TEMP%\gtrnctr_power.gpx
%compare%  reference\track\gtrnctr_power.gpx %TEMP%\gtrnctr_power.gpx
if %errorlevel% neq 0 exit /b %errorlevel%

del /F /Q %TEMP%\tpx-sample.gpx
gpsbabel -i gpx -f reference\track\gpx_garmin_extensions.gpx -o gpx,garminextensions -F %TEMP%\tpx-sample.gpx
%compare% reference\track\gpx_garmin_extensions.gpx %TEMP%\tpx-sample.gpx
if %errorlevel% neq 0 exit /b %errorlevel%

del /F /Q %TEMP%\basecamp~gpx.gpx
gpsbabel -i gpx -f reference\basecamp.gpx -o gpx -F %TEMP%\basecamp~gpx.gpx
%compare% reference\basecamp~gpx.gpx %TEMP%\basecamp~gpx.gpx
if %errorlevel% neq 0 exit /b %errorlevel%

del /F /Q %TEMP%\extensiondata.gpx
gpsbabel -i unicsv -f reference\extensiondata.unicsv -x transform,trk=wpt -o gpx,garminextensions -F %TEMP%\extensiondata.gpx
%compare% reference\extensiondata~unicsv.gpx %TEMP%\extensiondata.gpx
if %errorlevel% neq 0 exit /b %errorlevel%

REM Read, write GPX file with times that don't fit in time_t, subsecond.
gpsbabel -i gpx -f reference\bigtime.gpx -o gpx -F %TEMP%\bigtime.gpx
%compare% reference\bigtime.gpx %TEMP%\bigtime.gpx
if %errorlevel% neq 0 exit /b %errorlevel%

REM test standard output
del /F /Q %TEMP%\basecamp~gpx_so.gpx
gpsbabel -i gpx -f reference\basecamp.gpx -o gpx -F - 1> %TEMP%\basecamp~gpx_so.gpx
%compare% reference\basecamp~gpx.gpx %TEMP%\basecamp~gpx_so.gpx
if %errorlevel% neq 0 exit /b %errorlevel%

REM test standard input
del /F /Q %TEMP%\basecamp~gpx_si.gpx
type reference\basecamp.gpx | gpsbabel -i gpx -f - -o gpx -F %TEMP%\basecamp~gpx_si.gpx
%compare% reference\basecamp~gpx.gpx %TEMP%\basecamp~gpx_si.gpx
if %errorlevel% neq 0 exit /b %errorlevel%

REM test unknown tags
del /F /Q %TEMP%\unknowntag.gpx
gpsbabel -i gpx -f reference\unknowntag.gpx -o gpx -F %TEMP%\unknowntag.gpx
%compare% reference\unknowntag~gpx.gpx %TEMP%\unknowntag.gpx
if %errorlevel% neq 0 exit /b %errorlevel%

del /F /Q %TEMP%\unknowntag2.gpx
gpsbabel -i gpx -f reference\unknowntag2.gpx -o gpx -F %TEMP%\unknowntag2.gpx
%compare% reference\unknowntag2~gpx.gpx %TEMP%\unknowntag2.gpx
if %errorlevel% neq 0 exit /b %errorlevel%
