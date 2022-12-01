;XIncludeFile "COMateplus_Residents.pbi"
XIncludeFile "COMateplus.pbi"

Global Sound_Available = InitSound(), RedFlagCount.i, EmailCount.i

Enumeration
  #Gad_MainText
  #Gad_SubText
  #Gad_Hide
  #Gad_Audionag
EndEnumeration

Procedure.i CountUnreadSupportEmails()
  Protected ObjOutlook.COMateObject, ObjnSpace.COMateObject, ObjFolder.COMateObject, Items.COMateObject, ItemsRestricted.COMateObject, Item.COMateObject
  Protected Count.i, i.i, SupportFolder.i, Timer.i
  
  ObjOutlook = COMate_CreateObject("Outlook.Application")
  
  If ObjOutlook
    ObjnSpace = ObjOutlook\GetObjectProperty("GetNamespace(" + Chr(39) + "MAPI" + Chr(39) + ")")
    If ObjnSpace
      Count = ObjnSpace\GetIntegerProperty("Folders\Count")
      
      For i = 1 To Count
        If ObjnSpace\GetStringProperty("Folders("+Str(i)+")\Name") = "Support"
          SupportFolder = I
          Break
        EndIf
      Next 
      
      ObjFolder = ObjnSpace\GetObjectProperty("Folders("+Str(SupportFolder)+")\Folders('Inbox')")
      Count = 0
      If ObjFolder
        ;/ count unread mails
        Count = ObjFolder\GetIntegerProperty("UnReadItemCount")
        EmailCount = ObjFolder\GetIntegerProperty("Items\Count") 
        Debug "EmailCount: "+Str(EmailCount)
        Timer = ElapsedMilliseconds()
        Items = ObjFolder\GetObjectProperty("Items")
        If Items
          RedFlagCount = 0
          For i = 1 To EmailCount
            If Items\GetIntegerProperty("Item("+Str(i)+")\FlagIcon") = 6
              Debug "RedFlagIcon Date: "+Items\GetStringProperty("Item("+Str(i)+")\TaskDueDate")
              Debug "RedFlagIcon Status: "+Items\GetStringProperty("Item("+Str(i)+")\FlagStatus")
              Debug "RedFlagIcon Request: "+Items\GetStringProperty("Item("+Str(i)+")\TaskCompletedDate")
              RedFlagCount + 1
            EndIf
          Next
        EndIf
        Timer = ElapsedMilliseconds() - Timer
        Debug "RedFlagCount: "+Str(RedFlagCount)
        Debug "Time for redflag count: "+Str(Timer)
        
        Protected Command.s = "Find(" + Chr(34) + "[TaskCompletedDate] <> '0'" + Chr(34) + ")"
        Items = ObjFolder\GetObjectProperty("Items")
        Protected FindItems.COMateEnumObject = ObjFolder\CreateEnumeration(Command)
        ;Protected FindItems.COMateEnumObject = Items\Invoke(Command)
        
        If FindItems
          
          Repeat 
            
            Item = FindItems\GetNextObject()
            
            If Item
              Debug Item\GetStringProperty("Subject")    
            EndIf
            
          Until Not(Item)
          
        Else
          Debug "FindItems:"
          Debug COMate_GetLastErrorDescription()
          
        EndIf

        Debug EmailCount
      EndIf
      
    EndIf
    
    ObjOutlook\Release()
    
    ProcedureReturn Count
  Else
    ProcedureReturn -1
  EndIf
  
EndProcedure

OpenWindow(0,0,0,380,104,"Open Support Emails",#PB_Window_ScreenCentered|#PB_Window_MinimizeGadget) : StickyWindow(0,#True)
LoadFont(0,"Arial",24)
TextGadget(#Gad_MainText,0, 0,376,48,"")
TextGadget(#Gad_SubText,0, 50,376,28,"")
CheckBoxGadget(#Gad_Audionag,290,80,70,22,"Nag?") : SetGadgetState(#Gad_Audionag,1)
ButtonGadget(#Gad_Hide,0,80,280,22,"Hide")
SetGadgetFont(#Gad_MainText,FontID(0))
If Sound_Available
  CatchSound(0,?Sample)
EndIf

Define.i Event, UpdateTimer.i, Sound.i, Timer.i, Count.i = 99, Lastcount.i = 99, Flash.i, NextNag.i, NextNagDelay.i = 30000

UpdateTimer = ElapsedMilliseconds()

Repeat
  Event = WaitWindowEvent(200)
  
  If EventGadget() = 1 : SetWindowState(0,#PB_Window_Minimize) : EndIf
  
  If ElapsedMilliseconds() > UpdateTimer
    Lastcount = Count
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
            PlaySound(0)
          EndIf
        EndIf
    EndSelect
    SetGadgetText(#Gad_SubText,"Total Items: "+Str(EmailCount)+" - Red Flagged: "+Str(RedFlagCount))
    UpdateTimer = ElapsedMilliseconds() + 1000
  EndIf
  
Until Event = #PB_Event_CloseWindow

DataSection
  Sample:
  IncludeBinary("Windows Notify Messaging.wav")
EndDataSection

; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 56
; FirstLine = 34
; Folding = +
; EnableXP
; UseIcon = Support.ico
; Executable = S:\Tools\Support Email Monitor test.exe
; EnableUnicode