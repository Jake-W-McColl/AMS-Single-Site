;Funktionsbibliothek (made COMate) zu Excel für PB 4.5X

;Autor Falko
;Letzte Änderung 07.09.2010

;Ursprüngliche ExcelFunktionen mit Disphelper habe ich nun
;auf COMatePlus umgeschrieben.

;Disphelper-Funktionen:
;http://www.purebasic.fr/german/viewtopic.php?p=158777#158777

;COMate-Funktionen:
;http://www.purebasic.fr/german/viewtopic.php?p=239466#239466

;Die Comate-lib, die hierzu benötigt wird, bitte hier von srod's HP herunterladen:
;http://www.purecoder.net/comate.htm

;Danke an alle, die mir schon beim Disphelper und Excel geholfen haben.

;Einen persönicher Dank von mir an ts-soft und Kiffi, die mir
;bei der Disphelperanpassung für die Excelfunktionen, sowie ihre weiteren, neuen
;Excelfunktionen (Codes), unterstützt haben.

;Ein weiterer persönlicher Dank geht an
;MK-Soft (Purebasic Disphelper und vieles mehr)
;shic (prima Tips zu Excel)
;mueckerich ( für seine klitzekleine Änderung zu SaveWorkbooks)
;srod ( für seine aktuelle COMate-Lib )
;marco2007 (MarkCellsRight() funktioniert jetzt perfekt)
;ThoPie (Einige Anregungen und Präfixe auf Wunsch hinzugefügt)
;Dazu noch einige Funktionen aus seinen Tips erweitert. Danke, ThoPie
;Um diese Funktionen anzuwenden, braucht ihr folgende Lib:
;http://www.purecoder.net/comate.htm

EnableExplicit

;IncludePath #PB_Compiler_Home+"COMatePlus"
;XIncludeFile "COMatePlus.pbi"

Define.l Pattern, ExcelAPP, Sheets, SheetN, n
Define.s StandardFile, sPattern, Datei, StandardFile, Text


Procedure XLSFunc_OpenExcelFile(Datei.s); Open ExcelFile
  Protected ExcelObject.COMateObject ,Workbook
  ExcelObject = COMate_CreateObject("Excel.Application")
  If ExcelObject
      ExcelObject\Invoke("Workbooks\Open('"+Datei+"')")
  Else
    MessageRequester("Achtung","Bitte geben Sie eine vorhandene xls-Datei mit Pfad an!")
  EndIf
  ProcedureReturn ExcelObject
EndProcedure

Procedure XLSFunc_CreateExcelFile(Datei.s); Create a new Excelfile
  Protected ExcelObject.COMateObject,Workbook
  ExcelObject = COMate_CreateObject("Excel.Application")
  If ExcelObject
      WorkBook = ExcelObject\GetObjectProperty("Workbooks\Add")
      ;SetCurrentDirectory(Datei)
  EndIf
  ProcedureReturn ExcelObject
EndProcedure

Procedure XLSFunc_OpenExcelFileNext(ExcelObject.COMateObject,Datei.s)
  If ExcelObject
    ExcelObject\Invoke("Workbooks\Open('"+Datei+"')")
  EndIf
  ProcedureReturn ExcelObject
EndProcedure

Procedure XLSFunc_ExcelVisible(ExcelObject.COMateObject,Wert.l);To visible Excel #True or #False
  If Wert=#True
    ExcelObject\SetProperty("Visible = #True")
  ElseIf Wert=#False
    ExcelObject\SetProperty("Visible = #False")
  EndIf
EndProcedure

Procedure.s XLSFunc_ReadCellS(ExcelObject.COMateObject, Row.l,Column.l)
  Protected ReturnValue.s, Resume.s
  ReturnValue = ExcelObject\GetStringProperty("Cells("+ Str(Row)+","+Str(Column)+")\Value")
  ProcedureReturn ReturnValue
EndProcedure

Procedure XLSFunc_WriteCellS(ExcelObject.COMateObject, Row.l, Column.l, NewValue.s); Row & Column (Row & Column) must be non Alpha
  ExcelObject\SetProperty("Cells("+ Str(Row)+","+Str(Column)+")\Value = '" + NewValue + "'") 
EndProcedure

