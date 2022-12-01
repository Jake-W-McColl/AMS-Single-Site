;Funktionsbibliothek (made COMate) zu Excel für PB 5.40B3

;Autor Falko
;Letzte Änderung 07.09.2015

;Ursprüngliche ExcelFunktionen mit Disphelper habe ich nun
;auf COMatePlus umgeschrieben.

;Disphelper-Funktionen:
;http://www.purebasic.fr/german/viewtopic.php?p=158777#158777

;COMate-Funktionen:
;http://www.purebasic.fr/german/viewtopic.php?p=239466#239466

;Die Comate-lib, die hierzu benötigt wird, bitte hier von srod's HP herunterladen:
;http://www.purecoder.net/comate.htm

;Danke an alle, die mir schon beim Disphelper und Excel geholfen haben.

;Einen persönlicher Dank von mir an ts-soft und Kiffi, die mir
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
;Danke Hilli für zwei weitere Funktionen zur Range-Wandlung
;Um diese Funktionen anzuwenden, braucht ihr folgende Lib:
;http://www.purecoder.net/comate.htm
;XLSFunc_SetCellTextWrap und weitere Codeschnipsel hinzugefügt. Dank an mueckerich aus dem PB-Forum


;Folgende Modifikation für den Compiler mit Warunung vor falsche Compileroptionen (12.12.15)
;Danke FrW

