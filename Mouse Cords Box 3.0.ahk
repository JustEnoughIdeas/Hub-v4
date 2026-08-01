#SingleInstance force
CoordMode, Mouse, Screen
SetWinDelay, -1
DllCall("SetThreadDpiAwarenessContext", "ptr", -3)  ; Handle DPI scaling

state := 0  ; 0 = idle, 1 = first dot set, 2 = frozen

; Create four GUI dots
Gui, 1:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20
Gui, 1:Color, Red
Gui, 1:Show, x0 y0 w10 h10 NoActivate Hide
Gui, 1:+HwndGui1Hwnd
WinSet, Transparent, 192, ahk_id %Gui1Hwnd%

Gui, 2:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20
Gui, 2:Color, Blue
Gui, 2:Show, x0 y0 w10 h10 NoActivate Hide
Gui, 2:+HwndGui2Hwnd
WinSet, Transparent, 192, ahk_id %Gui2Hwnd%

Gui, 3:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20
Gui, 3:Color, Green
Gui, 3:Show, x0 y0 w10 h10 NoActivate Hide
Gui, 3:+HwndGui3Hwnd
WinSet, Transparent, 192, ahk_id %Gui3Hwnd%

Gui, 4:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20
Gui, 4:Color, Yellow
Gui, 4:Show, x0 y0 w10 h10 NoActivate Hide
Gui, 4:+HwndGui4Hwnd
WinSet, Transparent, 192, ahk_id %Gui4Hwnd%

; Create four GUI lines
Gui, 5:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20
Gui, 5:Color, Red
Gui, 5:Show, x0 y0 w1 h1 NoActivate Hide
Gui, 5:+HwndGui5Hwnd
WinSet, Transparent, 192, ahk_id %Gui5Hwnd%

Gui, 6:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20
Gui, 6:Color, Green
Gui, 6:Show, x0 y0 w1 h1 NoActivate Hide
Gui, 6:+HwndGui6Hwnd
WinSet, Transparent, 192, ahk_id %Gui6Hwnd%

Gui, 7:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20
Gui, 7:Color, Blue
Gui, 7:Show, x0 y0 w1 h1 NoActivate Hide
Gui, 7:+HwndGui7Hwnd
WinSet, Transparent, 192, ahk_id %Gui7Hwnd%

Gui, 8:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20
Gui, 8:Color, Yellow
Gui, 8:Show, x0 y0 w1 h1 NoActivate Hide
Gui, 8:+HwndGui8Hwnd
WinSet, Transparent, 192, ahk_id %Gui8Hwnd%

return

F::
    if (state = 0 or state = 2) {
        ; Reset: Hide all dots and lines
        Gui, 1:Hide
        Gui, 2:Hide
        Gui, 3:Hide
        Gui, 4:Hide
        Gui, 5:Hide
        Gui, 6:Hide
        Gui, 7:Hide
        Gui, 8:Hide
        ; Set first dot
        MouseGetPos, x1, y1
        dot_x1 := x1 - 5
        dot_y1 := y1 - 5
        Gui, 1:Show, x%dot_x1% y%dot_y1% w10 h10 NoActivate
        state := 1
        SetTimer, UpdateDots, 10
    } else if (state = 1) {
        ; Freeze dots and lines
        SetTimer, UpdateDots, Off
        MouseGetPos, x2, y2
        A_Clipboard := x1 . ", " . y1 . ", " . x2 . ", " . y2
        ToolTip, Copied: %x1%,%y1%,%x2%,%y2%, 100, 100
        SetTimer, RemoveToolTip, -2000
        state := 2
    }
return

UpdateDots:
    MouseGetPos, x2, y2
    ; Update dots
    dot_x2 := x2 - 5
    dot_y2 := y2 - 5
    dot_y1 := y1 - 5
    dot_x1 := x1 - 5
    Gui, 2:Show, x%dot_x2% y%dot_y2% w10 h10 NoActivate
    Gui, 3:Show, x%dot_x2% y%dot_y1% w10 h10 NoActivate
    Gui, 4:Show, x%dot_x1% y%dot_y2% w10 h10 NoActivate
    ; Update lines to touch dot edges
    ; Red line: red dot (x1,y1) to green dot (x2,y1), horizontal
    if (x1 < x2) {
        line_x := x1 + 5  ; Right edge of red dot
        line_w := x2 - x1 - 10  ; Left edge of green dot
    } else {
        line_x := x2 + 5  ; Right edge of green dot
        line_w := x1 - x2 - 10  ; Left edge of red dot
    }
    Gui, 5:Show, x%line_x% y%y1% w%line_w% h2 NoActivate
    ; Green line: green dot (x2,y1) to blue dot (x2,y2), vertical
    if (y1 < y2) {
        line_y := y1 + 5  ; Bottom edge of green dot
        line_h := y2 - y1 - 10  ; Top edge of blue dot
    } else {
        line_y := y2 + 5  ; Bottom edge of blue dot
        line_h := y1 - y2 - 10  ; Top edge of green dot
    }
    Gui, 6:Show, x%x2% y%line_y% w2 h%line_h% NoActivate
    ; Blue line: blue dot (x2,y2) to yellow dot (x1,y2), horizontal
    if (x2 > x1) {
        line_x := x1 + 5  ; Right edge of yellow dot
        line_w := x2 - x1 - 10  ; Left edge of blue dot
    } else {
        line_x := x2 + 5  ; Right edge of blue dot
        line_w := x1 - x2 - 10  ; Left edge of yellow dot
    }
    Gui, 7:Show, x%line_x% y%y2% w%line_w% h2 NoActivate
    ; Yellow line: yellow dot (x1,y2) to red dot (x1,y1), vertical
    if (y2 > y1) {
        line_y := y1 + 5  ; Bottom edge of red dot
        line_h := y2 - y1 - 10  ; Top edge of yellow dot
    } else {
        line_y := y2 + 5  ; Bottom edge of yellow dot
        line_h := y1 - y2 - 10  ; Top edge of red dot
    }
    Gui, 8:Show, x%x1% y%line_y% w2 h%line_h% NoActivate
return

RemoveToolTip:
    ToolTip
return

C::
    Gui, 1:Hide
    Gui, 2:Hide
    Gui, 3:Hide
    Gui, 4:Hide
    Gui, 5:Hide
    Gui, 6:Hide
    Gui, 7:Hide
    Gui, 8:Hide
    SetTimer, UpdateDots, Off
    ToolTip
    state := 0
return

Esc::ExitApp