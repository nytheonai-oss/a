' Simple VBS to open Notepad
Dim objShell
Set objShell = CreateObject("WScript.Shell")

objShell.Run "notepad.exe", 1, False

Set objShell = Nothing