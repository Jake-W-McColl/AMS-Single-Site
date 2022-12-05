;/ Named pipe Include - PJ 04/2021 - For RaRz
;/ ===========================================
;/ If no valid named pipes selected, user is warned and program exits
;/ If 1 valid named pipe available, it's automatically selected.
;/ if > 1 available, user is provided with a selection.

Enumeration
  #PipeImage_Main
EndEnumeration

;/ JM20220428 - for reporting
; Structure LineAnalysis
;   Width.s
;   Angle.s
;   Height.s
;   ;HeightT.s
; EndStructure

Structure HW
  PipeName.s
  PipeName_DeviceOnly.s
  Width.l : Height.l : Widthm1.l : Heightm1.l
  PixelCount.l
  IsHD.l ;/ used to half size the graphic displays.
  Draw_BufferSize.l
  Pipe_12bitBufferSize.l
  Pipe_12bitBufferSizePPMM.l
  Pipe_24BitBufferSize.l    
  *lpOutbuffer
  lpBytesRead.l
EndStructure
; Structure LineAnalysis
;   Width.s
;   Angle.s
;   Height.s
;   ;HeightT.s
; EndStructure
Structure Scan
  ScanNumber.i
  PPMMs.s
  PPMM.f
  File.s
  Vol.s
  VolAverage.s
  Vol1.s
  Vol2.s
  Vol3.s
  Vol4.s
  Vol5.s
  Depth.s
  Divisor.d
  JobDepthF.d
  RollID.s
  Time.s
  Date.s
  Screen.s
  Operator.s
  Customer.s
  Comment.s
  DebugInfo.s
  Lens.s
  Wall.s
  Opening.s
  Angle.s
  
  ;/ JM20220428 - for reporting
  CrossSection_Width.s 
  CrossSection_Height.s
  ScreenAngle.s
  Angle_Left.s
  Angle_Right.s
  Angle_Full.s
  Height.s
  Width_Top.s
  Width_Middle.s
  Width_Bottom.s
  Custom.s[8]
  ;/Line.LineAnalysis[8]
  
  Min.f
  Max.f
  
  TimeStamp.i
EndStructure



Structure Pipe_System
  Main_ScreenUnit.l
  Main_VolUnit.l
  Main_HeightUnit.l
  Main_ScreenUnitTxt.s
  Main_VolUnitTxt.s
  Main_HeightUnitTxt.s
EndStructure
Structure pipe_rgb
  r.a : g.a : b.a
EndStructure

Global NewList NamedPipes.s(), HW.HW, Pipe_System.Pipe_System
Global NewList Scans.Scan()

