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

Dependencies := {ahk2exe: "", hhc: "", makensis: ""}
ahk2exe := { 	DefaultLocation32: "C:\Program Files\AutoHotKey\Compiler\Ahk2Exe.exe"
			,   DefaultLocation64: "C:\Program Files (x86)\AutoHotKey\Compiler\Ahk2Exe.exe"
			, 	RegistryRootKey: "HKLM"
			, 	RegistrySubKey: "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Ahk2Exe.exe"
			, 	RegistryValueName: ""}
hhc 	:= 	{	DefaultLocation32: "C:\Program Files\HTML Help Workshop\hhc.exe"
			, 	DefaultLocation64: "C:\Program Files (x86)\HTML Help Workshop\hhc.exe"
			, 	RegistryRootKey: "HKLM"
			, 	RegistrySubKey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Components\28E7A37130464D115AF3000972A8B18B"
			, 	RegistryValueName: "6EA51B6D250BE3636BBB4C17C4AB5690"}
makensis := {	DefaultLocation32: "C:\Program Files\NSIS\makensis.exe"
			, 	DefaultLocation64: "C:\Program Files (x86)\NSIS\makensis.exe"
			, 	RegistryRootKey: "HKLM"
			, 	RegistrySubKey: "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\NSIS"
			, 	RegistryValueName: "InstallLocation"}
ConfigFile = build.ini
; Check for a build.ini. Create an annotated boilerplate if one does not exist.
FileAppend, % "Searching for " . ConfigFile . " ... ", *
IfNotExist, %ConfigFile%
{
	FileAppend, not found ... creating one now.`n, *
	FileAppend, `; Configuration for build.ahk`n, %ConfigFile%
	FileAppend, [compilers]`n, %ConfigFile%
	FileAppend, ahk2exe=`n, %ConfigFile%
	FileAppend, hhc=`n, %ConfigFile%
	FileAppend, makensis=`n, %ConfigFile%
}

; If it already exists read from the configuration file
Else
{
	FileAppend, found. searching for dependencies.`n, *
	For Key, Value in Dependencies
	{
		Filename = %ConfigFile%
		Section = compilers
		IniRead, CompilerLocation, %Filename%, %Section%, %Key%
		FileAppend, % "Searching for " . key . " at " . CompilerLocation . " ... ", *
		IfExist, %CompilerLocation%
		{
			FileAppend, found!`n, *
			Dependencies[key] := CompilerLocation
		}
		Else
		{
			FileAppend, not found.`n, *
		}
	}
}

; Search at default install locations.
FileAppend, Seaching default install paths...`n, *
For Key, Value in Dependencies
{
	; Continue if already found.
	If (Value)
	{
		Continue
	}
	If (Is64Bit())
	{
		CompilerLocation := %key%.DefaultLocation64
	}
	Else
	{
		CompilerLocation := %key%.DefaultLoaction32
	}
	FileAppend, % "Searching for " . key . " at " . CompilerLocation . " ... ", *
	IfExist, %CompilerLocation%
	{
		FileAppend, found!`n, *
		Dependencies[key] := CompilerLocation
	}
	Else
	{
		FileAppend, not found.`n, *
	}
}

; Search in registry.
FileAppend, Searching the registry...`n, *
For Key, Value in Dependencies
{
	if(Value)
	{
		Continue
	}
	RootKey := %Key%.RegistryRootKey
	SubKey := %Key%.RegistrySubKey
	ValueName := %Key%.RegistryValueName
	RegRead, CompilerLocation, %RootKey%, %SubKey%, %ValueName%

	; The regesitry value for makensis only has the path to the executable, 
	; not the full file name. Append the rest.
	If (%key% == makensis)
	{
		CompilerLocation := CompilerLocation . "\makensis.exe"
	}

	IfExist, %CompilerLocation%
	{
		Dependencies[key] := CompilerLocation
	}
}

; Summary of configuration.
Loop 80
{
	FileAppend, -, *
}
FileAppend, `n, *
FileAppend, Configuration Summary:`n, *

For Key, Value in Dependencies
{
	FileAppend, %key% = %value%`n, *
	If(Value)
	{
		Count ++
	}
}
If (Count == 3)
{
	FileAppend, Configuration successful!`n,
}

; Function definitions.
; Detect CPU architecture
Is64Bit() {
	EnvGet, procID, Processor_Identifier
	return RegexMatch(procID, "^[^ ]+64") > 0
}
