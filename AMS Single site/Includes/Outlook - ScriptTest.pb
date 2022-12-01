;IncludePath "..\"
XIncludeFile "COMatePLUS.pbi"

code$ = "Dim DomainName" + #CRLF$
code$ + "Dim UserAccount" + #CRLF$
code$ + "Set net = CreateObject(" + Chr(34) + "WScript.Network" + Chr(34) + ")" + #CRLF$
code$ + "computerName = net.ComputerName"

Define.COMateObject scriptObject, errorObject
scriptObject = COMate_CreateObject("MSScriptControl.ScriptControl.1")

If scriptObject
  scriptObject\SetProperty("Language = 'VBScript'")
  If scriptObject\Invoke("AddCode('" + code$ + "')") = #S_OK
    result$ = scriptObject\GetStringProperty("Eval('computerName')")
    MessageRequester("Script demo", Chr(34) + code$ + Chr(34) + #LF$ + #LF$ + "Produced a result of : " + result$)
  Else
    errorObject = scriptObject\GetObjectProperty("Error")
    If errorObject 
      MessageRequester("Script demo - error reported!", Chr(34) + errorObject\GetStringProperty("Text") + Chr(34) + #LF$ + " produced the following error : " + #LF$ + #LF$ + errorObject\GetStringProperty("Description"))
      errorObject\Release()
    EndIf
  EndIf
  scriptObject\Release()
Else
  MessageRequester("COMate - Scripting demo", "Couldn't create the scripting object!")
EndIf
; IDE Options = PureBasic 5.50 (Windows - x86)
; EnableXP