;/ ***************************************************
;/ Convert AMS FMPro database file to AMS SQLite file
;/ ***************************************************
;/
;/ *NB: FMPro insists on the PC being online to allow ODBC connectivity.
;/ 
;/ Rename file: .usr to .fp7
;/  Load into Passware Kit Pro
;/  File will be unlocked (new file created in place)
;/  Note user names that've been unlocked.
;/  
;/  Open the file into FM pro
;/   Use one of the unlocked user names ('th' if 'th' is there)
;/

;/ Menu -> File\Sharing\ODBC...
;/ In dialog, enable sharing and select all users, click on okay.
;/ Keep FMPro open!

;/ Ensure ODBC driver is installed from FMpro CD
;/ Open ODBC *Administrator* - in system DSN, select 'add' and choose 'DataDirect 32-bit Sequelink' option
;/ Give the datasource the name 'LegacyAMS' - Sequelink Host: Localhost
;/                                          - Sequelink Port: 2399
;/                                          - Server Data source: click the button & choose the name that matches the loaded file in Filemaker pro
;/ Test connection, use same Username / password combo that unlocked database in FMPRO
;/    If Geoff has unlocked the file, username should be 'guest' & leave password blank. 
;/ Click on 'Apply' and then 'Ok' - Data source is now set up.


;/ V1.1 - 06/11/2012
;/ Fixed Filemaker pro sending duplicate Roll Master data - now checks for existence. prior to creating a new RollID.
;/ Fixed, If ReadingDate = -1 (No date keyed in Filemaker) - AMS ignores the record if Readingdate < 1 - Now Setting all -1s to +1s.

;/ **** To Do ****
;/ Automatically calculate the variance & Capacity on the roll master table (it's the headline figure that's reported on the roll report view


;/ ********** ADO connection string example
;/ To access a Filemaker Pro database through ADO, set up a System DSN using the Filemaker Pro ODBC Driver.
;/ ADO Connection string: "dsn=your_dsn; Initial Catalog=your_database; User Id=; Password="
;/ I use the .fp5 file extension For my databases.
;/ *********************************************
;/ 4696

;} / Database information
;/ Tables
;/ Rolls
;/  Maker - AMS_Manufacturer_List - Query - Create List - Allocate
;/  ID - Roll_Name
;/  Resolution - Screencount
;/  Width - Roll_Width
;/  Comment - Comments
;/  Suitability - AMS_Suitability - Query - Create List - Allocate
;/  Machine - AMS_Groups - Query - Create List - Allocate
;/  Picorig - TopSnapImage (Blob)
;/  Pos1Orig - 

;EnableExplicit

#Debug = 0

UseJPEGImageDecoder()
UseJPEGImageEncoder()
UseSQLiteDatabase()
UseODBCDatabase()

Global GlobalSize.i = 640*480*3, Timer.i, MyConnection.i, connectionString$
Global Dim CodeString.s(10)

timer = ElapsedMilliseconds()
XIncludeFile("adomate.pbi")

Macro GetGadgetTextMac(a)
  ;/ a macro to force string encapsulation of ' character, otherwise text issues will ensue when retrieving.
  ReplaceString(ReplaceString(GetGadgetText(a),"''","'"),"'","''") ;/DNT
EndMacro

