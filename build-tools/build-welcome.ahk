Gui, 1:Add, Text, x2 y0 w270 h20 +ReadOnly +ReadOnly +Center, Belvedere Installer Build Tool
Gui, 1:Add, Picture, x2 y20 w270 h270 , I:\dev\projects\belvedere\resources\both.png
Gui, 1:Add, Button, x282 y10 w100 h50 , &Build
Gui, 1:Add, Button, x282 y70 w100 h30 , &Configure
Gui, 1:Add, Button, x282 y110 w100 h30 gGuiClose, &Exit
Gui, 1:Add, Text, x392 y10 w190 h50 , Build the installer using the default setting. The build tool will look for dependencies automatically.
Gui, 1:Add, Text, x392 y70 w190 h30 , Configure the build environment manually.
Gui, 1:Add, Text, x392 y110 w190 h30 , Close the build tool.
Gui, 1:Add, Text, x282 y150 w300 h140 , Copyright 2012 Dorian Alexander Patterson.`nDistrubed under the GNU Public License version 3. See LICENSE.txt for details.`nWritten in AutoHotkey.
; Generated using SmartGUI Creator 4.0
Gui, 1:Show, x484 y359 h298 w600, New GUI Window
Return

GuiClose:
ExitApp