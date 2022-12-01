strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set IPConfigSet = objWMIService.ExecQuery("Select IPAddress from Win32_NetworkAdapterConfiguration")
For Each IPConfig in IPConfigSet
   If Not IsNull(IPConfig.IPAddress) Then
      For i=LBound(IPConfig.IPAddress) To UBound(IPConfig.IPAddress)
         IPAddress = IPAddress & IPConfig.IPAddress(i) & vbCrLf
      Next
   End If
Next