If #PB_Compiler_Version > 531
  If #PB_Compiler_Unicode = #False
    MessageRequester("Information", "Unicode-Exe in den Compileroptionen einschalten", #PB_MessageRequester_Ok)
    End
  EndIf
EndIf
;
 
EnableExplicit
XIncludeFile "ExcelConstantsPLUS.pbi"
;IncludePath #PB_Compiler_Home + "COMatePLUS"
;XIncludeFile "COMatePLUS.pbi"

Global WCF_Row.i, WCF_Column.i, WCF_String.i
Define.l Pattern, ExcelAPP, Sheets, SheetN, n
Define.s StandardFile, sPattern, Datei, StandardFile, Text
Define ExcelObject.COMateObject
Global Workbook.COMateObject
Global XLS_WriteCellFast = COMate_PrepareStatement("Cells(" + Str(@WCF_Row) + " As long BYREF," + Str(@WCF_Column) + " As long BYREF) = " + Str(@WCF_String) + " As string BYREF")
Global XLS_WriteCellFast = COMate_PrepareStatement("Cells(" + Str(@WCF_Row) + " As long BYREF," + Str(@WCF_Column) + " As long BYREF) = " + Str(@WCF_String) + " As string BYREF")

Structure MyVariant
  StructureUnion
    l.l
  EndStructureUnion
EndStructure

Procedure ShowErrorIfAny(); Sourcecode from Kiffi
  If COMate_GetLastErrorCode()
    Debug COMate_GetLastErrorCode()
    Debug COMate_GetLastErrorDescription()
  EndIf
EndProcedure

; Procedure.l XLSFunc_OpenExcelFile(Datei.s); Open ExcelFile
;   Protected ExcelObject.COMateObject,Workbook
;   ExcelObject = COMate_CreateObject("Excel.Application")
;   If ExcelObject
;       ExcelObject\Invoke("Workbooks\Open('"+Datei+"')")
;   Else
;     MessageRequester("Achtung","Bitte geben Sie eine vorhandene xls-Datei mit Pfad an!")
;   EndIf
;   ProcedureReturn ExcelObject ;.COMateObject
; EndProcedure

; Wird nun durch folgende Procedure mit optionalen Parameter ReadOnly hier ersetzt. Änderung am 7.1.2014

Procedure XLSFunc_OpenExcelFile(Datei.s,ReadOnly.l=#False); Open ExcelFile with ReadOnly-Parameter, #True or #False
  Protected ExcelObject.COMateObject,Workbooks
  ExcelObject = COMate_CreateObject("Excel.Application")
  If ExcelObject
    If ReadOnly=#False
      ExcelObject\Invoke("Workbooks\Open('"+Datei+"',#opt, #False)"); The first open Excelfile is not ReadOnly
    ElseIf ReadOnly=#True
        ExcelObject\Invoke("Workbooks\Open('"+Datei+"',#opt, #True)"); The first open Excel is ReadOnly
    EndIf    
        
  Else
    MessageRequester("Achtung","Bitte geben Sie eine vorhandene xls-Datei mit Pfad an!")
  EndIf
  ProcedureReturn ExcelObject ;.COMateObject
EndProcedure


Procedure.l XLSFunc_CreateExcelFile(Datei.s); Create a new Excelfile
  Protected ExcelObject.COMateObject,Workbook
  ExcelObject = COMate_CreateObject("Excel.Application")
  If ExcelObject
      WorkBook = ExcelObject\GetObjectProperty("Workbooks\Add")
       SetCurrentDirectory(Datei)
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
    Delay(3000)
    ExcelObject\SetProperty("Visible = #False")
  EndIf
EndProcedure
Procedure.s XLSFunc_ReadCellS(ExcelObject.COMateObject, Zeile.l,Spalte.l)
  Protected ReturnValue.s, Resume.s
  ReturnValue = ExcelObject\GetStringProperty("Cells("+ Str(Zeile)+","+Str(Spalte)+")\Value")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.s XLSFunc_ReadCellWithName(ExcelObject.COMateObject,CellName.s)
  Protected ReturnValue.s
  ReturnValue=ExcelObject\GetStringProperty("Range('"+CellName+"')\Value")
  ProcedureReturn ReturnValue
EndProcedure

Procedure XLSFunc_WriteCellWithName(ExcelObject.COMateObject,CellName.s,NewValue.d)
  ExcelObject\SetProperty("Range('"+CellName+"')\Value ="+StrD(NewValue))
EndProcedure

Procedure XLSFunc_RenameCellName(ExcelObject.COMateObject,Cellname.s,NewCellname.s)
  ExcelObject\SetProperty("ActiveWorkbook\Names('"+Cellname+"')\Name='"+NewCellname+"'")
EndProcedure

Procedure XLSFunc_DeleteCellName(ExcelObject.COMateObject,CellName.s)
  ExcelObject\invoke("ActiveWorkbook\Names('"+CellName+"')\Delete");:Debug COMate_GetLastErrorDescription()
EndProcedure

Procedure.s XLSFunc_CreateCellName(ExcelObject.COMateObject,Range.s,CellName.s)
    ExcelObject\SetProperty("Range('"+Range+"')\Name='"+CellName+"'")
EndProcedure

Procedure XLSFunc_WriteCellS(ExcelObject.COMateObject, Zeile.l, Spalte.l, NewValue.s); Zeile & Spalte (Row & Column) must be none Alpha
  ExcelObject\SetProperty("Cells("+ Str(Zeile)+","+Str(Spalte)+")\Value = '" + NewValue + "'")
EndProcedure

Procedure XLSFunc_WriteCellSFast(ExcelObject.COMateObject, Row.l, Column.l, NewValue.s); Zeile & Spalte (Row & Column) must be none Alpha
  WCF_Row = Row
  WCF_Column = Column
  WCF_String = COMate_MakeBSTR(NewValue)
  ExcelObject\SetProperty("", XLS_WriteCellFast)
  SysFreeString_(WCF_String)   ;Free the BSTR.
EndProcedure

Procedure XLSFunc_WriteCellZ(ExcelObject.COMateObject, Zeile.i, Spalte.i, NewValue.d); Zeile & Spalte (Row & Column) must be none Alpha
  ExcelObject\SetProperty("Cells("+ Str(Zeile)+","+Str(Spalte)+")\Value="+StrD(NewValue))
EndProcedure

Procedure XLSFunc_SetColumnAutoFit(ExcelObject.COMateObject, Range.s)
  ExcelObject\Invoke("Columns('"+Range+"')\AutoFit()")
  Debug "Columns('"+Range+"')\AutoFit()"
EndProcedure

Procedure XLSFunc_SetColumnWidth(ExcelObject.COMateObject, Range.s,Width.f); Set ColumnWidth to one or more Columns
  ExcelObject\Invoke("Columns('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\ColumnWidth="+StrF(Width))
EndProcedure

Procedure XLSFunc_SetRowsHeight(ExcelObject.COMateObject, Range.s,Height.f); Set Height on rang to rows
  ExcelObject\Invoke("Rows('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\RowHeight="+StrF(Height))
EndProcedure

Procedure XLSFunc_SetRowHeight(ExcelObject.COMateObject, Range.s,Height.f); Set Height to one or all Rows
  ExcelObject\Invoke("Row('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\RowHeight="+StrF(Height))
EndProcedure

Procedure XLSFunc_SetCellTextWrap(ExcelObject.COMateObject, Range.s, Wert.l);Set Cell WrapText
  ExcelObject\Invoke("Range('"+ Range +"')\Select")
  If Wert=#True
    ExcelObject\SetProperty("Selection\WrapText = #TRUE")
  ElseIf Wert=#False
    ExcelObject\SetProperty("Selection\WrapText = #FALSE")
  EndIf
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

Procedure XLSFunc_WriteLeftHeader(ExcelObject.COMateObject, Text.s)     ;Write into left Header
  ExcelObject\SetProperty("ActiveSheet\PageSetup\LeftHeader = '"+Text+" '"):Debug COMate_GetLastErrorDescription()
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

Procedure XLSFunc_Grafik(ExcelObject.COMateObject,File.s,X.l,Y.l,Width.l,Height.l)
  Protected pct.COMateObject
  If FileSize(File)>=0
    pct=ExcelObject\GetObjectProperty("ActiveSheet")
    pct\Invoke("Pictures\Insert('"+File+"')")
    pct\setproperty("Pictures\Left="+Str(X))
    pct\setproperty("Pictures\Top="+Str(Y))
    pct\setproperty("Pictures\Width="+Str(Width))
    pct\setproperty("Pictures\Height="+Str(Height))
    pct\setproperty("Pictures\Placement = "+Str(#xlMoveAndSize))
    pct\Release()
  Else
    MessageRequester("Achtung","Grafik nicht gefunden")
  EndIf
EndProcedure
;Bilder und Grafik
#msoTrue=-1
#msoFalse=0
#msoShapeOval=9
#msoLineSolid=1
#msoLineSingle=1
#msoShapeRectangle=1
#msoLine = 9

Procedure XLSFunc_Image(ExcelObject.COMateObject,File.s,X.l,Y.l,Width.l,Height.l,Rot.l=0,Prop=#msoTrue,Trans.f=0)
  Protected Tran.l

  If FileSize(File)>=0
    ExcelObject\Invoke("ActiveSheet\Pictures\Insert('"+File+"')\Select")
    ExcelObject\SetProperty("Selection\ShapeRange\LockAspectRatio = "+Str(Prop));msoTrue = Proportional
    ExcelObject\SetProperty("Selection\ShapeRange\Height="+Str(Height))
    ExcelObject\SetProperty("Selection\ShapeRange\Width="+Str(Width))
    ExcelObject\SetProperty("Selection\ShapeRange\Left="+Str(X))
    ExcelObject\SetProperty("Selection\ShapeRange\Top="+Str(Y))
    If Trans>0
      Tran=#msoTrue
    Else
      Tran=#msoFalse
    EndIf
    ExcelObject\SetProperty("Selection\ShapeRange\Fill\Visible ="+Str(Tran))
    ExcelObject\SetProperty("Selection\ShapeRange\Fill\Solid")
    ExcelObject\SetProperty("Selection\ShapeRange\Fill\Transparency ="+StrF(Trans))
    ExcelObject\SetProperty("Selection\ShapeRange\Rotation ="+Str(Rot))
  Else
    MessageRequester("Achtung","Grafik nicht gefunden")
  EndIf
EndProcedure

Procedure XLSFunc_Elipse(ExcelObject.COMateObject,X.d,Y.d,Width.d,Height.d,BkColor.l,F_ShemeColor.l,LDicke.f,Trans.f=0)
    ExcelObject\invoke("ActiveSheet\Shapes\AddShape("+Str(#msoShapeOval)+","+StrD(X)+","+StrD(Y)+","+StrD(Width)+","+StrD(Height)+")\Select") 
    ExcelObject\SetProperty("Selection\ShapeRange\Fill\Visible = "+Str(#msoTrue))
    ExcelObject\SetProperty("Selection\ShapeRange\Fill\Transparency = "+StrF(Trans))
    ExcelObject\SetProperty("Selection\ShapeRange\Line\Weight = "+StrF(LDicke))
    ExcelObject\SetProperty("Selection\ShapeRange\Line\DashStyle = "+StrF(#msoLineSolid))
    ExcelObject\SetProperty("Selection\ShapeRange\Line\Style = "+Str(#msoLineSingle))
    ExcelObject\SetProperty("Selection\ShapeRange\Fill\Visible = "+Str(#msoTrue))
    ExcelObject\SetProperty("Selection\ShapeRange\Line\ForeColor\RGB = "+Str(F_ShemeColor))
    ExcelObject\SetProperty("Selection\ShapeRange\Fill\ForeColor\RGB = "+Str(BkColor))
EndProcedure

Procedure XLSFunc_Rectangle(ExcelObject.COMateObject,X.d,Y.d,Width.d,Height.d,BkColor.l,F_ShemeColor.l,LDicke.f,Trans.f=0)
    ExcelObject\invoke("ActiveSheet\Shapes\AddShape("+Str(#msoShapeRectangle)+","+StrD(X)+","+StrD(Y)+","+StrD(Width)+","+StrD(Height)+")\Select") 
    ExcelObject\SetProperty("Selection\ShapeRange\Fill\Visible = "+Str(#msoTrue))
    ExcelObject\SetProperty("Selection\ShapeRange\Fill\Transparency = "+StrF(Trans))
    ExcelObject\SetProperty("Selection\ShapeRange\Line\Weight = "+StrF(LDicke))
    ExcelObject\SetProperty("Selection\ShapeRange\Line\DashStyle = "+StrF(#msoLineSolid))
    ExcelObject\SetProperty("Selection\ShapeRange\Line\Style = "+Str(#msoLineSingle))
    ExcelObject\SetProperty("Selection\ShapeRange\Fill\Visible = "+Str(#msoTrue))
    ExcelObject\SetProperty("Selection\ShapeRange\Line\ForeColor\RGB = "+Str(F_ShemeColor))
    ExcelObject\SetProperty("Selection\ShapeRange\Fill\ForeColor\RGB = "+Str(BkColor))
EndProcedure
 
Procedure XLSFunc_Line(ExcelObject.COMateObject,X1.d,Y1.d,X2.d,Y2.d,RGBColor.l,LStyle.l,LDicke.f=1)
  ExcelObject\invoke("ActiveSheet\Shapes\AddLine("+StrD(X1)+","+StrD(Y1)+","+StrD(X2)+","+StrD(Y2)+")\Select")
  ExcelObject\SetProperty("Selection\ShapeRange\Line\DashStyle = "+Str(LStyle))
  ExcelObject\SetProperty("Selection\ShapeRange\Line\Weight = "+StrF(LDicke))
  ExcelObject\SetProperty("Selection\ShapeRange\Line\ForeColor\RGB = "+Str(RGBColor)) 
EndProcedure

;For Orientation you can change it.
#msoTextOrientationDownward=3
#msoTextOrientationHorizontal=1
#msoTextOrientationHorizontalRotatedFarEast=6
#msoTextOrientationMixed=   -2
#msoTextOrientationUpward=2
#msoTextOrientationVertical=5
#msoTextOrientationVerticalFarEast=4
Procedure XLSFunc_TextBox(ExcelObject.COMateObject,Orientation.l,X.d,Y.d,Width.d,Height.d,Name.s,Text.s)
  ExcelObject\setproperty("ActiveSheet\Shapes\AddTextbox("+Str(Orientation)+","+StrD(X)+","+StrD(Y)+","+StrD(Width)+","+StrD(Height)+")\Name='"+Name+"'")
  ExcelObject\SetProperty("ActiveSheet\Shapes('"+Name+"')\DrawingObject\Text='"+Text+"'")
EndProcedure
 
Procedure XLSFunc_DisplayAlertsOnOff(ExcelObject.COMateObject,Wert.l); Set #True or #False for Displayalerts on/off
If Wert=#True
   ExcelObject\SetProperty("Application\DisplayAlerts = #True")
ElseIf Wert=#False
     ExcelObject\SetProperty("Application\DisplayAlerts = #False"); War vorher invoke, warum auch immer :(
EndIf
EndProcedure

Procedure XLSFunc_CloseExcelAll(ExcelObject.COMateObject)
  ExcelObject\Invoke("Quit()") ; Close Excel
  ExcelObject\Release()  ; ExcelObject freigeben
EndProcedure

Procedure XLSFunc_CloseWorkbook(ExcelObject.COMateObject,Alerts=0);Change Alerts to 1 for Non Alerts
  Protected Workbook.COMateObject
  Workbook=ExcelObject\GetObjectProperty("ActiveWorkbook")
  If Alerts=1; 
    ExcelObject\SetProperty("Application\DisplayAlerts = #False"); insert this here :)
  EndIf  
   If Workbook
    Workbook\Invoke("Close"); Close Excel Worksheet
    Workbook\Release()      ;Workbook freigeben
  If Alerts=1; 
    ExcelObject\SetProperty("Application\DisplayAlerts = #True"); insert this here :)
  EndIf
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

Procedure XLSFunc_SaveAsWorkbook(ExcelObject.COMateObject,Datei.s,FFormat)
  Protected Workbook.COMateObject
  Workbook=ExcelObject\GetObjectProperty("ActiveWorkbook")
  If Workbook
    ;Workbook\Invoke("SaveAs('"+Datei+"')") ; replace this with Filefomat for another Formats (12.03.2011) for Excel < 2007 with next line
    Workbook\Invoke("SaveAs('"+Datei+"', " + Str(FFormat) + ")") ;Save As #xlNormal or #xlCSV or another CSV (MSDOS or Windows)
        Workbook\Release()     ;Workbook Freigeben
  EndIf
EndProcedure

Procedure XLSFunc_SaveWorkbookAs(ExcelObject.COMateObject, FileName.s,FFormat); Save WorkSheet as FileFormat
  Protected Workbook.COMateObject
  Workbook=ExcelObject\GetObjectProperty("ActiveWorkbook")
  If FileName <> ""
      If Workbook
         Workbook\Invoke("SaveAs('"+FileName+"', " + Str(FFormat) + ")") ;Save As #xlNormal or #xlCSV or another CSV (MSDOS or Windows)
         Workbook\Release();WorkBook freigeben
      EndIf
    EndIf
  EndProcedure

Procedure XLSFunc_WriteToWorksheet(ExcelObject.COMateObject,Name.s,Zeile.l, Spalte.l, NewValue.s);Zeile & Spalte (Row & Column) must be none Alpha
  ExcelObject\SetProperty("Worksheets('"+Name+"')\Cells("+ Str(Zeile)+","+Str(Spalte)+")\Value = '"+NewValue+"'")
EndProcedure

Procedure XLSFunc_ChangeToWorksheet(ExcelObject.COMateObject,Name.s); Change worksheet
  ExcelObject\Invoke("Worksheets('"+Name+"')\Select")
EndProcedure

Procedure XLSFunc_ChangeToSheet(ExcelObject.COMateObject,Name.s); Change Sheet
  ExcelObject\Invoke("Sheets('"+Name+"')\Select")
EndProcedure
 
Procedure.s XLSFunc_GetSheetName(ExcelObject.COMateObject,Num.l)
  Protected ReturnValue.s
  ReturnValue=ExcelObject\GetStringProperty("Worksheets("+Str(Num)+")\Name")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.l XLSFunc_GetLastRow(ExcelObject.COMateObject)
  Protected ReturnValue.l
   ;ReturnValue=ExcelObject\GetIntegerProperty("ActiveSheet\UsedRange\SpecialCells("+Str(#xlCellTypeLastCell)+")\Row")
   ReturnValue=ExcelObject\GetIntegerProperty("ActiveSheet\UsedRange\End("+#xlDown+")\Row")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.l XLSFunc_GetLastRowCell(ExcelObject.COMateObject)
  Protected ReturnValue
   ReturnValue=ExcelObject\GetIntegerProperty("ActiveSheet\Cells(65536,1)\End("+#xlDown+")\Row")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.l XLSFunc_GetLastColumn(ExcelObject.COMateObject)
  Protected ReturnValue.l
   ReturnValue=ExcelObject\GetIntegerProperty("ActiveSheet\UsedRange\SpecialCells("+Str(#xlCellTypeLastCell)+")\Column")
  ProcedureReturn ReturnValue
EndProcedure

Procedure.l XLSFunc_GetLastCellFillFirst(ExcelObject.COMateObject,Spalte.s="A:A")
  ;Codetipp für Pure_Beginner von Kiffi mit freundlicher Erlaubnis aufgenommen.
  Protected ReturnValue.l
    ReturnValue=ExcelObject\GetIntegerProperty("Columns('"+Spalte+"')\CurrentRegion\Rows\Count")
    ProcedureReturn ReturnValue
EndProcedure

Procedure.l XLSFunc_GetWorkbookName(ExcelObject.COMateObject)
  Protected ReturnValue.l
   ReturnValue=ExcelObject\GetIntegerProperty("ActiveWorkbook\Name")
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

Procedure XLSFunc_AddWorksheetAfterSheet(ExcelObject.COMateObject,CountSheet.l, NewSheetName.s = "");New Worksheet after any Worksheet
  Protected  Sheet.COMateObject,NewSheet.COMateObject
  Sheet = ExcelObject\GetObjectProperty("Sheets("+ Str(CountSheet)+")")
  ; Neues Sheet hinter ausgewählten Sheet erstellen
  NewSheet = ExcelObject\GetObjectProperty("Sheets\Add(#Optional," + Str(Sheet) + " As COMateObject)"):Debug COMate_GetLastErrorDescription()
 ; Optional: Namen des neuen Sheets setzen
  If NewSheetName <> ""
    NewSheet\SetProperty("Name = '" + NewSheetName + "'")
  EndIf
  ; NewSheet-Objekte freigeben
  NewSheet\Release()
  Sheet\Release()
EndProcedure

Procedure XLSFunc_RenameActiveSheet(ExcelObject.COMateObject,Name.s)
   ExcelObject\SetProperty("ActiveSheet\Name('"+Name+"')")
EndProcedure

Procedure XLSFunc_SetColor(ExcelObject.COMateObject, Range.s, cRed.l, cGreen.l, cBlue.l); Set color in Cells
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\Interior\Color = "+Str(RGB(cRed,cGreen,cBlue)))
  ;ExcelObject\SetProperty("Selection\Interior\Pattern ="+Str(#xlPatternSolid))
EndProcedure

Procedure XLSFunc_SetFontColor(ExcelObject.COMateObject, Range.s, cRed.l, cGreen.l, cBlue.l); Set FontColor
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\Font\Color = "+Str(RGB(cRed,cGreen,cBlue)))
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

Procedure.l XLSFunc_GetNumberOfPages(ExcelObject.COMateObject,Sheet.s)
 
  ; Hint from Kiffi; Get Number of printer pages
  ; http://www.purebasic.fr/german/viewtopic.php?p=303424#p303424
 
  Protected oScriptControl.COMateObject
  Protected NumberOfPages.l, oExcelApp.l, VBS.s
 
  oScriptControl = COMate_CreateObject("ScriptControl")
 
  If oScriptControl
   
    oScriptControl\SetProperty("Language = 'VBScript'")
   
    oScriptControl\Invoke("AddObject('oExcelApp', " + Str(ExcelObject) + " As COMateObject)")
   
    VBS = "ReturnValue = oExcelApp.ExecuteExcel4Macro(" + Chr(34) + "Get.Document(50,"+Chr(34)+Chr(34)+Sheet+Chr(34)+Chr(34)+")" + Chr(34) + ")"
   
    oScriptControl\Invoke("AddCode('" + VBS + "')")
   
    NumberOfPages = oScriptControl\GetIntegerProperty("Eval('ReturnValue')")
   
    oScriptControl\Release()
   
    ProcedureReturn NumberOfPages
   
  Else
    Debug COMate_GetLastErrorDescription()
  EndIf
 
EndProcedure

Procedure XLSFunc_LinienEinAus(ExcelObject.COMateObject) ; Skip the lines on or off
    Protected *Linestyles.MyVariant
    *Linestyles=ExcelObject\GetVariantProperty("Selection\Borders\Linestyle")
    If *Linestyles\l = #xlContinuous
       ExcelObject\SetProperty("Selection\Borders\LineStyle = "+Str(#xlLineStyleNone))
    Else
       ExcelObject\SetProperty("Selection\Borders\LineStyle = "+Str(#xlContinuous))
       ExcelObject\SetProperty("Selection\Borders\Weight="+Str(#xlMedium))   
    EndIf
EndProcedure

Procedure XLSFunc_MarkCellsRight(ExcelObject.COMateObject,Offset_Zeile.l=0,Offset_Spalte.l=0,Offset_Zeile1.l=0,Offset_Spalte1.l=0); Marks an offset from active Cell right from there
  ;Thanks marco2007 (german forum)
  Protected.COMateObject active
  Protected.s actadress,Range1,Range2,Range
  active = ExcelObject\GetObjectProperty("ActiveCell")
  actadress=active\GetStringProperty("address")
  If active
    Range1=active\GetStringProperty("Offset("+Str(Offset_Zeile)+","+Str(Offset_Spalte)+")\address"):Debug Range1
    Range2=active\GetStringProperty("Offset("+Str(Offset_Zeile1)+","+Str(Offset_Spalte1)+")\address"):Debug Range2
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

Procedure XLSFunc_SetBorders(ExcelObject.COMateObject, Range.s, NBorder.l, NLineStyles.l,LineThick.l, ColorIndex.l) ; create a border
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

  ExcelObject\Invoke("Range('"+Range+"')\Select")
  ;dhCallMethod(*obj, ".Range(%T).Select", @Range)
  If NBorder &1
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalDown)+")\LineStyle = "+Str(NLineStyles))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalDown)+")\ColorIndex = "+Str(ColorIndex))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalDown)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalDown)+")\Weight = "+Str(LineThick))
  EndIf
  If NBorder &2
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalUp)+")\LineStyle = "+Str(NLineStyles))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalUp)+")\ColorIndex = "+Str(ColorIndex))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalUp)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlDiagonalUp)+")\Weight = "+Str(LineThick))
  EndIf
   If NBorder &4
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\LineStyle = "+Str(NLineStyles))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\ColorIndex = "+Str(ColorIndex))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\Weight = "+Str(LineThick))
   EndIf
  If NBorder &8
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeTop)+")\LineStyle = "+Str(NLineStyles))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeTop)+")\ColorIndex = "+Str(ColorIndex))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeTop)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeTop)+")\Weight = "+Str(LineThick))
  EndIf
  If NBorder &16
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeBottom)+")\LineStyle = "+Str(NLineStyles))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeBottom)+")\ColorIndex = "+Str(ColorIndex))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeBottom)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeBottom)+")\Weight = "+Str(LineThick))
  EndIf
  If NBorder &32
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeRight)+")\LineStyle = "+Str(NLineStyles))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeRight)+")\ColorIndex = "+Str(ColorIndex))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeRight)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeRight)+")\Weight = "+Str(LineThick))
  EndIf
  If NBorder &64
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideVertical)+")\LineStyle = "+Str(NLineStyles))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideVertical)+")\ColorIndex = "+Str(ColorIndex))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideVertical)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideVertical)+")\Weight = "+Str(LineThick))
  EndIf
  If NBorder &128
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideHorizontal)+")\LineStyle = "+Str(NLineStyles))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideHorizontal)+")\ColorIndex = "+Str(ColorIndex))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideHorizontal)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlInsideHorizontal)+")\Weight = "+Str(LineThick))
  EndIf
   