Procedure XLSFunc_WriteCellZ(ExcelObject.COMateObject, Row.i, Column.i, NewValue.d); Row & Column (Row & Column) must be non Alpha
  ExcelObject\SetProperty("Cells("+ Str(Row)+","+Str(Column)+")\Value="+StrD(NewValue)) 
EndProcedure

Procedure XLSFunc_SetColumnWidth(ExcelObject.COMateObject, Range.s,Width.f); Set ColumnWidth to one or more Columns
  ExcelObject\Invoke("Columns('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\ColumnWidth="+Str(Width))
EndProcedure

Procedure XLSFunc_SetRowsHeight(ExcelObject.COMateObject, Range.s,Height.f); Set Height on rang to rows
  ExcelObject\Invoke("Rows('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\RowHeight="+Str(Height))
EndProcedure

Procedure XLSFunc_SetRowHeight(ExcelObject.COMateObject, Range.s,Height.f); Set Height to one or all Rows
  ExcelObject\Invoke("Row('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\RowHeight="+Str(Height))
EndProcedure
Procedure XLSFunc_SetRowAutoFit(ExcelObject.COMateObject, Range.s)
;  ExcelObject\Invoke("Row('"+Range+"')\Select")
  ExcelObject\Invoke("Columns('"+Range+"')\AutoFit()")
  Debug "Columns('"+Range+"')\AutoFit()"
;  ExcelObject\SetProperty("Selection\RowHeight="+Str(Height))
EndProcedure
Procedure.s XLSFunc_ReadLeftHeader(ExcelObject.COMateObject)
  Protected ReturnValue.s, Resume.s
  ReturnValue = ExcelObject\GetStringProperty("ActiveSheet\PageSetup\LeftHeader")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.s XLSFunc_ReadCenterHeader(ExcelObject.COMateObject)
  Protected ReturnValue.s, Resume.s
  ReturnValue = ExcelObject\GetStringProperty("ActiveSheet\PageSetup\CenterHeader")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.s XLSFunc_ReadRightHeader(ExcelObject.COMateObject)
  Protected ReturnValue.s
  ReturnValue = ExcelObject\GetStringProperty("ActiveSheet\PageSetup\RightHeader")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.s XLSFunc_ReadLeftFooter(ExcelObject.COMateObject)
  Protected ReturnValue.s
  ReturnValue = ExcelObject\GetStringProperty("ActiveSheet\PageSetup\LeftFooter")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.s XLSFunc_ReadCenterFooter(ExcelObject.COMateObject)
  Protected ReturnValue.s
  ReturnValue = ExcelObject\GetStringProperty("ActiveSheet\PageSetup\CenterFooter")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.s XLSFunc_ReadRightFooter(ExcelObject.COMateObject)
  Protected ReturnValue.s
  ReturnValue = ExcelObject\GetStringProperty("ActiveSheet\PageSetup\RightFooter")
  ProcedureReturn ReturnValue
EndProcedure

Procedure XLSFunc_WriteLeftHeader(ExcelObject.COMateObject, Text.s)
  ExcelObject\SetProperty("ActiveSheet\PageSetup\LeftHeader='"+Text+"'")
EndProcedure

Procedure XLSFunc_WriteCenterHeader(ExcelObject.COMateObject, Text.s)
  ExcelObject\SetProperty("ActiveSheet\PageSetup\CenterHeader='"+Text+"'")
EndProcedure

Procedure XLSFunc_WriteRightHeader(ExcelObject.COMateObject, Text.s)
  ExcelObject\SetProperty("ActiveSheet\PageSetup\RightHeader='"+Text+"'")
EndProcedure

Procedure XLSFunc_WriteLeftFooter(ExcelObject.COMateObject, Text.s)
  ExcelObject\SetProperty("ActiveSheet\PageSetup\LeftFooter='"+Text+"'")
EndProcedure

Procedure XLSFunc_WriteCenterFooter(ExcelObject.COMateObject, Text.s)
  ExcelObject\SetProperty("ActiveSheet\PageSetup\CenterFooter='"+Text+"'")
EndProcedure

Procedure XLSFunc_WriteRightFooter(ExcelObject.COMateObject, Text.s)
  ExcelObject\SetProperty("ActiveSheet\PageSetup\RightFooter='"+Text+"'") 
