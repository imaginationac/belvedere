Gui, 1:Add, Text, x2 y0 w270 h20 +ReadOnly +ReadOnly +Center, Belvedere Installer Build Tool
Gui, 1:Add, Picture, x2 y20 w270 h270 , I:\dev\projects\belvedere\resources\both.png
Gui, 1:Add, Button, x282 y10 w100 h50 gBuild, &Build
Gui, 1:Add, Button, x282 y70 w100 h30 , &Configure
Gui, 1:Add, Button, x282 y110 w100 h30 g1GuiClose, &Exit
Gui, 1:Add, Text, x392 y10 w190 h50 , Build the installer using the default setting. The build tool will look for dependencies automatically.
Gui, 1:Add, Text, x392 y70 w190 h30 , Configure the build environment manually.
Gui, 1:Add, Text, x392 y110 w190 h30 , Close the build tool.
Gui, 1:Add, Text, x282 y150 w300 h140 , Copyright 2012 Dorian Alexander Patterson.`nDistrubed under the GNU Public License version 3. See LICENSE.txt for details.`nWritten in AutoHotkey.
; Generated using SmartGUI Creator 4.0
Gui, 1:Show, Center h298 w600, %buildToolsName%
Return

1GuiClose:
ExitApp
return

Build:
Gui, 1:Cancel
#Include build-GUI-build.ahk
Return