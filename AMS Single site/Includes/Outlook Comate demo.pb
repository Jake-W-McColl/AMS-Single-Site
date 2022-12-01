XIncludeFile "COMateplus_Residents.pbi"
XIncludeFile "COMateplus.pbi"
XIncludeFile "ExcelConstants.pbi"
XIncludeFile "ExcelFunctions.pbi"

Global Sound_Available = InitSound()

Enumeration
  #Gad_MainText
  #Gad_Hide
  #Gad_Audionag
EndEnumeration

Procedure.i CountUnreadSupportEmails()
  Protected ObjOutlook.COMateObject, ObjnSpace.COMateObject, ObjFolder.COMateObject
  Protected Count.i, i.i, SupportFolder.i
  
  ObjOutlook = COMate_CreateObject("Outlook.Application")
  
  If ObjOutlook
    Debug "Object created!"
    ObjnSpace = ObjOutlook\GetObjectProperty("GetNamespace(" + Chr(39) + "MAPI" + Chr(39) + ")")
    Debug "NameSpace: "+Str(ObjnSpace)
    If ObjnSpace
      Count = ObjnSpace\GetIntegerProperty("Folders\Count")
      Debug "Folder Count: "+Str(Count)
      
      For i = 1 To Count
        If ObjnSpace\GetStringProperty("Folders("+Str(i)+")\Name") = "Support"
          Debug "Support folder is folder: "+Str(i)
          SupportFolder = I
          Break
        EndIf
      Next 
      
      ObjFolder = ObjnSpace\GetObjectProperty("Folders("+Str(SupportFolder)+")\Folders("+Chr(39)+"Inbox"+Chr(39)+")")
      Debug "Folder: "+Str(ObjFolder)
      
      ;/ count unread mails
      Count = ObjFolder\GetIntegerProperty("UnReadItemCount")  
      Debug Count
      ProcedureReturn Count
    EndIf
  Else
    ProcedureReturn -1
  EndIf
  
EndProcedure

OpenWindow(0,0,0,380,74,"Open Support Emails",#PB_Window_ScreenCentered|#PB_Window_MinimizeGadget)
StickyWindow(0,#True)
LoadFont(0,"Arial",24)
;LoadFont(1,"Arial",7)
TextGadget(#Gad_MainText,0, 0,376,48,"")
CheckBoxGadget(#Gad_Audionag,290,50,70,22,"Nag?") : SetGadgetState(#Gad_Audionag,1)
ButtonGadget(#Gad_Hide,0,50,280,22,"Hide")
SetGadgetFont(#Gad_MainText,FontID(0))
If Sound_Available
  CatchSound(0,?Sample)
  Debug "Caught sound"
EndIf

Define.i Event, UpdateTimer.i, Sound.i, Timer.i, Count.i = 99, Lastcount.i = 99, Flash.i, NextNag.i, NextNagDelay.i = 30000

UpdateTimer = ElapsedMilliseconds()

Repeat
  Event = WaitWindowEvent(200)
  
  If EventGadget() = 1 : SetWindowState(0,#PB_Window_Minimize) : EndIf
  
  If ElapsedMilliseconds() > UpdateTimer
    Lastcount = Count
    Timer = ElapsedMilliseconds()
    Count = CountUnreadSupportEmails()
    If Count > Lastcount
      If Sound_Available ;/ play a sound
        PlaySound(0)
      EndIf
      SetWindowState(0,#PB_Window_Normal)      
    EndIf
    ;/ set colour to black initially
    SetGadgetColor(0,#PB_Gadget_FrontColor,0)
    Select Count
      Case -1 ;/ outlook not open
        If GetGadgetText(0) <> "Outlook must be open"
          SetGadgetText(0,"Outlook must be open")
        EndIf
        
      Case 0
        If GetGadgetText(0) <> "No Unread Support Emails"
          SetGadgetColor(0,#PB_Gadget_FrontColor,RGB(0,250,0))
          SetGadgetText(0,"No Unread Support Emails")
        EndIf
        NextNagDelay = 30000
      Default
        If GetGadgetText(0) <> "Unread Support Emails: "+Str(Count)
          SetGadgetText(0,"Unread Support Emails: "+Str(Count))
        EndIf
        
        Flash = 1 - Flash

        If Flash = 0
          SetGadgetColor(0,#PB_Gadget_FrontColor,255)
          If GetGadgetState(#Gad_Audionag) And ElapsedMilliseconds() => NextNag
            If NextNagDelay > 2000 : NextNagDelay - 1000 : EndIf
            NextNag = ElapsedMilliseconds() + NextNagDelay
            ;SetWindowTitle(0,Str(ElapsedMilliseconds())+" - "+Str(NextNagDelay)+" - "+Str(nextnag))
            PlaySound(0)
          EndIf
        EndIf
    EndSelect
    
    Timer = ElapsedMilliseconds() - Timer
    Debug "Time for update: "+Str(Timer)
    UpdateTimer = ElapsedMilliseconds() + 1000
  EndIf
  
Until Event = #PB_Event_CloseWindow

DataSection
  Sample:
  IncludeBinary("Windows Notify Messaging.wav")
EndDataSection

; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 30
; Folding = +
; EnableXP
; UseIcon = Support.ico
; Executable = S:\Tools\Support Email Monitor.exe
; DisableDebugger
; EnableUnicode