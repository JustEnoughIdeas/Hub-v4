#Requires AutoHotkey v2.0

; Текст, який ти хочеш скопіювати (у лапках)
textToCopy := "
(
MouseGetPos, savedX, savedY
Send {Click 163, 451}
MouseMove, %savedX%, %savedY%, 0
)"

; Присвоюємо текст буферу
A_Clipboard := textToCopy

ExitApp