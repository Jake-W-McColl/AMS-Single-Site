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
  
  #Editor
  
  #Load
  #Save
EndEnumeration

Macro GetGadgetTextMac(a)
  ;/ a macro to force string encapsulation of ' character, otherwise text issues will ensue when retrieving.
  ReplaceString(ReplaceString(GetGadgetText(a),"''","'"),"'","''") ;/DNT
EndMacro
Procedure.s FormatTextMac(a.s) 
  ;/ a macro to force string encapsulation of ' character, otherwise text issues will ensue when storing.
  ProcedureReturn ReplaceString(ReplaceString(a,"''","'"),"'","''") ;/DNT
EndProcedure

OpenWindow(#Window,0,0,920,220,"Database Settings Import / Export - V1.0",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)

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
TextGadget(#ContactNumber_Text,60,Y,60,20,"Number:") : StringGadget(#ContactNumber,130,Y-2,160,20,"") : Y + 30

ButtonGadget(#Load,2,2,40,20,"Import")
ButtonGadget(#Save,2,24,40,20,"Export")
EditorGadget(#Editor,300,2,600,140)

Global Dim CodeString.s(10)

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
Procedure.s EncryptPasswordUni1(password.s, key.s)
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
Procedure.s DecryptPasswordUni1(password.s, key.s)
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
Procedure.s DeCodeI(String.s,Pos=2)
  Dec.s = DecryptPassword(String.s,"OpenWindow")
  
  If Left(dec,3)="ARK"
    ProcedureReturn  StringField(dec,Pos,Chr(10))
  Else
    ProcedureReturn String
  EndIf
EndProcedure

Repeat
  event = WaitWindowEvent()
  
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #Load
          Dim CodeString.s(10)
          If GetGadgetText(#Editor) <> ""
            CurrentCode.s = GetGadgetTextMac(#Editor)
            ChecksumString.s = ""
            For CheckLoop = 1 To 6
              CodeString(CheckLoop) = StringField(Currentcode,CheckLoop,Chr(10))
              If Checkloop < 7 : ChecksumString + CodeString(CheckLoop) : EndIf
              Debug CodeString(CheckLoop)
            Next
            
            Decode(CodeString(1))
            DecodeI(CodeString(1))

            SetGadgetText(#Location,DecodeI(CodeString(2)))
            SetGadgetText(#Country,DecodeI(CodeString(3)))
            SetGadgetText(#ContactName,DecodeI(CodeString(4)))
            SetGadgetText(#Email,DecodeI(CodeString(5)))
            SetGadgetText(#ContactNumber,DecodeI(CodeString(6)))
            ClearGadgetItems(#Editor)
          Else
            MessageRequester("Error","Nothing to import")
          EndIf
          
          
        Case #Save
          OkayToSave = 1
          Errors.s = ""
          
          If Trim(GetGadgetText(#CompanyName)) = "" : OkayToSave = 0 : Errors + "No Company Name Keyed" + Chr(10) : EndIf
          If Val(Trim(GetGadgetText(#Site_Limit))) = 0 : OkayToSave = 0 : Errors + "No Site Limit Keyed" + Chr(10) : EndIf
          If Val(Trim(GetGadgetText(#Roll_Limit))) = 0 : OkayToSave = 0 : Errors + "No Roll Limit Keyed" + Chr(10) : EndIf
          If Val(Trim(GetGadgetText(#ReadingPerRoll_Limit))) = 0 : OkayToSave = 0 : Errors + "No Reading Limit Keyed" + Chr(10) : EndIf
          
          If OkayToSave = 1
            CurrentCode = Code(GetGadgetText(#CompanyName),GetGadgetText(#Site_Limit),GetGadgetText(#Roll_Limit),GetGadgetText(#ReadingPerRoll_Limit)) + Chr(10)
            CurrentCode + CodeI(GetGadgetText(#Location)) + Chr(10)
            CurrentCode + CodeI(GetGadgetText(#Country)) + Chr(10)
            CurrentCode + CodeI(GetGadgetText(#ContactName)) + Chr(10)
            CurrentCode + CodeI(GetGadgetText(#Email)) + Chr(10)
            CurrentCode + CodeI(GetGadgetText(#ContactNumber)) + Chr(10)
            SetGadgetText(#Editor,CurrentCode)
            
            CurrentCode = GetGadgetTextMac(#Editor)
            ChecksumString = ""
            For CheckLoop = 1 To 6     
              Debug Checkloop
              CodeString(CheckLoop) = StringField(Currentcode,CheckLoop,Chr(10))
              ChecksumString + CodeString(CheckLoop)
;              Debug CodeString(CheckLoop)
            Next
              Debug "Len: "+Str(Len(ChecksumString))
            ;Currentcode + Chr(10)
            SetGadgetText(#Editor,CurrentCode+MD5Fingerprint(@ChecksumString, Len(ChecksumString)))
;          DatabaseUpdate(1,"UPDATE AMS_Settings SET Code='"+Code(GetGadgetText(#CompanyName),GetGadgetText(#Site_Limit),GetGadgetText(#Roll_Limit),GetGadgetText(#ReadingPerRoll_Limit))+"';")
;          DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET Location='"+CodeI(GetGadgetText(#Location))+"';")
;          DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET Country='"+CodeI(GetGadgetText(#Country))+"';")
;          DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET ContactName='"+CodeI(GetGadgetText(#ContactName))+"';")
;          DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET ContactEmail='"+CodeI(GetGadgetText(#Email))+"';")          
;          DatabaseUpdate(1,"UPDATE AMS_CompanyInfo SET ContactNumber='"+CodeI(GetGadgetText(#ContactNumber))+"';")
          
          ;MessageRequester("
          
        Else
          MessageRequester("Unable to save due to the following problem(s)",Errors)  
        EndIf
        
          
          
      EndSelect

  EndSelect

Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 4.61 Beta 1 (Windows - x86)
; CursorPosition = 241
; FirstLine = 67
; Folding = Gg
; EnableUnicode
; Executable = ARK - Code Generator.exe