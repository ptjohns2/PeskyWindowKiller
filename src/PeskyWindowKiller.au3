;---------------------------------------------------------
;Build option directives

#NoTrayIcon

#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Change2CUI=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****


;---------------------------------------------------------
;Includes

#include <Array.au3>



;---------------------------------------------------------
;Constants

Const $hotkeyMode_enabled = False
Const $hotkeyMode_character = "["


Const $interruptMode_enabled = False
Const $interruptMode_delayMsec = 5 * 1000


Const $notificationWindow_enabled = False
Const $notificationWindow_title = "Notification window title"
Const $notificationWindow_message = "Notification window message"

Const $affectedWindowNameSubstrings[2] = [1, "testwindowname"]



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
;Main functions

;Hotkey mode
Func hotkeyMode_callback()

EndFunc   ;==>hotkeyMode_callback

Func hotkeyMode_init()
	If $hotkeyMode_enabled Then
		HotKeySet($hotkeyMode_character, hotkeymode_callback)
	EndIf
EndFunc   ;==>hotkeyMode_init


;Interrupt mode
Func interruptMode_callback()
	If $interruptMode_enabled Then
		AdlibRegister(interruptMode_callback, $interruptMode_delayMsec)
	EndIf
EndFunc   ;==>interruptMode_callback

Func interruptMode_init()

EndFunc   ;==>interruptMode_init


;Main
Func init()
	windowHandleList_update()

	hotkeyMode_init()
	interruptMode_init()
EndFunc   ;==>init

Func main()
	init()

	windowHandleList_kill()

EndFunc   ;==>main


;---------------------------------------------------------
;Entry point
main()







