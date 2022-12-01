;InputRequester("Password","Please Enter password","")

#Window = 1

Enumeration ; Gadgets
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
  
  #Load
  #Save
EndEnumeration

UseSQLiteDatabase()

OpenWindow(#Window,0,0,320,240,"Database Prepper v1",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)

ButtonGadget(#Load,2,2,40,20,"Load")
ButtonGadget(#Save,2,24,40,20,"Write") : DisableGadget(#Save,1)

Y = 8
TextGadget(#CompanyName_Text,60,y,50,20,"Company:")
StringGadget(#CompanyName,130,y-2,160,20,"") : Y + 22

TextGadget(#Site_Limit_Text,60,Y,65,20,"Site Limit:")
StringGadget(#Site_Limit,130,Y-2,20,20,"") : Y + 22

TextGadget(#Roll_Limit_Text,60,Y,50,20,"Roll Limit:")
StringGadget(#Roll_Limit,130,Y-2,40,20,"") : Y + 22

TextGadget(#ReadingPerRoll_Limit_Text,60,Y,70,20,"Reading Limit:")
StringGadget(#ReadingPerRoll_Limit,130,Y-2,40,20,"") : Y + 22

TextGadget(#Location_Text,60,Y,60,20,"Location:") : StringGadget(#Location,130,Y-2,160,20,"") : Y + 22
TextGadget(#Country_Text,60,Y,60,20,"Country:") : StringGadget(#Country,130,Y-2,160,20,""): Y + 22
TextGadget(#ContactName_Text,60,Y,60,20,"Name:") : StringGadget(#ContactName,130,Y-2,160,20,""): Y + 22
TextGadget(#Email_Text,60,Y,60,20,"Email:") : StringGadget(#Email,130,Y-2,160,20,""): Y + 22
TextGadget(#ContactNumber_Text,60,Y,60,20,"Number:") : StringGadget(#ContactNumber,130,Y-2,160,20,"") : Y + 22

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
;9nU1cmqvk92D7mhyJDpYHTvSR56ZG0FeDIRK6rR8g3/oCIc0eKEmSLYn+govjq2N6AiHNHihJki2J/oKL46tjQ==

Procedure.s EncryptPasswordUni(password.s, key.s)
  Protected passin.s        = LSet(password.s, 32, Chr(32))                  ; Pad the password with spaces to make 32 characters   
;  Protected keyin.s         = LSet(key.s, 16, Chr(32))                       ; key for 128bit encryption needs length=16
  Protected *encodedbinary = AllocateMemory(32)                              ; 32 bytes for encrypted binary result, see 2 lines down
  Protected *encodedtext   = AllocateMemory(64)                             ; Destination for Base64Encoder must be 33% larger- we double it
  
  Protected *AsciiPass     = AllocateMemory(65)
  Protected *AsciiKey      = AllocateMemory(65)
  PokeS(*AsciiPass,passin,Len(passin),#PB_Ascii)
  PokeS(*AsciiKey,Key,Len(Key),#PB_Ascii)

  AESEncoder(*AsciiPass, *encodedbinary, 64, *AsciiKey, 128, 0, #PB_Cipher_ECB) ; We don't encrypt the trailing zero so 32 bytes is enough
  Base64Encoder(*encodedbinary, 64, *encodedtext, 128)                          ; Convert encrypted binary data to ascii for return                     
  ProcedureReturn PeekS(*encodedtext,-1,#PB_Ascii)                              ; Return the completed ascii result
EndProcedure

Procedure.s DecryptPasswordUni(password.s, key.s)
;  Protected keyin.s         = LSet(key.s, 16, Chr(32))                            ; key for 128bit decryption needs length=16
  Protected *encodedbinary = AllocateMemory(32)                                   ; 32 bytes for data + one safety byte
  Protected *decodedtext   = AllocateMemory(32)                                   ; 32 bytes for characters + one byte for terminating zero
  
  Protected *AsciiPass     = AllocateMemory(33)
  Protected *AsciiKey      = AllocateMemory(33)  
  
  PokeS(*AsciiKey,Key,Len(Key),#PB_Ascii)
  PokeS(*AsciiPass,password,Len(password),#PB_Ascii)
  
  Base64Decoder(*AsciiPass, Len(password.s), *encodedbinary, 32)                 ; Convert the ascii encoded password back to binary
  AESDecoder(*encodedbinary, *decodedtext, 64, *AsciiKey, 128, 0, #PB_Cipher_ECB)  ; Convert the encrypted password back to original
  ProcedureReturn Trim(PeekS(*decodedtext, -1,#PB_Ascii))                         ; Remove any trailing spaces and return result
EndProcedure

;Troika Systems Uk Division

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
Procedure.s DeCode(String.s)
  
  Dec.s = DecryptPassword(String.s,"OpenWindow")
  
  If Left(dec,3)="ARK"
    SetGadgetText(#CompanyName,StringField(dec,2,Chr(10)))
    SetGadgetText(#Site_Limit,StringField(dec,3,Chr(10)))
    SetGadgetText(#Roll_Limit,StringField(dec,4,Chr(10)))
    SetGadgetText(#ReadingPerRoll_Limit,StringField(dec,5,Chr(10)))
  Else
    MessageRequester("Error","Unable to decode")
  EndIf
EndProcedure

Procedure.s DeCodeI(String.s)
  Dec.s = DecryptPassword(String.s,"OpenWindow")
  
  If Left(dec,3)="ARK"
    ProcedureReturn  StringField(dec,2,Chr(10))
  Else
    ProcedureReturn String
  EndIf
EndProcedure

Procedure CheckDatabaseUpdate(Database, query.S)
  Protected Result.i
  
  Result = DatabaseUpdate(Database, query.S)
  ;Debug Query
  If Result = 0
    MessageRequester("Error in query: ",query+Chr(10)+ DatabaseError())
    ;End
  EndIf
  ProcedureReturn Result
EndProcedure
Procedure.S Database_StringQuery(SQL.S)
  Protected Result.S, QueryResult.i
  QueryResult = DatabaseQuery(1, SQL)
  NextDatabaseRow(1) ;/ only one row, so no need for while / 
  Result = GetDatabaseString(1,0)
  
  If QueryResult = 0
    MessageRequester("Error"+"?"+" ",SQL+Chr(10)+DatabaseError())
  EndIf
  
  FinishDatabaseQuery(1)
  ProcedureReturn Result.S
EndProcedure

Repeat
  event = WaitWindowEvent()
  
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #CompanyName, #Site_Limit, #Roll_Limit, #ReadingPerRoll_Limit
          code(GetGadgetText(#CompanyName),GetGadgetText(#Site_Limit),GetGadgetText(#Roll_Limit),GetGadgetText(#ReadingPerRoll_Limit))
        ;Case #Import
        ;  decode(GetGadgetText(#inputstring))
      Case #Load
        File.s = OpenFileRequester("Select AMS Database","","Database (*.db)|*.db",0)
        If file <> ""
          If IsDatabase(1) : CloseDatabase(1) : EndIf
          If OpenDatabase(1,File,"","",#PB_Database_SQLite)
            SetGadgetText(#Location,DecodeI(Database_StringQuery("Select Location from AMS_Companyinfo")))
            SetGadgetText(#Country,DecodeI(Database_StringQuery("Select Country from AMS_Companyinfo")))
            SetGadgetText(#ContactName,DecodeI(Database_StringQuery("Select ContactName from AMS_Companyinfo")))
            SetGadgetText(#Email,DecodeI(Database_StringQuery("Select ContactEmail from AMS_CompanyInfo")))
            SetGadgetText(#ContactNumber,DecodeI(Database_StringQuery("Select ContactNumber from AMS_CompanyInfo")))
            Code.s = Database_StringQuery("Select Code from AMS_Settings")
            Decode(Code)
            SetWindowTitle(#Window,""+File)
            DisableGadget(#Save,0)
          Else
            MessageRequester("Error","Unable to open database file")
          EndIf
        EndIf
        
      Case #Save
        OkayToSave = 1
        Errors.s = ""
        If Trim(GetGadgetText(#CompanyName)) = "" : OkayToSave = 0 : Errors + "No Company Name Keyed" + Chr(10) : EndIf
        If Val(Trim(GetGadgetText(#Site_Limit))) = 0 : OkayToSave = 0 : Errors + "No Site Limit Keyed" + Chr(10) : EndIf
        If Val(Trim(GetGadgetText(#Roll_Limit))) = 0 : OkayToSave = 0 : Errors + "No Roll Limit Keyed" + Chr(10) : EndIf
        If Val(Trim(GetGadgetText(#ReadingPerRoll_Limit))) = 0 : OkayToSave = 0 : Errors + "No Reading Limit Keyed" + Chr(10) : EndIf
        
        If OkayToSave = 1
          DatabaseUpdate(1,"UPDATE AMS_Settings SET Code='"+Code(GetGadgetText(#CompanyName),GetGadgetText(#Site_Limit),GetGadgetText(#Roll_Limit),GetGadgetText(#ReadingPerRoll_Limit))+"';")
          DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET Location='"+CodeI(GetGadgetText(#Location))+"';")
          DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET Country='"+CodeI(GetGadgetText(#Country))+"';")
          DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET ContactName='"+CodeI(GetGadgetText(#ContactName))+"';")
          DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET ContactEmail='"+CodeI(GetGadgetText(#Email))+"';")          
          DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET ContactNumber='"+CodeI(GetGadgetText(#ContactNumber))+"';")
          
          ;MessageRequester("
          
        Else
          MessageRequester("Unable to save due to the following problem(s)",Errors)  
        EndIf
        
          
          
      EndSelect

  EndSelect

Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 4.60 RC 1 (Windows - x86)
; CursorPosition = 71
; FirstLine = 18
; Folding = Cs
; EnableUnicode
; Executable = ARK - Code Generator.exe