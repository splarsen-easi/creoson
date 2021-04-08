@echo off

set PROE_COMMON=C:\Program Files\PTC\Creo 4.0\M130\Common Files
set JAVA_HOME=C:\Program Files\Java\jre1.8.0_281\
@REM set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_281\jre\

set PROE_ENV=x86e_win64
set JSON_PORT=9056
SET mypath=%~dp0

echo.
echo %mypath%
echo.

@REM might not need this line, need more info on the pro_comm_msg_exe file and what it does
set PRO_COMM_MSG_EXE=%PROE_COMMON%\%PROE_ENV%\obj\pro_comm_msg.exe

@REM These are needed to load teh DLL's required to run (such as pfcasyncmt)
set opath=%path%
set path=%PROE_COMMON%\%PROE_ENV%\lib;%PROE_COMMON%\%PROE_ENV%\obj;%path%

set cp=.
setlocal enabledelayedexpansion
for %%x in ("%mypath%output\"./*jar) do (
  echo %%x
  echo.
  set cp=!cp!;%%x
)

@REM for %%x in ("%mypath%includes\"./*jar) do (
@REM   echo %%x
@REM   echo.
@REM   set cp=!cp!;%%x
@REM )
@REM echo %cp%

@REM might not need to load pfcasync if otk includes all the pfc sub.jar files

@REM need to load pfcasync and otk from creo location, doesn't like loading from local location
set cp=%cp%;%PROE_COMMON%\text\java\pfcasync.jar;%PROE_COMMON%\text\java\otk.jar

@REM for /f %%j in ("java.exe") do (
@REM   set JAVA_HOME=%%~dp$PATH:j
@REM )
echo.

"%JAVA_HOME%bin\java" -classpath "%cp%" -Dsli.jlink.timeout=200 -Dsli.socket.port=%JSON_PORT% -Dsli.debug=jshell,regen,parameter.set,connect,jlink com.simplifiedlogic.nitro.jshell.MainServer

set path=%opath%

goto end

:end