UseSQLiteDatabase()

Procedure CheckDatabaseUpdate(SQL.s)
  Result.i = DatabaseUpdate(1,SQL.s);"Select (Select Count(*) from AMS_groups),(Select Count(*) from AMS_Roll_Master);")
  If Result = 0
    Debug "Error with Query: "+DatabaseError()
  Else
    Debug "Update Successfull"
  EndIf
EndProcedure

;If OpenDatabase(1,"C:\ProgramData\Troika Systems\AMS\AMS_ss.db","","",#PB_Database_SQLite) = 0
If OpenDatabase(1,"C:\ProgramData\Troika Systems\AMS\AMS_ss.db","","",#PB_Database_SQLite) = 0
  Debug "Failed to Open the database"
  Debug DatabaseError()
Else

  ;Result.i = DatabaseQuery(1,"Select Count(*) from AMS_groups;");, Count(*) from AMS_Roll_Master;")
  
  ;SQL.s = "Select (Select Count(*) from AMS_Groups),(Select Count(*) from AMS_Roll_Master),(Select Count(*) from AMS_Roll_Master where LastReadingDate > "
  ;SQL   + Str(DateI14)+"),(Select Count(*) from AMS_Roll_Master where LastReadingDate > "+Str(DateI6W)+"),(Select Count(*) from AMS_Roll_Master where LastReadingDate > "+Str(DateI6M)+");"
  
  ;SQL.s = "select column_name from information_schema.columns where table_name='ams_roll_master' order by column_name;"
  
  ;/ use joins!!
  ;SQL.s = "Select AMS_Roll_Master.ID From AMS_Roll_Master, AMS_Groups Where AMS_Roll_Master.Name = 'First MS import' and AMS_Roll_Master.GroupID = AMS_Groups.ID;"
  ;SQL.s = "Select AMS_Roll_Master.ID From AMS_Roll_Master, AMS_Groups Where upper(AMS_Roll_Master.Name) = 'FIRST MS IMPORT' and AMS_Roll_Master.GroupID = AMS_Groups.ID;"
  ;/ Group count for companyid
  
  ;/ ****************************
  ;/ ***** Update Site Info *****
  ;/ ****************************
  
  ;SQL.s = "Update AMS_Sites set CompanyID = 1 where ID = 6;"
  
  ;/ ***********************************
  ;/ ***** Update Database Version *****
  ;/ ***********************************
  
  SQL.s = "Update AMS_Settings set Version = 10;"
  CheckDatabaseUpdate(Sql)
  
  ;/ ****************************
  ;/ ***** Update Roll Data *****
  ;/ ****************************

  ;SQL.s = "Update AMS_Roll_Data set Depth = 9 where ID = 35;"
  ;SQL.s = "Update AMS_Settings set Version = 8;"
  ;CheckDatabaseUpdate(Sql)
  
;   For x = 1 To 43
;     SQL.s = "Update AMS_Roll_Master set Depth = "+Str(X)+" where ID = "+Str(X)+";"
;     CheckDatabaseUpdate(Sql)
;   Next
  
  
  ;/ *******************
  ;/ ***** Counts  *****
  ;/ *******************
  ;Sql.s = "Select Count(*) from ams_roll_master, ams_groups WHERE ams_roll_master.groupid = ams_groups.id and siteid = 2;"
  ;SQL.s = "SELECT Count(*) FROM ams_roll_master, ams_groups, ams_sites WHERE ams_Roll_Master.groupid = ams_groups.id and ams_groups.siteid = ams_sites.id and ams_sites.companyid = 1;"
  ;SQL.s = "Select Count(*) from AMS_Groups, ams_sites WHERE ams_Roll_Master.groupid = ams_groups.id and ams_groups.siteid = ams_sites.id and ams_sites.companyid = "+Str(1)+";"
  ;SQL.s = "Select (Select Count(*) from AMS_Groups, ams_sites WHERE ams_groups.siteid = ams_sites.id and ams_sites.companyid = "+Str(2)+");"
    
    
  ;/ ****************************
  ;/ ***** Table Amendments *****
  ;/ ****************************
  ;CheckDatabaseUpdate("Alter Table GMS_Roll_Master Add Column AverageVol Float;")
  ;CheckDatabaseUpdate("Alter Table GMS_Roll_Master Add Column AverageDepth Float;")
  ;CheckDatabaseUpdate("Alter Table GMS_Roll_Master Add Column VolTrend Float;")
  ;CheckDatabaseUpdate("Alter Table GMS_Roll_Master Add Column DepthTrend Float;")

  CloseDatabase(1)
EndIf

; IDE Options = PureBasic 5.71 beta 2 LTS (Windows - x86)
; CursorPosition = 11
; Folding = -
; EnableXP