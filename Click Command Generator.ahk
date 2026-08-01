#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%

; Set coordinate mode to screen to use desktop coordinates
CoordMode, Mouse, Screen

; Create GUI
Gui, Add, Edit, w300 h200 vMyEdit, 
Gui, Show,, Click Command Generator

; Hotkey for F key
f::
MouseGetPos, MouseX, MouseY
Gui, Submit, NoHide
GuiControlGet, CurrentText,, MyEdit
NewText := CurrentText ? CurrentText "`nSend {Click " MouseX ", " MouseY "}" : "Send {Click " MouseX ", " MouseY "}"
GuiControl,, MyEdit, %NewText%
return

GuiClose:
ExitApp