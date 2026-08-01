Gui, Add, Text, x10 y10, Sleep (ms):
Gui, Add, Edit, x100 y10 w50 vSleepTime, 10

Gui, Add, Text, x10 y40, Active Tooltip:
Gui, Add, Edit, x100 y40 w200 vActiveTooltip, Activated

Gui, Add, Text, x10 y70, Tooltip Pos (X, Y):
Gui, Add, Edit, x100 y70 w100 vTooltipPos, 1476, 475
Gui, Add, Text, x210 y70, Number:
Gui, Add, Edit, x250 y70 w50 vTooltipNum, 2

Gui, Add, Text, x10 y100, Start Hotkey:
Gui, Add, Edit, x100 y100 w50 vStartKey, f
Gui, Add, DropDownList, x160 y100 w80 vStartMod, None||Ctrl|Shift|Alt|Win
Gui, Add, Button, x250 y100 w100 gResetStartHotkey, Reset to f

Gui, Add, Text, x10 y130, Search Range (X1,Y1,X2,Y2):
Gui, Add, Edit, x160 y130 w190 vSearchRange, 0, 0, 1919, 1079

Gui, Add, Text, x10 y160, Image File Name:
Gui, Add, Edit, x100 y160 w200 vFileName, knife

Gui, Add, Text, x10 y190, Color Match (0-255):
Gui, Add, Edit, x120 y190 w50 vVariation, 3

Gui, Add, Text, x10 y220, Action on Find:
Gui, Add, DropDownList, x100 y220 w80 vActionType, Send||Click
Gui, Add, Text, x190 y220, Key:
Gui, Add, Edit, x220 y220 w50 vSendKey, f

