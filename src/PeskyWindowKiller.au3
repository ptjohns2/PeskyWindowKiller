#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=..\bin\PeskyWindowKiller_x86.exe
#AutoIt3Wrapper_Outfile_x64=..\bin\PeskyWindowKiller_x64.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_AU3Check=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****


;---------------------------------------------------------
;Build option directives

;#NoTrayIcon


;---------------------------------------------------------
;Includes

#include <Array.au3>



;---------------------------------------------------------
;Constants

Const $config_filename = "PeskyWindowKiller.ini"
Const $config_failedKeyLoadValue = "PeskyWindowKiller_config_failedKeyLoadValue"

Global $hotkeyMode_enabled = True
Global $hotkeyMode_character = "["

Global $interruptMode_enabled = False
Global $interruptMode_delayMsec = 5000

Global $notificationWindow_enabled = False
Global $notificationWindow_title = "Notification window title"
Global $notificationWindow_message = "Notification window message"

Global $affectedWindowNameSubstrings[2] = [1, "testwindowname"]

Global $main_busyLoopSleep_delayMsec = 100


;---------------------------------------------------------
;Globals

Global $windowHandleList[1] = [0]


;---------------------------------------------------------
;Helper functions

Func windowHandleList_clear()
	ReDim $windowHandleList[1]
	$windowHandleList[0] = 0
EndFunc   ;==>windowHandleList_clear

Func windowHandleList_update()
	windowHandleList_clear()
	$windowList = WinList()
	For $windowNumber = 1 To $windowList[0][0]
		$windowIsAffected = False
		For $substringNumber = 1 To $affectedWindowNameSubstrings[0]
			If StringInStr($windowList[$windowNumber][0], $affectedWindowNameSubstrings[$substringNumber]) <> 0 Then
				$windowIsAffected = True
				ExitLoop
			EndIf
		Next
		If $windowIsAffected Then
			_ArrayAdd($windowHandleList, $windowList[$windowNumber][1])
			$windowHandleList[0] = $windowHandleList[0] + 1
		EndIf
	Next
EndFunc   ;==>windowHandleList_update

Func windowHandleList_hasWindows()
	Return $windowHandleList[0] <> 0
EndFunc   ;==>windowHandleList_hasWindows

Func windowHandleList_kill()
	For $i = 1 To $windowHandleList[0]
		WinKill($windowHandleList[$i])
	Next
EndFunc   ;==>windowHandleList_kill



;---------------------------------------------------------
;Mode functions

Func attemptNotificationWindow()
	If $notificationWindow_enabled Then
		MsgBox(0, $notificationWindow_title, $notificationWindow_message)
	EndIf
EndFunc   ;==>attemptNotificationWindow

Func main_callback()
	windowHandleList_update()
	If windowHandleList_hasWindows() Then
		attemptNotificationWindow()
		windowHandleList_kill()
	EndIf
EndFunc   ;==>main_callback


;Hotkey mode
Func hotkeyMode_callback()
	main_callback()
EndFunc   ;==>hotkeyMode_callback

Func hotkeyMode_init()
	If $hotkeyMode_enabled Then
		HotKeySet($hotkeyMode_character, "hotkeyMode_callback")
	EndIf
EndFunc   ;==>hotkeyMode_init


;Interrupt mode
Func interruptMode_callback()
	main_callback()
EndFunc   ;==>interruptMode_callback

Func interruptMode_init()
	If $interruptMode_enabled Then
		AdlibRegister("interruptMode_callback", $interruptMode_delayMsec)
	EndIf
EndFunc   ;==>interruptMode_init



;---------------------------------------------------------
;Main init

Func StrToBool($pStr)
	Return (StringLower($pStr) == "true") ? True : False
EndFunc   ;==>StrToBool

Const $attemptSetConfigValue_readModificationMode_str = 0
Const $attemptSetConfigValue_readModificationMode_int = 1
Const $attemptSetConfigValue_readModificationMode_bool = 2

Func attemptSetConfigValue(ByRef $rpGlobal, $pSectionName, $pKeyName, $pReadMofificationMode)
	$tmp = IniRead($config_filename, $pSectionName, $pKeyName, $config_failedKeyLoadValue)
	If $tmp <> $config_failedKeyLoadValue Then
		Switch $pReadMofificationMode
			Case $attemptSetConfigValue_readModificationMode_str
				$rpGlobal = $tmp
			Case $attemptSetConfigValue_readModificationMode_int
				$rpGlobal = Int($tmp)
			Case $attemptSetConfigValue_readModificationMode_bool
				$rpGlobal = StrToBool($tmp)
		EndSwitch
	EndIf
EndFunc   ;==>attemptSetConfigValue


Func attemptLoadConfig()
	If FileExists($config_filename) Then
		;attemptSetConfigValue for each global in $g_config_filename

	EndIf
EndFunc   ;==>attemptLoadConfig

Func init()
	windowHandleList_update()

	hotkeyMode_init()
	interruptMode_init()
EndFunc   ;==>init



;---------------------------------------------------------
;Main

Func main()
	init()
	While 1
		;Do nothing but sleep, infinite busy loop
		Sleep($main_busyLoopSleep_delayMsec)
	WEnd
EndFunc   ;==>main


;---------------------------------------------------------
;Entry point
main()








