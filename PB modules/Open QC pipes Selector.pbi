;/ Named pipe selector include - PJ 04/2021.
;/ If no valid named pipes selected, user is warned and program exits
;/ If 1 valid named pipe available, it's automatically selected.
;/ if > 1 available, user is provided with a selection.

Global NewList NamedPipes.s(), PipeName.s

Procedure PopulateNamedPipes()
  Protected Target_Prefix.s = "//./pipe/*.*", FindFileData.win32_find_data, DLL, Ret.l, Result.s, ValidPipeCount.l, MyLoop.l
  
  ;/ populate map from valid pipe names
  NewMap ValidPipes.s() : Read.l ValidPipeCount
  For MyLoop = 1 To ValidPipeCount
    Read.s Result : ValidPipes(Result) = Result
  Next
  
  ClearList(NamedPipes())
  DLL = OpenLibrary(#PB_Any,"kernel32.dll") ;#FindFirstFileNameW
  If DLL
    Ret = CallFunction(DLL,"FindFirstFileW",@Target_Prefix,@FindFileData) 
    Result = PeekS(@FindFileData\cFileName)
    ForEach ValidPipes() : If FindString(Result,ValidPipes(),1) : AddElement(NamedPipes()) : NamedPipes() = Result : EndIf : Next
    While CallFunction(DLL,"FindNextFileW",Ret,@FindFileData)
      Result = PeekS(@FindFileData\cFileName)
      ForEach ValidPipes() : If FindString(Result,ValidPipes(),1) : AddElement(NamedPipes()) : NamedPipes() = Result : EndIf : Next
    Wend
    CloseLibrary(DLL)
  EndIf   
EndProcedure

Procedure.s ChooseNamedPipe()
  Protected Win, Gad_OK, Gad_Combo, Gad_Text, Event, Exit.i, Choice.i
  
  Win = OpenWindow(#PB_Any,0,0,240,60,"QC App choice:",#PB_Window_ScreenCentered)
  Gad_Text = TextGadget(#PB_Any,4,4,80,22,"Please Select:")
  Gad_Combo = ComboBoxGadget(#PB_Any,84,2,100,20)
  ForEach NamedPipes()
    AddGadgetItem(Gad_Combo,-1,NamedPipes())
  Next
  SetGadgetState(Gad_Combo,0)
  ButtonGadget(Gad_OK,90,24,80,22,"OK")
  
  Repeat
    Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case Gad_OK
            Exit = #True
        EndSelect
    EndSelect
  Until Exit = #True
  
  ProcedureReturn GetGadgetText(Gad_Combo)
EndProcedure  

PopulateNamedPipes()

If ListSize(NamedPipes()) = 0
  MessageRequester("Error","No valid AniCAM or SurfaceCAM connections found, exiting",#PB_MessageRequester_Error)
  End
EndIf

If ListSize(NamedPipes()) = 1
  MessageRequester("QC app connection:","Connecting to QC application: "+NamedPipes())
  PipeName = NamedPipes()
EndIf

If ListSize(NamedPipes()) > 1
  PipeName = ChooseNamedPipe()
EndIf

DataSection ;/ Valid pipes...
  Data.l 10
  Data.s "AniloxQC", "AniloxQC_HD", "GravureQC", "GravureQC_HD", "FlexoQC", "FlexoQC_HD", "AniloxQC_LS", "AniloxQC_LS_HD", "EngravingQC", "EngravingQC_HD"
EndDataSection

; IDE Options = PureBasic 5.71 beta 2 LTS (Windows - x86)
; CursorPosition = 59
; FirstLine = 27
; Folding = -
; EnableXP