EndProcedure

Procedure XLSFunc_DisplayAlertsOnOff(ExcelObject.COMateObject,Wert.l); Set #True or #False for Displayalerts on/off
If Wert=#True
   ExcelObject\SetProperty("Application\DisplayAlerts = #True")
ElseIf Wert=#False
   ExcelObject\SetProperty("Application\DisplayAlerts = #False")
EndIf
EndProcedure

Procedure XLSFunc_CloseExcelAll(ExcelObject.COMateObject)
  ExcelObject\Invoke("Quit()") ; Close Excel
  ExcelObject\Release()  ; ExcelObject freigeben
EndProcedure

Procedure XLSFunc_CloseWorkbook(ExcelObject.COMateObject)
  Protected Workbook.COMateObject
  Workbook=ExcelObject\GetObjectProperty("ActiveWorkbook")
  If Workbook
    Workbook\Invoke("Close"); Close Excel Worksheet
    Workbook\Release() ;Workbook freigeben
  EndIf
EndProcedure

Procedure XLSFunc_SaveWorkbook(ExcelObject.COMateObject,Value.l=#False)
  Protected Workbook.COMateObject
  Workbook=ExcelObject\GetObjectProperty("ActiveWorkbook")
  If Workbook
    Workbook\Invoke("Save");Save Excel Workbook
    Workbook\Release()     ;Workbook Freigeben
  EndIf
EndProcedure

Procedure XLSFunc_SaveAsWorkbook(ExcelObject.COMateObject,Datei.s,FFormat=#xlNormal)
  Protected Workbook.COMateObject
  Workbook=ExcelObject\GetObjectProperty("ActiveWorkbook")
  If Workbook
   ; Workbook\Invoke("SaveAs('"+Datei+"')") ; replaced this to next line source with Filefomat for another Formats (12.03.2011)
    Workbook\Invoke("SaveAs('"+Datei+"', " + Str(FFormat) + ")") ;Save As #xlNormal or #xlCSV or another CSV (MSDOS or Windows)
    Workbook\Release()     ;Workbook Freigeben
  EndIf
EndProcedure

Procedure XLSFunc_SaveWorkbookAs(ExcelObject.COMateObject, FileName.s,FFormat=#xlNormal); Save WorkSheet as FileFormat
  Protected Workbook.COMateObject
  Workbook=ExcelObject\GetObjectProperty("ActiveWorkbook")
  If FileName <> ""
      If Workbook
         Workbook\Invoke("SaveAs('"+FileName+"', " + Str(FFormat) + ")") ;Save As #xlNormal or #xlCSV or another CSV (MSDOS or Windows)
         Workbook\Release();WorkBook freigeben
      EndIf
    EndIf
EndProcedure

Procedure XLSFunc_WriteToWorksheet(ExcelObject.COMateObject,Name.s,Row.l, Column.l, NewValue.s);Row & Column (Row & Column) must be none Alpha
  ExcelObject\SetProperty("Worksheets('"+Name+"')\Cells("+ Str(Row)+","+Str(Column)+")\Value = '"+NewValue+"'") 
EndProcedure

Procedure XLSFunc_ChangeToWorksheet(ExcelObject.COMateObject,Name.s); Change worksheet
  ExcelObject\Invoke("Worksheets('"+Name+"')\Select")
EndProcedure
   
Procedure.s XLSFunc_GetSheetName(ExcelObject.COMateObject,Num.l)
  Protected ReturnValue.s
  ReturnValue=ExcelObject\GetStringProperty("Worksheets("+Str(Num)+")\Name")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.s XLSFunc_GetWorkbookName(ExcelObject.COMateObject)
  Protected ReturnValue.s
   ReturnValue=ExcelObject\GetStringProperty("ActiveWorkbook\Name")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.l XLSFunc_CountSheets(ExcelObject.COMateObject)   ;    Counting all Sheets
  Protected ReturnValue.l
  ReturnValue=ExcelObject\GetIntegerProperty("Worksheets\Count")
  ProcedureReturn ReturnValue
EndProcedure

Procedure XLSFunc_AddWorksheetBefore(ExcelObject.COMateObject); New Worksheet before active Worksheet
   ExcelObject\invoke("Worksheets\Add")
EndProcedure

Procedure XLSFunc_AddWorksheetAfter(ExcelObject.COMateObject, NewSheetName.s = "");New Worksheet after last Worksheet
  ; Thanks Kiffi for your help to this Function AddWorksheetAfter
  Protected LastSheet.COMateObject, NewSheet.COMateObject

  ; Letztes Sheet ermitteln
  LastSheet = ExcelObject\GetObjectProperty("Sheets(" + Str(ExcelObject\GetintegerProperty("Sheets\Count")) + ")")

  ; Neues Sheet hinter dem letzten Sheet erstellen
  NewSheet = ExcelObject\GetObjectProperty("Sheets\Add(#Optional, " + Str(LastSheet) + " As COMateObject)")
 
  ; Optional: Namen des neuen Sheets setzen
  If NewSheetName <> ""
    NewSheet\SetProperty("Name = '" + NewSheetName + "'")
  EndIf

  ; NewSheet-Objekt freigeben
  NewSheet\Release()
   
  ; LastSheet-Objekt freigeben
  LastSheet\Release()

EndProcedure

Procedure XLSFunc_RenameActiveSheet(ExcelObject.COMateObject,Name.s)
   ExcelObject\SetProperty("ActiveSheet\Name('"+Name+"')")
EndProcedure

Procedure XLSFunc_SetColor(ExcelObject.COMateObject, Range.s, cRed.l, cGreen.l, cBlue.l); Set color in Cells
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\Interior\Color = "+Str(RGB(cRed,cGreen,cBlue)))
  ExcelObject\SetProperty("Selection\Interior\Pattern ="+Str(#xlPatternSolid))
EndProcedure

Procedure XLSFunc_SetRGBtoColorindex(ExcelObject.COMateObject,ColorIndex.l,cRed.l,cGreen.l,cBlue.l); You can change all the 56 Excelindexes of Colors
  ExcelObject\SetProperty("ActiveWorkbook\Colors("+Str(ColorIndex)+") = "+Str(RGB(cRed,cGreen,cBlue)))
EndProcedure

Procedure.l XLSFunc_GetColor(ExcelObject.COMateObject,Range.s)   ;    Get Color from Cells
  Protected ReturnValue.l
   ExcelObject\Invoke("Range('"+Range+"')\Select")
   ReturnValue = ExcelObject\GetRealProperty("Activecell\Interior\Color")
   ProcedureReturn ReturnValue
EndProcedure

Procedure.l XLSFunc_GetColorIndex(ExcelObject.COMateObject,Range.s)   ;    Get active Colorindex from Cells
  Protected ReturnValue.l
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  ReturnValue = ExcelObject\GetRealProperty("Activecell\Interior\Colorindex")
  ProcedureReturn ReturnValue
EndProcedure

Procedure XLSFunc_ColorOff(ExcelObject.COMateObject, Range.s); Erase color in Cells (Falko)
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\Interior\Pattern = "+Str(#xlColorIndexNone))
EndProcedure

Structure MyVariant
StructureUnion
  l.l
EndStructureUnion
EndStructure

Procedure XLSFunc_LinienEinAus(ExcelObject.COMateObject) ; Skip the lines on or off
    Protected *Linestyles.MyVariant
    *Linestyles=ExcelObject\GetVariantProperty("Selection\Borders\Linestyle")
    If *Linestyles\l = #xlContinuous
       ExcelObject\SetProperty("Selection\Borders\LineStyle = "+Str(#xlLineStyleNone))
    Else
       ExcelObject\SetProperty("Selection\Borders\LineStyle = "+Str(#xlContinuous))
       ExcelObject\SetProperty("Selection\Borders\Weight=+"+Str(#xlMedium))   
    EndIf
EndProcedure 

Procedure XLSFunc_MarkCellsRight(ExcelObject.COMateObject,Offset_Row.l=0,Offset_Column.l=0,Offset_Row1.l=0,Offset_Column1.l=0); Marks an offset from active Cell right from there
  ;Thanks marco2007 (german forum)
  Protected.COMateObject active
  Protected.s actadress,Range1,Range2,Range
  active = ExcelObject\GetObjectProperty("ActiveCell")
  actadress=active\GetStringProperty("address")
  If active
    Range1=active\GetStringProperty("Offset("+Str(Offset_Row)+","+Str(Offset_Column)+")\address"):Debug Range1
    Range2=active\GetStringProperty("Offset("+Str(Offset_Row1)+","+Str(Offset_Column1)+")\address"):Debug Range2
    Range=RemoveString(Range1+":"+Range2,"$"):Debug Range
    ExcelObject\Invoke("Range('"+Range+"')\Select")
    Debug "MarkCellsRight(): "+COMate_GetLastErrorDescription()
    active\Release()
  EndIf
EndProcedure

Procedure XLSFunc_ScreenUpdating(ExcelObject.COMateObject,Wert.l) ;/ NOT PART OF THE MAIN BUNDLE!
  ; Turn screen updating off (#False) To speed up your code. You won't be able to see what the code is doing, but it will run faster.
  ; Remember To set the ScreenUpdating property back To #True when your code ends.
  If Wert=#True
    ExcelObject\SetProperty("Application\ScreenUpdating=#True")
  ElseIf Wert=#False
    ExcelObject\SetProperty("Application\ScreenUpdating=#False")
  EndIf
EndProcedure

Procedure XLSFunc_SelectCells(ExcelObject.COMateObject, Range.s); Select Cells
  ExcelObject\Invoke("Range('"+Range+"')\Select")
EndProcedure

Procedure XLSFunc_ActivateCell(ExcelObject.COMateObject, Range.s); Activate Cell
  ExcelObject\Invoke("Range('"+Range+"')\Activate")
EndProcedure

Procedure XLSFunc_AskToUpdateLinks(ExcelObject.COMateObject,Wert.l)     ;Fremdbezüge ein-, bzw. ausschalten       ;AskToUpdateLinks on / off with #True or #False
  ExcelObject\SetProperty("AskToUpdateLinks = "+Str(Wert))
EndProcedure

Procedure XLSFunc_PageSetup(ExcelObject.COMateObject,Orient.l=#xlPortrait,Left.d=1.3,Right.d=1.5,Top.d=2.0,Bottom.d=2.0,Header.d=1,Footer.d=1,HorCenter.b=#False,VertCenter.b=#False);  xlLandscape Or xlPortrait
   Protected.COMateObject active
   Protected.d LeftM,RightM,TopM,ButtomM,HeaderM,FooterM
   
   active = ExcelObject\GetObjectProperty("ActiveSheet")
   
   If active
     active\SetProperty("PageSetup\Orientation="+Str(Orient))
     LeftM=ExcelObject\GetRealProperty("Application\CentimetersToPoints("+StrD(Left)+")")
     active\SetProperty("PageSetup\LeftMargin="+StrD(LeftM))
     RightM=ExcelObject\GetRealProperty("Application\CentimetersToPoints("+StrD(Right)+")")
     active\SetProperty("PageSetup\RightMargin="+StrD(RightM))
     TopM=ExcelObject\GetRealProperty("Application\CentimetersToPoints("+StrD(Top)+")")
     active\SetProperty("PageSetup\TopMargin="+StrD(TopM))
     ButtomM=ExcelObject\GetRealProperty("Application\CentimetersToPoints("+StrD(Bottom)+")")
     active\SetProperty("PageSetup\BottomMargin="+StrD(ButtomM))
     HeaderM=ExcelObject\GetRealProperty("Application\CentimetersToPoints("+StrD(Header)+")")
     active\SetProperty("PageSetup\HeaderMargin="+StrD(HeaderM))
     FooterM=ExcelObject\GetRealProperty("Application\CentimetersToPoints("+StrD(Footer)+")")
     active\SetProperty("PageSetup\FooterMargin="+StrD(FooterM))
     active\SetProperty("PageSetup\CenterHorizontally="+Str(HorCenter))
     active\SetProperty("PageSetup\CenterVertically="+Str(VertCenter))
     ;Debug "CenterVertically: "+COMate_GetLastErrorDescription() 
   EndIf
   
   active\Release()
EndProcedure

Procedure XLSFunc_SetBorders(ExcelObject.COMateObject, Range.s, NBorder.l, NLineStyles.l,LineThick.l, ColorIndex.l,OmitRange=0) ; create a border
; Set Bit to LineStyle on Variable Wert

; Bit 1 set DiagonalDown (1)
; Bit 2 set DiagonalUp   (2)
; Bit 3 set EdgeLeft     (4)
; Bit 4 set EdgeTop      (8)
; Bit 5 set EdgeBottom   (16)
; Bit 6 set EdgeRight    (32)
; Bit 7 set InsideVertical(64)
; Bit 8 set InsideHorizontal(128)



; %00111100 or 60; at all Sites a Line.

; LineThick :#xlHairline,#xlSolid ,#xlMedium Or #xlThick
; LineStyle: #xlLineStyleNone, #xlDouble,#xlDash,#xlDashDot,#xlDashDotDot,#xlDot,#xlAutomatic,#xlLineStyleNone,#xlSlantDashDot

  If OmitRange = 0 : ExcelObject\Invoke("Range('"+Range+"')\Select") : EndIf
  ;dhCallMethod(*obj, ".Range(%T).Select", @Range)
  If NBorder &1
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalDown)+")\LineStyle = "+Str(NLineStyles))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalDown)+")\ColorIndex = "+Str(ColorIndex))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalDown)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalDown)+")\Weight = "+Str(LineThick))
  EndIf
  If NBorder &2
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalUP)+")\LineStyle = "+Str(NLineStyles))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalUP)+")\ColorIndex = "+Str(ColorIndex))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalUP)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalUP)+")\Weight = "+Str(LineThick))
  EndIf
   If NBorder &4
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\LineStyle = "+Str(NLineStyles))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\ColorIndex = "+Str(ColorIndex))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\Weight = "+Str(LineThick))
   EndIf
  If NBorder &8
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeTop)+")\LineStyle = "+Str(NLineStyles))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeTop)+")\ColorIndex = "+Str(ColorIndex))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeTop)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeTop)+")\Weight = "+Str(LineThick))
  EndIf
  If NBorder &16
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeBottom)+")\LineStyle = "+Str(NLineStyles))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeBottom)+")\ColorIndex = "+Str(ColorIndex))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeBottom)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeBottom)+")\Weight = "+Str(LineThick))
  EndIf
  If NBorder &32
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeRight)+")\LineStyle = "+Str(NLineStyles))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeRight)+")\ColorIndex = "+Str(ColorIndex))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeRight)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeRight)+")\Weight = "+Str(LineThick))
  EndIf
  If NBorder &64
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideVertical)+")\LineStyle = "+Str(NLineStyles))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideVertical)+")\ColorIndex = "+Str(ColorIndex))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideVertical)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideVertical)+")\Weight = "+Str(LineThick))
  EndIf
  If NBorder &128
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideHorizontal)+")\LineStyle = "+Str(NLineStyles))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideHorizontal)+")\ColorIndex = "+Str(ColorIndex))
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideHorizontal)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideHorizontal)+")\Weight = "+Str(LineThick))
  EndIf
   
