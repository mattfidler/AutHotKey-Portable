;Copyright (C) 2004-2008 John T. Haller
;Copyright (C) 2008 Brian All

;Website: http://portableapps.com/AutoHotkeyPortable

;This software is OSI Certified Open Source Software.
;OSI Certified is a certification mark of the Open Source Initiative.

;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;as published by the Free Software Foundation; either version 2
;of the License, or (at your option) any later version.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

!define NAME "AHKCompilerPortable"
!define PORTABLEAPPNAME "AHK Compiler Portable"
!define APPNAME "AHK Compiler"
!define VER "1.5.6.0"
!define WEBSITE "PortableApps.com/development/test"
!define DEFAULTEXE "ahk2exe.exe"
!define DEFAULTAPPDIR "AutoHotkey\Compiler"
!define DEFAULTSETTINGSDIR "settings"

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows the ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "PortableApps.com & Contributers"
VIAddVersionKey FileDescription "${PORTABLEAPPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${PORTABLEAPPNAME}"
VIAddVersionKey LegalTrademarks "PortableApps.com is a Trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "${NAME}.exe"
;VIAddVersionKey PrivateBuild ""
;VIAddVersionKey SpecialBuild ""

;=== Runtime Switches
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
!include "GetParameters.nsh"
!include "Registry.nsh"
!include "FileFunc.nsh"
!include "MUI.nsh"
!include "StrRep.nsh"
!include "ReplaceInFile.nsh"

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Icon & Stye ===
!define MUI_ICON "..\..\App\AppInfo\appicon.ico"

;=== Languages
!insertmacro MUI_LANGUAGE "English"

LangString LauncherFileNotFound ${LANG_ENGLISH} "${PORTABLEAPPNAME} cannot be started. You may wish to re-install to fix this issue. (ERROR: $MISSINGFILEORPATH could not be found)"
LangString LauncherAlreadyRunning ${LANG_ENGLISH} "Another instance of ${APPNAME} is already running. Please close other instances of ${APPNAME} before launching ${PORTABLEAPPNAME}."
LangString LauncherAskCopyLocal ${LANG_ENGLISH} "${PORTABLEAPPNAME} appears to be running from a location that is read-only. Would you like to temporarily copy it to the local hard drive and run it from there?$\n$\nPrivacy Note: If you say Yes, your personal data within ${PORTABLEAPPNAME} will be temporarily copied to a local drive. Although this copy of your data will be deleted when you close ${PORTABLEAPPNAME}, it may be possible for someone else to access your data later."
LangString LauncherNoReadOnly ${LANG_ENGLISH} "${PORTABLEAPPNAME} can not run directly from a read-only location and will now close."


Var PROGRAMDIRECTORY
Var SETTINGSDIRECTORY
Var ADDITIONALPARAMETERS
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var INIPATH
Var SECONDARYLAUNCH
Var DISABLESPLASHSCREEN
Var FAILEDTORESTOREKEY
Var USERTYPE
Var ISDEFAULTDIRECTORY
Var MISSINGFILEORPATH


