;/ ** AMS Language Database file editor - Version 1.03 - P.James Dec 2011 - Aug 2014.
;/ V1.03 - removed admin mode, added user mode.

EnableExplicit

Macro GetGadgetTextMac(a)
  ;/ a macro to force string encapsulation of ' character, otherwise text issues will ensue when retrieving.
  ReplaceString(ReplaceString(GetGadgetText(a),"''","'"),"'","''") ;/DNT
EndMacro

Enumeration ;/windows
  #Window_Main
  #Window_AddString
EndEnumeration
Enumeration ;/Gadgets
  #Gad_Lang1DropDown
  #Gad_Lang2DropDown
  #Gad_Reference
  #Gad_LangReference
  #Gad_LangWork
  #Gad_Import
  #Gad_Export
  #Gad_NewLanguage
  #Gad_Lang_List

  #Gad_Font_Name
  #Gad_Font_Size_XS
  #Gad_Font_Size_S
  #Gad_Font_Size_M
  #Gad_Font_Size_L
  #Gad_Font_Size_XL
  #Gad_Font_Name_Text
  #Gad_Font_Size_XS_Text
  #Gad_Font_Size_S_Text
  #Gad_Font_Size_M_Text
  #Gad_Font_Size_L_Text
  #Gad_Font_Size_XL_Text
  
  #Gad_Search_Lang1
  #Gad_Search_Lang2
  #Gad_Search_Lang1_Text
  #Gad_Search_Lang2_Text
  
  #Gad_SameString_Report
  #Gad_AddString
  #Gad_Add_Ok
  #Gad_Add_Cancel
  #Gad_Add_String
  #Gad_Add_Enumeration
  #Gad_Add_String_Text
  #Gad_Add_Enumeration_Text
  #Gad_Add_Check
  
  #Gad_ShowIdenticalOnly
  #Gad_ShowNullStringsOnly
EndEnumeration

Structure System
  LanguageCount.i
  StringCount.i
  Showing_Enumerations.i
  
  Filter1.s
  Last_Filter1.s
  
  Filter2.s
  Last_Filter2.s
  
  Allow_Add.i
  Hide_NonTranslated.i
  
EndStructure
Structure LanguageMaster
  FileName.s
  Language.s
  FontName.s
  FontsizeXS.i
  FontsizeS.i
  FontsizeM.i
  FontsizeL.i
  FontsizeXL.i
  Comment.s
  StringCount.i
  String.s[500]
  String_Override.s[500]
EndStructure

Global MaxStr.i = 1000
Global Dim Enums.s(MaxStr)
Global Dim Lang1.s(MaxStr)
Global Dim Lang2.s(MaxStr)
Global Dim Lang2Override.s(MaxStr)
Global NewList LangMaster.Languagemaster()
Global Event.i, System.system, Count.i

Global FontText.i, LanguagesDirectory.s
Global Dim FontSize.i(8)

