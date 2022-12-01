UseSQLiteDatabase()
UseJPEGImageEncoder()

Procedure CheckDatabaseUpdate(SQL.s)
  Result.i = DatabaseUpdate(1,SQL.s);"Select (Select Count(*) from AMS_groups),(Select Count(*) from AMS_Roll_Master);")
  If Result = 0
    Debug "Error with Query: "+DatabaseError()
  Else
    Debug "Update Successfull"
  EndIf
EndProcedure
Procedure Database_Update(Database, query.S)
  ;/ ***************************************************************************************************************
  ;/ This procedure is used for all database updates, user is warned if error occurs.  Message is added to the message
  ;/ list with the query text and the time it has taken to run.
  ;/ ***************************************************************************************************************
  ;/ In:  Database ID, Query String, source linenumber that update was called from.
  ;/ Out: Result (Integer) - is update acknowledgement, or zero if update error.
  ;/ ***************************************************************************************************************
  
  If IsDatabase(Database)
    
    Protected Result.i, Time.i
    time = ElapsedMilliseconds()-time
    Debug query
    Result = DatabaseUpdate(Database, query.s)

    If Result = 0
      MessageRequester("Error?"+" ",query+Chr(10)+DatabaseError())
    EndIf
    time = ElapsedMilliseconds()-time
    
    ProcedureReturn Result
  EndIf
  
  
EndProcedure

Structure Blob
  ID.s
  Size.i
  *Mem
EndStructure




If OpenDatabase(1,"C:\ProgramData\Troika Systems\AMS\AMS_ss.db","","",#PB_Database_SQLite) = 0
  Debug "Failed to Open the database"
  Debug DatabaseError()
Else
  
  NewList BlobList.Blob()
  
  Debug "Master table"
  If DatabaseQuery(1, "Select ID, TopSnapImage from AMS_Roll_Master") ; Get all the records in the 'employee' table
    While NextDatabaseRow(1) ; Loop for each records
      Size = DatabaseColumnSize(1,1)
      ID.s = GetDatabaseString(1, 0)
      If Size = 921654                              ;/ bitmap
        Debug GetDatabaseString(1, 0)+" - "+Str(Size) + " <<< Bitmap" ; Display the content of the first field      
        AddElement(BlobList())
        BlobList()\ID = ID
        BlobList()\Size = Size
        BlobList()\Mem = AllocateMemory(Size)
        GetDatabaseBlob(1,1,BlobList()\Mem,Size)
      Else
        Debug GetDatabaseString(1, 0)+" - "+Str(Size) ; Display the content of the first field      
      EndIf
    Wend
    FinishDatabaseQuery(1)
  EndIf
  
  ForEach BlobList()
    CatchImage(1,BlobList()\Mem,BlobList()\Size)
    *OutMem = EncodeImage(1,#PB_ImagePlugin_JPEG,10,24)
    SetDatabaseBlob(1, 0, *OutMem, MemorySize(*OutMem))
    SQL.s = "Update AMS_Roll_Master set TopSnapImage = ? where id = "+BlobList()\ID+";"
    Database_Update(1,SQL)
    FreeMemory(*OutMem)
  Next
  
  ClearList(BlobList())
  
  Debug "Data table"
  If DatabaseQuery(1, "Select ID, HistTopSnapImage from AMS_Roll_Data") ; Get all the records in the 'employee' table
    While NextDatabaseRow(1) ; Loop for each records
      Size = DatabaseColumnSize(1,1)
      ID.s = GetDatabaseString(1, 0)
      If Size = 921654                              ;/ bitmap
        AddElement(BlobList())
        BlobList()\ID = ID
        BlobList()\Size = Size
        BlobList()\Mem = AllocateMemory(Size)
        GetDatabaseBlob(1,1,BlobList()\Mem,Size)
      Else
        Debug GetDatabaseString(1, 0)+" - "+Str(Size) ; Display the content of the first field      
      EndIf
    Wend
    FinishDatabaseQuery(1)
  EndIf
  
  ForEach BlobList()
    CatchImage(1,BlobList()\Mem,BlobList()\Size)
    *OutMem = EncodeImage(1,#PB_ImagePlugin_JPEG,10,24)
    SetDatabaseBlob(1, 0, *OutMem, MemorySize(*OutMem))
    SQL.s = "Update AMS_Roll_Data set HistTopSnapImage = ? where id = "+BlobList()\ID+";"
    Database_Update(1,SQL)
    FreeMemory(*OutMem)
  Next

  
  
;  DatabaseQuery(1,
    ;SQL.s = "Select ID, TopSnapImage from AMS_Roll_Master set Depth = "+Str(X)+" where ID = "+Str(X)+";"
;    CheckDatabaseUpdate(Sql)
;  Next
  
;  DatabaseQuery(#Databases_Master,"Select HistTopSnapImage from AMS_Roll_Data Where ID = '"+Str(HistoryID)+"';")  ;/DNT
;  NextDatabaseRow(#Databases_Master)
  
 ; Length = DatabaseColumnSize(#Databases_Master, 0) ; Display the content of the first field  
  
EndIf

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 106
; FirstLine = 80
; Folding = -
; EnableXP