; [Filename]: Mouse Cords 3.0.ahk
CoordMode, Mouse, Screen
togglearrows := 1

; Set coordinate modes to screen for both mouse and tooltips
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen

Tooltip %A_ScreenHeight%, 0, 0, 8
Tooltip, %A_ScreenWidth%, %A_ScreenWidth%, %A_ScreenHeight%, 9

SetTimer, Check, 20
return

F::
    MouseGetPos, xx1, yy1
    Tooltip X: ←- %xx1% →+ `, Y: ↓+ %yy1% ↑-, %MouseX%, %MouseY%, 2
    A_Clipboard := xx1 . ", " . yy1
return

+F::
    MouseGetPos, xx1, yy1
    Tooltip X: ←- %xx1% →+ `, Y: ↓+ %yy1% ↑-, %MouseX%, %MouseY%, 2
    if (xx2 != "" && yy2 != "") {
        A_Clipboard := xx1 . ", " . yy1 . ", " . xx2 . ", " . yy2
    } else {
        A_Clipboard := xx1 . ", " . yy1
    }
return

G::
    MouseGetPos, xx2, yy2
    Tooltip X: ←- %xx2% →+ `, Y: ↓+ %yy2% ↑-, %MouseX%, %MouseY%, 3
    A_Clipboard := xx2 . ", " . yy2
return


C::
    ToolTip , , , , 3
    ToolTip , , , , 2
return

Check:
    MouseGetPos, xx1, yy1
    Tooltip X: ←- %xx1% →+ `, Y: ↓+ %yy1% ↑-
return

T::
    SetTimer, Check, Off
    Tooltip
return

R::
    SetTimer, Check, 20
return

Esc::ExitApp