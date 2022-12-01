;/ AMS code generator v1.1, PJ 12.06.2018
;/ Added file save function as copying / pasting opens us up for human error.

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
  
  #Import
  #Export
  #FileLoad
  #FileSave
  #Reset
EndEnumeration
Macro GetGadgetTextMac(a)
  ;/ a macro to force string encapsulation of ' character, otherwise text issues will ensue when retrieving.
  ReplaceString(ReplaceString(GetGadgetText(a),"''","'"),"'","''") ;/DNT
EndMacro
Procedure.s FormatTextMac(a.s)
  ;/ a macro to force string encapsulation of ' character, otherwise text issues will ensue when storing.
  ProcedureReturn ReplaceString(ReplaceString(a,"''","'"),"'","''") ;/DNT
EndProcedure

UseMD5Fingerprint()

Procedure Init_Main()
  OpenWindow(#Window,0,0,844,240,"AMS Code Generator - V1.1 -  PJ 06.2018",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  
  Y = 8
  TextGadget(#CompanyName_Text,2,y,50,20,"Company:")
  StringGadget(#CompanyName,70,y-2,160,20,"") : Y + 22
  
  TextGadget(#Site_Limit_Text,2,Y,65,20,"Site Limit:")
  StringGadget(#Site_Limit,70,Y-2,20,20,"1") : Y + 22
  
  TextGadget(#Roll_Limit_Text,2,Y,50,20,"Roll Limit:")
  StringGadget(#Roll_Limit,70,Y-2,40,20,"150")  : Y + 22
  
  TextGadget(#ReadingPerRoll_Limit_Text,2,Y,70,20,"Reading Limit:")
  StringGadget(#ReadingPerRoll_Limit,70,Y-2,40,20,"99") : Y + 22
  
  TextGadget(#Location_Text,2,Y,60,20,"Location:") : StringGadget(#Location,70,Y-2,160,20,"") : Y + 22
  TextGadget(#Country_Text,2,Y,60,20,"Country:") : StringGadget(#Country,70,Y-2,160,20,""): Y + 22
  TextGadget(#ContactName_Text,2,Y,60,20,"Name:") : StringGadget(#ContactName,70,Y-2,160,20,""): Y + 22
  TextGadget(#Email_Text,2,Y,60,20,"Email:") : StringGadget(#Email,70,Y-2,160,20,""): Y + 22
  TextGadget(#ContactNumber_Text,2,Y,60,20,"Number:") : StringGadget(#ContactNumber,70,Y-2,160,20,"") : Y + 22
  
  ButtonGadget(#Import,242,144,160,24,"<<<< Import <<<<") : GadgetToolTip(#Import,"Populate the data fields from the currently displayed code")
  ButtonGadget(#Export,70,Y,160,24,">>>> Export >>>>") : GadgetToolTip(#Export,"Generate the Licence code using the data fields")

  ButtonGadget(#FileLoad,660,144,160,24,"Load from file..."): GadgetToolTip(#FileLoad,"Populate the code window using the data fields")
  ButtonGadget(#FileSave,660,170,160,24,"Save to file..."): GadgetToolTip(#FileSave,"Populate the code window using the data fields")
  ButtonGadget(#Reset,660,210,160,24,"Reset"): GadgetToolTip(#Reset,"Clear all fields back to original state")
  EditorGadget(#Editor,240,2,600,140)
EndProcedure

Global Dim CodeString.s(10)

Procedure$ EncryptPassword(password$, key$)
  Protected passin$        = LSet(password$, 64, Chr(32))                   ; Pad the password with spaces to make 64 characters   
  Protected keyin$         = LSet(key$, 16, Chr(32))                        ; key for 128bit encryption needs length=16
  Protected *encodedbinary = AllocateMemory(64)                             ; 32 bytes for encrypted binary result, see 2 lines down
  Protected *encodedtext   = AllocateMemory(128)                            ; Destination for Base64Encoder must be 33% larger- we double it
  
  Protected *AsciiPass     = AllocateMemory(65)
  Protected *AsciiKey      = AllocateMemory(65)
  PokeS(*AsciiPass,passin$,Len(passin$),#PB_Ascii)
  PokeS(*AsciiKey,Keyin$,Len(Keyin$),#PB_Ascii)
  
  AESEncoder(*AsciiPass, *encodedbinary, 64, *AsciiKey, 128, 0, #PB_Cipher_ECB) ; We don't encrypt the trailing zero so 64 bytes is enough
  Base64EncoderBuffer(*encodedbinary, 64, *encodedtext, 128)                    ; Convert encrypted binary data to ascii for return                     
  ProcedureReturn PeekS(*encodedtext,-1,#PB_Ascii)                              ; Return the completed ascii result
EndProcedure
Procedure$ DecryptPassword(password$, key$)
  Protected keyin$         = LSet(key$, 16, Chr(32))                            ; key for 128bit decryption needs length=16
  Protected *encodedbinary = AllocateMemory(128)                                ; 32 bytes for data + one safety byte
  Protected *decodedtext   = AllocateMemory(128)                                ; 32 bytes for characters + one byte for terminating zero
  
  Protected *AsciiPass     = AllocateMemory(128)
  Protected *AsciiKey      = AllocateMemory(128)  
  
  PokeS(*AsciiKey,Keyin$,Len(keyin$),#PB_Ascii)
  PokeS(*AsciiPass,password$,Len(password$),#PB_Ascii)
  
  If password$ = "" : ProcedureReturn : EndIf
  
  Base64DecoderBuffer(*AsciiPass, Len(password$), *encodedbinary, 64)                 ; Convert the ascii encoded password back to binary
  AESDecoder(*encodedbinary, *decodedtext, 64, *AsciiKey, 128, 0, #PB_Cipher_ECB)     ; Convert the encrypted password back to original
  ProcedureReturn Trim(PeekS(*decodedtext, -1,#PB_Ascii))                             ; Remove any trailing spaces and return result
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

Init_Main()

Repeat
  event = WaitWindowEvent()
  
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #FileLoad
          
          File.s = OpenFileRequester("Filename","","Text (*.txt)|*.txt",0)
          If File = "" : Break : EndIf
          If FileSize(File) < 500 Or FileSize(File) > 1000
            MessageRequester("Error","What are you trying to load, you spanner.",#PB_MessageRequester_Warning)
            Break
          EndIf
          
          If OpenFile(1,File)
            Txt.s = ""
            Repeat
              Txt.s + ReadString(1) + #CRLF$
            Until Eof(1)
            SetGadgetText(#Editor,txt)
            CloseFile(1)
          Else
            MessageRequester("Error","Unable to open file, open elsewhere?",#PB_MessageRequester_Ok)
          EndIf
          
        Case #Reset
          If MessageRequester("","Clear current contents?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
            SetGadgetText(#Editor,"")
            SetGadgetText(#CompanyName,"")
            SetGadgetText(#Site_Limit,"1")
            SetGadgetText(#Roll_Limit,"150")
            SetGadgetText(#ReadingPerRoll_Limit,"99")
            SetGadgetText(#Location,"")
            SetGadgetText(#Country,"")
            SetGadgetText(#ContactName,"")
            SetGadgetText(#Email,"")
            SetGadgetText(#ContactNumber,"")
          EndIf
          
        Case #FileSave
          If GetGadgetText(#Editor) <> ""
            File.s = SaveFileRequester("Filename","","*.txt",0)
            
            If File = "" : Break : EndIf
            
            If UCase(Right(File,4)) <> ".TXT" : File + ".txt" : EndIf ;/DNT
            
            If CreateFile(1,File)
              WriteString(1,GetGadgetText(#Editor))
              CloseFile(1)
            Else
              MessageRequester("Error","Unable to write to file, open elsewhere?",#PB_MessageRequester_Ok)
              Break 
            EndIf
          Else
            MessageRequester("Error","No data to save",#PB_MessageRequester_Ok)
          EndIf
          
        Case #Import
          Dim CodeString.s(10)
          If GetGadgetText(#Editor) <> ""
            CurrentCode.s = GetGadgetTextMac(#Editor)
            ChecksumString.s = ""
            For CheckLoop = 1 To 6
              CodeString(CheckLoop) = StringField(Currentcode,CheckLoop,Chr(10))
              If Checkloop < 7 : ChecksumString + CodeString(CheckLoop) : EndIf
              Debug CodeString(CheckLoop)
            Next
            
            ShowMemoryViewer(@ChecksumString,2048)
            
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
          
          
        Case #Export
          OkayToSave = 1
          Errors.s = ""
          
          If Trim(GetGadgetText(#CompanyName)) = "" : OkayToSave = 0 : Errors + "No Company Name" + Chr(10) : EndIf
          If Val(Trim(GetGadgetText(#Site_Limit))) = 0 : OkayToSave = 0 : Errors + "No Site Limit" + Chr(10) : EndIf
          If Val(Trim(GetGadgetText(#Roll_Limit))) = 0 : OkayToSave = 0 : Errors + "No Roll Limit" + Chr(10) : EndIf
          If Val(Trim(GetGadgetText(#ReadingPerRoll_Limit))) = 0 : OkayToSave = 0 : Errors + "No Reading Limit" + Chr(10) : EndIf
          
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
            
            SetGadgetText(#Editor,CurrentCode+Fingerprint(@ChecksumString,Len(ChecksumString), #PB_Cipher_MD5))
          Else
            MessageRequester("Unable to save due to the following problem(s)",Errors)  
          EndIf
      EndSelect
      
  EndSelect
  
Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 232
; FirstLine = 150
; Folding = pw
; Executable = AMS - Code Generator v1.1.exe
; EnableUnicode