EndProcedure

Procedure XLSFunc_EraseBorders(ExcelObject.COMateObject,Range.s,NBorder.l) ; Erase a borders
; Set Bit to LineStyle on Variable Wert

; Bit 1 set DiagonalDown (1)
; Bit 2 set DiagonalUp   (2)
; Bit 3 set EdgeLeft     (4)
; Bit 4 set EdgeTop      (8)
; Bit 5 set EdgeBottom   (16)
; Bit 6 set EdgeRight    (32)
; Bit 7 set InsideVertical(64)
; Bit 8 set InsideHorizontal(128)
 
  ExcelObject\invoke("Range('"+Range+"')\Select")   
  If NBorder &1
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalDown)+")\LineStyle = "+Str(#xlLineStyleNone))
  EndIf
  If NBorder &2
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalUp)+")\LineStyle = "+Str(#xlLineStyleNone))
  EndIf
  If NBorder &4
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\LineStyle = "+Str(#xlLineStyleNone))
  EndIf
  If NBorder &8
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeTop)+")\LineStyle = "+Str(#xlLineStyleNone))
  EndIf
  If NBorder &16
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeBottom)+")\LineStyle = "+Str(#xlLineStyleNone))
  EndIf
  If NBorder &32   
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeRight)+")\LineStyle = "+Str(#xlLineStyleNone))
  EndIf
  If NBorder &64
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideVertical)+")\LineStyle = "+Str(#xlLineStyleNone))
  EndIf
  If NBorder &128
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideHorizontal)+")\LineStyle = "+Str(#xlLineStyleNone))
  EndIf
EndProcedure

Procedure XLSFunc_MergeCells(ExcelObject.COMateObject, Range.s,Wert.l) ; merge or unmerge Cells, use #True or #False
ExcelObject\Invoke("Range('"+Range+"')\Select")
If Wert=#True
   ExcelObject\Invoke("Selection\Merge")
EndIf
If Wert=#False
   ExcelObject\Invoke("Selection\UnMerge")
EndIf
EndProcedure

Procedure XLSFunc_InsertRow(ExcelObject.COMateObject,Range.s,Wert.b) ;         insert or delete Row, use #True or #False
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  If Wert=#True
    ExcelObject\Invoke("Selection\EntireRow\Insert")
  ElseIf Wert=#False
    ExcelObject\Invoke("Selection\EntireRow\Delete")
  EndIf
EndProcedure

Procedure XLSFunc_InsertColumn(ExcelObject.COMateObject,Range.s,Wert.b);       insert or delete Column, use #True or #False
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  If Wert=#True
    ExcelObject\Invoke("Selection\EntireColumn\Insert")
  ElseIf Wert=#False 
    ExcelObject\Invoke("Selection\EntireColumn\Delete") 
  EndIf
EndProcedure   

Procedure XLSFunc_InsertCell(ExcelObject.COMateObject,Range.s,Wert.b)        ;Insert Cells  and shift right or down with Wert 0 or 1
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  If Wert=0
   ExcelObject\Invoke("Selection\Insert("+Str(#xlToRight)+")")
  ElseIf Wert=1
      ExcelObject\Invoke("Selection\Insert("+Str(#xlDown)+")")
  EndIf
EndProcedure

Procedure XLSFunc_DeleteCell(ExcelObject.COMateObject,Range.s,Wert.b)        ;Delete Cells and shift left Or up with Wert 0 or 1
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  If Wert=0
     ExcelObject\Invoke("Selection\Delete("+Str(#xlToLeft)+")")
  ElseIf Wert=1
    ExcelObject\Invoke("Selection\Delete("+Str(#xlUp)+")")
  EndIf
EndProcedure

Procedure XLSFunc_Pattern(ExcelObject.COMateObject,Range.s,Pattern.l,PatternColor.l,OnOff.b) ; PatternColor=RGB() 
Protected pat.l
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  Select Pattern
    Case 1
      pat = #xlPatternAutomatic
    Case 2
      pat = #xlPatternChecker
    Case 3
      pat = #xlPatternCrissCross
    Case 4
      pat = #xlPatternDown
    Case 5
      pat = #xlPatternGray16
    Case 6
      pat = #xlPatternGray25
    Case 7
      pat = #xlPatternGray50
    Case 8
      pat = #xlPatternGray75
    Case 9
      pat = #xlPatternGray8
    Case 10
      pat = #xlPatternGrid
    Case 11
      pat = #xlPatternHorizontal
    Case 12
      pat = #xlPatternLightDown
    Case 13
      pat = #xlPatternLightHorizontal
    Case 14
      pat = #xlPatternLightUp
    Case 15
      pat = #xlPatternSemiGray75
    Case 16
      pat = #xlPatternSolid
    Case 17
      pat = #xlPatternUp
    Case 18
      pat = #xlPatternVertical
   EndSelect
   If OnOff=#True
     ExcelObject\SetProperty("Selection\Interior\PatternColor = "+Str(PatternColor))
     ExcelObject\SetProperty("Selection\Interior\Pattern = "+Str(pat))
   ElseIf OnOff=#False
     ExcelObject\SetProperty("Selection\Interior\PatternColor = "+Str(#xlTickLabelOrientationAutomatic))
     ExcelObject\SetProperty("Selection\Interior\Pattern = "+Str(#xlPatternNone))
   EndIf
EndProcedure

Procedure XLSFunc_SetFont(ExcelObject.COMateObject, Range.s,Name.s="Arial",Size.l=10,Style.s="Standard")
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\Font\Name = '"+Name+"'")
  ExcelObject\SetProperty("Selection\Font\FontStyle = '"+Style+"'")
  ExcelObject\SetProperty("Selection\Font\Size = "+Str(Size))
  ExcelObject\SetProperty("Selection\Font\Strikethrough = #False")
  ExcelObject\SetProperty("Selection\Font\Superscript = #False")
  ExcelObject\SetProperty("Selection\Font\Supscript = #False")
  ExcelObject\SetProperty("Selection\Font\OutlineFont = #False")
  ExcelObject\SetProperty("Selection\Font\Shadow = #False")
  ExcelObject\SetProperty("Selection\Font\ThemeColor = xlThemeColorLight1")
  ExcelObject\SetProperty("Selection\Font\TintAndShade = 0")
  ExcelObject\SetProperty("Selection\Font\ThemeFont = xlThemeFontNone")
EndProcedure

Procedure XLSFunc_SetFontSize(ExcelObject.COMateObject, Range.s,Size.l=10)
  ExcelObject\Invoke("Range('"+Range+"')\Select") 
  ExcelObject\SetProperty("Selection\Font\Size = '"+Str(Size))
EndProcedure

Procedure XLSFunc_SetFontStyle(ExcelObject.COMateObject, Range.s,Underline.l=#xlUnderlineStyleNone,Bold.l=#False,Italic.l=#False)
  ;For Underline you can set:
  ;#xlUnderlineStyleDouble
  ;#xlUnderlineStyleDoubleAccounting
  ;#xlUnderlineStyleNone
  ;#xlUnderlineStyleSingle
  ;#xlUnderlineStyleSingleAccounting
  ExcelObject\Invoke("Range('"+Range+"')\Select") 
  ExcelObject\SetProperty("Selection\Font\Bold ="+Str(Bold))
  ExcelObject\SetProperty("Selection\Font\Italic ="+Str(Italic))
  ExcelObject\SetProperty("Selection\Font\Underline ="+Str(Underline))
EndProcedure

Procedure XLSFunc_SetFontAlignment(ExcelObject.COMateObject, Range.s,HorAlignment.l=#xlHAlignLeft ,VertAlignment.l=#xlHAlignCenter)
  ;set ...Alignment with folow variable:
  ;#xlVAlignDistributed
  ;#xlVAlignJustify
  ;#xlHAlignCenter
  ;#xlVAlignBottom
  ;#xlVAlignTop
  ;#xlHAlignLeft
  ;#xlHAlignRight
  ExcelObject\Invoke("Range('"+Range+"')\Select") 
  ExcelObject\SetProperty("Selection\VerticalAlignment = "+Str(HorAlignment))
  ExcelObject\SetProperty("Selection\HorizontalAlignment = "+Str(HorAlignment))
EndProcedure

Procedure XLSFunc_AddComment(ExcelObject.COMateObject, Range.s, MyComment.s, Visible.l=#False); Write comments to cells
  ExcelObject\Invoke("Range('"+Range+"')\AddComment('"+MyComment+"')")
  ExcelObject\SetProperty("Range('"+Range+"')\Comment\Visible = "+Str(Visible))
EndProcedure

Procedure XLSFunc_SetCellFormat(ExcelObject.COMateObject, Range.s, Format.s);Set another format to Cells
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\NumberFormat = '"+Format+"'")
EndProcedure

Procedure.s XLSFunc_RowCol2Range(Row.i,Col.i)
  Protected Ganz.i,Rest.i,Range.s
  If Col<=26
    Range=Chr(Col+64)+Str(Row)
  Else
    Rest=Col%26
    Ganz=(Col-Rest)/26
    Range=Chr(Ganz+64)+Chr(Rest+64)+Str(Row)
  EndIf
  ProcedureReturn Range
EndProcedure
; IDE Options = PureBasic 5.71 beta 1 LTS (Windows - x86)
; CursorPosition = 344
; FirstLine = 340
; Folding = --------DAg
; EnableXP