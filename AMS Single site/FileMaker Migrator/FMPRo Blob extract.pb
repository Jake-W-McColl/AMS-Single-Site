UseODBCDatabase()
myConnection = 1
OpenDatabase(myConnection,"LegacyAMS","th",#Null$,#PB_Database_ODBC)
;Result = OpenDatabaseRequester(myConnection,#PB_Database_ODBC)
UseJPEGImageDecoder()

SQL$ = "Select ID, AvWallWidth, AvOpening, Angle, Resolution, Width, "+Chr(34)+"Date"+Chr(34)+", Comment, Suitability, Machine, Pos1Orig, Pos2Orig, Pos3Orig, Pos4Orig, Pos5Orig, AverageOrig, Author, VarianceOrig, DateOfBirth,"
SQL$ + "Created, DateMade, Maker from Rolls"

;SQL$ = "Select id, AvWallWidth , AvOpening, Angle, Resolution , Width, "+Chr(34)+"Date"+Chr(34)+", Machine from Rolls"
;SQL$ = "Select id from Rolls"

SQL$ = "Select ID, PicOrig from Rolls"

Size = 640*480*3 : *Mem = AllocateMemory(Size)

If DatabaseQuery(myConnection, SQL$)
  While NextDatabaseRow(myConnection)
    Select DatabaseColumnType(myConnection,1)
      Case #PB_Database_Blob
        Pos = DatabaseColumnSize(myConnection,1)
        Debug "Size: "+Str(Pos);+" - @ Mem: "+Str(PeekI(Pos))
        GetDatabaseBlob(myConnection,1,*Mem,Size)
        Txt.s = ""
        For X = 0 To 10 Step 1
          Txt + Hex(PeekC(*Mem+X))+":"
        Next
        Debug Txt
    EndSelect
    
    ;NameCheck.s = GetDatabaseString(myConnection,0)
    ;Debug "Namecheck: "+NameCheck
  Wend
  Debug CatchImage(1,*Mem,Size)
  CallDebugger
  FinishDatabaseQuery(MyConnection)
Else
  Debug "Error"
;  Debug  GetLastErrorDescription()
;  Debug  GetLastErrorCode()  
EndIf


; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 14
; EnableXP