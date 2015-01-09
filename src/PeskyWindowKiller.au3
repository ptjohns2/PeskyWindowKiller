#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=..\bin\PeskyWindowKiller_x86.exe
#AutoIt3Wrapper_Outfile_x64=..\bin\PeskyWindowKiller_x64.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


;---------------------------------------------------------
;Build option directives



;---------------------------------------------------------
;Includes

#include <Array.au3>



;---------------------------------------------------------
;Config

Const $config_filename = "PeskyWindowKiller.ini"
;Const $config_failedKeyLoadValue = "__RESERVED__PeskyWindowKiller_config_failedKeyLoadValue"
Const $config_failedKeyLoadValue = ""

Global $hotkeyMode_enabled = True
Global $hotkeyMode_character = "["

Global $interruptMode_enabled = False
Global $interruptMode_delayMsec = 5000

Global $notificationWindow_enabled = False
Global $notificationWindow_title = "Notification window title"
Global $notificationWindow_message = "Notification window message"

Global $main_busyLoopSleep_delayMsec = 100

Global $affectedWindowNameSubstrings[2] = [1, "testwindowname"]



;---------------------------------------------------------
;Globals

Global $affectedWindowHandleList[1] = [0]



;---------------------------------------------------------
;Helper functions

Func affectedWindowHandleList_clear()
	ReDim $affectedWindowHandleList[1]
	$affectedWindowHandleList[0] = 0
EndFunc   ;==>affectedWindowHandleList_clear

Func affectedWindowHandleList_update()
	affectedWindowHandleList_clear()
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
			_ArrayAdd($affectedWindowHandleList, $windowList[$windowNumber][1])
			$affectedWindowHandleList[0] = $affectedWindowHandleList[0] + 1
		EndIf
	Next
EndFunc   ;==>affectedWindowHandleList_update

Func affectedWindowHandleList_hasWindows()
	Return $affectedWindowHandleList[0] <> 0
EndFunc   ;==>affectedWindowHandleList_hasWindows

Func affectedWindowHandleList_kill()
	For $i = 1 To $affectedWindowHandleList[0]
		WinKill($affectedWindowHandleList[$i])
	Next
EndFunc   ;==>affectedWindowHandleList_kill



;---------------------------------------------------------
;Mode functions

Func attemptNotificationWindow()
	If $notificationWindow_enabled Then
		MsgBox(0, $notificationWindow_title, $notificationWindow_message)
	EndIf
EndFunc   ;==>attemptNotificationWindow

Func main_callback()
	affectedWindowHandleList_update()
	If affectedWindowHandleList_hasWindows() Then
		affectedWindowHandleList_kill()
		attemptNotificationWindow()
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
	If StringLower($pStr) == "true" Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>StrToBool

Func printConfigValues()
	ConsoleWrite("hotkeyMode_enabled = " & $hotkeyMode_enabled & @CRLF)
	ConsoleWrite("hotkeyMode_character = " & $hotkeyMode_character & @CRLF)

	ConsoleWrite("interruptMode_enabled = " & $interruptMode_enabled & @CRLF)
	ConsoleWrite("interruptMode_delayMsec = " & $interruptMode_delayMsec & @CRLF)

	ConsoleWrite("notificationWindow_enabled = " & $notificationWindow_enabled & @CRLF)
	ConsoleWrite("notificationWindow_title = " & $notificationWindow_title & @CRLF)
	ConsoleWrite("notificationWindow_message = " & $notificationWindow_message & @CRLF)

	ConsoleWrite("main_busyLoopSleep_delayMsec = " & $main_busyLoopSleep_delayMsec & @CRLF)

	;Print all substrings
	For $substringNumber = 1 To $affectedWindowNameSubstrings[0]
		ConsoleWrite("affectedWindowNameSubstrings[ " & $substringNumber & " ] = " & $affectedWindowNameSubstrings[$substringNumber] & @CRLF)
	Next

EndFunc   ;==>printConfigValues


Const $attemptSetConfigValue_readModificationMode_str = 0
Const $attemptSetConfigValue_readModificationMode_int = 1
Const $attemptSetConfigValue_readModificationMode_bool = 2

Func attemptLoadConfigValue(ByRef $rpGlobal, $pSectionName, $pKeyName, $pReadMofificationMode)
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
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>attemptLoadConfigValue


Func attemptLoadConfigFile()
	If FileExists($config_filename) Then
		;attemptLoadConfigValue for each global in $config_filename
		attemptLoadConfigValue($hotkeyMode_enabled, "config", "hotkeyMode_enabled", $attemptSetConfigValue_readModificationMode_bool)
		attemptLoadConfigValue($hotkeyMode_character, "config", "hotkeyMode_character", $attemptSetConfigValue_readModificationMode_str)

		attemptLoadConfigValue($interruptMode_enabled, "config", "interruptMode_enabled", $attemptSetConfigValue_readModificationMode_bool)
		attemptLoadConfigValue($interruptMode_delayMsec, "config", "interruptMode_delayMsec", $attemptSetConfigValue_readModificationMode_int)

		attemptLoadConfigValue($notificationWindow_enabled, "config", "notificationWindow_enabled", $attemptSetConfigValue_readModificationMode_bool)
		attemptLoadConfigValue($notificationWindow_title, "config", "notificationWindow_title", $attemptSetConfigValue_readModificationMode_str)
		attemptLoadConfigValue($notificationWindow_message, "config", "notificationWindow_message", $attemptSetConfigValue_readModificationMode_str)

		attemptLoadConfigValue($main_busyLoopSleep_delayMsec, "config", "main_busyLoopSleep_delayMsec", $attemptSetConfigValue_readModificationMode_int)

		;attemptLoadConfigValue for strings "1", "2" up to infinity until one is not loaded (end of list)
		$i = 1
		$tmpSubstringValue = ""
		$indexLoaded = True
		ReDim $affectedWindowNameSubstrings[1]
		$affectedWindowNameSubstrings[0] = 0
		While $indexLoaded
			If attemptLoadConfigValue($tmpSubstringValue, "substrings", String($i), $attemptSetConfigValue_readModificationMode_str) Then
				_ArrayAdd($affectedWindowNameSubstrings, $tmpSubstringValue)
				$affectedWindowNameSubstrings[0] = $affectedWindowNameSubstrings[0] + 1
				$indexLoaded = True
				$i = $i + 1
			Else
				$indexLoaded = False
			EndIf
		WEnd

	EndIf
EndFunc   ;==>attemptLoadConfigFile

Func init()
	affectedWindowHandleList_update()

	hotkeyMode_init()
	interruptMode_init()
EndFunc   ;==>init



;---------------------------------------------------------
;Main

Func main()
	init()

	attemptLoadConfigFile()
	printConfigValues()

	While 1
		;Do nothing but sleep, infinite busy loop
		Sleep($main_busyLoopSleep_delayMsec)
	WEnd
EndFunc   ;==>main



;---------------------------------------------------------
;Entry point

main()








