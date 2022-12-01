;/ Self Draw Graph Work - Removal of RMCHart library due to Unicode font issues.
;/ PJ 26.03.2021

EnableExplicit

Enumeration ;/ fonts
  #GraphFont_Title
  #GraphFont_Axis
  #GraphFont_Warnings
  #GraphFont_Legend
EndEnumeration

Enumeration ;/ Windows
  #Window_Main
EndEnumeration

Enumeration ;/ Gadgets
  #Gad_Canvas_Graph
EndEnumeration

Enumeration ;/ Images
  #Image_Graph
EndEnumeration

Enumeration ;/ pjGraph Styles
  #pjGraph_Style_Original
EndEnumeration

Structure System
  Event.i
  Exit.a
  Refresh.a
EndStructure

Structure pjGraph
  Width.i
  Height.i
  
  Style.i
  
  Title.s
  
  Legend_X.s
  List Data_X.s()
  
  Legend_Y.s
  List Data_Y.f()
  
  Show_WarningLines.a
  Amber_Value.f
  Red_Value.f
  
EndStructure

Global System.system, pjGraph.pjGraph

Procedure pjGraph_Render()
  Protected ScaleX.f, ScaleY.f, Width.f, Height.f, Ratio.f, LineThickness.f = 0.25, DrawWidth.i, DrawHeight.i, SpacingX.f, SpacingY.f, Count.i, FontScale.f
  Protected Border_Inner_Area.rect, Border_Outer_Area.rect
  Protected MyLoop.i, TmpX.f, TmpY.f
  
  Protected MaxY.f, MinY.f, StrideY.f, Txt.s, MaxVal.f, MinVal.f
  
  Width  = pjGraph\Width
  Height = pjGraph\Height
  
  Ratio = pjGraph\Width / pjGraph\Height
  If Ratio <> 1.1 ;/ correct the Width/Height if incorrect ratio
    If Ratio > 1.1 : Width = Height * 1.1 : EndIf ;/ correct the Width
    If Ratio < 1.1 : Height = Width / 1.1 : EndIf ;/ correct the Width
  EndIf
  
  FontScale = Width / 1024.0
  Debug FontScale
  LoadFont(#GraphFont_Title,"Arial",20 * FontScale,#PB_Font_Bold)
  LoadFont(#GraphFont_Axis,"Arial",15 * FontScale,#PB_Font_Bold)
  LoadFont(#GraphFont_Warnings,"Arial",12 * FontScale,#PB_Font_Bold)
  LoadFont(#GraphFont_Legend,"Arial",11 * FontScale)
  
  CreateImage(#Image_Graph,Width,Height)
  
  ;/ draw initial as standard 2d drawing as vector output lines are 2 pixels thick....
  
  StartDrawing(ImageOutput(#Image_Graph))
    DrawingMode(#PB_2DDrawing_Default)
    Box(0,0,Width,Height,RGBA(240,248,255,255))
    
    ;/ Outer border
    Border_Outer_Area\left = 8
    Border_Outer_Area\top = 8
    Border_Outer_Area\right = Width - 8
    Border_Outer_Area\bottom = Height - 8

    DrawingMode(#PB_2DDrawing_Outlined)
    Box(Border_Outer_Area\left,Border_Outer_Area\top,Border_Outer_Area\right-Border_Outer_Area\left,Border_Outer_Area\bottom-Border_Outer_Area\top,RGBA(0,0,0,255))
    
    ;/ Inner border
    Border_Inner_Area\left = Width * 0.07
    Border_Inner_Area\top = Height * 0.05
    Border_Inner_Area\right = Width * 0.97
    Border_Inner_Area\bottom = Height * 0.89
    DrawWidth = Border_Inner_Area\right - Border_Inner_Area\left
    DrawHeight = Border_Inner_Area\bottom - Border_Inner_Area\top
    
    DrawingMode(#PB_2DDrawing_Default)
    Box(Border_Inner_Area\left,Border_Inner_Area\top,Border_Inner_Area\right-Border_Inner_Area\left,Border_Inner_Area\bottom-Border_Inner_Area\top,RGBA(245,245,245,255))
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(Border_Inner_Area\left,Border_Inner_Area\top,Border_Inner_Area\right-Border_Inner_Area\left,Border_Inner_Area\bottom-Border_Inner_Area\top,RGBA(0,0,0,255))
    
    If ListSize(pjGraph\Data_X()) > 1
      
      Count = ListSize(pjGraph\Data_X())
      SpacingX = DrawWidth / (Count-1)    
      SpacingY = DrawHeight / (Count-1)    
      
      For MyLoop = 1 To Count-2
        ;/ lines across...
        LineXY(Border_Inner_Area\left,Border_Inner_Area\top + (MyLoop * SpacingY),Border_Inner_Area\left+DrawWidth-1,Border_Inner_Area\top + (MyLoop * SpacingY),RGBA(0,0,0,255))
        ;/ lines down...
        LineXY(Border_Inner_Area\left + (MyLoop * SpacingX),Border_Inner_Area\top, Border_Inner_Area\left + (MyLoop * SpacingX),Border_Inner_Area\top + DrawHeight-1,RGBA(0,0,0,255))
      Next
      
    EndIf
    
  StopDrawing()
  
  If ListSize(pjGraph\Data_X()) > 1
    
    StartVectorDrawing(ImageVectorOutput(#Image_Graph))
    DrawVectorImage(ImageID(#Image_Graph))
    
    ;/ draw graph Title
    VectorFont(FontID(#GraphFont_Title))
    TmpX.f = ((Border_Inner_Area\Left + Border_Inner_Area\right) / 2.0) - (VectorTextWidth(pjGraph\Title)/2.0)
    MovePathCursor(TmpX,Border_Outer_Area\Top+1); + VectorTextHeight(pjGraph\Title))
    DrawVectorText(pjGraph\Title)
    
    
    ;/ draw axis titles
    VectorFont(FontID(#GraphFont_Axis))
    TmpX.f = ((Border_Inner_Area\Left + Border_Inner_Area\right) / 2.0) - (VectorTextWidth(pjGraph\Legend_X)/2.0)
    TmpY.f = ((Border_Inner_Area\top + Border_Inner_Area\bottom) / 2.0) + (VectorTextWidth(pjGraph\Legend_Y)/2.0)
    MovePathCursor(Border_Outer_Area\left + 1,TmpY)
    RotateCoordinates(Border_Outer_Area\left + 1,TmpY,-90)
    DrawVectorText(pjGraph\Legend_Y)
    ResetCoordinates()
    MovePathCursor(TmpX,Border_Outer_Area\bottom - VectorTextHeight(pjGraph\Legend_X))
    DrawVectorText(pjGraph\Legend_X)
    
    
    ;/ draw x axis legends
    VectorFont(FontID(#GraphFont_Legend))
    ForEach pjGraph\Data_X()
      ResetCoordinates()
      TmpX.f = Border_Inner_Area\Left + (ListIndex(pjGraph\Data_X()) * SpacingX)
      MovePathCursor((TmpX + VectorTextHeight(pjGraph\Data_X())/2)+2,Border_Inner_Area\bottom+2); + VectorTextWidth(pjGraph\Data_X()))
      RotateCoordinates(TmpX - VectorTextHeight(pjGraph\Data_X()),Border_Inner_Area\bottom,90)
      DrawVectorText(pjGraph\Data_X())
    Next

    ;/ draw Y axis legends
    
    ;/ get min / max values
    MinY = 999999 : MaxY = -999999
    ForEach pjGraph\Data_Y()
      If pjGraph\Data_Y() < MinY : MinY = pjGraph\Data_Y() : EndIf
      If pjGraph\Data_Y() > MaxY : MaxY = pjGraph\Data_Y() : EndIf
    Next
    
    MinVal = MinY
    MaxVal = MaxY
    
    ;/ add small value to Max Y...
    MaxY + 0.1
    
    ;/ Apply Red percentage to MinY and Roll down to nearest whole number.
    
    MinY * (pjGraph\Red_Value / 100.0)
    MinY  -0.4
    
    StrideY = (MaxY - MinY) / (Count-1)
    
    VectorFont(FontID(#GraphFont_Legend))
    ResetCoordinates()
    ForEach pjGraph\Data_Y()
      TmpY.f = Border_Inner_Area\Bottom - (ListIndex(pjGraph\Data_Y()) * SpacingY)
      Txt = StrF(MinY + (StrideY * ListIndex(pjGraph\Data_Y())),1)
      MovePathCursor(Border_Inner_Area\Left-(VectorTextWidth(Txt) + 3),TmpY - (VectorTextHeight(Txt)/2.0)); + VectorTextWidth(pjGraph\Data_X()))
      DrawVectorText(Txt)
    Next
    
    ScaleY = (Border_Inner_Area\Bottom - Border_Inner_Area\Top) / (MaxY - MinY)
    
    ;/ plot graph points
    VectorSourceColor(RGBA(0,80,230,255))
    ForEach pjGraph\Data_Y()
      ;/ where does this value sit on the scale?
      TmpX.f = Border_Inner_Area\Left + (ListIndex(pjGraph\Data_Y()) * SpacingX)
      TmpY = Border_Inner_Area\Bottom - ((pjGraph\Data_Y() - MinY) * ScaleY)
      If ListIndex(pjGraph\Data_Y()) = 0
        MovePathCursor(TmpX,TmpY)
      Else
        AddPathLine(TmpX,TmpY)
      EndIf
    Next
    StrokePath(3 * FontScale)

    ForEach pjGraph\Data_Y()
      TmpX.f = Border_Inner_Area\Left + (ListIndex(pjGraph\Data_Y()) * SpacingX)
      TmpY = Border_Inner_Area\Bottom - ((pjGraph\Data_Y() - MinY) * ScaleY)
      VectorSourceCircularGradient(TmpX,TmpY,7 * Fontscale,2,-1)
      VectorSourceGradientColor(RGBA(255, 255, 255, 200), 0.0)
      VectorSourceGradientColor(RGBA(255, 255, 255, 200), 0.25)
      VectorSourceGradientColor(RGBA(0, 80, 255, 200), 1.0)
      AddPathCircle(TmpX,TmpY,7 * FontScale)
      FillPath()
    Next
    
    If pjGraph\Show_WarningLines = #True
      
      ;/ Amber Line
      TmpY = Border_Inner_Area\Bottom - ((MaxVal * (pjGraph\Amber_Value / 100.0) - MinY) * ScaleY)
      VectorSourceColor(RGBA(255,160,20,200))
      MovePathCursor(Border_Inner_Area\left,TmpY)
      AddPathLine(Border_Inner_Area\Right-1,TmpY)
      StrokePath(4.0 * FontScale)
      
      VectorSourceColor(RGBA(0,0,0,255))
      VectorFont(FontID(#GraphFont_Warnings))
      MovePathCursor(Border_Inner_Area\Right - (VectorTextWidth(Str(pjGraph\Amber_Value)+"% ")), Tmpy - (VectorTextHeight(Str(pjGraph\Amber_Value))+1))
      DrawVectorText(Str(pjGraph\Amber_Value)+"%")
      
      TmpY = Border_Inner_Area\Bottom - ((MaxVal * (pjGraph\Red_Value / 100.0) - MinY) * ScaleY)
      VectorSourceColor(RGBA(255,20,20,200))
      MovePathCursor(Border_Inner_Area\left,TmpY)
      AddPathLine(Border_Inner_Area\Right-1,TmpY)
      StrokePath(4.0 * FontScale)
      
      VectorSourceColor(RGBA(0,0,0,255))
      MovePathCursor(Border_Inner_Area\Right - (VectorTextWidth(Str(pjGraph\Red_Value)+"% ")), Tmpy - (VectorTextHeight(Str(pjGraph\Red_Value))+1))
      DrawVectorText(Str(pjGraph\Red_Value)+"%")
    EndIf
    
    StopVectorDrawing()
  EndIf
  
  SetGadgetAttribute(#Gad_Canvas_Graph,#PB_Canvas_Image,ImageID(#Image_Graph))
  
EndProcedure

Procedure pjGraph_LoadExampleData()
  Protected Count.i, MyLoop.i
  
  ;/ load up example data
  pjGraph\Width = GadgetWidth(#Gad_Canvas_Graph)
  pjGraph\Height = GadgetHeight(#Gad_Canvas_Graph)
  
  pjGraph\Style = #pjGraph_Style_Original
  
  pjGraph\Title = "ロールID: TR1000"
  pjGraph\Legend_X = "読書日";"Reading Date"
  pjGraph\Legend_Y = "体積 (cm3/m2)"
  
  Restore GraphData
  
  Read.i Count
  ClearList(pjGraph\Data_X())
  For MyLoop = 0 To Count-1
    AddElement(pjGraph\Data_X())
    Read.s pjGraph\Data_X()
  Next
  ClearList(pjGraph\Data_Y())
  For MyLoop = 0 To Count-1
    AddElement(pjGraph\Data_Y())
    Read.f pjGraph\Data_Y()
  Next
  
  pjGraph\Show_WarningLines = #True
  pjGraph\Amber_Value = 84
  pjGraph\Red_Value = 75
  
EndProcedure

Procedure Init_Main()

  OpenWindow(#Window_Main,0,0,1024,768,"Self Draw Graph Window",#PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
  CanvasGadget(#Gad_Canvas_Graph,0,0,1024,768)  
  
  System\Refresh = #True
EndProcedure

Init_Main()

Repeat
  System\Event = WaitWindowEvent()

  Select System\Event
    Case #PB_Event_CloseWindow
      System\Exit = #True
      Debug "Close window"
      
    Case #PB_Event_SizeWindow
      System\Refresh = #True
      ResizeGadget(#Gad_Canvas_Graph,#PB_Ignore,#PB_Ignore,WindowWidth(#Window_Main),WindowHeight(#Window_Main))
    Case #PB_Event_Gadget
      Select EventGadget()
          
      EndSelect
  EndSelect
  
  If System\Refresh = #True
    System\Refresh = #False
    pjGraph_LoadExampleData()
    pjGraph_Render()
    Debug "Render"
  EndIf
  
Until System\Exit = #True

End

DataSection
  Graphdata:
  Data.i 10
  Data.s "03/2011","04/2013","08/2013","03/2014","06/2014","11/2014","01/2015","05/2015","09/2015","02/2016"  
  Data.f 5.5, 5.2, 5.1, 5.0, 4.9, 4.9, 4.8, 4.7, 4.6, 4.5 ;/ 
EndDataSection


; IDE Options = PureBasic 5.71 beta 2 LTS (Windows - x86)
; CursorPosition = 219
; FirstLine = 196
; Folding = --
; EnableXP