EndProcedure
Procedure XLSFunc_SetBordersFast(ExcelObject.COMateObject, Range.s) ; create a border
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

  ExcelObject\Invoke("Range('"+Range+"')\Select")

    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft|#xlEdgeTop|#xlEdgeBottom|#xlEdgeRight)+")\LineStyle = "+Str(#xlContinuous))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\ColorIndex = "+Str(ColorIndex))
    ;ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\TintAndShade = 0")
    ExcelObject\SetProperty("Selection\Borders("+Str(#xlEdgeLeft)+")\Weight = "+Str(#xlHairline))

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

Procedure XLSFunc_SetFont(ExcelObject.COMateObject, Range.s,Name.s="Arial",Size.l=10,Style.s="Regular")
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\Font\Name = '"+Name+"'")
  ExcelObject\SetProperty("Selection\Font\FontStyle = '"+Style+"'")
  ExcelObject\SetProperty("Selection\Font\Size = "+Str(Size))
  ExcelObject\SetProperty("Selection\Font\Strikethrough = 0")
  ExcelObject\SetProperty("Selection\Font\Superscript = 0")
  ExcelObject\SetProperty("Selection\Font\Shadow = 0")
  ExcelObject\SetProperty("Selection\Font\TintAndShade = 0")
  ExcelObject\SetProperty("Selection\Font\ThemeFont = 0")
EndProcedure

Procedure XLSFunc_SetFontSize(ExcelObject.COMateObject, Range.s,Size.l=10)
  ExcelObject\Invoke("Range('"+Range+"')\Select")
  ExcelObject\SetProperty("Selection\Font\Size = "+Str(Size))
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


;This tip is from Hilli, for Excel2003 and more.
;Range now all the columns up To max. 16,384 To spend.
;Test it with  debug XLSFunc_RowCol2Range(1 , 16384) ;<--- (Rows , Columns)
;Thank you.
;changed 4.12.2012
Procedure.s XLSFunc_RowCol2Range(Row.i,Col.i); Excel 2007 & 2010 tested
   Protected Ganz.i, Ganz1.i, Ganz2.i
   Protected Rest.i, Range.s
   If Col <= 26
     Range = Chr(Col + 64) + Str(Row)
   ElseIf Col > 26
     Rest = Col % 26
     If Rest = 0
       Rest = 26
     EndIf
     Ganz = (Col - Rest) / 26
     If Ganz > 26
       Ganz1 = Ganz % 26
       Ganz2 = (Ganz - Ganz1) / 26
       Range = Chr(Ganz2 + 64) + Chr(Ganz1 + 64) + Chr(Rest + 64) + Str(Row)
     Else
       Range = Chr(Ganz + 64) + Chr(Rest + 64) + Str(Row)
     EndIf
   EndIf
   ProcedureReturn Range
 EndProcedure
 
;Thanks at Hilli For this Procedure to calc Range from columns
;Included 4.12.2012
;Test it with ;Test it with  debug XLSFunc_Col2Range(500) ;<--- (Columns)
Procedure.s XLSFunc_Col2Range(Col.i); Excel 2007 & 2010 tested
  Protected Ganz.i, Ganz1.i, Ganz2.i
  Protected Rest.i, Range.s
    If Col <= 26
      Range = Chr(Col + 64)
    ElseIf Col > 26
      Rest = Col % 26
    If Rest = 0
      Rest = 26
    EndIf
    Ganz = (Col - Rest) / 26
    If Ganz > 26
      Ganz1 = Ganz % 26
      Ganz2 = (Ganz - Ganz1) / 26
      Range = Chr(Ganz2 + 64) + Chr(Ganz1 + 64) + Chr(Rest + 64)
    Else
      Range = Chr(Ganz + 64) + Chr(Rest + 64)
    EndIf
  EndIf
  ProcedureReturn Range
EndProcedure
 
 

;Worksheets("Sheet1").Copy After:=Worksheets("Sheet3")
;srod tipp help: http://www.purebasic.fr/english/viewtopic.php?f=27&t=39535&hilit=Comate
Procedure XLSFunc_CopyWorksheetAfter(ExcelObject.COMateObject, FirstSheet.s="",SecondSheet.s="");Copy Sheet_One after Sheet_Two
  Protected.COMateObject objSheet
  objSheet = ExcelObject\GetObjectProperty("Worksheets('"+SecondSheet+"')")
  If objSheet
    ExcelObject\Invoke("Worksheets('"+FirstSheet+"')\Copy(#Empty, " + Str(objSheet) + " as COMateObject)")
    objSheet\Release()
  EndIf
EndProcedure

Procedure XLSFunc_MoveWorksheetAfter(ExcelObject.COMateObject, FirstSheet.s="",SecondSheet.s="");Move Sheet_One after Sheet_Two
  Protected.COMateObject objSheet
  objSheet = ExcelObject\GetObjectProperty("Worksheets('"+SecondSheet+"')")
  If objSheet
    ExcelObject\Invoke("Worksheets('"+FirstSheet+"')\move(#Empty, " + Str(objSheet) + " as COMateObject)")
    objSheet\Release()
  EndIf
EndProcedure

Procedure XLSFunc_CopyWorksheetBefore(ExcelObject.COMateObject, FirstSheet.s="",SecondSheet.s="");Copy Sheet_One before Sheet_Two
  Protected.COMateObject objSheet
  objSheet = ExcelObject\GetObjectProperty("Worksheets('"+SecondSheet+"')")
  If objSheet
    ExcelObject\Invoke("Worksheets('"+FirstSheet+"')\Copy(#Optional, " + Str(objSheet) + " as COMateObject)")
    objSheet\Release()
  EndIf
EndProcedure
 
Procedure XLSFunc_MoveWorksheetBefore(ExcelObject.COMateObject, FirstSheet.s="",SecondSheet.s="");Move Sheet_One before Sheet_Two
  Protected.COMateObject objSheet
  objSheet = ExcelObject\GetObjectProperty("Worksheets('"+SecondSheet+"')")
  If objSheet
    ExcelObject\Invoke("Worksheets('"+FirstSheet+"')\move(#Optional, " + Str(objSheet) + " as COMateObject)")
    objSheet\Release()
  EndIf
EndProcedure

Procedure XLSFunc_DeleteWorksheet(ExcelObject.COMateObject,SheetName.s="")
   ExcelObject\Invoke("Worksheets('"+SheetName+"')\Delete")
EndProcedure

;Codeschnipsel von Kiffi. Danke hierfür :)
Procedure XLSFunc_ExcelCallback(ExcelObject.COMateObject, eventName$, parameterCount)
  Debug "ExcelEvent: " + eventName$
  If eventName$ = "WorkbookBeforeClose"
    Workbook\Invoke("Save")
  EndIf
EndProcedure 
;Codeschnipsel von mueckerich. Danke hierfür :)
Procedure XLSFunc_HCellAlignment(ExcelObject.COMateObject, Range.s, Wert.l);Set horizontal cell alignment
  ExcelObject\Invoke("Range('"+ Range +"')\Select")
  ExcelObject\SetProperty("Selection\HorizontalAlignment = " + Str(Wert))
