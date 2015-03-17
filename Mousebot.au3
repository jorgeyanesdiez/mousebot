#include <GUIConstantsEx.au3>

; Global variables
Dim $isActive = 0
Dim $delaySeconds = 10
Dim $windowMain
Dim $labelDelay
Dim $inputDelay
Dim $buttonStart
Dim $buttonStop
Dim $trayOptionExit
Dim $trayOptionRestore

; Run the main function
Main()

; Program functions
Func Main()
  Setup()
  CreateGui()
  ShowGui()
  While 1
    If $isActive == 1 Then
      SimulateActivity()
      Sleep($delaySeconds * 1000)
    EndIf
  WEnd
EndFunc

Func Setup()
  Opt("GUIOnEventMode", 1)
  Opt("TrayAutoPause", 0)
  Opt("TrayIconHide", 0)
  Opt("TrayMenuMode", 3)
  Opt("TrayOnEventMode", 1)
  Opt("WinTitleMatchMode", -3)
EndFunc

Func CreateGui()
  $windowMain = GUICreate("Mousebot", 200, 80)
  $labelDelay = GUICtrlCreateLabel("Delay (seconds):", 10, 10, 100, 20)
  $inputDelay = GUICtrlCreateInput(String($delaySeconds), 100, 07, 40, 20)
  $buttonStart = GUICtrlCreateButton("Start", 33, 35, 65, 30)
  $buttonStop = GUICtrlCreateButton("Stop", 103, 35, 65, 30)
  $trayOptionRestore = TrayCreateItem("Restore")
  $trayOptionExit = TrayCreateItem("Exit")
  GUICtrlSetState($buttonStop, $GUI_DISABLE)
  GUISetOnEvent($GUI_EVENT_CLOSE, "OnCloseEvent")
  GUISetOnEvent($GUI_EVENT_MINIMIZE, "OnMinimizeEvent")
  GUICtrlSetOnEvent($buttonStart, "OnStartEvent")
  GUICtrlSetOnEvent($buttonStop, "OnStopEvent")
  TrayItemSetOnEvent($trayOptionExit, "OnCloseEvent")
  TrayItemSetOnEvent($trayOptionRestore, "OnTrayRestoreEvent")
EndFunc

Func ShowGui()
  GUISetState(@SW_SHOW, $windowMain)
EndFunc

Func HideGui()
  GUISetState(@SW_HIDE, $windowMain)
EndFunc

Func ApplyDelayFromGui()
  $delaySeconds = Int(GUICtrlRead($inputDelay))
  If $delaySeconds <= 0 Then
    $delaySeconds = 1
  EndIf
EndFunc

Func OnCloseEvent()
  Exit
EndFunc

Func OnMinimizeEvent()
  HideGui()
EndFunc

Func OnStartEvent()
  GUICtrlSetState($inputDelay, $GUI_DISABLE)
  GUICtrlSetState($buttonStart, $GUI_DISABLE)
  GUICtrlSetState($buttonStop, $GUI_ENABLE)
  ApplyDelayFromGui()
  $isActive = 1
EndFunc

Func OnStopEvent()
  GUICtrlSetState($inputDelay, $GUI_ENABLE)
  GUICtrlSetState($buttonStart, $GUI_ENABLE)
  GUICtrlSetState($buttonStop, $GUI_DISABLE)
  $isActive = 0
EndFunc

Func OnTrayRestoreEvent()
  ShowGui()
  GUISetState(@SW_RESTORE, $windowMain)
  WinActivate($windowMain)
EndFunc

Func SimulateActivity()
  MouseMove(MouseGetPos(0)+100, MouseGetPos(1)+100)
  MouseMove(MouseGetPos(0)-100, MouseGetPos(1)-100)
EndFunc
