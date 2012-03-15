; Build script for Belvedere
; Version 0.1.1
; Author: Dorian Alexander Patterson <imaginationc@gmail.com>
; Requires: AutoHotkey_L 1.1.07.01+
;
; Copyright 2012 Dorian Alexander Patterson
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

; Set up build environment
#NoEnv
#SingleInstance ignore
#NoTrayIcon
SetWorkingDir ..
buildDir = %A_WorkingDir%\build
buildToolsDir = %A_WorkingDir%\build-tools
;buildToolsName = Belvedere Installer Build Tool
installerDir = %A_WorkingDir%\installer
helpProject = %A_WorkingDir%\help\Belvedere Help.hhp
distDir = %A_WorkingDir%\dist
executableName = Belvedere.exe
installerScript = %buildDir%\installer.nsi

SetWorkingDir, %buildToolsDir%
#Include configure.ahk
