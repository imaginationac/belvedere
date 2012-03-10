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
buildToolsName = Belvedere Installer Build Tool
installerDir = %A_WorkingDir%\installer
helpProject = %A_WorkingDir%\help\Belvedere Help.hhp
distDir = %A_WorkingDir%\dist
executableName = Belvedere.exe
installerScript = %buildDir%\installer.nsi

; Load GUI
SetWorkingDir %buildToolsDir%
#Include build-GUI-welcome.ahk
Return

/*
; Check dependencies
dependencies := {ahk2exe: 0, hhc: 0, nsis: 0}
; Default locations
; 32-bit
Defaults32 := {ahk2exe: "C:\Program Files\AutoHotKey\Compiler\Ahk2Exe.exe" , hhc: "C:\Program Files\HTML Help Workshop\hhc.exe", makensis: "C:\Program Files\NSIS\makensis.exe"}
; 64-bit
Defaults64 := {ahk2exe: "C:\Program Files (x86)\AutoHotKey\Compiler\Ahk2Exe.exe", hhc: "C:\Program Files (x86)\HTML Help Workshop\hhc.exe", makensis: "C:\Program Files (x86)\NSIS\makensis.exe"}
; Detect CPU architecture
Is64Bit() {
	EnvGet, procID, Processor_Identifier
	return RegexMatch(procID, "^[^ ]+64") > 0
}
arc := Is64Bit()

; AutoHotkey script compiler.

OutputVar = ahk2exe
RootKey = HKLM
SubKey = SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Ahk2Exe.exe
RegRead, %OutputVar%, %RootKey%, %SubKey%
if ErrorLevel{
	MsgBox, You do not have AutoHotkey_L installed. Please download it.
	ExitApp, 1
}

; Help manual compiler.
; FIXME: Not reading the registry value.
OutputVar = hhc
RootKey = HKLM
SubKey = SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Components\28E7A37130464D115AF3000972A8B18B
;ValueName = 6EA51B6D250BE3636BBB4C17C4AB5690
RegRead, %OutputVar%, %RootKey%, %SubKey% ;, %ValueName%
MsgBox, %hhc%
if ErrorLevel{
	MsgBox, %ErrorLevel%: You do not have Microsoft HTML Help Workshop installed. Please download it.
	ExitApp, 1
}
; Commandline compiler for NSIS (makensis.exe)
OutputVar = makensis
RootKey = HKLM
SubKey = SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\NSIS
ValueName = InstallLocation
RegRead, %OutputVar%, %RootKey%, %SubKey%, %ValueName%
makensis .= "\makensis.exe"

; Clean old build files
IfExist, %buildDir%
	FileRemoveDir, %buildDir%, 1
FileCreateDir, %buildDir%

; Compile Belvedere.ahk
RunWait, %ahk2exe% /in Belvedere.ahk

; Move to build folder
FileMove, %executableName%, %buildDir%

; Compile help.
RunWait %hhc% %helpProject%

; Copy installer files to build
FileCopy, %installerDir%\*.*, %buildDir%\*.*

; Build the installer
CompileCommand = %makensis% /V1 %installerScript%
FileCreateDir, %A_WorkingDir%\dist
RunWait, %CompileCommand%
