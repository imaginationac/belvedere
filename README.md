Belvedere
=========

An automated file manager for Windows
-------------------------------------

* Platform: Windows (XP and later)
* Language(s): AutoHotkey, NSIS (for the installer)
* License: GPL v3 

See [LICENSE.txt](https://github.com/mshorts/belvedere/blob/master/LICENSE.txt) for licensing details.

### How to build the installer manually.

1. Clone the repo: `git clone git://github.com/mshorts/belvedere.git`
2. Download and install [NSIS](http://prdownloads.sourceforge.net/nsis/nsis-2.46-setup.exe?download)
3. Download [KIllProc plug-in for NSIS](http://code.google.com/p/mulder/downloads/detail?name=NSIS-KillProc-Plugin.2011-04-09.zip&can=4&q=) 
4. Download and install [AutoHotkey_L](http://www.autohotkey.com/download/).
5. Download and install [Compile_AHK](http://www.autohotkey.com/forum/topic22975.html).
6. Compile Belvedere.ahk with Compile_AHK(in the root of the repo) and move the .exe into the /installer directory.
7. Compile /help/Belvedere Help.hhp with HTML Help Workshop and move the .chm to the /installer directory.
8. Compile /installer/install.nsi
9. Make sure to test the installer.

### How to build the installer automatically.

1. Run build-tools/build.ahk
2. Find the installer in the /dist directory. 

### How to run.

1. Download the installer -or-
2. Install AutoHotkey and run Belvedere.ahk.
