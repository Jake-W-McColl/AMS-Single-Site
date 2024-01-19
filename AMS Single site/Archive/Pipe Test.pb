EnableExplicit

Enumeration ;/gadgets
  #Gad_Editor
  #Gad_Button
  #Gad_String
  #Gad_Preset_Combo
  #Gad_Preset_Set
  #Gad_Navtree
  #Gad_Navtree_Set
  #Gad_RollInfo_Export
EndEnumeration
Enumeration ;/Tree gadget data types
  #NavTree_Company
  #NavTree_Site
  #NavTree_Group
  #NavTree_Roll
EndEnumeration

Structure Tree
  Type.i ; 0 = Home, 1 = Site, 2 = Group, 3 = Roll
  String.S ;/ String to display
  AddString.S ;/ String for additional info on main string
  RollID.i
  SiteID.i
  GroupID.i
EndStructure
Structure System
  EventID.l
  Quit.l
  PipeName.s
  *mem
  MemSize.i
  On_Nav_Entry.i

EndStructure
Structure RollMaster_Import
  ID.s : GroupID.s : Name.s : Manufacturer.s : Width.s : Suitability.s : datemade.s : Screencount.s : Wall.s : Opening.s : Comments.s : Operator.s : ReadingDate.s : Vol1.s : Vol2.s : Vol3.s : Vol4.s : Vol5.s
  Volume.s : Capacity.s : Variance.s : lastreadingdate.s : AniCAM_Config.s : Depth.s : Current_Depth.s : Usage.s : Current_Usage.s
EndStructure

Global NewList NavTree.Tree()
Global NewList RollMaster_Import.RollMaster_Import()
Global System.system : System\PipeName.s = "\\.\pipe\AMS_Pipe" : System\MemSize = 65536
System\mem = AllocateMemory(System\MemSize)

