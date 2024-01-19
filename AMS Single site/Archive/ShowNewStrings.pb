If OpenFile(1,"ams 11.10.12 Multi Site.pb")
  CreateFile(2,"Translation helper.txt")
  OpenConsole()
  Repeat
    a$ = Trim(ReadString(1))
    Line + 1
    If Left(a$,1) <> ";" And Right(a$,3) <> "DNT" And FindString(a$,"Debug") = 0 And Left(A$,11) <> "Message_Add" And Left(a$,3) <> "SQL" And FindString(a$,"OpenWindow") = 0 And Left(a$,3) <> "TXT"
      If FindString(UCase(a$),"DATABASE") = 0 And FindString(UCase(a$),"QUERY") = 0
        Count = CountString(a$,Chr(34))
        If Count > 2
          StrCount = Count / 2
          Pos = 0 : IsGood = 0
          For MyLoop = 1 To StrCount
            PosF = FindString(a$,Chr(34),Pos)
            PosT = FindString(a$,Chr(34),PosF+1)
            
            If PosT - Posf > 2 : IsGood = 1 : EndIf
            
          Next
          If IsGood = 1
            WriteStringN(2,"Line: "+Str(Line)+" Has "+Str(Count) + " - "+a$)
            LCount + 1
            PrintN("Line: "+Str(Line)+" Has "+Str(Count) + " - "+a$)
          EndIf
          
        EndIf
      EndIf
    EndIf
    
  Until Eof(1)
  PrintN("Lcount: "+Str(LCOunt))
  WriteStringN(2,"Lcount: "+Str(LCOunt))
  CloseFile(1)
  CloseFile(2)
  Input()
  CloseConsole()
EndIf

; IDE Options = PureBasic 4.70 Beta 1 (Windows - x86)
; CursorPosition = 32
; EnableXP