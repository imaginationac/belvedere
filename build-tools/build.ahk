; Build script for Belvedere
; Version 0.2.1
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

; After configuration, actually build things.
SetWorkingDir, ..
; Clean old build files.
IfExist, %BuildDir%
{
	FileAppend, Clean old build files...`n, *
	FileRemoveDir, %BuildDir%, 1
}
; Create build directory.
try
{
	FileAppend, Creating build directory: %BuildDir%`n, *
	FileCreateDir, %BuildDir%
}
catch e
{
	FileAppend, Could not create the build directory. Check your permissions.`n, *
	ExitApp, 1
}

; Compile executable.
FileAppend, Building Belvedere.exe...`n, *
; 64-Bit workaround. Compile_AHK doesn't play nice. Use ahk2exe directly.
if (Is64Bit())
{
	try
	{
		Program := Dependencies.ahk2exe
		Target = %Program% /in %A_WorkingDir%\Belvedere.ahk
		RunWait, %Target%
	}
	catch e
	{
		FileAppend, Could not build Belvedere.exe. Check your permissions.`n, *
		ExitApp, 1
	}
}
; 32-bit. Use Compile_AHK.
else
{
	try
	{
		Program := Dependencies.compileahk
		Target = %Program% /auto %A_WorkingDir%\Belvedere.ahk
		RunWait, %Target%
	}
	catch e
	{
		FileAppend, Could not build Belvedere.exe. Check your permissions.`n, *
		ExitApp, 1
	}
}

; Move executable to build directory.
FileMove, %A_WorkingDir%\%executableName%, %BuildDir%

; Compile help.
FileAppend, Building help...`n, *
try
{
	Program := Dependencies.hhc
	Target = "%Program%" "%helpProject%"
	RunWait, %Target%
}
catch e
{
	FileAppend, Could not build help. Check your permissions.`n, *
	ExitApp, 1
}

; Copy installer files to build directory.
try
{
	FileCopy, %InstallerDir%\*.*, %BuildDir%\*.*
}
catch e
{
	FileAppend, Could not copy installation files. Check your permissions.`n, *
	ExitApp, 1
}

/*
OnExit:
If (%A_ExitReason% == Error)
{
	MsgBox, Unable to compile the installer. Please check the logs.
}
Else
{
	MsgBox, Installer compiled successfully!`nYou can find the installer in %distDir%.
}