Procedure MakeConnection()
  Protected User.s
  User.s = InputRequester("","Enter user name (user same as logged in on FM Pro)","")
  MyConnection = 1
  Debug "Connection value: "+Str(myConnection)
  If Not OpenDatabase(1,"LegacyAMS",User,#Null$,#PB_Database_ODBC)
    If MessageRequester("Error", "Unable to connect to the FMPro database, would you like to see the setup help?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      OpenConsole()
      
      PrintN("*NB: FMPro insists on the PC being online to allow ODBC connectivity")
      PrintN("     no network connection = no database connection")
      PrintN("")
      PrintN("Load the *Unlocked* AMS database into FileMaker Pro Advanced")
      PrintN("(Files must be unlocked by Russel @ Ditronic, or by using Passware password recovery software.)")
      PrintN("")
      PrintN("Menu -> File\Sharing\ODBC... ")
      PrintN("In dialog, enable sharing and select all users, click on okay - Keep FMPro open!")
      PrintN("Ensure ODBC driver is installed from FMpro CD")
      PrintN("")
      PrintN("Open ODBC *Administrator*")
      PrintN(" - In system DSN, Select 'add' And choose 'DataDirect 32-bit Sequelink' option")
      PrintN(" - Give the datasource the name 'LegacyAMS'")
      PrintN(" - Sequelink Host: Localhost")
      PrintN(" - Sequelink Port: 2399")
      PrintN(" - Server Data source: click the button & choose the name that matches the")
      PrintN("    loaded file in Filemaker pro")
      PrintN(" - Unlocked database username should be 'guest' & leave password blank.") 
      PrintN("")
      PrintN("Click on 'Apply' and then 'Ok'. Data source now set up, please retry connection")
      
      PrintN(""): PrintN("Return to exit")
      Input()
      
      
      CloseConsole()
      
    EndIf
    End
    
  EndIf
EndProcedure

MakeConnection()

CreateDirectory("Blobs")

Structure DatabaseColumn
  Name.s
  Type.i
EndStructure
Structure Group
  ID.i
  Name.s
  Type.i
  SiteID.i
EndStructure
Structure Suitabilities
  ID.i
  Name.s
EndStructure
Structure Manufacturers
  ID.i
  Name.s
EndStructure
Structure FMPro_RollMaster
  ID.s ;(Name)
  WallWidth.f
  Opening.f
  Angle.f
  Resolution.f
  Width.f
  Date.i
  Comment.s
  Suitability.s
  Machine.s
  Pos1Orig.f
  Pos2Orig.f
  Pos3Orig.f
  Pos4Orig.f
  Pos5Orig.f
  AverageOrig.f
  Author.s
  VarianceOrig.f
  DateOfBirth.i
  Created.i
  DateMade.i
  ColumnData.s[30]
EndStructure
Structure FMPro_RollData
  DateStamp.i
  RollerID.i
  ID.i
  Pos1After.f
  Pos2After.f
  Pos3After.f
  Pos4After.f
  Pos5After.f
  Author.s
  
  VarianceOrig.f
  DateOfBirth.i
  Created.i
  DateMade.i
  ColumnData.s[30]
EndStructure
Structure Damage
  ID.i
  Date.s
  DistanceFromLeft.s
  DistanceFromRight.s
  RollID.i
  Size.s
  Comments.s
  Type.s
EndStructure
Structure System
  Unit.s
EndStructure
Structure SQL_RollMaster
  ID.i ;/ Database Ref
  GroupID.i ;/ Refers to linked list from Group table
  Name.s
  Type.i
  Manufacturer.i ;/ Refers to linked list from Manufacturers table
  Width.i
  Diameter.i
  Suitability.i ;/ Refers to linked list from Suitability table
  DateMade.i
  ScreenCount.i
  Wall.f
  Opening.f
  Comments.s
  Operator.s
  ReadingDate.i
  Vol1.f
  Vol2.f
  Vol3.f
  Vol4.f
  Vol5.f
  Volume.f
  Capacity.f
  Variance.f
  LastReadingDate.i
  PPMM.f
  TopSnapImage.i
  BlobFile.s
  *BlobMem
  *EncodedBlobMem
 
EndStructure
Structure SQL_RollData
  ID.i
  RollID.i
  ReadingDate.i
  Operator.S
  Vol1.f
  Vol2.f
  Vol3.f
  Vol4.f
  Vol5.f
  HistTopSnapImage.i
  BlobFile.s
  *BlobMem
  *EncodedBlobMem
EndStructure
Structure Admin
  Company.s ; User
  ScreenFormat.s ;/ resolution
  LengthUnit.s ; 
  VolumeUnit.s
  Location.s
EndStructure


Global Dim DatabaseColumn.DatabaseColumn(100)
Global NewList RollMaster.SQL_RollMaster()
Global NewList RollData.SQL_RollData()
Global NewList Groups.Group()
Global NewList Suitabilities.Suitabilities()
Global NewList Manufacturers.Manufacturers()
Global NewList Damage.Damage()

Global System.System, Admin.Admin

Enumeration ;/ gadgets
  #Gad_Frame_FMPro
  #Gad_Frame_SQLite
  
  #Gad_RollList
  #Gad_RollContents
  #Gad_RollListText
  #Gad_RollContentsText
  
  #Gad_Machines
  #Gad_Machines_Text
  
  #Gad_Damage
  #Gad_Damage_Text
  
  #Gad_GroupList
  #Gad_ManufacturerList
  #Gad_SuitabilityList
  #Gad_RollMasterList
  #Gad_RollDataList
  #Gad_GeneralHistoryList
  
  #Gad_GroupList_Text
  #Gad_ManufacturerList_Text
  #Gad_SuitabilityList_Text
  #Gad_RollMasterList_Text
  #Gad_RollDataList_Text
  #Gad_GeneralHistoryList_Text
  
  #Gad_Main_Frame
  #Gad_Main_Check
  
  #Gad_Main_ScreenUnit
  #Gad_Main_VolumeUnit
  #Gad_Main_LengthUnit
  #Gad_Main_CompanyName
  #Gad_Main_RecordLimit
  
  #Gad_Frame_Migrator
  
  #CompanyName
  #CompanyName_Text
  
  #Site_Limit
  #Site_Limit_Text
  
  #Roll_Limit
  #Roll_Limit_Text
  
  #ReadingPerRoll_Limit
  #ReadingPerRoll_Limit_Text
  
  #OutputString
  #OutputString_Text
  
  #InputString
  #InputString_Text
  
  #Location
  #Country
  #ContactName
  #Email
  #ContactNumber
  #Location_Text
  #Country_Text
  #ContactName_Text
  #Email_Text
  #ContactNumber_Text
  
  #Gad_Migrate
  #Gad_Messages
  #Gad_Load
EndEnumeration
Enumeration ;/ Windows
  #Win_Main
EndEnumeration

Procedure.s StripSpecial(Txt.s)
  Txt = ReplaceString(Txt,#CR$,"")
  Txt = ReplaceString(Txt,#CRLF$,"")
  Txt = Trim(Txt)
  
  ProcedureReturn Txt
EndProcedure

Procedure Init_Main()
  
  If #Debug = 1
    OpenWindow(#Win_Main,0,0,1900,900,"FMPro Database to SQLite AMS solution",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_MinimizeGadget)
  Else
    OpenWindow(#Win_Main,0,0,640,250,"FMPro Database to SQLite AMS solution",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_MinimizeGadget)
  EndIf
  
  Y = 8
  TextGadget(#CompanyName_Text,10,y,50,20,"Company:")
  StringGadget(#CompanyName,80,y-2,160,20,"") : Y + 22
  
  TextGadget(#Site_Limit_Text,10,Y,65,20,"Site Limit:")
  StringGadget(#Site_Limit,80,Y-2,20,20,"1") : Y + 22
  
  TextGadget(#Roll_Limit_Text,10,Y,50,20,"Roll Limit:")
  StringGadget(#Roll_Limit,80,Y-2,40,20,"100") : Y + 22
  
  TextGadget(#ReadingPerRoll_Limit_Text,10,Y,70,20,"Reading Limit:")
  StringGadget(#ReadingPerRoll_Limit,80,Y-2,40,20,"50") : Y + 22
  
  TextGadget(#Location_Text,10,Y,60,20,"Location:") : StringGadget(#Location,80,Y-2,160,20,"") : Y + 22
  TextGadget(#Country_Text,10,Y,60,20,"Country:") : StringGadget(#Country,80,Y-2,160,20,""): Y + 22
  TextGadget(#ContactName_Text,10,Y,60,20,"Name:") : StringGadget(#ContactName,80,Y-2,160,20,""): Y + 22
  TextGadget(#Email_Text,10,Y,60,20,"Email:") : StringGadget(#Email,80,Y-2,160,20,""): Y + 22
  TextGadget(#ContactNumber_Text,10,Y,60,20,"Number:") : StringGadget(#ContactNumber,80,Y-2,160,20,"") : Y + 30
  ButtonGadget(#Gad_Load,10,Y,110,30,"*** Load ***") 
  ButtonGadget(#Gad_Migrate,120,Y,110,30,"*** Migrate ***") : DisableGadget(#Gad_Migrate,1)
  
  
  If #Debug = 1
    
    FrameGadget(#Gad_Frame_FMPro,400,4,1492,452,"FM Pro data")
    TextGadget(#Gad_RollListText,414,24,200,16,"Roll Master Table (Rolls)")
    ListIconGadget(#Gad_RollList,414,40,800,400,"",0)
    TextGadget(#Gad_RollContentsText,1220,24,200,16,"Roll Content Table (Reports)")
    ListIconGadget(#Gad_RollContents,1220,40,600,400,"",0)
    
    FrameGadget(#Gad_Frame_SQLite,4,456,1892,452,"SQLite data")
    
    TextGadget(#Gad_RollMasterList_Text,14,476,200,16,"AMS_Roll_Master")
    ListIconGadget(#Gad_RollMasterList,14,496,600,400,"ID",24)
    AddGadgetColumn(#Gad_RollMasterList,2,"GroupID",44)
    AddGadgetColumn(#Gad_RollMasterList,3,"Name",44)
    ;  AddGadgetColumn(#Gad_RollMasterList,4,"Type",44)
    AddGadgetColumn(#Gad_RollMasterList,5,"Manufacturer",44)
    AddGadgetColumn(#Gad_RollMasterList,6,"Width",44)
    ;  AddGadgetColumn(#Gad_RollMasterList,7,"Diameter",44)
    AddGadgetColumn(#Gad_RollMasterList,8,"Suitability",44)
    AddGadgetColumn(#Gad_RollMasterList,9,"DateMade",44)
    AddGadgetColumn(#Gad_RollMasterList,10,"ScreenCount",44)
    AddGadgetColumn(#Gad_RollMasterList,11,"Wall",44)
    AddGadgetColumn(#Gad_RollMasterList,12,"Opening",44)
    AddGadgetColumn(#Gad_RollMasterList,13,"Comments",44)
    AddGadgetColumn(#Gad_RollMasterList,14,"Operator",44)
    AddGadgetColumn(#Gad_RollMasterList,15,"ReadingDate",44)
    AddGadgetColumn(#Gad_RollMasterList,16,"Vol1",44)
    AddGadgetColumn(#Gad_RollMasterList,17,"Vol2",44)
    AddGadgetColumn(#Gad_RollMasterList,18,"Vol3",44)
    AddGadgetColumn(#Gad_RollMasterList,19,"Vol4",44)
    AddGadgetColumn(#Gad_RollMasterList,20,"Vol5",44)
    ; AddGadgetColumn(#Gad_RollMasterList,21,"Volume",44)
    ; AddGadgetColumn(#Gad_RollMasterList,22,"Capacity",44)
    ; AddGadgetColumn(#Gad_RollMasterList,23,"Variance",44)
    ; AddGadgetColumn(#Gad_RollMasterList,24,"LastReadingDate",44)
    AddGadgetColumn(#Gad_RollMasterList,25,"TopSnapImage",44)
    
    TextGadget(#Gad_RollDataList_Text,620,476,200,16,"AMS_Roll_Data")
    ListIconGadget(#Gad_RollDataList,620,496,400,400,"ID",24)
    AddGadgetColumn(#Gad_RollDataList,2,"RollID",44)
    AddGadgetColumn(#Gad_RollDataList,3,"ReadingDate",60)
    AddGadgetColumn(#Gad_RollDataList,4,"Operator",44)
    AddGadgetColumn(#Gad_RollDataList,5,"Vol1",44)
    AddGadgetColumn(#Gad_RollDataList,6,"Vol2",44)
    AddGadgetColumn(#Gad_RollDataList,7,"Vol3",44)
    AddGadgetColumn(#Gad_RollDataList,8,"Vol4",44)
    AddGadgetColumn(#Gad_RollDataList,9,"Vol5",44)
    AddGadgetColumn(#Gad_RollDataList,10,"HistTopSnapImage",60)
    
    TextGadget(#Gad_GroupList_Text, 1030,476,190,16,"AMS_Groups")
    ListIconGadget(#Gad_GroupList, 1030,496,190,400,"ID",24)
    AddGadgetColumn(#Gad_GroupList,2,"Groupname",68)
    AddGadgetColumn(#Gad_GroupList,3,"Type",36)
    AddGadgetColumn(#Gad_GroupList,4,"SiteID",48)
    
    TextGadget(#Gad_GeneralHistoryList_Text,1430,476,200,16,"AMS_General_History")
    ListIconGadget(#Gad_GeneralHistoryList,1430,496,250,400,"ID",24)
    AddGadgetColumn(#Gad_GeneralHistoryList,2,"Date",60)
    AddGadgetColumn(#Gad_GeneralHistoryList,3,"Type",50)
    AddGadgetColumn(#Gad_GeneralHistoryList,4,"Comments",120)
    
    TextGadget(#Gad_ManufacturerList_Text,1690,476,100,16,"AMS_Manufacturers")
    ListIconGadget(#Gad_ManufacturerList,1690,496,100,400,"ID",24)
    AddGadgetColumn(#Gad_ManufacturerList,2,"Name",70)
    
    TextGadget(#Gad_SuitabilityList_Text,1230,476,180,16,"AMS_Suitability")
    ListIconGadget(#Gad_SuitabilityList,1230,496,180,400,"ID",24)
    AddGadgetColumn(#Gad_SuitabilityList,2,"Description",96)
    ListViewGadget(#Gad_Messages,2,250,380,200)
  Else
    ListViewGadget(#Gad_Messages,250,4,380,240)
  EndIf
  
EndProcedure
Procedure Flush_Events()
  Repeat
  Until WindowEvent() =0
EndProcedure
Procedure Add_Message(Txt.s)
  AddGadgetItem(#Gad_Messages,-1,txt)
  Flush_Events()
EndProcedure
Procedure$ EncryptPassword(password$, key$)
  ;Debug Len(password$)
  Protected passin$        = LSet(password$, 64, Chr(32))                   ; Pad the password with spaces to make 64 characters   
  Protected keyin$         = LSet(key$, 16, Chr(32))                        ; key for 128bit encryption needs length=16
  Protected *encodedbinary = AllocateMemory(64)                             ; 32 bytes for encrypted binary result, see 2 lines down
  Protected *encodedtext   = AllocateMemory(128)                             ; Destination for Base64Encoder must be 33% larger- we double it
  
  Protected *AsciiPass     = AllocateMemory(65)
  Protected *AsciiKey      = AllocateMemory(65)
  PokeS(*AsciiPass,passin$,Len(passin$),#PB_Ascii)
  PokeS(*AsciiKey,Keyin$,Len(Keyin$),#PB_Ascii)
  
  AESEncoder(*AsciiPass, *encodedbinary, 64, *AsciiKey, 128, 0, #PB_Cipher_ECB) ; We don't encrypt the trailing zero so 64 bytes is enough
  Base64Encoder(*encodedbinary, 64, *encodedtext, 128)                       ; Convert encrypted binary data to ascii for return                     
  ProcedureReturn PeekS(*encodedtext,-1,#PB_Ascii)                                       ; Return the completed ascii result
EndProcedure
Procedure$ DecryptPassword(password$, key$)
  Protected keyin$         = LSet(key$, 16, Chr(32))                            ; key for 128bit decryption needs length=16
  Protected *encodedbinary = AllocateMemory(128)                                 ; 32 bytes for data + one safety byte
  Protected *decodedtext   = AllocateMemory(128)                               ; 32 bytes for characters + one byte for terminating zero
  
  Protected *AsciiPass     = AllocateMemory(128)
  Protected *AsciiKey      = AllocateMemory(128)  
  
  PokeS(*AsciiKey,Keyin$,Len(keyin$),#PB_Ascii)
  PokeS(*AsciiPass,password$,Len(password$),#PB_Ascii)
  
  Base64Decoder(*AsciiPass, Len(password$), *encodedbinary, 64)                 ; Convert the ascii encoded password back to binary
  AESDecoder(*encodedbinary, *decodedtext, 64, *AsciiKey, 128, 0, #PB_Cipher_ECB) ; Convert the encrypted password back to original
  ProcedureReturn Trim(PeekS(*decodedtext, -1,#PB_Ascii))                                 ; Remove any trailing spaces and return result
EndProcedure

Procedure.s Code(Comp.s,SiteLimit.s,RollLimit.s,ReadingLimit.s)
  
  Encode.s = "ARK"+Chr(10)+Comp+Chr(10)+SiteLimit+Chr(10)+RollLimit + Chr(10) + ReadingLimit
  
  Enc.s = EncryptPassword(encode,"OpenWindow")
  
  ProcedureReturn Enc
  
EndProcedure
Procedure.s CodeI(Comp.s)
  
  Encode.s = "ARK"+Chr(10)+Comp
  
  Enc.s = EncryptPassword(encode,"OpenWindow")
  
  ProcedureReturn Enc
  
EndProcedure

Procedure Get_SuitabilityID(Txt.s)
  ForEach Suitabilities()
    If Suitabilities()\Name = Txt
      ProcedureReturn Suitabilities()\ID
    EndIf
  Next
  ProcedureReturn 0
  
EndProcedure
Procedure Get_GroupID(Txt.s)
  ForEach Groups()
    If groups()\Name = Txt
      ProcedureReturn Groups()\ID
    EndIf
  Next
  ProcedureReturn 0
EndProcedure
Procedure Get_RollID(Txt.s)
  Txt = Trim(Txt)
  Debug "Get_RollID Lookup For: "+txt+" - Len: "+Str(Len(Txt))
  ForEach RollMaster()
    If Trim(RollMaster()\Name) = Txt
      Debug Txt+" found at Record: "+Str(RollMaster()\ID)
      ProcedureReturn RollMaster()\ID
    EndIf
  Next
  Debug "Not Found"
  ProcedureReturn -1
EndProcedure
Procedure Get_ManufacturerID(Txt.s)
  ForEach Manufacturers()
    If Manufacturers()\Name = Txt
      ProcedureReturn Manufacturers()\ID
    EndIf
  Next
  ProcedureReturn 0
EndProcedure

Procedure Load_RollMasterData()
  Protected NameCheck.s
  ;              0       1            2          3    4          5                 6                 7           8          9       10        11        12         13       14       15            16       17            18
  SQL$ = "Select ID, AvWallWidth, AvOpening, Angle, Resolution, Width, "+Chr(34)+"Date"+Chr(34)+", Comment, Suitability, Machine, Pos1Orig, Pos2Orig, Pos3Orig, Pos4Orig, Pos5Orig, AverageOrig, Author, VarianceOrig, DateOfBirth,"
  SQL$ + "Created, DateMade, Maker from Rolls"
  ;         19        20       21
  Debug "SQL: " + Sql$
  If DatabaseQuery(myConnection, SQL$, #PB_Database_StaticCursor)
    If #Debug = #True : Add_Message("Opened database query - OK") : EndIf
    
    While NextDatabaseRow(myConnection)
      NameCheck = StripSpecial(GetDatabaseString(myConnection,0))
      Debug "Namecheck: "+NameCheck
      If Get_RollID(NameCheck) = -1
        AddElement(RollMaster())
        RollMaster()\ID = ListIndex(RollMaster())+1
        RollMaster()\Name = NameCheck
        RollMaster()\Capacity = 100
        RollMaster()\Comments = Trim(GetDatabaseString(myConnection,7))
        RollMaster()\Comments = ReplaceString(RollMaster()\Comments,#CR$,#CRLF$)
        
        Debug "added master roll: "+RollMaster()\Name
        
        If Len(RollMaster()\Comments) > 53 ;/ need to split string
          Protected Dummy.s, Pos.i
          Dummy.s = RollMaster()\Comments
          RollMaster()\Comments = ""
          Repeat
            For Pos = 53 To 0 Step - 1
              If Mid(Dummy,Pos,1) = " " ;/ split at this point
                RollMaster()\Comments + Trim(Left(Dummy,pos)) + #CRLF$
                Dummy = Trim(Right(Dummy,Len(Dummy)-Pos))
                Break
              EndIf
            Next
          Until Len(Dummy) < 53
          RollMaster()\Comments + Dummy
        EndIf
        
        RollMaster()\Wall = GetDatabaseLong(myConnection,1)
        RollMaster()\Opening = GetDatabaseLong(myConnection,2)
        RollMaster()\Operator = StripSpecial(GetDatabaseString(myConnection,16))
        
        Date.s = GetDatabaseString(myConnection,19) : Debug "Date: "+Date
        If FindString(Date,"-")
          Year = Val(StringField(Date,1,"-"))
          Month = Val(StringField(Date,2,"-"))
          Day = Val(StringField(Date,3,"-"))
        Else
          Year = Val(StringField(Date,3,"/"))
          Month = Val(StringField(Date,2,"/"))
          Day = Val(StringField(Date,1,"/"))
        EndIf
        RollMaster()\DateMade = Date(Year,Month,Day,0,0,0)
      
      
        Date.s = GetDatabaseString(myConnection,6)
        If FindString(Date,"-")
          Year = Val(StringField(Date,1,"-"))
          Month = Val(StringField(Date,2,"-"))
          Day = Val(StringField(Date,3,"-"))
        Else
          Year = Val(StringField(Date,3,"/"))
          Month = Val(StringField(Date,2,"/"))
          Day = Val(StringField(Date,1,"/"))
        EndIf
        RollMaster()\ReadingDate = Date(Year,Month,Day,0,0,0)
        
        If RollMaster()\ReadingDate = -1 : RollMaster()\ReadingDate = 1 : EndIf ;/ Fixed for any entries that have no date set - AMS uses it to check if data actually exists.

        RollMaster()\ScreenCount = GetDatabaseLong(myConnection,4)
        RollMaster()\Vol1 = GetDatabaseFloat(myConnection,10)
        RollMaster()\Vol2 = GetDatabaseFloat(myConnection,11)
        RollMaster()\Vol3 = GetDatabaseFloat(myConnection,12)
        RollMaster()\Vol4 = GetDatabaseFloat(myConnection,13)
        RollMaster()\Vol5 = GetDatabaseFloat(myConnection,14)
        
        ;/ these require lookups:
        RollMaster()\Suitability = Get_SuitabilityID(GetDatabaseString(myConnection,8))
        RollMaster()\GroupID = Get_GroupID(GetDatabaseString(myConnection,9))
        RollMaster()\Manufacturer = Get_ManufacturerID(GetDatabaseString(myConnection,21))
        
        If RollMaster()\GroupID = 0: RollMaster()\GroupID =  1 : EndIf
        
        RollMaster()\BlobMem = AllocateMemory(GlobalSize)
        ;If RollMaster()\Suitability = 0: RollMaster()\Suitability =  0 : EndIf
        ;If RollMaster()\Manufacturer = 0: RollMaster()\Manufacturer =  0 : EndIf
      Else
        Debug "Error, The following roll already exists: "+NameCheck
      EndIf
      
      ;NextDatabaseRow(myConnection)
    Wend
    FinishDatabaseQuery(MyConnection)
    
    ;/ Now save Blobs
    SQL$ = "Select ID, PicOrig from Rolls"
    
    If DatabaseQuery(myConnection, SQL$, #PB_Database_StaticCursor)
      While NextDatabaseRow(myConnection)
        row + 1
        Record = Get_RollID(GetDatabaseString(myConnection,0))-1
        ;Debug "Record for Blob: "+ Str(Record)
        If Record > 0
          SelectElement(RollMaster(),Record)

          Result = GetDatabaseBlob(myConnection,1,Rollmaster()\Blobmem,GlobalSize)
          
          If CatchImage(1,Rollmaster()\BlobMem) 
            Rollmaster()\EncodedBlobMem = EncodeImage(1,#PB_ImagePlugin_JPEG)
          EndIf
          
          ;Debug "Blob extracted? "+Str(Result)+" - Size: "+Str(GlobalSize)
        EndIf 
      Wend
      FinishDatabaseQuery(myConnection)
      
    EndIf
    
    If #Debug = 1
      ForEach RollMaster()
        Ad.s = Str(RollMaster()\ID) + Chr(10)
        AD.s + Str(RollMaster()\GroupID) + Chr(10)
        AD.s + RollMaster()\Name + Chr(10)
        AD.s + Str(RollMaster()\Manufacturer) + Chr(10)
        AD.s + Str(RollMaster()\Width) + Chr(10);wid
        AD.s + Str(RollMaster()\Suitability) + Chr(10);suit
        AD.s + Str(RollMaster()\DateMade) + Chr(10);datem
        AD.s + Str(RollMaster()\ScreenCount) + Chr(10)
        AD.s + Str(RollMaster()\wall) + Chr(10)
        AD.s + Str(RollMaster()\Opening) + Chr(10)
        AD.s + RollMaster()\Comments + Chr(10)
        AD.s + RollMaster()\Operator + Chr(10)
        AD.s + Str(RollMaster()\ReadingDate) + Chr(10)
        
        AD.s + StrF(RollMaster()\Vol1,1) + Chr(10)
        AD.s + StrF(RollMaster()\Vol2,1) + Chr(10)
        AD.s + StrF(RollMaster()\Vol3,1) + Chr(10)
        AD.s + StrF(RollMaster()\Vol4,1) + Chr(10)
        AD.s + StrF(RollMaster()\Vol5,1) + Chr(10)
        
        AD.s + RollMaster()\BlobFile
        
        AddGadgetItem(#Gad_RollMasterList,-1,ad.s)
        
      Next
    EndIf
  Else ;/ unable to run query
    ;Repeat
      Debug  DatabaseError()
      Debug  "* Database Query Errored on Roll Master table *"
      CloseDatabase(MyConnection)
      CallDebugger
  EndIf
;  CallDebugger
EndProcedure
Procedure Load_RollData()
  Protected Total.i, NotFound.i
  ;                 0           1         2           3         4           5       6           7         8
  SQL$ = "Select RollerID, DateStamp, Pos1After, Pos2After, Pos3After, Pos4After, Pos5After, Author, AverageAfter,"
  SQL$ + " Variance, PicAfter from Reports"
  ;            9       10
  Debug "Listing Roll Data:"
  
  If DatabaseQuery(myConnection, SQL$, #PB_Database_StaticCursor)
;    numColumns = DatabaseColumns(myConnection)
;    Debug "Number of Columns: "+Str(numColumns)
    
    While NextDatabaseRow(myConnection)
      
      RollID.s = GetDatabaseString(myConnection,0)
      Record = Get_RollID(StripSpecial(RollId))
      Debug "Loaded Record: "+Str(Record)+" - ID: "+RollID
      
      For i = 0 To DatabaseColumns(myConnection)-1
        a$ = DatabaseColumnName(myConnection, i)
        a$ + " ("+Str(DatabaseColumnType(myConnection, i))+") - "
        
        Select DatabaseColumnType(myConnection, i)
          Case 0
            a$+GetDatabaseString(myConnection,i)+Chr(10)
          Case #PB_Database_Long
            a$+Str(GetDatabaseLong(myConnection,i))+Chr(10)
          Case #PB_Database_String
            a$+GetDatabaseString(myConnection,i)+Chr(10)
          Case #PB_Database_Float
            a$+StrF(GetDatabaseFloat(myConnection,i),2)+Chr(10)
          Case #PB_Database_Double
            a$+StrD(GetDatabaseDouble(myConnection,i),2)+Chr(10)
          Case #PB_Database_Quad
            a$+Str(GetDatabaseQuad(myConnection,i))+Chr(10)
          Default
            a$+"Blob"+Chr(10)
        EndSelect
      Next
      total + 1
      If Record > 0 ;/ has related master roll data
        
        AddElement(RollData())
        
        RollData()\ID = ListIndex(RollData())+1
        
        RollData()\Operator = GetDatabaseString(myConnection,7)
        
        Date.s = GetDatabaseString(myConnection,1)
        If FindString(Date,"-")
          Year = Val(StringField(Date,1,"-"))
          Month = Val(StringField(Date,2,"-"))
          Day = Val(StringField(Date,3,"-"))
        Else
          Year = Val(StringField(Date,3,"/"))
          Month = Val(StringField(Date,2,"/"))
          Day = Val(StringField(Date,1,"/"))
        EndIf
        RollData()\ReadingDate = Date(Year,Month,Day,0,0,0)
        
        RollData()\RollID = Get_RollID(StripSpecial(GetDatabaseString(myConnection,0)))
        RollData()\Vol1 =   GetDatabaseFloat(myConnection,2)
        RollData()\Vol2 =   GetDatabaseFloat(myConnection,3) 
        RollData()\Vol3 =   GetDatabaseFloat(myConnection,4) 
        RollData()\Vol4 =   GetDatabaseFloat(myConnection,5) 
        RollData()\Vol5 =   GetDatabaseFloat(myConnection,6) 
        
        RollData()\BlobMem = AllocateMemory(GlobalSize)
        GetDatabaseBlob(myConnection,10,RollData()\BlobMem,GlobalSize)
        
        
        If CatchImage(1,RollData()\BlobMem)
          RollData()\EncodedBlobMem = EncodeImage(1,#PB_ImagePlugin_JPEG)
        EndIf
        
      Else
        Debug "No Master Roll data linked"
        NotFound + 1
      EndIf
      
      NextDatabaseRow(myConnection)
    Wend
    FinishDatabaseQuery(MyConnection)
    
    If #Debug = 1
      ForEach RollData()
        a$ = Str(RollData()\ID) + Chr(10)
        a$ + Str(RollData()\RollID) + Chr(10)
        a$ + Str(RollData()\ReadingDate) + Chr(10)
        a$ + RollData()\Operator + Chr(10)
        a$ + StrF(RollData()\Vol1,1) + Chr(10)
        a$ + StrF(RollData()\Vol2,1) + Chr(10)
        a$ + StrF(RollData()\Vol3,1) + Chr(10)
        a$ + StrF(RollData()\Vol4,1) + Chr(10)
        a$ + StrF(RollData()\Vol5,1) + Chr(10)
        a$ + RollData()\BlobFile + Chr(10)
        AddGadgetItem(#Gad_RollDataList,-1,a$)
      Next
    EndIf
    
    ;/ work out last reading date
    ForEach RollMaster()
      RollMaster()\LastReadingDate = RollMaster()\ReadingDate  
      ForEach RollData()
        If RollData()\RollID = ListIndex(RollMaster())+1
          If RollData()\ReadingDate > RollMaster()\LastReadingDate
            RollMaster()\LastReadingDate = RollData()\ReadingDate  
          EndIf
        EndIf
      Next
    Next
    
  EndIf
  Debug "Total: "+Str(Total)+" - Not Found: "+Str(NotFound)
EndProcedure

Procedure Load_AdminData()
  SQL$ = "Select "+Chr(34)+"User"+Chr(34)+", ResolutionUnit, LengthUnit, VolumeUnit, Location from Admin"
  Debug ""
  Debug "Admin Table"
  Debug "-----------------------"
  
  If DatabaseQuery(myConnection, SQL$, #PB_Database_StaticCursor)
    NextDatabaseRow(MyConnection)    
    Admin\Company = GetDatabaseString(myConnection,0)
    Admin\ScreenFormat = GetDatabaseString(myConnection,1)
    Admin\LengthUnit = GetDatabaseString(myConnection,2)
    Admin\VolumeUnit = GetDatabaseString(myConnection,3)
    Admin\Location = GetDatabaseString(myConnection,4)
    
    SetGadgetText(#CompanyName,Admin\Company)
    ;SetGadgetText(#CompanyName,Admin\ScreenFormat)
    ; SetGadgetText(#CompanyName,Admin\LengthUnit)
    ; SetGadgetText(#CompanyName,Admin\VolumeUnit)
    SetGadgetText(#Location,Admin\Location)
    
    FinishDatabaseQuery(MyConnection)
    
    If #Debug = 1
      If DatabaseQuery(myConnection, "Select * from Admin", #PB_Database_StaticCursor)
        NextDatabaseRow(MyConnection)
        numColumns = DatabaseColumns(myConnection)
        If numColumns
          a$ = ""
          For i = 0 To numColumns-1
            a$ = DatabaseColumnName(myConnection, i)
            a$ + " ("+Str(DatabaseColumnType(myConnection, i))+") - "
            
            Select DatabaseColumn(i)\Type
              Case 0
                a$+GetDatabaseString(myConnection,i)+Chr(10)
              Case #PB_Database_Long
                a$+Str(GetDatabaseLong(myConnection,i))+Chr(10)
              Case #PB_Database_String
                a$+GetDatabaseString(myConnection,i)+Chr(10)
              Case #PB_Database_Float
                a$+StrF(GetDatabaseFloat(myConnection,i),2)+Chr(10)
              Case #PB_Database_Double
                a$+StrD(GetDatabaseDouble(myConnection,i),2)+Chr(10)
              Case #PB_Database_Quad
                a$+Str(GetDatabaseQuad(myConnection,i))+Chr(10)
              Default
                a$+"Blob"+Chr(10)
                
            EndSelect
            
            Debug a$ ;AddGadgetColumn(#Gad_RollContents,i,a$,Len(a$)*7)
            
            
          Next
          FinishDatabaseQuery(MyConnection)
        EndIf
        
      EndIf
    EndIf
    
  EndIf
EndProcedure

Procedure Load_GroupData()
  Protected Txt.s
  
  AddElement(Groups()) : Groups()\ID = 1 : Groups()\Name = "Unassigned" : Groups()\Type = 0 : Groups()\SiteID = 1
  SQL$ = "Select Name from Machines"
  If DatabaseQuery(myConnection, SQL$, #PB_Database_StaticCursor)
    While NextDatabaseRow(myConnection)
      AddElement(Groups())
      Groups()\ID = ListIndex(Groups())+1
      Groups()\Name = GetDatabaseString(myConnection,0)
      Groups()\SiteID = 1
      Groups()\Type = 1
    Wend
    
    FinishDatabaseQuery(MyConnection)
    
    If #Debug = 1
      ForEach Groups()
        txt.s = Str(Groups()\ID) + Chr(10) + Groups()\Name + Chr(10) + Str(Groups()\Type) + Chr(10)  +Str(Groups()\SiteID)+Chr(10)
        AddGadgetItem(#Gad_GroupList,-1,txt)
      Next
    EndIf
    
  EndIf
  
EndProcedure
Procedure Load_ManufacturerData()
  Protected Txt.s, NewMap ManufacturerMap.s()
  ClearList(Manufacturers())
  ;  AddElement(Manufacturers())
  ;  Manufacturers()\ID = 1 : Manufacturers()\Name = "Unknown"
  
  SQL$ = "Select Maker from Rolls"
  
  If DatabaseQuery(myConnection, SQL$, #PB_Database_StaticCursor)
    While NextDatabaseRow(myConnection)
      Txt.s = Trim(GetDatabaseString(myConnection,0))
      ManufacturerMap(Txt) = Txt
    Wend
    
    ForEach ManufacturerMap()
      If ManufacturerMap() <> ""
        AddElement(Manufacturers())
        Manufacturers()\ID = ListIndex(Manufacturers())+1
        Manufacturers()\Name = ManufacturerMap()
      EndIf
    Next
  EndIf
  
  If #Debug = 1
    ForEach Manufacturers()
      txt.s = Str(Manufacturers()\ID) + Chr(10) + Manufacturers()\Name
      AddGadgetItem(#Gad_ManufacturerList,-1,txt)
    Next
  EndIf
EndProcedure
Procedure Load_SuitabilityData()
  Protected Txt.s, NewMap SuitabilityMap.s()
  
  ClearList(Suitabilities())
  ;AddElement(Suitabilities())
  ;Suitabilities()\ID = 1 : Suitabilities()\Name = "Unknown"
  
  SQL$ = "Select Suitability from Rolls"
  
  If DatabaseQuery(myConnection, SQL$, #PB_Database_StaticCursor)
While NextDatabaseRow(myConnection)
      Txt.s = GetDatabaseString(myConnection,0)
      SuitabilityMap(Txt) = Txt
    Wend
    
    ForEach SuitabilityMap()
      If SuitabilityMap() <> ""
        AddElement(Suitabilities())
        Suitabilities()\ID = ListIndex(Suitabilities())+1
        Suitabilities()\Name = SuitabilityMap()
      EndIf
    Next
  EndIf
  
  If #Debug = 1
    ForEach Suitabilities()
      txt.s = Str(Suitabilities()\ID) + Chr(10) + Suitabilities()\Name
      AddGadgetItem(#Gad_SuitabilityList,-1,txt)
    Next
  EndIf
EndProcedure

Procedure Load_DamageData()
  SQL$ = "Select "+Chr(34)+"Date"+Chr(34)+", DistanceFromLeft, DistanceFromRight, RollID, Size, Type from Damage"
  
  SQL$ = "Select "+Chr(34)+"Date"+Chr(34)+", DistanceFromLeft, DistanceFromRight, RollID, "+Chr(34)+"Size"+Chr(34)+", "+Chr(34)+"Type"+Chr(34)+" from Damage"
  Debug sql$
  
  If DatabaseQuery(myConnection, SQL$, #PB_Database_StaticCursor)
    While NextDatabaseRow(myConnection)
      AddElement(Damage())
      
      Date.s = GetDatabaseString(myConnection,0)
      Year = Val(StringField(Date,3,"/"))
      Month = Val(StringField(Date,2,"/"))
      Day = Val(StringField(Date,1,"/"))
      Damage()\Date = Str(Date(Year,Month,Day,0,0,0))
      
      Damage()\DistanceFromLeft = Str(GetDatabaseFloat(myConnection,1))
      Damage()\DistanceFromRight = Str(GetDatabaseLong(myConnection,2))
      Damage()\RollID = Get_RollID(GetDatabaseString(myConnection,3))
      Damage()\Size = StrF(GetDatabaseFloat(myConnection,4),2)
      Damage()\Type = GetDatabaseString(myConnection,5)
      
      Damage()\Comments = "Distance (from left): "+Damage()\DistanceFromLeft+ Admin\LengthUnit +" - Size: "+Damage()\Size + Admin\lengthUnit +" - Type: "+Damage()\Type
      
      Damage()\Type = "Damage"
    Wend
    FinishDatabaseQuery(MyConnection)
    
    ForEach Damage() ;/ remove those with zero RollID values (assigned to rolls which no longer exist)
      If Damage()\RollID = 0
        DeleteElement(Damage())
      EndIf
    Next
    
    ForEach Damage() ;/ remove those with zero RollID values (assigned to rolls which no longer exist)
      Damage()\ID = ListIndex(Damage())
    Next
    
    If #Debug = 1
      ForEach Damage()
        a$ = Str(Damage()\RollID) + Chr(10);Str(Damage()\Date)
        a$ + Damage()\Date + Chr(10)
        a$ + Damage()\Type + Chr(10)
        a$ + Damage()\Comments
        
        AddGadgetItem(#Gad_GeneralHistoryList,-1,a$)
      Next
    EndIf
    
  Else
    MessageRequester("Error","Error with SQL on Damage data")
  EndIf
EndProcedure

Procedure CheckDatabaseUpdate(Database, query.S)
  Result = DatabaseUpdate(Database, query.S)
  If Result = 0
    MessageRequester("Error in query: ",query+Chr(10)+ DatabaseError())
    End
  EndIf
  ProcedureReturn Result
EndProcedure
Procedure.s FormatTextMac(a.s) 
  ;/ a macro to force string encapsulation of ' character, otherwise text issues will ensue when storing.
  ProcedureReturn ReplaceString(ReplaceString(a,"''","'"),"'","''") ;/DNT
EndProcedure

Procedure Load()
  Add_Message("Loading Admin Data....")
  Load_AdminData()
  
  Add_Message("Loading Group Data....")
  Load_GroupData()
  
  Add_Message("Loading Suitability Data....")
  Load_SuitabilityData()
  
  Add_Message("Loading Manufacturer Data....")
  Load_ManufacturerData()
  
  Add_Message("Loading Roll Master Data....")
  Load_RollMasterData()
  
  Add_Message("Loading Damage Data....")
  Load_DamageData()
  
  Add_Message("Loading Roll Data....")
  Load_RollData()
  
  Add_Message("Loading complete.")
  
  CloseDatabase(myConnection)
  
  DisableGadget(#Gad_Migrate,0)
  DisableGadget(#Gad_Load,1)
  
EndProcedure

Procedure Migrate()
  Protected Txt.s
  ;Add_Message("Generating empty database file...")
  CopyFile("Database\AMS_Empty.db","Database\AMS_SS.db")
  
  If OpenDatabase(1,"Database\AMS_SS.db","","",#PB_Database_SQLite)
    
    ;/ Write company info and settings text
    Add_Message("Updating AMS_Settings table...")
    DatabaseUpdate(1,"UPDATE AMS_Settings SET Code='"+Code(GetGadgetText(#CompanyName),GetGadgetText(#Site_Limit),GetGadgetText(#Roll_Limit),GetGadgetText(#ReadingPerRoll_Limit))+"';")
    
    If Admin\VolumeUnit = "BCM"
      DatabaseUpdate(1,"UPDATE AMS_Settings SET VolumeUnit= 1;")
    Else
      DatabaseUpdate(1,"UPDATE AMS_Settings SET VolumeUnit= 0;")
    EndIf
    
    If Admin\ScreenFormat = "lpi"
      DatabaseUpdate(1,"UPDATE AMS_Settings SET ScreenUnit= 0;")
    Else
      DatabaseUpdate(1,"UPDATE AMS_Settings SET ScreenUnit= 1;")
    EndIf
    
    If Admin\LengthUnit = "in."
      DatabaseUpdate(1,"UPDATE AMS_Settings SET LengthUnit= 1;")
    Else
      DatabaseUpdate(1,"UPDATE AMS_Settings SET LengthUnit= 0;")
    EndIf
    
    Add_Message("Updating AMS_Companyinfo table")
    
    DatabaseUpdate(1,"Insert into AMS_CompanyInfo (Location) Values ('"+CodeI(GetGadgetText(#Location))+"');")
    DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET Country = '"+CodeI(GetGadgetText(#Country))+"';")
    DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET ContactName = '"+CodeI(GetGadgetText(#ContactName))+"';")
    DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET ContactEmail = '"+CodeI(GetGadgetText(#Email))+"';")          
    DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET ContactNumber = '"+CodeI(GetGadgetText(#ContactNumber))+"';")
    
    DatabaseUpdate(1,"Update AMS_Sites Set Location ='"+GetGadgetText(#Location)+"';")
    DatabaseUpdate(1,"Update AMS_Sites Set Name ='"+GetGadgetText(#Location)+"';")
    DatabaseUpdate(1,"UPDATE AMS_Sites SET Country  = '"+GetGadgetText(#Country)+"';")
    DatabaseUpdate(1,"UPDATE AMS_Sites SET ContactName   = '"+GetGadgetText(#ContactName)+"';")
    DatabaseUpdate(1,"UPDATE AMS_Sites SET ContactEmail  = '"+GetGadgetText(#Email)+"';")
    DatabaseUpdate(1,"UPDATE AMS_Sites SET ContactNumber = '"+GetGadgetText(#ContactNumber)+"';")
    
    ;/ Write Roll Master records
    ForEach RollMaster()
      Txt = "INSERT INTO AMS_Roll_Master "
      ;/        1        2    3             4         5          6        7            8     9          10        11      
      Txt + "(GroupID, Name, Manufacturer, Width, Suitability, DateMade, ScreenCount, Wall, Opening, Comments, Operator,"
      Txt + "ReadingDate, Vol1, Vol2, Vol3, Vol4, Vol5, Volume, Capacity, Variance, LastReadingDate, TopSnapImage) Values ("
      ;/      12           13    14    15    16    17    18      19        20            21              22  
      
      If MemorySize(RollMaster()\EncodedBlobMem) > 0
        SetDatabaseBlob(1,0,RollMaster()\EncodedBlobMem,MemorySize(RollMaster()\EncodedBlobMem))
      EndIf
      
      With RollMaster()
        Txt + Str(\GroupID)+",'"+\Name+"',"+Str(\Manufacturer)+","+Str(\Width)+","+Str(\Suitability)+","+Str(\DateMade)+","+Str(\ScreenCount)+","+StrF(\Wall,1)+","+StrF(\Opening,1)+",'"+\Comments+"','"+\Operator+"',"
        Txt + Str(\ReadingDate)+","+StrF(\Vol1,1)+","+StrF(\Vol2,1)+","+StrF(\Vol3,1)+","+StrF(\Vol4,1)+","+StrF(\Vol5,1)+","+StrF(\Volume,1)+","+StrF(\Capacity,1)+","+StrF(\Variance,1)+","+Str(\LastReadingDate)+",?)"
      EndWith
      
      CheckDatabaseUpdate(1,Txt)
    Next
    
    ;/ Write Roll Data records
    ForEach RollData()
      Txt = "INSERT INTO AMS_Roll_Data "
      Txt + "(RollId, ReadingDate, Operator, Vol1, Vol2, Vol3, Vol4, Vol5, HistTopSnapImage) Values ("
      ;/        1          2            3      4    5      6    7      8           9         
      ;SetDatabaseBlob(1,0,RollData()\BlobMem,GlobalSize)
      If MemorySize(RollData()\EncodedBlobMem) > 0
        SetDatabaseBlob(1,0,RollData()\EncodedBlobMem,MemorySize(RollData()\EncodedBlobMem))
      EndIf
      
      With RollData()
        Txt + Str(\RollID)+","+Str(\ReadingDate)+",'"+\Operator+"',"+StrF(\Vol1,1)+","+StrF(\Vol2,1)+","+StrF(\Vol3,1)+","+StrF(\Vol4,1)+","+StrF(\Vol5,1)+",?)"
      EndWith
      CheckDatabaseUpdate(1,Txt)
    Next
    
    ;/ Write Group records
    Add_Message("Updating AMS_Groups table: "+Str(ListSize(Groups()))+" records.")
    ForEach Groups()
      CheckDatabaseUpdate(1, "INSERT INTO AMS_Groups (GroupName, Type, SiteID) VALUES ('"+Groups()\Name+"',"+Str(Groups()\Type)+",'1')")   
    Next
    
    ;/ Write general history records (Damage)
    Add_Message("Updating AMS_General_History table")
    ForEach Damage()
      If Damage()\RollID > -1
        Debug "Date written: "+Damage()\Date
        CheckDatabaseUpdate(1, "INSERT INTO AMS_General_History (RollID, Date, Type, Comments) VALUES ('"+Str(Damage()\RollID)+"','"+Damage()\Date+"','"+Damage()\Type+"','"+Damage()\Comments+"')")   
      EndIf
    Next
    
    ;/ Write Manufacturer records
    Add_Message("Updating AMS_Manufacturers table")
    ForEach Manufacturers()
      CheckDatabaseUpdate(1, "INSERT INTO AMS_Manufacturers (Name) VALUES ('"+Manufacturers()\Name+"')")   
    Next
    
    ;/ Write Suitability records
    Add_Message("Updating AMS_Suitability table")
    ForEach Suitabilities()
      CheckDatabaseUpdate(1, "INSERT INTO AMS_Suitability (RollType, Description) VALUES ('1', '"+Suitabilities()\Name+"')")
    Next
    
    Add_Message("Finished updating, please check database is working correctly")
    
    If MessageRequester("Option:","Do you wish to copy the new database to the Program Data directory?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      If CopyFile("Database\AMS_SS.db","C:\ProgramData\Troika Systems\AMS\AMS_SS.db")
        MessageRequester("Success","File Copied successfully")
      EndIf
      
    EndIf
    
    
    CloseDatabase(1)
  Else
    MessageRequester("Error","Unable to open empty database file")
  EndIf
  
  
EndProcedure

Init_Main()

Define.i OKToMigrate, Loaded

Repeat
  event = WaitWindowEvent()
  
  If Loaded = 1
    OKToMigrate = 1
    If GetGadgetText(#Location) <> ""
      If GetGadgetText(#Email) <> ""
        If GetGadgetText(#Country) <> ""
          If GetGadgetText(#ContactName) <> ""
            If GetGadgetText(#ContactNumber) <> ""
              OKToMigrate = 0
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
    DisableGadget(#Gad_Migrate,OKToMigrate)
  EndIf
  
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #Gad_Migrate
          Migrate()
          
        Case #Gad_Load
          Load()
          Loaded = 1
      EndSelect
      
  EndSelect
  
  
  
Until Event = #PB_Event_CloseWindow

End

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 1161
; FirstLine = 945
; Folding = Aw3B7--
; Executable = Filemaker to SQL AMS migrator - 2015.exe
; EnablePurifier