Procedure.s Command_SendToAniCAMPipe(Txt.s)
  Protected Result.i;, X.i, Y.i
  If FindString(HW\PipeName,"\\.\pipe\")
    HW\PipeName = HW\PipeName ;/ bacon sandwiches are bacon sandwiches
  Else
     HW\PipeName = "\\.\pipe\"+HW\PipeName ;/JM20220822 moved appending here
  EndIf

  Debug "Calling named pipe with pipename: "+HW\PipeName
  If CallNamedPipe_(HW\PipeName, @txt, StringByteLength(txt)+2 , HW\lpOutbuffer, HW\Pipe_12bitBufferSizePPMM, @HW\lpBytesRead, 100)
    ;AddDebug("Command Txt: "+Txt + " - Returned Bytes: "+Str(lpBytesRead))
    Debug "Command Txt: "+Txt + " - Returned Bytes: "+Str(hw\lpBytesRead)
    If HW\lpBytesRead > HW\Pipe_24BitBufferSize : HW\lpBytesRead = HW\Pipe_24BitBufferSize : EndIf ;/ truncate if oversized...
    If HW\lpBytesRead < 1024                                                                       ;/ rationalize expected return
      Debug "Returning: "+Str(Result)
      ProcedureReturn PeekS(HW\lpOutBuffer,hw\lpBytesRead)
    Else
      ProcedureReturn ""
    EndIf
  Else
    ;AddDebug("Failed response - Pipe error?")
    Debug "Failed response - Pipe error in Command_SendToAniCAMPipe?"
    ProcedureReturn "-1"
  EndIf
EndProcedure

Procedure Update_Image12_FromPipeMem(Image.i,PPMM = #False) ;/ 12 bit mono...
  Protected *Pos.word, P, PixelCount.i = HW\Width * HW\Height, *buffer.integer
  If IsImage(Image)
    StartDrawing(ImageOutput(Image))
      *Buffer = DrawingBuffer()
      If PPMM = #True : *Pos = hw\lpOutBuffer + 4 : Else : *Pos = hw\lpOutBuffer : EndIf
      For P = 1 To PixelCount-1
        *Buffer\i = *Pos\w : *Pos + 2 : *Buffer + 3
      Next
    StopDrawing()
  EndIf
EndProcedure

Procedure Update_Image24_FromPipeMem(Image.i) ;/ 24 bit RGB
  Protected *Pos.pipe_rgb, X.i, Y.i, V.i, Timer.i, Buffer, P.i, PixelCount.i = HW\Width * HW\Height, *buffer.pipe_rgb
  If IsImage(Image)
    StartDrawing(ImageOutput(Image))
      *Buffer = DrawingBuffer()
      *Pos = hw\lpOutBuffer
      For p = 0 To PixelCount - 1
        *Buffer\r = *Pos\r : *Buffer\g = *Pos\g : *Buffer\b = *Pos\b : *Pos + 3
        *Buffer + 3
      Next
    StopDrawing()
  EndIf
EndProcedure

Procedure Update_Array12_FromPipeMem(Array Arr.w(2), PPMM = #False) ;/ 12 bit mono...
  Protected *Pos.word, X,Y
  Debug "************************************************"
  Debug "Update_Array12_FromPipeMem: PPMM? "+Str(PPMM)
  Debug "************************************************"
  
  If PPMM = #True
    *Pos = hw\lpOutBuffer + 4
  Else
    *Pos = hw\lpOutBuffer
  EndIf
  
  For Y = 0 To HW\Heightm1
    For X = 0 To HW\Widthm1
      Arr(HW\Heightm1-y,x) = *Pos\w : *Pos + 2 
    Next
  Next

  
EndProcedure

Procedure.s PipeCommand_ToArray12(Txt.s, Array Arr.w(2))
  Protected Result.i, lpBytesRead.i, ReturnString.s = "Null", Pos.i, X.i, Y.i, PPMM.i = #False
  Result.i = CallNamedPipe_(HW\PipeName, @txt, StringByteLength(txt)+2 , HW\lpOutBuffer, HW\Pipe_12BitBufferSize+4, @lpBytesRead, 100)
  
  Debug "************************************************"
  Debug "************************************************"
  Debug "************************************************"
  Debug "************************************************"
  Debug txt
  Debug "lpBytesRead: "+Str(lpBytesRead)+" - 12 bit buffer size: "+Str(HW\Pipe_12bitBufferSize)
  
  If Result = 1
    If lpBytesRead => hw\Pipe_12bitBufferSize ;/ assume image / video frame of some description
      If lpBytesRead = hw\Pipe_12bitBufferSize  + 4
        ;System\Live_PPMM.f = PeekF(hw\lpOutBuffer)
        ;PPMM = #True
      EndIf
      Select lpBytesRead
        Case hw\Pipe_12bitBufferSize
          Update_Array12_FromPipeMem(Arr())
        Case HW\Pipe_12bitBufferSizePPMM
          MessageRequester("Info...","Has PPMM")
          Update_Array12_FromPipeMem(Arr(),1)
        Default
          Debug "Size not recognised: "+Str(lpBytesRead)
      EndSelect
    Else
      ;AddDebug("Failed response - Returned Array size not recognized: "+Str(lpBytesRead))
      Debug "Failed response - Returned Array size not recognized: "+Str(lpBytesRead)
      ProcedureReturn "-1"
      
    EndIf
  Else
    ;AddDebug("Failed response - Pipe error?")
    Debug "Failed response - Pipe error?"
    ProcedureReturn "-1"
  EndIf
  
  ProcedureReturn ReturnString
EndProcedure

Procedure.s PipeCommand_ToImage(Txt.s, OutputImage.i)
  Protected Result.i, ReturnString.s = "Null", Pos.i, X.i, Y.i, PPMM = #False
  
  ;Debug "Result of: ?$DocActive = "+Command_SendToAniCAMPipe("?$DocActive")
  Result.i = CallNamedPipe_(HW\PipeName, @txt, StringByteLength(txt)+2 , hw\lpOutBuffer, HW\Pipe_24BitBufferSize+4, @hw\lpBytesRead, 1000)
  Debug "Result of: "+Txt+" = "+Result
  Debug "Buffersize: "+Str(HW\Pipe_24BitBufferSize+4)
  Debug "MemorySize: "+Str(MemorySize(hw\lpOutBuffer))
  
  If Result = 1
    If HW\lpBytesRead => HW\Pipe_12bitBufferSize ;/ assume image / video frame of some description
      If HW\lpBytesRead = HW\Pipe_12bitBufferSize  + 4
        PPMM = #True
      EndIf
      Select HW\lpBytesRead
        Case HW\Pipe_12bitBufferSize To HW\Pipe_12bitBufferSizePPMM
          Debug "Image 12 returned from: "+Txt
          Update_Image12_FromPipeMem(OutputImage, PPMM)
        Case HW\Pipe_24BitBufferSize 
          Debug "Image 24 returned from: "+Txt
          Update_Image24_FromPipeMem(OutputImage)
        Default
          Debug "Size not recognised: "+Str(HW\lpBytesRead)
      EndSelect
    Else
      If HW\lpBytesRead > HW\Pipe_24BitBufferSize : HW\lpBytesRead = HW\Pipe_24BitBufferSize : EndIf
      ReturnString = PeekS(hw\lpOutBuffer,HW\lpBytesRead)
    EndIf
  Else
    Debug "Failed response - Pipe error in PipeCommand_ToImage?"
    ProcedureReturn "-1"
  EndIf

  ProcedureReturn ReturnString
EndProcedure

Procedure Pipe_SetActiveDoc(Doc.i)
  Protected ResultA.i, OutLoop.i = 0, ResultB.i
  
  ;Debug "********** Setting Document as active: "+Str(Doc)
  Repeat
    OutLoop + 1
    ResultA = Val(Command_SendToAniCAMPipe("$DocActive="+Str(Doc)))
    ResultB = Val(Command_SendToAniCAMPipe("?$DocActive"))
    ;Debug "********** Document active: "+ResultB
    Delay(10)
  Until ResultB = Doc Or ResultA = -1 Or OutLoop > 9
  
  If ResultB = Doc : ProcedureReturn 1 : EndIf
  
  Debug "***** FAILED to set active doc *****"
  ProcedureReturn -1 
  
EndProcedure


Procedure.s Pipe_GetScanCount()
  ProcedureReturn Command_SendToAniCAMPipe("?$DocCount")
EndProcedure

Procedure Pipe_UpdateThumbnail(Gadget,Scan.i)
  If IsGadget(Gadget)
    If GadgetType(Gadget) = #PB_GadgetType_Canvas
      
    EndIf
  EndIf
  
EndProcedure

Procedure Refresh_OpenScans(Gadget.i) ;/ called only if Anilox Activity > -1 - 
  Protected MyLoop.i, Current1.i, Current1String.s, ScanCount.i = 0, Time.i, OnScan.s
  
  Debug "**********************************************************************************"
  Debug "Refreshing OpenScans"
  
  ;/ store current position so that it can be reset after (if still available).
  
  ScanCount = Val(Pipe_GetScanCount())
  
  ClearList(Scans())
  
  If ScanCount > 0
    
    ;/ get settings information
    Pipe_System\Main_ScreenUnit = Val(Command_SendToAniCAMPipe("?$LineUnits"))
    Pipe_System\Main_VolUnit = Val(Command_SendToAniCAMPipe("?$VolUnits"))
    Pipe_System\Main_HeightUnit = Val(Command_SendToAniCAMPipe("?$HeightUnits"))
    
    If Pipe_System\Main_ScreenUnit = 0 : Pipe_System\Main_ScreenUnitTxt = "LPI" : Else : Pipe_System\Main_ScreenUnitTxt = "L/CM" : EndIf
    If Pipe_System\Main_VolUnit = 0 : Pipe_System\Main_VolUnitTxt = "BCM"       : Else : Pipe_System\Main_VolUnitTxt = "cm³/m²": EndIf
    If Pipe_System\Main_HeightUnit = 0 : Pipe_System\Main_HeightUnitTxt = "Though"  : Else : Pipe_System\Main_HeightUnitTxt = "µm" : EndIf
    
    ;/ get scan information
    For MyLoop = 0 To ScanCount-1
      Command_SendToAniCAMPipe("$DocActive="+Str(MyLoop))
      AddElement(Scans())
      Scans()\Time = Command_SendToAniCAMPipe("?$DocTime")
      Scans()\Date = Command_SendToAniCAMPipe("?$DocDate")
      Scans()\File = Command_SendToAniCAMPipe("?$DocTitle")
      Scans()\RollID = Command_SendToAniCAMPipe("?$DocRollID")
      Scans()\Wall = Command_SendToAniCAMPipe("?$DocWall")
      Scans()\Opening = Command_SendToAniCAMPipe("?$DocOpening")
      Scans()\Angle = Command_SendToAniCAMPipe("?$DocAngle")
      Scans()\PPMMs = Command_SendToAniCAMPipe("?$DocPPM")
      Scans()\PPMM = ValF(Scans()\PPMMs)
      If Scans()\PPMM = 0 : Scans()\PPMM = 1000 : EndIf ;/ protect
      If Trim(Scans()\RollID) = "" : Scans()\RollID = "[Blank]" : EndIf ;/ 
      Scans()\Comment = Command_SendToAniCAMPipe("?$DocComment")
      Scans()\Operator = Command_SendToAniCAMPipe("?$DocOperator")
      Scans()\Customer = Command_SendToAniCAMPipe("?$DocCustomer")
      Scans()\VolAverage = StrF(ValF(Command_SendToAniCAMPipe("?$DOCAVGVOLUME")),1)
      Scans()\Vol1 = StrF(ValF(Command_SendToAniCAMPipe("$DOCAVGVOLUME=0")),1)
      Scans()\Vol2 = StrF(ValF(Command_SendToAniCAMPipe("$DOCAVGVOLUME=1")),1)
      Scans()\Vol3 = StrF(ValF(Command_SendToAniCAMPipe("$DOCAVGVOLUME=2")),1)
      Scans()\Vol = StrF(ValF(Command_SendToAniCAMPipe("?$DocVolume")),1)
      Scans()\Depth = Command_SendToAniCAMPipe("?$DocDepth")
      Scans()\Depth = Str(ValF(Scans()\Depth))
      Scans()\JobDepthF = ValF(Command_SendToAniCAMPipe("?$JobPeakDepth")) ;/ new - needs Anilox QC v9.5i or newer...
      
      ;/ overwrite old depth with new peak depth...
      Scans()\Depth = StrF(Scans()\JobDepthF)
      
      ;/ frig fix for pipe-mode always sending LPI
      If Pipe_System\Main_ScreenUnit = 0
        ;/ LPI is OK...
        Scans()\Screen = Str(Val(Command_SendToAniCAMPipe("?$DocScreen")))
      Else ;/ lpcm, do conversion.
        Scans()\Screen = Str(Val(Command_SendToAniCAMPipe("?$DocScreen"))/2.54)
      EndIf

      Scans()\TimeStamp = Date(ValF(StringField(Scans()\Date,3,"/")),
                               ValF(StringField(Scans()\Date,2,"/")),
                               ValF(StringField(Scans()\Date,1,"/")),
                               ValF(StringField(Scans()\Time,1,":")),
                               ValF(StringField(Scans()\Time,2,":")),0)
      Scans()\ScanNumber = ListIndex(Scans())
    Next
    SortStructuredList(Scans(),#PB_Sort_Ascending,OffsetOf(Scan\TimeStamp),#PB_Integer)
    
    If IsGadget(Gadget)
      If GadgetType(Gadget) = #PB_GadgetType_ComboBox
        ClearGadgetItems(Gadget)
        ForEach Scans()
          AddGadgetItem(Gadget,-1,Scans()\RollID + ": [" + Scans()\Date +"-" + Scans()\Time+"]")
        Next
        SetGadgetState(Gadget,0)
      EndIf
    EndIf
    
  Else
    
    Select ScanCount
      Case 0
        MessageRequester("Error",ReplaceString(HW\PipeName_DeviceOnly,"_"," ") + " is open but no scans are currently open.")
      Case -1
        MessageRequester("Error","Unable to communicate with "+HW\PipeName_DeviceOnly);+#LFCR$+"Please ensure Gravure QC (V9.4 or greater) is running.")          
    EndSelect
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

Procedure SetHWStructure()
  HW\PipeName_DeviceOnly = ReplaceString(HW\PipeName,"\\.\pipe\","")
  If FindString(HW\PipeName,"HD")
    HW\Width = 1024 : HW\Height = 768 : HW\IsHD = #True
  Else
    HW\Width = 640 : HW\Height = 480 : HW\IsHD = #True
  EndIf
  Hw\PixelCount = HW\Width * HW\Height
  HW\Widthm1 = HW\Width - 1
  HW\Heightm1 = HW\Height - 1
  HW\Draw_BufferSize = 640 * 480 * 4
  HW\Pipe_12bitBufferSize = (2 * HW\Width * HW\Height)
  HW\Pipe_12bitBufferSizePPMM = (2 * HW\Width * HW\Height) + 4
  HW\Pipe_24BitBufferSize = (3 * HW\Width * HW\Height)
  HW\lpOutbuffer = AllocateMemory(HW\Pipe_24bitBufferSize + 4)
EndProcedure

Procedure PopulateNamedPipes()
  Protected Target_Prefix.s = "//./pipe/*.*", FindFileData.win32_find_data, DLL, Ret.l, Result.s, ValidPipeCount.l, MyLoop.l
  ;/ populate map from valid pipe names
  Restore ValidPipes
  NewMap ValidPipes.s() : Read.l ValidPipeCount
  For MyLoop = 1 To ValidPipeCount
    Read.s Result : ValidPipes(Result) = Result
  Next
  
  ClearList(NamedPipes())
  DLL = OpenLibrary(#PB_Any,"kernel32.dll") ;#FindFirstFileNameW
  If DLL
    Ret = CallFunction(DLL,"FindFirstFileW",@Target_Prefix,@FindFileData) 
    Result = PeekS(@FindFileData\cFileName)
    Debug Result
    ForEach ValidPipes() : If UCase(Result) = UCase(ValidPipes()) : AddElement(NamedPipes()) : NamedPipes() = Result : EndIf : Next
    While CallFunction(DLL,"FindNextFileW",Ret,@FindFileData)
      Result = PeekS(@FindFileData\cFileName)
      ForEach ValidPipes() : If UCase(Result) = UCase(ValidPipes()) : AddElement(NamedPipes()) : NamedPipes() = Result : EndIf : Next
    Wend
    CloseLibrary(DLL)
  EndIf
  
  If ListSize(NamedPipes()) = 0
    ;MessageRequester("Error","No valid AniCAM or SurfaceCAM connections found, exiting",#PB_MessageRequester_Error)
    ;End
  EndIf
  
  If ListSize(NamedPipes()) = 1
    ;MessageRequester("QC app connection:","Connecting to QC application: "+NamedPipes())
    HW\PipeName = NamedPipes()
  EndIf
  
  If ListSize(NamedPipes()) > 1
    ;HW\PipeName = ChooseNamedPipe()
  EndIf
  
  SetHWStructure()
EndProcedure

PopulateNamedPipes()

DataSection ;/ Valid pipes...
  ValidPipes:
  Data.l 10
  Data.s "AniloxQC", "AniloxQC_HD", "GravureQC", "GravureQC_HD", "FlexoQC", "FlexoQC_HD", "AniloxQC_LS", "AniloxQC_LS_HD", "EngravingQC", "EngravingQC_HD"
EndDataSection

; IDE Options = PureBasic 5.71 LTS (Windows - x86)
; CursorPosition = 88
; FirstLine = 75
; Folding = ---
; EnableXP