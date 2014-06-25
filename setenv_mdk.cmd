@echo off
@rem
@rem Copyright 2014 The NETMF Fork project contributors
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

set MDK_VER=%1
set MDK_TOOL_PATH=%2

if not "%MDK_VER%"=="" goto ARG_OK

rem Read Keil MDK version and path from registry
call :RegQueryHelper HKLM\SOFTWARE\Keil\Products\MDK Version MDK_VER       > nul 2>&1
call :RegQueryHelper HKLM\SOFTWARE\Keil\Products\MDK Path    MDK_TOOL_PATH > nul 2>&1

if "%MDK_VER%"=="" goto ARG_ERROR

rem Strip 'V' from the registry version string ("V5.01" -> "5.01")
set MDK_VER=%MDK_VER:V=%

:ARG_OK
%~dp0setenv_base.cmd MDK %MDK_VER% %MDK_TOOL_PATH% %3 %4 %5

goto :EOF

:RegQueryHelper
setlocal
set regVal=
for /F "tokens=1,2*" %%i in ('reg query "%1" /v "%2" /reg:32') do (
	if "%%i"=="%2" set "regVal=%%k"
)
endlocal & set "%3=%regVal%"
exit /b

:ARG_ERROR
@echo.
@echo ERROR: Invalid version argument or Keil MDK-ARM installation was not found in registry.
@echo USAGE: setenv_mdk.cmd [MDK_VERSION [MDK_TOOL_PATH]]
@echo        where MDK_VERSION is (3.80a, 4.12, 4.13, ...)
@echo        where MDK_TOOL_PATH is the path to the ARM directory of the MDK install (C:\Keil\Arm)
@echo.