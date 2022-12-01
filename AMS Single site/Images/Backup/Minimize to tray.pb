Structure NOTIFYICONDATA_v6
cbSize.l
hWnd.l
uID.l
uFlags.l
uCallbackMessage.l
hIcon.l
szTip.s{128}
dwState.l
dwStateMask.l
szInfo.s{256}
StructureUnion
  uTimeout.l
  uVersion.l
EndStructureUnion
szInfoTitle.s{64}
dwInfoFlags.l
guidItem.GUID
EndStructure

Procedure.i WindowShowBalloonTip(window.i,systrayicon.i,title$,content$,timeout.l)
Protected result.i=#False,balloon.NOTIFYICONDATA_v6
If OSVersion()>=#PB_OS_Windows_2000
  If IsSysTrayIcon(systrayicon)
   balloon\hWnd=WindowID(window)
   balloon\uID=systrayicon
   balloon\uFlags=#NIF_INFO
   balloon\dwState=#NIS_SHAREDICON
   balloon\szInfoTitle=title$
   balloon\szInfo=content$
   balloon\uTimeout=timeout
   balloon\dwInfoFlags=#NIIF_NOSOUND
   balloon\cbSize=SizeOf(NOTIFYICONDATA_v6)
   result=Shell_NotifyIcon_(#NIM_MODIFY,balloon)
  EndIf
EndIf
ProcedureReturn result
EndProcedure


Procedure WinCallback(hwnd, uMsg, wParam, lParam) 
  
  If uMsg = #WM_SIZE 
    Select wParam 
      Case #SIZE_MINIMIZED 
        ShowWindow_(WindowID(0),#SW_HIDE)
      Case #SIZE_RESTORED 
        
      Case #SIZE_MAXIMIZED 
        
    EndSelect 
  EndIf 
  
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 


If OpenWindow(0, 100, 150, 300, 100, "PureBasic - SysTray Example", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
  SetWindowCallback(@WinCallback(),0)
  AddSysTrayIcon(0, WindowID(0), LoadImage(0, "AniCAM_Mini_T.ico"))
  SysTrayIconToolTip(0, "Icon 1")
  WindowShowBalloonTip(0,0,"Hello","Imported from Anilox QC",3000)
  
  If CreatePopupMenu(0)
    MenuItem(1, "Restore")
  EndIf
  
  Repeat
    Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_SysTray
        If EventType() = #PB_EventType_RightClick
          If IsIconic_(WindowID(0))
            DisplayPopupMenu(0, WindowID(0))
          EndIf 
        EndIf
        
      Case #PB_Event_Menu
        Select EventMenu()  
          Case 1
            ShowWindow_(WindowID(0),#SW_MINIMIZE)
            Delay(250)
            ShowWindow_(WindowID(0),#SW_RESTORE)
        EndSelect 
        
    EndSelect 
  Until Event = #PB_Event_CloseWindow
EndIf 
; IDE Options = PureBasic 4.60 RC 1 (Windows - x86)
; CursorPosition = 79
; FirstLine = 47
; Folding = -
; EnableXP