EndProcedure

Procedure XLSFunc_VCellAlignment(ExcelObject.COMateObject, Range.s, Wert.l);Set vertical cell alignment
  ExcelObject\Invoke("Range('"+ Range +"')\Select")
  ExcelObject\SetProperty("Selection\VerticalAlignment = " + Str(Wert))
EndProcedure

Procedure XLSFunc_LockFirstLine(ExcelObject.COMateObject, Range.s, Wert.l=#True); Set Wert #True or #false
  ExcelObject\Invoke("Range('"+ Range +"')\Select")
  ExcelObject\SetProperty("ActiveWindow\FreezePanes = " + Str(Wert))
EndProcedure

Procedure XLSFunc_PasteFromClipboard(ExcelObject.COMateObject,ImgNr,Width,Height,Prop=#msoFalse); This function put any Images from Clipboard. 
  If GetClipboardImage(ImgNr)
    ExcelObject\Invoke("ActiveSheet\Paste")
    ExcelObject\SetProperty("Selection\ShapeRange\LockAspectRatio = "+Str(Prop));msoTrue = Proportional
    ExcelObject\SetProperty("Selection\ShapeRange\Height="+Str(Height))
    ExcelObject\SetProperty("Selection\ShapeRange\Width="+Str(Width))
  Else
    MessageRequester("Achtung","Es liegt keine Bildkopie im Zwischenspeicher vor!")
  EndIf
EndProcedure

;Folgende Funktion für das Lesen von Kommentaren zur Verfügung gestellt von FrW, Danke fürs Teilen ;)
Procedure.s XLSFunc_ReadCommentWithWorksheet(ExcelObject.COMateObject,Name.s,Zeile.l, Spalte.l)
 Protected ReturnValue.s
 ReturnValue=ExcelObject\GetStringProperty("Worksheets('"+Name+"')\Cells("+Str(Zeile)+","+Str(Spalte)+")\Comment\Text")
 ProcedureReturn ReturnValue
EndProcedure

;Folgende Funktion zum kopieren von einem zum anderen Tabellenblatt.von FrW. Sehr praktisch. Danke dafür.
;Aufruf dazu: --- XLSFunc_CopyRangeFromTo(NewExcelObject, "Blatt1", "A1:A3", "Blatt2", "B2") ---
Procedure XLSFunc_CopyRangeFromTo(ExcelObject.COMateObject, FromSheet.s, FromRange.s, ToSheet.s, ToRange.s)
   
  ExcelObject\Invoke("Sheets('"+FromSheet+"')\Select")
  ExcelObject\Invoke("Sheets('"+FromSheet+"')\Range('"+FromRange+"')\Copy")
  ;
  ExcelObject\Invoke("Sheets('"+ToSheet+"')\Select")
  ExcelObject\Invoke("Sheets('"+ToSheet+"')\Range('"+ToRange+"')\Select")
  ExcelObject\Invoke("ActiveSheet\Paste")
 
EndProcedure

;eine Weitere Funktion von FrW zum Auslesen der Excel-Version. Lieben Dank dafür
Procedure.s XLSFunc_GetExcelInfo(ExcelObject.COMateObject)
  Protected ReturnValue.s 
  ; Debug "Version:  " + ExcelObject\GetStringProperty("Application\Version")
  ; Debug "BuildNr.: " + ExcelObject\GetStringProperty("Application\Build")
  ReturnValue=ExcelObject\GetStringProperty("Application\Version")
  ProcedureReturn ReturnValue
 
  ; Excel-Versionen
  ; Version Bezeichnung
  ;  4.0    Excel 4.0
  ;  5.0    Excel 5.0
  ;  7.0    Excel 95
  ;  8.0    Excel 97
  ;  9.0    Excel 2000
  ; 10.0    Excel 2002 / MS Office XP
  ; 11.0    Excel 2003
  ; 12.0    Excel 2007
  ; 14.0    Excel 2010
  ; 15.0    Excel 2013
  ; 16.0    Excel 2016
EndProcedure

; IDE Options = PureBasic 5.71 beta 1 LTS (Windows - x86)
; CursorPosition = 749
; FirstLine = 680
; Folding = A9----------------
; EnableUnicode