XIncludeFile "COMateplus_Residents.pbi"
XIncludeFile "COMateplus.pbi"
XIncludeFile "ExcelConstants.pbi"
XIncludeFile "ExcelFunctions.pbi"

Define.COMateObject ExcelObject
Define.i WorkBook, ColumnCount.i, Txt.s, Error.q

ExcelObject = COMate_CreateObject("Excel2.Application")  ;/DNT
If ExcelObject
  If ExcelObject\SetProperty("Visible = #True") = #S_OK ;/DNT
    WorkBook = ExcelObject\GetObjectProperty("Workbooks\Add") ;/DNT
    If WorkBook
      XLSFunc_WriteCellS(ExcelObject, 1, 1,"AMS - Export test") ;/DNT
      XLSFunc_WriteCellS(ExcelObject, 2, 1,"Standalone application test for Heinz") ;/DNT
    EndIf
  EndIf
Else
  Txt.s = "Unable to create Excel Object..."+Chr(10)+Chr(10)
  Error = COMate_GetLastErrorCode()
  Txt + Str(Error) + Chr(10)
  Txt + COMate_GetLastErrorDescription()
  Debug txt
  MessageRequester("Error",Txt)
EndIf


; IDE Options = PureBasic 4.60 (Windows - x86)
; CursorPosition = 22
; EnableUnicode
; EnableXP
; Executable = ..\Executable\XLS export standalone.exe