Procedure.s GetSpecialFolder(iVal.l)
  ;/ Procedure that returns the 'All User' data storage area
  ;/ Win XP - C:\Documents&Settings\AllUsers\ProgramData
  ;/ Windows Vista & 7;  C:\ProgramData\AllUsers\
  
  Protected Folder_ID, SpecialFolderLocation.s
  
  If SHGetSpecialFolderLocation_(0, iVal, @Folder_ID) = 0
    
    SpecialFolderLocation = Space(#MAX_PATH)
    SHGetPathFromIDList_(Folder_ID, @SpecialFolderLocation)
    
    If SpecialFolderLocation
      
      If Right(SpecialFolderLocation, 1) <> "\"
        
        SpecialFolderLocation + "\"
        
      EndIf
      
    EndIf
    
    CoTaskMemFree_(Folder_ID)
    
  EndIf
  
  ProcedureReturn SpecialFolderLocation
  
EndProcedure
LanguagesDirectory = GetSpecialFolder($23)+"Troika Systems\AMS\Languages\"
Debug "Languages Directory: "+LanguagesDirectory

Procedure Create_SameString_Report()
  Protected X.i, T1.s, T2.s, Txt.s
  
  CreateFile(10,"SameString Report.txt")
  For X = 1 To System\StringCount
    T1.s = Lang1(x)
    T2.s = Lang2(x)
    If Lang2Override(x) <> "" : t2 = Lang2Override(x) : EndIf
    If t1 = t2
      Txt.s = "Record: "+Str(x)+" - Found untranslated string: "+t1
      WriteStringN(10,txt)
    EndIf
  Next
  CloseFile(10)
  MessageRequester("Message","File written")
  
EndProcedure

Procedure.i CheckDatabaseUpdate(Database, query.S)
  Protected Result.i
  
  Result = DatabaseUpdate(Database, query.S)
  Debug Query
  If Result = 0
    MessageRequester("Error in query: ",query+Chr(10)+ DatabaseError())
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure.i Database_CountQuery(Database.i,SQL.S, Quiet.i = 0)
  Protected Result.i, QueryResult.i
  QueryResult =  DatabaseQuery(Database, SQL)
  NextDatabaseRow(Database) ;/ only one row, so no need for while / 
  Result = Val(GetDatabaseString(Database,0))
  
  If QueryResult = 0 And quiet = 0
    MessageRequester("Error?"+" ",SQL+Chr(10)+DatabaseError())
  EndIf
  
  FinishDatabaseQuery(Database)
  
  ProcedureReturn Result
EndProcedure
Procedure.S Database_StringQuery(Database.i,SQL.S)
  Protected Result.S, QueryResult.i
  QueryResult = DatabaseQuery(Database, SQL)
  NextDatabaseRow(Database) ;/ only one row, so no need for while / 
  Result = GetDatabaseString(Database,0)
  
  If QueryResult = 0
    MessageRequester("Error?"+" ",SQL+Chr(10)+DatabaseError())
  EndIf
  
  FinishDatabaseQuery(Database)
  ProcedureReturn Result.S
EndProcedure
Procedure.i Database_IntQuery(Database.i,SQL.S)
  Protected Result.i, QueryResult.i
  QueryResult = DatabaseQuery(Database, SQL)
  NextDatabaseRow(Database) ;/ only one row, so no need for while / 
  Result = GetDatabaseLong(Database,0)
  
  If QueryResult = 0
    MessageRequester("Error?"+" ",SQL+Chr(10)+DatabaseError())
  EndIf
  
  FinishDatabaseQuery(Database)

  ProcedureReturn Result.i
EndProcedure
Procedure.i Database_Export()
  Protected MyLoop.i, fileName.s, SM.s
  FileName.s = LanguagesDirectory
  FileName.s + GetGadgetText(#Gad_Lang1DropDown)+"-"+GetGadgetText(#Gad_Lang2DropDown)+ "Stringexport.CSV"
  SM.s = Chr(34)
  CreateFile(1,fileName)
  WriteStringN(1,"#, Lang1, Lang2")  
  For MyLoop = 1 To System\StringCount
    WriteStringN(1,sm+Str(Myloop)+SM+","+sm+lang1(Myloop)+SM+","+SM+Lang2(Myloop)+SM)  
  Next

  CloseFile(1)
  MessageRequester("Info","CSV file Exported")
EndProcedure

Procedure.s FormatTextMac(a.s) ;/ a macro to force string encapsulation of ' character, otherwise text issues will ensue.
  ProcedureReturn ReplaceString(ReplaceString(a,"''","'"),"'","''") ;/DNT
EndProcedure

Procedure Parse_Language_Files()
  Protected DirectoryID.i, Stringcount.i, MasterCount.i, NewString.s, MyLoop.i, LoopFrom.i, Version.i
  ClearList(LangMaster())
  directoryID = ExamineDirectory(#PB_Any,LanguagesDirectory,"*.db")
  If directoryID
    While NextDirectoryEntry(directoryID)
      AddElement(Langmaster())
      LangMaster()\FileName = DirectoryEntryName(directoryID)
      Debug LangMaster()\FileName
    Wend
    FinishDirectory(directoryID)
  Else
    MessageRequester("Error","No Language files found, is AMS installed on this machine?")
    End
  EndIf  
  
  ;/ Check version of all language database files and update if necessary.
  
  ForEach LangMaster()
    Debug "Loading: "+LangMaster()\FileName
    ;MessageRequester("Msg","Loading: "+LangMaster()\FileName)
    If OpenDatabase(0,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
      DatabaseQuery(0,"Select Version from AMS_Language_Master;")

      NextDatabaseRow(0)
      Version =  GetDatabaseLong(0,0)
      Debug LangMaster()\FileName+" - Version: "+Str(Version)
      
      Select Version
        Case 0 
          ;/ No Version field in Table - Add Version Field, Delimiter Type & Decimal notation
          CheckDatabaseUpdate(0,"ALTER TABLE AMS_Language_Master ADD Column [Version] Int;") ;/DNT
          CheckDatabaseUpdate(0,"ALTER TABLE AMS_Language_Master ADD Column [CSVDelimiter] Char;") ;/DNT
          CheckDatabaseUpdate(0,"ALTER TABLE AMS_Language_Master ADD Column [DecimalNotation] Char;") ;/DNT
          
          ;/ Insert default values
          CheckDatabaseUpdate(0,"Update AMS_Language_Master Set Version = 1, CSVDelimiter = '0', DecimalNotation = '0';")
          
        Case 1
          
          
      EndSelect       
      FinishDatabaseQuery(0)
      CloseDatabase(0)
    EndIf
    
  Next
  
  
  ;/ *** Align Database sizes, so that all databases have the same quantity of records as the master (English) database
  ForEach LangMaster()
    OpenDatabase(0,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
    LangMaster()\StringCount = Database_CountQuery(0,"Select Count(*) from AMS_Language_Data;")
    
    If UCase(LangMaster()\FileName) = UCase("English.DB")
      MasterCount = LangMaster()\StringCount
      Debug "Master Count: "+Str(MasterCount)  
    EndIf
    CloseDatabase(0)
  Next
  ForEach LangMaster()
    If LangMaster()\StringCount < MasterCount
      OpenDatabase(0,LanguagesDirectory+"English.DB","","",#PB_Database_SQLite)
      OpenDatabase(1,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
      LoopFrom = LangMaster()\StringCount
      If Loopfrom = 0 : LoopFrom = 1 : EndIf 
      For Myloop = LoopFrom+1 To MasterCount
        NewString.s = Database_StringQuery(0,"Select String from AMS_Language_Data Where ID = "+Str(MyLoop)+";")
        CheckDatabaseUpdate(1,"Insert Into AMS_Language_Data (String) Values ('"+FormatTextMac(NewString)+"');")
        Debug "Added string to Database: "+LangMaster()\FileName
      Next
      CloseDatabase(0) : CloseDatabase(1)
    EndIf
  Next
  ;/ ***
  
  ForEach LangMaster()
    Debug "Loading: "+LangMaster()\FileName
    OpenDatabase(0,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)

    ;/ Load master data
    ;/ Populate initial table
    DatabaseQuery(0,"Select Language, FontName, FontsizeXS, FontsizeS, FontsizeM, FontsizeL, FontsizeXL, Comment from AMS_Language_Master;")
    ;Debug DatabaseError()
    
    While NextDatabaseRow(0)
      LangMaster()\Language.s = GetDatabaseString(0,0)
      LangMaster()\FontName.s = GetDatabaseString(0,1)
      LangMaster()\FontsizeXS.i = GetDatabaseLong(0,2)
      LangMaster()\FontsizeS.i = GetDatabaseLong(0,3)
      LangMaster()\FontsizeM.i = GetDatabaseLong(0,4)
      LangMaster()\FontsizeL.i = GetDatabaseLong(0,5)
      LangMaster()\FontsizeXL.i = GetDatabaseLong(0,6)
      LangMaster()\Comment.s = GetDatabaseString(0,7)
    Wend
    FinishDatabaseQuery(0)
    
    ;/ Load Strings
    DatabaseQuery(0,"Select String, Override_String from AMS_Language_Data;")
    StringCount = 0
    While NextDatabaseRow(0)
      StringCount + 1
      LangMaster()\String[StringCount] = GetDatabaseString(0,0)
      LangMaster()\String_Override[StringCount] = GetDatabaseString(0,1)
    Wend
    Debug Str(Stringcount)+" strings loaded for Language: "+LangMaster()\Language.s
    LangMaster()\StringCount = StringCount
    FinishDatabaseQuery(0)
    CloseDatabase(0)
    
  Next

  ;/ *** Set default editor languages
  
  Define EngPos.i, GermPos.i
  
  ForEach LangMaster()
    AddGadgetItem(#Gad_Lang1DropDown,-1,LangMaster()\Language)
    AddGadgetItem(#Gad_Lang2DropDown,-1,LangMaster()\Language)
    If LangMaster()\Language = "English"
      EngPos = ListIndex(LangMaster())
    EndIf
    If LangMaster()\Language = "German"
      GermPos = ListIndex(LangMaster())
    EndIf
  Next
  
  SetGadgetState(#Gad_Lang1DropDown,EngPos)
  SetGadgetState(#Gad_Lang2DropDown,GermPos)

EndProcedure

Procedure Write_Enumerations()
  Protected MyLoop.i
  RenameFile("AMS Language Enumerations.PBI","AMS Language Enumerations_BACKUP.PBI")
  CreateFile(1,"AMS Language Enumerations.PBI")
  WriteStringN(1,"Global Dim tTxt.s(1000)")
  WriteStringN(1,"")
  WriteStringN(1,"Enumeration")
  
  For MyLoop = 1 To System\StringCount
    WriteStringN(1,"  "+Enums(MyLoop))
  Next
  
  WriteStringN(1,"EndEnumeration")
  CloseFile(1)

EndProcedure

Procedure Read_Enumerations()
  
  If FileSize("AMS Language Enumerations.PBI") > 0
    OpenFile(1,"AMS Language Enumerations.PBI")
    ReadString(1) : ReadString(1) : ReadString(1)
    Count = 1
    Repeat
      Enums(Count) = Trim(ReadString(1))
      Count + 1
    Until Eof(1)
    
    CloseFile(1)
    System\Allow_Add = 1
  Else
    System\Allow_Add = 0
  EndIf
EndProcedure

Procedure Update_Databases(String.s)
  Protected Result.i
  ForEach LangMaster()
    OpenDatabase(1,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
    Result = CheckDatabaseUpdate(1,"Insert Into AMS_Language_Data (String) Values ('"+FormatTextMac(String)+"');")
    If Result = 0
      MessageRequester("Error?","Insert failed... check access privileges.")
    EndIf
    CloseDatabase(1)
  Next
EndProcedure

Procedure AddString()
  Protected Width.i = 320, Height.i = 100, Exit.i, Txt.s, OTxt.s, Check.s, Okay.i, EnumTxt.s, MyLoop.i, Ascii.i, AsciiOkay.i
  
  OpenWindow(#Window_AddString,0,0,width,height,"Add String",#PB_Window_WindowCentered,WindowID(#Window_Main))
  
  ButtonGadget(#Gad_Add_Ok,width - 160,height - 24,70,20,"Add...")
  ButtonGadget(#Gad_Add_Cancel,width - 80,height - 24,70,20,"Close")  
  DisableGadget(#Gad_Add_OK,1)
  TextGadget(#Gad_Add_String_Text,4,6,80,20,"New String:")
  StringGadget(#Gad_Add_String,86,4,230,20,"")
  TextGadget(#Gad_Add_Enumeration_Text,4,28,80,20,"Enumeration:")
  StringGadget(#Gad_Add_Enumeration,86,26,230,20,"",#PB_String_ReadOnly)
  TextGadget(#Gad_Add_Check,4,50,300,20,"Check:")
  Exit = 0
  
  Repeat
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gad_Add_Ok
            ;/ Update Now
            System\StringCount + 1
            
            Enums(System\StringCount) = GetGadgetText(#Gad_Add_Enumeration)
            Lang2(System\StringCount) = GetGadgetText(#Gad_Add_String)
            
            ;/ Write enumerations file
            
            Write_Enumerations()
            
            Update_Databases(GetGadgetText(#Gad_Add_String))
            
            MessageRequester("Okay","String added to databases & Enumeration file")
            
          Case #Gad_Add_Cancel
            Exit = 1
          Case #Gad_Add_String
            Okay = 1
            Check.s = ""
            Txt = GetGadgetText(#Gad_Add_String)
            If Txt <> OTxt.s
              OTxt = Txt
              ;/ Create Enumeration
              EnumTxt.s = ReplaceString(Txt," ","")
              EnumTxt.s = ReplaceString(EnumTxt,",","")
              EnumTxt.s = ReplaceString(EnumTxt,".","")
              EnumTxt.s = ReplaceString(EnumTxt,"*","")
              EnumTxt.s = ReplaceString(EnumTxt,"_","")
              EnumTxt.s = ReplaceString(EnumTxt,"'","")
              EnumTxt.s = ReplaceString(EnumTxt,"#","")
              EnumTxt.s = ReplaceString(EnumTxt,"-","")
              EnumTxt.s = ReplaceString(EnumTxt,"/","")
              EnumTxt = "#Str_"+EnumTxt
              
              ;/ Check if String Is Valid
              If Txt = "" : Okay = 0 : Check.s + "String cannot be empty - " : EndIf
              
              For MyLoop = 1 To Len(Txt)
                AsciiOkay = 0
              
                Ascii.i = Asc(Mid(UCase(txt),myloop,1)) 
                If ascii >47 And ascii < 58 : AsciiOkay = 1 : EndIf
                If ascii >64 And ascii < 91 : AsciiOkay = 1 : EndIf
                If ascii = 32 : AsciiOkay = 1 : EndIf ;/ space char 
                If AsciiOkay = 0 : Okay = 0 : Check.s + "Alphanumerics in Strings Only - " : Break : EndIf
                
              Next
              
              ;/ check if String begins or ends with characters out of A-Z (+0 - 9) range
              For MyLoop = 1 To System\StringCount
                If UCase(Lang2(MyLoop)) = UCase(Txt)
                  Okay = 0
                  Check.s + "String already Exists ("+Str(myloop)+") - "
                  Break
                EndIf
              Next
              
              ;/ check if enumeration string already exists
              For MyLoop = 1 To System\StringCount
                If UCase(Enums(MyLoop)) = UCase(EnumTxt)
                  Okay = 0
                  Check.s + "Enumeration already Exists - "
                  Break
                EndIf
              Next
              
              ;/
              
              ;/ Show Message
              SetGadgetText(#Gad_Add_Enumeration,EnumTxt)
              If Okay = 1 : Check.s = "Inputted text is valid for entering" : EndIf
              
              SetGadgetText(#Gad_Add_Check,Check)
              
              If Okay = 1
                DisableGadget(#Gad_Add_Ok,0)
              Else
                DisableGadget(#Gad_Add_Ok,1)
              EndIf
              
            EndIf
            
        EndSelect
    EndSelect
    
  Until Exit > 0

  CloseWindow(#Window_AddString)
  
EndProcedure

Procedure UpdateLists()
  Protected MyLoop.i, Count1.i, Count2.i, Txt.S, Position.i, PassFilter.i, KeyPos.i, PassCount.i ;, Count.i
  
  Protected Dim Listtxt.s(MaxStr)
  
  For Myloop = 1 To 600
    Listtxt(Myloop) = ""
    lang1(Myloop) = ""
    lang2(Myloop) = ""
    Lang2Override(Myloop) = ""
  Next
  
  Count1 = 0
  SelectElement(LangMaster(),GetGadgetState(#Gad_Lang1DropDown))
  For MyLoop = 1 To LangMaster()\StringCount
    Count1 + 1
    Lang1(Count1) = LangMaster()\String[MyLoop]
  Next
  
  Count2 = 0
  SelectElement(LangMaster(),GetGadgetState(#Gad_Lang2DropDown))
  For MyLoop = 1 To LangMaster()\StringCount
    Count2 + 1
    Lang2(Count2) = LangMaster()\String[MyLoop]
    Lang2Override(Count2) = LangMaster()\String_Override[MyLoop]
  Next 
  
  ;/
  SetGadgetText(#Gad_Font_Name,LangMaster()\FontName)
  SetGadgetText(#Gad_Font_Size_XS,Str(LangMaster()\FontsizeXS))
  SetGadgetText(#Gad_Font_Size_S,Str(LangMaster()\FontsizeS))
  SetGadgetText(#Gad_Font_Size_M,Str(LangMaster()\FontsizeM))
  SetGadgetText(#Gad_Font_Size_L,Str(LangMaster()\FontsizeL))
  SetGadgetText(#Gad_Font_Size_XL,Str(LangMaster()\FontsizeXL))
  
  If IsGadget(#Gad_Lang_List)
    SendMessage_(GadgetID(#Gad_Lang_List),#WM_SETREDRAW,#False,0)
    KeyPos = GetGadgetState(#Gad_Lang_List)
    ClearGadgetItems(#Gad_Lang_List) 
  Else
    ListIconGadget(#Gad_Lang_List,2,50,1250,640,"#",50,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
    SendMessage_(GadgetID(#Gad_Lang_List),#WM_SETREDRAW,#False,0)
    If System\Showing_Enumerations = 1 : AddGadgetColumn(#Gad_Lang_List,2,"Enumeration",380) : EndIf
    AddGadgetColumn(#Gad_Lang_List,3,"Reference Language",380)
    AddGadgetColumn(#Gad_Lang_List,4,"Editting Language",380)
    AddGadgetColumn(#Gad_Lang_List,5,"Text Override",380)
  EndIf 
  
  Protected SearchString1.s, SearchString2.s
  SearchString1 = UCase(GetGadgetText(#Gad_Search_Lang1))
  SearchString2 = UCase(GetGadgetText(#Gad_Search_Lang2))
  
  System\StringCount = Count1
  If Count2 > Count1 : System\StringCount = Count2 : EndIf
  
  PassCount.i = 0
  For MyLoop = 1 To System\StringCount
    PassFilter = 1
    Txt = Str(MyLoop)+Chr(10)
    If System\Showing_Enumerations = 1 : Txt + Enums(Myloop)+Chr(10) : EndIf
    If Lang1(MyLoop) = "" : Passfilter = 0 : EndIf
    Txt + Lang1(Myloop)+ Chr(10)
    
    Txt + Lang2(Myloop)+ Chr(10)
    Txt + Lang2Override(Myloop)+ Chr(10)
    
    If SearchString1 <> ""
      If FindString(UCase(Lang1(Myloop)),SearchString1) = 0 : PassFilter = 0 : EndIf
    EndIf
    
    If SearchString2 <> ""
      If FindString(UCase(Lang2(Myloop)),SearchString2) = 0 And FindString(UCase(Lang2Override(Myloop)),SearchString2) = 0: PassFilter = 0 : EndIf
    EndIf

    If GetGadgetState(#Gad_ShowIdenticalOnly) = 1
      If Lang1(MyLoop) <> Lang2(MyLoop) : PassFilter = 0 : EndIf
      If Lang1(MyLoop) = Lang2(MyLoop) And Lang2Override(MyLoop) <> "" : Passfilter = 0 : EndIf
    EndIf
    
    If GetGadgetState(#Gad_ShowNullStringsOnly) = 1
      If Lang2(MyLoop) <> "" : PassFilter = 0 : EndIf
    EndIf 
      
    If PassFilter = 1
      AddGadgetItem(#Gad_Lang_List,-1,txt)
      SetGadgetItemData(#Gad_Lang_List,PassCount,MyLoop)
      PassCount + 1
    EndIf

  Next
  
  SetGadgetState(#Gad_Lang_List,KeyPos)
  SendMessage_(GadgetID(#Gad_Lang_List),#WM_SETREDRAW,#True,0)
  
EndProcedure
Procedure ImportTxt()
  Protected File.s, Pattern$, Pattern.i, ImportImage.i, Form.i, Line.i
  ;Pattern$ = "Text File" + "|*.txt;"+"CSV File" + "|*.csv;" ;/DNT
  Pattern = 0    ; use the first of the three possible patterns as standard
  File = OpenFileRequester("Please choose file to load", "", Pattern$, Pattern)
  ;/ select correct file
  If File
    
    ForEach LangMaster()
      If LangMaster()\Language = GetGadgetText(#Gad_Lang2DropDown)
        Break
      EndIf
    Next
    
    If MessageRequester("Warning","This will replace all override strings in database: "+LangMaster()\FileName+", are you sure?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_No
      ProcedureReturn 
    EndIf
    
    If OpenDatabase(0,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
      
      If OpenFile(1,File)
        ReadStringFormat(1)
        ;Form.i = ReadString(1)
        
        ;CheckDatabaseUpdate(0,"Delete From AMS_Language_Data;")
        Line = 0
        DatabaseUpdate(0,"BEGIN TRANSACTION")
        Repeat
          Line + 1
          CheckDatabaseUpdate(0, "Update AMS_Language_Data Set Override_String = '"+FormatTextMac(ReadString(1,#PB_Unicode))+"' Where ID = "+Str(line)+";")      
        Until Eof(1)
        DatabaseUpdate(0,"END TRANSACTION")
        CloseFile(1)
      Else
        MessageRequester("Error", "Cannot open file")
        ProcedureReturn 0
      EndIf
    Else
      MessageRequester("Error", "Cannot open database file")
      ProcedureReturn 0
    EndIf
    
  EndIf
  
  UpdateLists()
  
EndProcedure
Procedure NewLanguage()
  Protected Language.s
  
  Language.s = InputRequester("Inputrequester","New Language...","")
  
  If Language <> ""
    CheckDatabaseUpdate(0, "INSERT INTO AMS_Language_Master (Language, Font, Fontsize, Version, Comment) VALUES ('"+Language+"', 'Arial', 8, 1, '')")
  EndIf

  UpdateLists()
EndProcedure
Procedure.S InputRequesterEx(Title$,Message$,DefaultString$)
  Protected Result$, Window, String, OK, Cancel, event
  Window = OpenWindow(#PB_Any,0,0,300,95,Title$,#PB_Window_WindowCentered| #PB_Window_SystemMenu ,WindowID(#Window_Main))

  If Window
    StickyWindow(Window,1)
    TextGadget(#PB_Any,10,10,280,20,Message$)
    String = StringGadget(#PB_Any,10,30,280,20,DefaultString$): SetActiveGadget(String)
    OK     = ButtonGadget(#PB_Any,60,60,80,25,"OK",#PB_Button_Default)
    Cancel = ButtonGadget(#PB_Any,150,60,80,25,"Cancel")
    Repeat
      event = WaitWindowEvent()
      If event = #PB_Event_Gadget
        If EventGadget() = OK
          Result$ = GetGadgetTextMac(String)
          Break
        ElseIf EventGadget() = Cancel
          Result$ = ""
          Break
        EndIf
      EndIf
      If event = #PB_Event_CloseWindow
        Result$ = ""
        Break
      EndIf
      If GetKeyState_(#VK_RETURN) > 1
        Result$ = GetGadgetTextMac(String)
        Break
      EndIf
    ForEver
    CloseWindow(Window)
  EndIf
  ProcedureReturn Result$
EndProcedure
Read_Enumerations()

OpenWindow(#Window_Main,0,0,1280,700,"AMS - Language file Database Editor v1.03 - Troika-System.  P.James 12.08.2014",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
TextGadget(#Gad_LangReference,2,5,60,18,"Reference:")
TextGadget(#Gad_LangWork,184,5,60,18,"Editting:")
ComboBoxGadget(#Gad_Lang1DropDown,70,2,100,20)
ComboBoxGadget(#Gad_Lang2DropDown,250,2,100,20)
ButtonGadget(#Gad_Import,360,2,40,18,"Import")
ButtonGadget(#Gad_Export,400,2,40,18,"Export")

If System\Allow_Add = 1
  ButtonGadget(#Gad_AddString,360,22,80,20,"Add String")
  DisableGadget(#Gad_AddString,1)
EndIf

;ButtonGadget(#Gad_NewLanguage,360,22,80,18,"New Language")

TextGadget(#Gad_Search_Lang1_Text,2,27,60,18,"Filter:")
TextGadget(#Gad_Search_Lang2_Text,184,27,60,18,"Filter:")
StringGadget(#Gad_Search_Lang1,70,24,100,20,"")
StringGadget(#Gad_Search_Lang2,250,24,100,20,"")

Global X.i = 460

TextGadget(#Gad_Font_Name_Text,X,5,70,16,"Font Name:")
TextGadget(#Gad_Font_Size_XS_Text,x,27,70,16,"Font Size XS:") : X + 70
StringGadget(#Gad_Font_Size_XS,x,24,30,20,"") 
StringGadget(#Gad_Font_Name,X,2,80,20,""): X + 90

TextGadget(#Gad_Font_Size_S_Text,x,5,70,16,"Font Size S:"); : X + 70
TextGadget(#Gad_Font_Size_M_Text,x,27,70,16,"Font Size M:") : X + 70

StringGadget(#Gad_Font_Size_S,x,2,30,20,"") ;: X + 50
StringGadget(#Gad_Font_Size_M,x,24,30,20,"") : X + 50

TextGadget(#Gad_Font_Size_L_Text,x,5,70,16,"Font Size L:"); : X + 70
TextGadget(#Gad_Font_Size_XL_Text,x,27,70,16,"Font Size XL:") : X + 70

StringGadget(#Gad_Font_Size_L,x,2,30,20,""); : X + 50
StringGadget(#Gad_Font_Size_XL,x,24,30,20,"") : X + 80

SetGadgetFont(#Gad_Lang_List, FontID(LoadFont(#PB_Any, "Arial Unicode MS", 8)))

CheckBoxGadget(#Gad_ShowIdenticalOnly,x,2,180,20,"Show Identical Only?")
CheckBoxGadget(#Gad_ShowNullStringsOnly,x,22,180,20,"Show Null Strings only?")

;ButtonGadget(#Gad_SameString_Report,x + 180,2,160,20,"Generate Identical String Report")

UseSQLiteDatabase()
Parse_Language_Files()

Repeat : Until WindowEvent() = 0

UpdateLists()

Define.i Pos, ListPos
Define.s Txt,NewTxt

Repeat
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_Gadget
    Select EventGadget()
      Case #Gad_SameString_Report
        Create_SameString_Report()
      Case #Gad_Search_Lang1
        If System\Last_Filter1 <> GetGadgetText(#Gad_Search_Lang1)
          System\Last_Filter1 = GetGadgetText(#Gad_Search_Lang1)
          UpdateLists()
        EndIf
      Case #Gad_Search_Lang2
        If System\Last_Filter2 <> GetGadgetText(#Gad_Search_Lang2)
          System\Last_Filter2 = GetGadgetText(#Gad_Search_Lang2)
          UpdateLists()
        EndIf 
      Case #Gad_Lang1DropDown
        UpdateLists()
      Case #Gad_Lang2DropDown
        SelectElement(LangMaster(),GetGadgetState(#Gad_Lang2DropDown))
        If System\Allow_Add = 1
          If Langmaster()\Language = "English"
            DisableGadget(#Gad_AddString,0)
          Else
            DisableGadget(#Gad_AddString,1)
          EndIf
        EndIf
        
        UpdateLists()
      Case #Gad_ShowIdenticalOnly
        UpdateLists()
      Case #Gad_ShowNullStringsOnly
        UpdateLists()
      Case #Gad_Export
        Database_Export()
      Case #Gad_Import
        ImportTxt()
      Case #Gad_NewLanguage
        NewLanguage()
      Case #Gad_AddString
        AddString()
      ; SQL.s = "Create TABLE [AMS_Language_Master] ([Language] CHAR, [FontName] Char, [FontsizeXS] Int, [FontsizeS] Int, [FontsizeM] Int, [FontsizeL] Int, [FontsizeXL] Int, [Comment] CHAR);"  
      Case #Gad_Font_Name
        If EventType() = #PB_EventType_LostFocus
          OpenDatabase(0,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
          CheckDatabaseUpdate(0,"Update AMS_Language_Master SET FontName = '"+FormatTextMac(GetGadgetText(#Gad_Font_Name))+"';")
          LangMaster()\FontName = GetGadgetText(#Gad_Font_Name)
          CloseDatabase(0)
        EndIf
      Case #Gad_Font_Size_XS
        If EventType() = #PB_EventType_LostFocus
          OpenDatabase(0,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
          CheckDatabaseUpdate(0,"Update AMS_Language_Master SET FontsizeXS = '"+FormatTextMac(GetGadgetText(#Gad_Font_Size_XS))+"';")
          LangMaster()\FontsizeXS = Val(GetGadgetText(#Gad_Font_Size_XS))
          CloseDatabase(0)
        EndIf
      Case #Gad_Font_Size_S
        If EventType() = #PB_EventType_LostFocus
          OpenDatabase(0,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
          CheckDatabaseUpdate(0,"Update AMS_Language_Master SET FontsizeS = '"+FormatTextMac(GetGadgetText(#Gad_Font_Size_S))+"';")
          LangMaster()\FontsizeS = Val(GetGadgetText(#Gad_Font_Size_S))
          CloseDatabase(0)
        EndIf
      Case #Gad_Font_Size_M
        If EventType() = #PB_EventType_LostFocus
          OpenDatabase(0,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
          CheckDatabaseUpdate(0,"Update AMS_Language_Master SET FontsizeM = '"+FormatTextMac(GetGadgetText(#Gad_Font_Size_M))+"';")
          LangMaster()\FontsizeM = Val(GetGadgetText(#Gad_Font_Size_M))
          CloseDatabase(0)
        EndIf
      Case #Gad_Font_Size_L
        If EventType() = #PB_EventType_LostFocus
          OpenDatabase(0,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
          CheckDatabaseUpdate(0,"Update AMS_Language_Master SET FontsizeL = '"+FormatTextMac(GetGadgetText(#Gad_Font_Size_L))+"';")
          LangMaster()\FontsizeL = Val(GetGadgetText(#Gad_Font_Size_L))
          CloseDatabase(0)
        EndIf    
      Case #Gad_Font_Size_XL
        If EventType() = #PB_EventType_LostFocus
          OpenDatabase(0,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
          CheckDatabaseUpdate(0,"Update AMS_Language_Master SET FontsizeXL = '"+FormatTextMac(GetGadgetText(#Gad_Font_Size_XL))+"';")
          LangMaster()\FontsizeXL = Val(GetGadgetText(#Gad_Font_Size_XL))
          CloseDatabase(0)
        EndIf  
      Case #Gad_Lang_List
        If EventType() = #PB_EventType_LeftDoubleClick
          ListPos.i = GetGadgetState(#Gad_Lang_List)
          Pos.i = GetGadgetItemData(#Gad_Lang_List,ListPos)
          
          Debug Pos
          Debug Lang2(Pos)
          If Lang2Override(Pos)<>""
            Txt = Lang2Override(Pos)
          Else
            Txt = Lang2(Pos)
          EndIf
          NewTxt = InputRequesterEx("Input required","Please input override value:",txt)
          If NewTxt <> Txt
            If Lang2Override(Pos) <>  NewTxt
              OpenDatabase(0,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
              If NewTxt <> ""
                CheckDatabaseUpdate(0,"Update AMS_Language_Data SET Override_String = '"+FormatTextMac(NewTxt)+"' Where ID = "+Str(Pos)+";")
              Else
                CheckDatabaseUpdate(0,"Update AMS_Language_Data SET Override_String = '' Where ID = "+Str(Pos)+";")
              EndIf
              Lang2Override(Pos) = NewTxt
              SetGadgetItemText(#Gad_Lang_List,ListPos,NewTxt,3)
              CloseDatabase(0)
            EndIf
            ;UpdateLists()
            
          EndIf
        Else
          Debug Str(GetGadgetItemData(#Gad_Lang_List,GetGadgetState(#Gad_Lang_List)))+" - "+Str(GetGadgetState(#Gad_Lang_List))
        EndIf
        
    EndSelect
  EndIf
  
Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 5.71 beta 2 LTS (Windows - x86)
; CursorPosition = 545
; FirstLine = 243
; Folding = RCax
; EnableXP
; EnableUser
; Executable = Executable\AMS - Language Database Editor v1.03.exe
; EnableUnicode