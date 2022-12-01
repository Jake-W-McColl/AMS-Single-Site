; NewMap Header.s()
; Header("Authorization" = UserInfo.getSessionID()
; Header("Content-Type") = "application/json"
;[{"label":"Winter '11","url":"/services/data/v20.0","version":"20.0"},

Structure SalesForce_DataVersions
  label.s
  url.s
  version.s
EndStructure
Global NewList SF_DataVersions.SalesForce_DataVersions() : AddElement(SF_DataVersions())

InitNetwork()
HttpRequest = HTTPRequest(#PB_HTTP_Get, "https://na45.salesforce.com/services/data");, "", 0, Header())

If HttpRequest
  Txt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
  Debug txt
  JSON.i = ParseJSON(#PB_Any,Txt)
  Debug "HTTP StatusCode (200 = OK): " + HTTPInfo(HTTPRequest, #PB_HTTP_StatusCode)
  Debug "JSON Parse result: "+Str(JSON)
  Debug "JSON errors?:"
  Debug JSONErrorMessage()
  Debug JSONErrorLine()
  Debug JSONErrorPosition()
  
  ExtractJSONList(JSONValue(JSON),SF_DataVersions());,SalesForce_DataVersions)
  
  ForEach SF_DataVersions()
    Debug "Label: "+SF_DataVersions()\label+" - Version: "+SF_DataVersions()\Version + " - url: "+SF_DataVersions()\url
  Next
  
  ;Debug "Response: " + Txt
  FinishHTTP(HTTPRequest)
Else
  Debug "Request creation failed"
EndIf

; IDE Options = PureBasic 5.71 beta 1 LTS (Windows - x86)
; CursorPosition = 29
; Folding = -
; EnableXP