Procedure Refresh_NavList()
  Protected Txt.s
  ClearGadgetItems(#Gad_Navtree)
  ForEach Navtree()
    Txt = Str(Navtree()\SiteID)+":"+Str(Navtree()\GroupID)+":"+Str(Navtree()\RollID)+" - "
    Txt + NavTree()\String
    Txt + NavTree()\AddString
    AddGadgetItem(#Gad_Navtree,-1,Txt)
  Next
  SetGadgetState(#Gad_Navtree,0)
EndProcedure

Procedure Update_RollInfo()
  Protected Txt.s, Avg.f, Count.i
  
  ;/ pre-process
  ForEach RollMaster_Import()
    If RollMaster_Import()\Volume = ""
      Avg = 0 : Count = 0
      If RollMaster_Import()\Vol1 <> "0.0" : Avg + ValF(RollMaster_Import()\Vol1) : Count + 1 : EndIf
      If RollMaster_Import()\Vol2 <> "0.0" : Avg + ValF(RollMaster_Import()\Vol2) : Count + 1 : EndIf
      If RollMaster_Import()\Vol3 <> "0.0" : Avg + ValF(RollMaster_Import()\Vol3) : Count + 1 : EndIf
      If RollMaster_Import()\Vol4 <> "0.0" : Avg + ValF(RollMaster_Import()\Vol4) : Count + 1 : EndIf
      If RollMaster_Import()\Vol5 <> "0.0" : Avg + ValF(RollMaster_Import()\Vol5) : Count + 1 : EndIf
      If Count > 0 : Avg / Count : EndIf
      RollMaster_Import()\Volume = StrF(Avg,2)
    EndIf
  Next
  
  ClearGadgetItems(#Gad_RollInfo_Export)
  ForEach RollMaster_Import()
    Txt = FormatDate("%dd/%mm%/%yyyy %hh:%ii",Val(RollMaster_Import()\ReadingDate)) + Chr(10)
    Txt + RollMaster_Import()\Operator + Chr(10)
    Txt + RollMaster_Import()\Vol1 + Chr(10)
    Txt + RollMaster_Import()\Vol2 + Chr(10)
    Txt + RollMaster_Import()\Vol3 + Chr(10)
    Txt + RollMaster_Import()\Vol4 + Chr(10)
    Txt + RollMaster_Import()\Vol5 + Chr(10)
    Txt + RollMaster_Import()\Volume + Chr(10)
    AddGadgetItem(#Gad_RollInfo_Export,-1,Txt)
  Next
EndProcedure

Procedure Pipe_Send(lpszPipename.s,Command.s)
  Protected File.i, BytesReceived.i, BytesWritten.i, Response.s, *Mem, Cmnd.s
  
  If WaitNamedPipe_(lpszPipename, #Null)
    File = CreateFile_(lpszPipename, #GENERIC_READ |#GENERIC_WRITE, 0, #Null, #OPEN_EXISTING,0, #Null)
    If File
      WriteFile_(File , @Command, StringByteLength(Command), @BytesWritten, 0)
      ;Delay(100)
      ;FlushFileBuffers_(File)
      Delay(500)
      ;If Command = "!REQUEST_NAVTREE" : Delay(100) : EndIf ;/ give more time for response
      FillMemory(System\mem, System\MemSize,0)
      ReadFile_(File, System\mem, System\MemSize, @BytesReceived, 0)
      Response = PeekS(System\mem)
      AddGadgetItem(#Gad_Editor, -1, "Received: "+Str(BytesReceived)+" bytes") 
      AddGadgetItem(#Gad_Editor, -1, Response) 
      
      ;/ handle special request commands
      Cmnd = Trim(StringField(Command,1,"="))
      
      If BytesReceived > 0
        Debug Cmnd
        Select Cmnd
          Case "!EXPORT_ROLL_INFO" 
            Debug Response
            If ParseJSON(0,Response)
              
            ExtractJSONList(JSONValue(0),RollMaster_Import())
            Update_RollInfo()
            FreeJSON(0)
          Else
            MessageRequester("Error",JSONErrorMessage())
          EndIf
          
        Case "!REQUEST_NAVTREE_SIZE"
          If Val(Response) > System\MemSize
            System\MemSize = Val(Response)
            If System\mem : FreeMemory(System\mem) : EndIf
            System\mem = AllocateMemory(System\MemSize)
            EndIf
          Case "!REQUEST_NAVTREE"
            ParseJSON(0,Response)
            ExtractJSONList(JSONValue(0),Navtree())
            Refresh_NavList()
            FreeJSON(0)
        EndSelect
      EndIf
      CloseHandle_(File)
    EndIf
    
  Else
    AddGadgetItem(#Gad_Editor, -1, "No AMS server detected")
  EndIf 
  
EndProcedure

Procedure Init_Main()
  OpenWindow(0,0,0,640,700,"AMS Pipe Communications",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  ComboBoxGadget(#Gad_Preset_Combo,4,4,160,20)
  AddGadgetItem(#Gad_Preset_Combo,-1,"!SHOW_ROLL_INFO =")
  AddGadgetItem(#Gad_Preset_Combo,-1,"!SHOW_GROUP =")
  AddGadgetItem(#Gad_Preset_Combo,-1,"!SHOW_SITE =")
  AddGadgetItem(#Gad_Preset_Combo,-1,"!SHOW_COMPANY =")
  AddGadgetItem(#Gad_Preset_Combo,-1,"!EXPORT_ROLL_INFO =")
  AddGadgetItem(#Gad_Preset_Combo,-1,"!REQUEST_NAVTREE_SIZE")
  AddGadgetItem(#Gad_Preset_Combo,-1,"!REQUEST_NAVTREE")
  SetGadgetState(#Gad_Preset_Combo,0)
  
  ButtonGadget(#Gad_Preset_Set,170,4,60,20,"Set")
  EditorGadget(#Gad_Editor,4,90,380,300)
  ComboBoxGadget(#Gad_Navtree,4,64,250,20)
  ButtonGadget(#Gad_Navtree_Set,260,64,60,20,"Set")
  StringGadget(#Gad_String,4, 34,320,20,"!EXPORT_ROLL_INFO = Balcan-Mtl9475_103_S1")
  ButtonGadget(#Gad_Button, 328, 34, 56, 20, "Send..")  
  
  ListIconGadget(#Gad_RollInfo_Export,4,400,632,292,"Date",120)
  AddGadgetColumn(#Gad_RollInfo_Export,1,"Operator",120)
  AddGadgetColumn(#Gad_RollInfo_Export,2,"Vol 1",40)
  AddGadgetColumn(#Gad_RollInfo_Export,3,"Vol 2",40)
  AddGadgetColumn(#Gad_RollInfo_Export,4,"Vol 3",40)
  AddGadgetColumn(#Gad_RollInfo_Export,5,"Vol 4",40)
  AddGadgetColumn(#Gad_RollInfo_Export,6,"Vol 5",40)
  AddGadgetColumn(#Gad_RollInfo_Export,7,"Vol Avg",40)
  Pipe_Send(System\PipeName,"!REQUEST_NAVTREE_SIZE")
  Pipe_Send(System\PipeName,"!REQUEST_NAVTREE")
  
EndProcedure
Init_Main()

Repeat
  System\EventID.l = WaitWindowEvent()
  Select System\EventID
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #Gad_Preset_Set
          SetGadgetText(#Gad_String,GetGadgetText(#Gad_Preset_Combo))
          
        Case #Gad_Navtree_Set
          SelectElement(Navtree(),GetGadgetState(#Gad_Navtree))
          SetGadgetText(#Gad_String,GetGadgetText(#Gad_Preset_Combo)+" "+NavTree()\String)
          
        Case #Gad_Button
          Pipe_Send(System\PipeName,GetGadgetText(#Gad_String))
      EndSelect
      
    Case #PB_Event_CloseWindow
      System\Quit = 1
  EndSelect
  
Until System\Quit = 1

; IDE Options = PureBasic 5.71 LTS (Windows - x86)
; CursorPosition = 34
; Folding = 50
; EnableXP
; DisableDebugger