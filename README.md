# PeskyWindowKiller   
Instantly kill all windows with names containing specified substrings.  Handy script   
   
Can be set to activate upon...   
-Hotkey (ex. Hit '[' to exit all windows with substring specified in array)   
-Periodic interrupt (ex. Every 10 seconds close the affected windows)   

Configurable via PeskyWindowKiller.ini located in same directory as specified:

'''ini
[config]

;Enable or disables hotkey mode.  Kills affected windows when you press your desired character specified below.  Right now it's the lbrack '['
hotkeyMode_enabled=false
hotkeyMode_character=[

;Enables or disables interrupt mode.  Kills affected windows periodically, every x number of milliseconds specified below
interruptMode_enabled=true
interruptMode_delayMsec=1000

;Enables or disables displaying a notification window when anything is killed.  Choose desired window title and message below
notificationWindow_enabled=false
notificationWindow_title=Notification window default title
notificationWindow_message=Notification window default message


[substrings]

;write your substrings below here like...

;1=chrome
;2=firefox
;3=skype

;...and all chrome, firefox, and skype windows will be closed.  Matches any text in window titles, process names, etc.  For example (this will close firefox):

1=firefox
'''

Ran as invisible background process.  Close via *taskkill /im PeskyWindowKiller.exe -f*, or task manager.