; configure.ahk
; Configures dependencies for the build script
;
; Copyright 2012 Dorian Alexander Patterson
;
; This is part of build.ahk.
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

Dependencies := {ahk2exe: 0, hhc: 0, nsis: 0}
ahk2exe := {DefaultLocation32: "C:\Program Files\AutoHotKey\Compiler\Ahk2Exe.exe", DefaultLocation64: "C:\Program Files (x86)\AutoHotKey\Compiler\Ahk2Exe.exe", RegistryRootKey: "HKLM", RegistrySubKey: "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Ahk2Exe.exe", RegistryValueName:}
hhc := {DefaultLocation32: "C:\Program Files\HTML Help Workshop\hhc.exe", DefaultLocation64: "C:\Program Files (x86)\HTML Help Workshop\hhc.exe", RegistryRootKey: "HKLM", RegistrySubKey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Components\28E7A37130464D115AF3000972A8B18B", RegistryValueName: "6EA51B6D250BE3636BBB4C17C4AB5690"}
makensis := {DefaultLocation32: "C:\Program Files\NSIS\makensis.exe", DefaultLocation64: "C:\Program Files\NSIS\makensis.exe", RegistryRootKey: "HKLM", RegistrySubKey: "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\NSIS", RegistryValueName: "InstallLocation"}

For key, value in Dependencies

; AutoHotkey script compiler.
AHK:
Dependencies.ahk2exe := FindDependencyDefault("ahk2exe")
if(Dependencies.ahk2exe)
{
	GoSub HHC
}
Else{
	; Look in registry
	Dependencies.ahk2exe := FindDependencyRegistry("HKLM", "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Ahk2Exe.exe")
}
if(Dependencies.ahk2exe)
{
	GoSub HHC
}
Return

HHC:
Dependencies.hhc := FindDependencyDefault("hhc")
if(Depedencies.hhc)
{
	GoSub MAKENSIS
}
Else
{
	Dependencies.ahk2exe := FindDependenciesRegistry("
}
Return

MAKENSIS:
Return
/*
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
*/

; Function definitions
; Detect CPU architecture
Is64Bit() {
	EnvGet, procID, Processor_Identifier
	return RegexMatch(procID, "^[^ ]+64") > 0
}

FindDependencyDefault(Array)
{
	If Is64Bit()
	{
		IfExist Array.DefaultLocation64
		{
			return Array.DefaultLocation64
		}
	}
	Else
	{
		IfExist Array.DefaultLocation32
		{
			return Array.DefaultLocation32
		}
	}
}

FindDependencyRegistry(Array)
{
	RegRead, OutputVar, %RootKey%, %SubKey%, %ValueName%
	Return OutputVar
}
