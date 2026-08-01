#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%

CoordMode, Mouse, Screen

; ================== GUI ==================
; Чекбокс для закріплення вікна (спрацьовує одразу при натисканні через gToggleTop)
Gui, Add, CheckBox, vAlwaysOnTop gToggleTop, Закріпити поверх усіх вікон (Pin)
Gui, Add, CheckBox, vEnableKL Checked, Увімкнути хоткеї K (Down) та L (Up)

Gui, Add, Text, , Затримка Sleep (мс) для клавіші F:
; Number забороняє вводити букви у це поле, тільки цифри
Gui, Add, Edit, vSleepTime w100 Number, 100

Gui, Add, Text, cGray, `nГарячі клавіші:`nM = MouseMove | C = Click | F = Sleep

; hwndhMyEdit - зберігає ID текстбокса, щоб ми могли його автоматично скролити
Gui, Add, Edit, w300 h200 vMyEdit +VScroll hwndhMyEdit, 
Gui, Show,, Макро Рекордер
return

; ================== ЛОГІКА GUI ==================
; Функція для закріплення вікна
ToggleTop:
Gui, Submit, NoHide
if (AlwaysOnTop)
    Gui, +AlwaysOnTop
else
    Gui, -AlwaysOnTop
return

; ================== HOTKEYS ==================

; M = MouseMove
$m::
MouseGetPos, MouseX, MouseY
AppendStr := "MouseMove, " MouseX ", " MouseY
GoSub, AddTextToEdit
return

; C = Click
$c::
MouseGetPos, MouseX, MouseY
AppendStr := "Send {Click " MouseX ", " MouseY "}"
GoSub, AddTextToEdit
return

; F = Sleep
$f::
Gui, Submit, NoHide ; Беремо актуальне значення з поля Sleep
if (SleepTime == "")
    SleepTime := 100 ; Якщо поле порожнє, ставимо 100 за замовчуванням
AppendStr := "Sleep, " SleepTime
GoSub, AddTextToEdit
return

; K = LButton Down
$k::
Gui, Submit, NoHide
if (EnableKL) {
    AppendStr := "Send {LButton Down}"
    GoSub, AddTextToEdit
} else {
    Send k ; Якщо чекбокс вимкнено - просто друкує "k"
}
return

; L = LButton Up
$l::
Gui, Submit, NoHide
if (EnableKL) {
    AppendStr := "Send {LButton Up}"
    GoSub, AddTextToEdit
} else {
    Send l
}
return

; ================== ФУНКЦІЇ ==================

; Додавання тексту без затирання попереднього
AddTextToEdit:
GuiControlGet, CurrentText,, MyEdit
NewText := CurrentText ? CurrentText "`n" AppendStr : AppendStr
GuiControl,, MyEdit, %NewText%

; Автоматичний скрол донизу, щоб завжди бачити останній рядок
SendMessage, 0x0115, 7, 0,, ahk_id %hMyEdit% 
return

GuiClose:
ExitApp