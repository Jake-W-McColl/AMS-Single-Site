UseSQLiteDatabase()

Global GlobalSize.i, Timer.i, MyConnection.i, connectionString$
Global Dim CodeString.s(10)

timer = ElapsedMilliseconds()
XIncludeFile("adomate.pbi")

connectionString$ = "dsn=LegacyAMS; User Id=th; SLKStaticCursorLongColBuffLen=4096"

myConnection = ADOmate_OpenDatabase(connectionString$)
Debug myConnection


SQL$ = "Select AvWallWidth, AvOpening, Angle, Resolution, Width, "+Chr(34)+"Date"+Chr(34)+", Comment, Suitability, Machine, Pos1Orig, Pos2Orig, Pos3Orig, Pos4Orig, Pos5Orig, AverageOrig, Author, VarianceOrig, DateOfBirth,"
SQL$ + "Created, DateMade, Maker from Rolls"

SQL$ = "Select id, AvWallWidth , AvOpening, Angle, Resolution , Width, "+Chr(34)+"Date"+Chr(34)+" from Rolls"
;         19        20       21
Debug "SQL: " + Sql$
If ADOmate_DatabaseQuery(myConnection, SQL$, #adOpenStatic)
  Debug "Opened database query - OK"
  AdoMAte_FinishdatabaseQuery(MyConnection)
Else
  Debug "Error"
  Debug  ADOmate_GetLastErrorDescription()
  Debug  ADOmate_GetLastErrorCode()  
EndIf

; IDE Options = PureBasic 5.21 LTS (Windows - x86)
; CursorPosition = 8
; EnableXP