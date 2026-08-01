Gui, Add, Text, x10 y10, Sleep (ms):
Gui, Add, Edit, x100 y10 w50 vSleepTime, 10
Gui, Add, Text, x10 y40, Active Tooltip:
Gui, Add, Edit, x100 y40 w200 vActiveTooltip, Activated
Gui, Add, Text, x10 y70, Tooltip Pos (X, Y):
Gui, Add, Edit, x100 y70 w100 vTooltipPos, 1476, 475
Gui, Add, Text, x210 y70, Number:
Gui, Add, Edit, x250 y70 w50 vTooltipNum, 2
Gui, Add, Text, x10 y100, Start Hotkey:
Gui, Add, Edit, x100 y100 w50 vStartKey, F
Gui, Add, DropDownList, x160 y100 w80 vStartMod, None||Ctrl|Shift|Alt|Win
Gui, Add, Button, x250 y100 w100 gResetStartHotkey, Reset to F
Gui, Add, Text, x10 y130, Search Range (X1, Y1, X2, Y2):
Gui, Add, Edit, x150 y130 w200 vSearchRange, 0, 0, 1919, 1079
Gui, Add, Text, x10 y160, Image File Name:
Gui, Add, Edit, x100 y160 w200 vFileName, cookie
Gui, Add, Checkbox, x10 y190 vUseAhkFolder, Use Ahk folder
Gui, Add, Checkbox, x10 y220 vFastMode, Fast mode (SetMouseDelay`, 0)
Gui, Add, Text, x10 y250, Stop Hotkey:
Gui, Add, Edit, x100 y250 w50 vStopKey, G
Gui, Add, DropDownList, x160 y250 w80 vStopMod, None||Ctrl|Shift|Alt|Win
Gui, Add, Button, x250 y250 w100 gResetStopHotkey, Reset to G
Gui, Add, Text, x10 y280, Disabled Tooltip:
Gui, Add, Edit, x100 y280 w200 vDisabledTooltip, Disabled
Gui, Add, Button, x10 y310 w100 gConvert, Convert
Gui, Add, Edit, x400 y10 w400 h300 vScriptOutput readonly
Gui, Add, Button, x400 y320 w100 gCopyScript, Copy to Clipboard
Gui, Show, w800 h350, Image Search Script Generator
return

ResetStartHotkey:
    GuiControl,, StartKey, F
    GuiControl, ChooseString, StartMod, None
return

ResetStopHotkey:
    GuiControl,, StopKey, G
    GuiControl, ChooseString, StopMod, None
return

Convert:
    Gui, Submit, NoHide
    ; Parse search range
    coords := StrSplit(SearchRange, ",")
    if (coords.MaxIndex() != 4)
    {
        MsgBox, Please enter four coordinates separated by commas.
        return
    }
    X1 := Trim(coords[1])
    Y1 := Trim(coords[2])
    X2 := Trim(coords[3])
    Y2 := Trim(coords[4])
    ; Parse tooltip position
    tooltip_coords := StrSplit(TooltipPos, ",")
    if (tooltip_coords.MaxIndex() != 2)
    {
        MsgBox, Please enter two tooltip coordinates separated by commas.
        return
    }
    TooltipX := Trim(tooltip_coords[1])
    TooltipY := Trim(tooltip_coords[2])
    ; Hotkeys
    start_key := StartKey ? StartKey : "F"
    stop_key := StopKey ? StopKey : "G"
    start_mod := ""
    if (StartMod = "Ctrl")
        start_mod := "^"
    else if (StartMod = "Shift")
        start_mod := "+"
    else if (StartMod = "Alt")
        start_mod := "!"
    else if (StartMod = "Win")
        start_mod := "#"
    stop_mod := ""
    if (StopMod = "Ctrl")
        stop_mod := "^"
    else if (StopMod = "Shift")
        stop_mod := "+"
    else if (StopMod = "Alt")
        stop_mod := "!"
    else if (StopMod = "Win")
        stop_mod := "#"
    start_hotkey := start_mod . start_key
    stop_hotkey := stop_mod . stop_key
    ; File path with single backslashes
    if (UseAhkFolder)
        file_path := "C:\Users\Адмін\Desktop\Ahk\" . FileName . ".png"
    else
        file_path := "C:\Users\Адмін\Desktop\" . FileName . ".png"
    ; Generate script
    script := "; WARNING: Single backslashes are used below. Replace \ with \\ or use raw string (`r) for AHK compatibility.`n"
    script .= "CoordMode, Mouse, Screen`n"
    script .= "loopActive := false`n`n"
    script .= start_hotkey . "::`n"
    if (FastMode)
        script .= "    SetMouseDelay, 0`n"
    script .= "    Tooltip, " . ActiveTooltip . ", " . TooltipX . ", " . TooltipY . ", " . TooltipNum . "`n"
    script .= "    if (loopActive)`n"
    script .= "    {`n"
    script .= "        loopActive := false`n"
    script .= "    }`n"
    script .= "    else`n"
    script .= "    {`n"
    script .= "        loopActive := true`n"
    script .= "        Loop`n"
    script .= "        {`n"
    script .= "            Sleep, " . SleepTime . "`n"
    script .= "            ImageSearch, OutputVarX, OutputVarY, " . X1 . ", " . Y1 . ", " . X2 . ", " . Y2 . ", " . file_path . "`n"
    script .= "            If ErrorLevel = 0`n"
    script .= "            {`n"
    script .= "                Click %OutputVarX%, %OutputVarY%`n"
    script .= "            }`n"
    script .= "            if (!loopActive)`n"
    script .= "                break`n"
    script .= "        }`n"
    script .= "    }`n"
    script .= "return`n`n"
    script .= stop_hotkey . "::`n"
    script .= "    loopActive := false`n"
    script .= "    Tooltip, " . DisabledTooltip . ", " . TooltipX . ", " . TooltipY . ", " . TooltipNum . "`n"
    script .= "return`n"
    GuiControl,, ScriptOutput, %script%
return

CopyScript:
    GuiControlGet, script_text,, ScriptOutput
    Clipboard := script_text
    MsgBox, Script copied to clipboard.
return

GuiClose:
    ExitApp
return