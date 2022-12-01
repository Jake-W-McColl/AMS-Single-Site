XIncludeFile "Includes\COMatePLUS_Residents.pbi" ;/DNT
XIncludeFile "Includes\ComatePlus.pbi"           ;/DNT


;Prepare our statement for writing to an individual cell. Our choice of cell is unimportant.
;What is important is that we use type-modifiers to set the parameter types.
;===========================================================================================
Define value.i
hStatement = COMate_PrepareStatement("Cells(" + Str(@row) + " As long BYREF," + Str(@col) + " As long BYREF) = " + Str(@value) + " As string BYREF")
If hStatement = 0
  MessageRequester("COMatePLUS!", "Couldn't create the statement!" + #CRLF$ + #CRLF$ + "COMatePLUS error : " + COMate_GetLastErrorDescription())
  End
EndIf


ExcelObject.COMateObject = COMate_CreateObject("Excel.Application")
If ExcelObject
  If ExcelObject\SetProperty("Visible = #True") = #S_OK
    WorkBook.COMateObject = ExcelObject\GetObjectProperty("Workbooks\Add")
    If WorkBook
      ;Write 100 cells using our pre-compiled statement.
        For row = 1 To 10
          For col = 1 To 10
            ;Create a BSTR to pass by ref. We use COMatePLUS' 
              value = COMate_MakeBSTR("PJ (" + Str(row) + ", " + Str(col) + ")")
            ;Execute the prepared statement.
              ExcelObject\SetProperty("", hStatement)
            ;Free the BSTR.
              SysFreeString_(value)
          Next
        Next
      ExcelObject\Invoke("Quit()") 
      WorkBook\Release()
    EndIf
  EndIf
  ExcelObject\Release()
Else
  MessageRequester("COMate -Excel demo", "Couldn't create the application object!")
EndIf


;Free our statement.
;===================
  COMate_FreeStatementHandle(hStatement)
; IDE Options = PureBasic 5.71 beta 1 LTS (Windows - x86)
; CursorPosition = 24
; EnableXP