Section "Main"
	;=== Check if already running
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${NAME}2") i .r1 ?e'
	Pop $0
	StrCmp $0 0 CheckINI
		StrCpy $SECONDARYLAUNCH "true"

	CheckINI:
		;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\AutoHotkey.ini" "" NoINI
			StrCpy "$INIPATH" "$EXEDIR"
			Goto ReadINI

	ReadINI:
		;=== Read the parameters from the INI file
		ReadINIStr $0 "$INIPATH\AutoHotkey.ini" "${NAME}" "${APPNAME}Directory"
		StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\$0"
		ReadINIStr $0 "$INIPATH\AutoHotkey.ini" "${NAME}" "SettingsDirectory"
		StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\$0"
	

		;=== Check that the above required parameters are present
		IfErrors NoINI
		
		ReadINIStr $0 "$INIPATH\AutoHotkey.ini" "${NAME}" "AdditionalParameters"
		StrCpy "$ADDITIONALPARAMETERS" $0
		ReadINIStr $0 "$INIPATH\AutoHotkey.ini" "${NAME}" "${APPNAME}Executable"
		StrCpy "$PROGRAMEXECUTABLE" $0
		ReadINIStr $0 "$INIPATH\AutoHotkey.ini" "${NAME}" "DisableSplashScreen"
		StrCpy "$DISABLESPLASHSCREEN" $0

	;CleanUpAnyErrors:
		;=== Any missing unrequired INI entries will be an empty string, ignore associated errors
		ClearErrors

		;=== Correct PROGRAMEXECUTABLE if blank
		StrCmp $PROGRAMEXECUTABLE "" "" CheckForProgramINI
			StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"
			Goto CheckForProgramINI
	CheckForProgramINI:
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE NoProgramEXE

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy "$ADDITIONALPARAMETERS" ""
		StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"
		StrCpy "$DISABLESPLASHSCREEN" "false"

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
			StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\Data\settings"
			StrCpy "$ISDEFAULTDIRECTORY" "true"
			GoTo FoundProgramEXE


	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		

	FoundProgramEXE:
		;=== Check if already running
		StrCmp $SECONDARYLAUNCH "true" CheckForSettings
		FindProcDLL::FindProc "$PROGRAMEXECUTABLE"
		StrCmp $R0 "1" WarnAnotherInstance CheckForSettings

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherAlreadyRunning)`
		Abort

	CheckForSettings:
		IfFileExists "$SETTINGSDIRECTORY\*.*" DisplaySplash
		;=== No settings found
		StrCmp $ISDEFAULTDIRECTORY "true" CopyDefaultSettings
		CreateDirectory $SETTINGSDIRECTORY
		Goto DisplaySplash

	CopyDefaultSettings:
		CreateDirectory "$EXEDIR\Data"
		CreateDirectory "$EXEDIR\Data\settings"
		CopyFiles /SILENT $EXEDIR\App\DefaultData\settings\*.* $EXEDIR\Data\settings
		GoTo DisplaySplash
	
	DisplaySplash:
		StrCmp $DISABLESPLASHSCREEN "true" GetPassedParameters
			;=== Show the splash screen before processing the files
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "AutoHotkeyPortable.jpg"	
			newadvsplash::show /NOUNLOAD 1500 200 0 -1 /L $PLUGINSDIR\splash.jpg
	
	GetPassedParameters:
		;=== Get any passed parameters
		Call GetParameters
		Pop $0
		StrCmp "'$0'" "''" "" LaunchProgramParameters

		;=== No parameters
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE"`
		Goto AdditionalParameters

	LaunchProgramParameters:
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" $0`

	AdditionalParameters:
		StrCmp $ADDITIONALPARAMETERS "" SettingsDirectory

		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`
	
	SettingsDirectory:
		;=== Set the settings directory if we have a path
		IfFileExists "$SETTINGSDIRECTORY\*.*" RegistryBackup
			CreateDirectory $SETTINGSDIRECTORY

	
	RegistryBackup:
		StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
		;=== Backup the registry
		UserInfo::GetAccountType
		Pop $USERTYPE
		${registry::KeyExists} "HKEY_CURRENT_USER\Software\AutoHotkeyBackupByAHKCompilerPortable" $R0
		StrCmp $R0 "0" RestoreSettings
		${registry::KeyExists} "HKEY_CURRENT_USER\Software\AutoHotkey" $R0
		StrCmp $R0 "-1" RestoreSettings
		${registry::MoveKey} "HKEY_CURRENT_USER\Software\AutoHotkey" "HKEY_CURRENT_USER\Software\AutoHotKeyBackupByAHKCompilerPortable" $R0
		Sleep 100
	
	RestoreSettings:
		IfFileExists "$SETTINGSDIRECTORY\AHKCompiler.reg" "" RestoreTheKey9x
		
	;RestoreTheKey
		IfFileExists "$WINDIR\system32\reg.exe" "" RestoreTheKey9x
			nsExec::ExecToStack `"$WINDIR\system32\reg.exe" import "$SETTINGSDIRECTORY\AHKCompiler.reg"`
			Pop $R0
			StrCmp $R0 '0' RestoreTheKey9x ;successfully restored key
	RestoreTheKey9x:
		${registry::RestoreKey} "$SETTINGSDIRECTORY\AHKCompiler.reg" $R0
		StrCmp $R0 '0' BackupHCR ;successfully restored key
		StrCpy $FAILEDTORESTOREKEY "true"

	BackupHCR:
		StrCmp $USERTYPE "Guest" StartProgramNow
		StrCmp $USERTYPE "User" StartProgramNow
		${registry::MoveKey} "HKEY_LOCAL_MACHINE\Software\Classes\AutoHotkeyScript" "HKEY_LOCAL_MACHINE\Software\Classes\Applications\AutoHotkeyScriptBackupByAHKCompilerPortable" $R0
		${registry::MoveKey} "HKEY_LOCAL_MACHINE\Software\Classes\.ahk" "HKEY_LOCAL_MACHINE\Software\Classes\.ahk-BackupByAHKCompilerPortable" $R0	
		${registry::MoveKey} "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\ahk2exe.exe" "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\ahk2exe.exe-BackupByAHKCompilerPortable" $R0		

	StartProgramNow:
		Sleep 100
		SetOutPath $PROGRAMDIRECTORY
		ExecWait $EXECSTRING
		
	CheckRunning:
		Sleep 1000
		FindProcDLL::FindProc "${DEFAULTEXE}"                  
		StrCmp $R0 "1" CheckRunning

	;DoneRunning:
		StrCmp $FAILEDTORESTOREKEY "true" SetOriginalKeyBack
		${registry::SaveKey} "HKEY_CURRENT_USER\Software\AutoHotkey" "$SETTINGSDIRECTORY\AHKCompiler.reg" "" $R0
		Sleep 100
	
	SetOriginalKeyBack:
		${registry::DeleteKey} "HKEY_CURRENT_USER\Software\AutoHotkey" $R0
		${registry::MoveKey} "HKEY_CURRENT_USER\Software\AutoHotkeyBackupByAHKCompilerPortable" "HKEY_CURRENT_USER\Software\AutoHotkey" $R0
		StrCmp $USERTYPE "Guest" TheEnd
		StrCmp $USERTYPE "User" TheEnd
		${registry::DeleteKey} "HKEY_LOCAL_MACHINE\Software\Classes\AutoHotkeyScript" $R0
		${registry::MoveKey} "HKEY_LOCAL_MACHINE\Software\Classes\Applications\AutoHotkeyScriptBackupByAHKCompilerPortable" "HKEY_LOCAL_MACHINE\Software\Classes\AutoHotkeyScript" $R0
		${registry::DeleteKey} "HKEY_LOCAL_MACHINE\Software\Classes\.ahk" $R0
		${registry::MoveKey} "HKEY_LOCAL_MACHINE\Software\Classes\.ahk-BackupByAHKCompilerPortable" "HKEY_LOCAL_MACHINE\Software\Classes\.ahk" $R0		
		${registry::DeleteKey} "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\ahk2exe.exe" $R0
		${registry::MoveKey} "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\ahk2exe.exe-BackupByAHKCompilerPortable" "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\ahk2exe.exe" $R0		

		Goto TheEnd
		
	LaunchAndExit:
		Exec $EXECSTRING

	TheEnd:
		${registry::Unload}
		newadvsplash::stop /WAIT
SectionEnd