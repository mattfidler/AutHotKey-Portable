AutoHotkey Portable, Package Version 1.0.47.6, Consisting of:
	AutoHotkey Portable Launcher 1.0.47.6 
	AutoIt3 Window Info Spy Portable Launcher 1.0.3.0
	AHK Compiler Portable Launcher 1.0.47.6
	AutoScriptWriter Portable Launcher 2.0.0.0
	SmartGUI Creator Portable Launcher 4.0.0.0
==============================================================
Copyright 2004-2006 John T. Haller
Copyright 2008 Brian All

Website: http://PortableApps.com/AutoHotKeyPortable

This software is OSI Certified Open Source Software.
OSI Certified is a certification mark of the Open Source Initiative.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


ABOUT AUTOHOTKEY PORTABLE
==========================
The AutoHotKey Portable Launchers allows you to run elements of AutoHotkey from a removable drive whose letter changes as you move it to another computer.
To run the AutoIt3 Window Info Spy, run AutoHotKeyPortable.exe and click on the link in the tray icon; OR: Run AutoIt3WindowInformationSpyPortable.exe.
To run the AHK Compiler, run AHKCompilerPortable.exe.
To run the AutoScriptWriter, run AutoScriptWriterPortable.exe.
To run SmartGui Creator, run SmartGUICreatorPortable.exe.
In the instructions below, substitute AutoHotkey for the name of any of the four launchers in the AutoHotkey Portable package.

LICENSE
=======
This code is released under the GPL.  
Within the Source directory you will find the code (AutoHotkeyPortable.nsi) as well as the full GPL license (License.txt).  
If you use the launcher or code in your own product, please give proper and prominent attribution.


INSTALLATION / DIRECTORY STRUCTURE
=================================
By default, the program expects this directory structure:

-\ <--- Directory with AutoHotkeyPortable.exe
	+\App\
	    +\AutoHotkey\
	+\Data\
		+\settings\

It can be used in other directory configurations by including the AutoHotkeyPortable.ini file in the same directory as AutoHotkeyPortable.exe and configuring it as details in the INI file section below.  The INI file may also be placed in a subdirectory of the directory containing AutoHotkeyPortable.exe called AutoHotkeyPortable or 2 directories deep in PortableApps\AutoHotkeyPortable or Data\AutoHotkeyPortable.  All paths in the INI should remain relative to the EXE and not the INI.


AUTOHOTKEYPORTABLE.INI CONFIGURATION
====================================
The AutoHotkey Portable Launcher will look for an ini file called AutoHotkeyPortable.ini within its directory (see the paragraph above in the Installation/Directory Structure section).  If you are happy with the default options, it is not necessary, though.  There is an example INI included with this package to get you started.  The INI file is formatted as follows:

[AutoHotkeyPortable]
AutoHotkeyDirectory=App\AutoHotkey
SettingsDirectory=Data\settings
AutoHotKeyExecutable=AutoHotkey.exe
AdditionalParameters=
DisableSplashScreen=false


The AutoHotkeyDirectory and SettingsDirectory entries should be set to the *relative* path to the directories containing AutoHotkey.exe and your settings from the current directory.  All must be a subdirectory (or multiple subdirectories) of the directory containing AutoHotkey.exe.  The default entries for these are described in the installation section above.

The SettingsFile entry is the name of your AutoHotkey settings file within the SettingsDirectory.

The AutoHotkeyExecutable entry allows you to give an alternate filename for the AutoHotkey executable.

The AdditionalParameters entry allows you to specify additional parameters to be passed to AutoHotkey on the command line.

The DisableSplashScreen entry allows you to run the AutoHotkey Portable Launcher without the splash screen showing up.  The default is false.


PROGRAM HISTORY / ABOUT THE AUTHORS
===================================
The launchers are loosely based on the Eraser Portable launcher. 