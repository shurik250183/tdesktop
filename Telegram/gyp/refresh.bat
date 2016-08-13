@echo OFF
setlocal enabledelayedexpansion
set "FullScriptPath=%~dp0"
set "FullExecPath=%cd%"

set "Silence=>nul"
if "%1" == "-v" set "Silence="

cd "%FullScriptPath%"
call gyp --depth=. --generator-output=../.. -Goutput_dir=out Telegram.gyp --format=ninja
if %errorlevel% neq 0 goto error
call gyp --depth=. --generator-output=../.. -Goutput_dir=out Telegram.gyp --format=msvs-ninja
if %errorlevel% neq 0 goto error
cd ../..

rem looks like ninja build works without sdk 7.1 which was used by generating custom environment.arch files

rem cd "%FullScriptPath%"
rem call gyp --depth=. --generator-output=../.. -Goutput_dir=out -Gninja_use_custom_environment_files=1 Telegram.gyp --format=ninja
rem if %errorlevel% neq 0 goto error
rem call gyp --depth=. --generator-output=../.. -Goutput_dir=out -Gninja_use_custom_environment_files=1 Telegram.gyp --format=msvs-ninja
rem if %errorlevel% neq 0 goto error
rem cd ../..

rem call msbuild /target:SetBuildDefaultEnvironmentVariables Telegram.vcxproj /fileLogger %Silence%
rem if %errorlevel% neq 0 goto error

rem call python "%FullScriptPath%create_env.py"
rem if %errorlevel% neq 0 goto error

rem call move environment.x86 out\Debug\ %Silence%
rem if %errorlevel% neq 0 goto error

cd "%FullExecPath%"
exit /b

:error
echo FAILED
if exist "%FullScriptPath%..\..\msbuild.log" del "%FullScriptPath%..\..\msbuild.log"
if exist "%FullScriptPath%..\..\environment.x86" del "%FullScriptPath%..\..\environment.x86"
cd "%FullExecPath%"
exit /b 1