Gui, Add, Checkbox, x10 y250 vUseAhkFolder Checked, Use Ahk folder
Gui, Add, Checkbox, x150 y250 vFastMode Checked, SetMouseDelay`, 0 (Fast)
Gui, Add, Checkbox, x10 y280 vShowErrors Checked, Show ErrorLevel Tooltips
Gui, Add, Checkbox, x180 y280 vReturnMouse, Get Mouse back after Click
Gui, Add, Checkbox, x10 y310 vDebugBox, Debug: Show Search Box & Image Pos

Gui, Add, Text, x10 y340, Stop Hotkey:
Gui, Add, Edit, x100 y340 w50 vStopKey, g
Gui, Add, DropDownList, x160 y340 w80 vStopMod, None||Ctrl|Shift|Alt|Win
Gui, Add, Button, x250 y340 w100 gResetStopHotkey, Reset to g

Gui, Add, Text, x10 y370, Disabled Tooltip:
Gui, Add, Edit, x100 y370 w200 vDisabledTooltip, Disabled

Gui, Add, Button, x10 y400 w150 h30 gConvert, Convert

Gui, Add, Edit, x380 y10 w450 h380 vScriptOutput readonly
Gui, Add, Button, x380 y400 w150 h30 gCopyScript, Copy to Clipboard

Gui, Show, w850 h440, Image Search Script Generator Ultimate
return

ResetStartHotkey:
    GuiControl,, StartKey, f
    GuiControl, ChooseString, StartMod, None
return

ResetStopHotkey:
    GuiControl,, StopKey, g
    GuiControl, ChooseString, StopMod, None
return

Convert:
    Gui, Submit, NoHide
    
    ; Перевірка координат пошуку
    coords := StrSplit(SearchRange, ",")
    if (coords.MaxIndex() != 4) {
        MsgBox, Please enter four coordinates separated by commas.
        return
    }
    X1 := Trim(coords[1]), Y1 := Trim(coords[2])
    X2 := Trim(coords[3]), Y2 := Trim(coords[4])
    
    ; Перевірка координат тултипу
    tooltip_coords := StrSplit(TooltipPos, ",")
    if (tooltip_coords.MaxIndex() != 2) {
        MsgBox, Please enter two tooltip coordinates separated by commas.
        return
    }
    TooltipX := Trim(tooltip_coords[1]), TooltipY := Trim(tooltip_coords[2])
    
    ; Формування гарячих клавіш
    start_key := StartKey ? StartKey : "f"
    stop_key := StopKey ? StopKey : "g"
    start_mod := (StartMod = "Ctrl") ? "^" : (StartMod = "Shift") ? "+" : (StartMod = "Alt") ? "!" : (StartMod = "Win") ? "#" : ""
    stop_mod := (StopMod = "Ctrl") ? "^" : (StopMod = "Shift") ? "+" : (StopMod = "Alt") ? "!" : (StopMod = "Win") ? "#" : ""
    start_hotkey := "$" . start_mod . start_key
    stop_hotkey := stop_mod . stop_key
    
    ; Шлях до файлу
    file_path := UseAhkFolder ? "C:\Users\Адмін\Desktop\Ank\" . FileName . ".png" : "C:\Users\Адмін\Desktop\" . FileName . ".png"
    StringLower, safe_key, SendKey
    
    ; ==== ГЕНЕРАЦІЯ СКРИПТУ ====
    script := "; Згенеровано автоматично`n"
    script .= "CoordMode, Mouse, Screen`n"
    script .= "CoordMode, Pixel, Screen`n"
    script .= "CoordMode, Tooltip, Screen`n"
    
    if (FastMode)
        script .= "SetMouseDelay, 0`n"
        
    script .= "loopActive := false`n"
    
    if (DebugBox) {
        script .= "`n; --- Debug Box Setup ---`n"
        script .= "boxW := " X2 " - " X1 "`n"
        script .= "boxH := " Y2 " - " Y1 "`n"
        script .= "Gui, Dbg1:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20`nGui, Dbg1:Color, Red`n"
        script .= "Gui, Dbg2:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20`nGui, Dbg2:Color, Red`n"
        script .= "Gui, Dbg3:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20`nGui, Dbg3:Color, Red`n"
        script .= "Gui, Dbg4:New, +AlwaysOnTop +ToolWindow -Caption +E0x08000000 +E0x20`nGui, Dbg4:Color, Red`n"
        script .= "; -----------------------`n"
    }

    script .= "`n" start_hotkey "::`n"
    script .= "    Tooltip, " ActiveTooltip ", " TooltipX ", " TooltipY ", " TooltipNum "`n"
    script .= "    if (loopActive) {`n"
    script .= "        loopActive := false`n"
    script .= "    } else {`n"
    script .= "        loopActive := true`n"
    
    if (DebugBox) {
        script .= "        Gui, Dbg1:Show, x" X1 " y" Y1 " w%boxW% h2 NoActivate`n"
        script .= "        Gui, Dbg2:Show, x" X1 " y" Y2 " w%boxW% h2 NoActivate`n"
        script .= "        Gui, Dbg3:Show, x" X1 " y" Y1 " w2 h%boxH% NoActivate`n"
        script .= "        Gui, Dbg4:Show, x" X2 " y" Y1 " w2 h%boxH% NoActivate`n"
    }
    
    script .= "        Loop {`n"
    script .= "            Sleep, " SleepTime "`n"
    script .= "            ImageSearch, OutputVarX, OutputVarY, " X1 ", " Y1 ", " X2 ", " Y2 ", *" Variation " " file_path "`n"
    script .= "            if (ErrorLevel = 0) {`n"
    
    if (ShowErrors)
        script .= "                Tooltip, 0: Знайдено!, " TooltipX ", " (TooltipY + 25) ", " (TooltipNum + 1) "`n"
    if (DebugBox)
        script .= "                Tooltip, IMAGE HERE, %OutputVarX%, %OutputVarY%, 4`n"
        
    if (ActionType = "Send") {
        script .= "                Send {" safe_key "}`n"
    } else {
        if (ReturnMouse) {
            script .= "                MouseGetPos, savedX, savedY`n"
            script .= "                Click %OutputVarX%, %OutputVarY%`n"
            script .= "                MouseMove, %savedX%, %savedY%, 0`n"
        } else {
            script .= "                Click %OutputVarX%, %OutputVarY%`n"
        }
    }
    script .= "            }`n"
    
    if (ShowErrors) {
        script .= "            else if (ErrorLevel = 1)`n"
        script .= "                Tooltip, 1: Немає на екрані, " TooltipX ", " (TooltipY + 25) ", " (TooltipNum + 1) "`n"
        script .= "            else if (ErrorLevel = 2)`n"
        script .= "                Tooltip, 2: Помилка файлу, " TooltipX ", " (TooltipY + 25) ", " (TooltipNum + 1) "`n"
    }
    
    script .= "            if (!loopActive) {`n"
    if (ShowErrors)
        script .= "                Tooltip, , , , " (TooltipNum + 1) "`n"
    if (DebugBox)
        script .= "                Tooltip, , , , 4`n"
    script .= "                break`n"
    script .= "            }`n"
    script .= "        }`n"
    script .= "    }`n"
    script .= "return`n`n"
    
    script .= stop_hotkey "::`n"
    script .= "    loopActive := false`n"
    script .= "    Tooltip, " DisabledTooltip ", " TooltipX ", " TooltipY ", " TooltipNum "`n"
    if (ShowErrors)
        script .= "    Tooltip, , , , " (TooltipNum + 1) "`n"
    if (DebugBox) {
        script .= "    Gui, Dbg1:Hide`n    Gui, Dbg2:Hide`n    Gui, Dbg3:Hide`n    Gui, Dbg4:Hide`n"
        script .= "    Tooltip, , , , 4`n"
    }
    script .= "return`n`n"
    
    script .= "NumpadEnter::Suspend`n"

    GuiControl,, ScriptOutput, %script%
return

CopyScript:
    GuiControlGet, script_text,, ScriptOutput
    Clipboard := script_text
    MsgBox, Script copied to clipboard!
return

GuiClose:
    ExitApp
return