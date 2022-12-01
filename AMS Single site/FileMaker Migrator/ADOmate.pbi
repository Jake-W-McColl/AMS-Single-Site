CompilerIf Defined(INCLUDE_ADOMATEWRAPPER, #PB_Constant)=0
#INCLUDE_ADOMATEWRAPPER=1
;/////////////////////////////////////////////////////////////////////////////////
;***ADOmate*** - access to OLEDB datasources via ADO (ActiveX Data Objects). Version 2.0.4.
;*============
;*
;*©nxSoftWare (www.nxSoftware.com) 2008.
;*======================================
;*   Stephen Rodriguez (srod) with thanks to kiffi.
;*   Created with Purebasic 4.5 for Windows.
;*
;*   Platforms :        Windows.
;*                      Purebasic 4.3 (will not compile with earlier versions of PB.)
;*   Unicode support :  Yes
;*   Threadsafe :       In itself this library is threadsafe (with the threadsafe compiler switch etc.)
;*                      However, a single connection object will remain as threadsafe as the underlying OLEDB provider.
;*                      Also, a single recordset represents a shared resource and as such would require mutex protection
;*                      if being used by multiple threads etc.
;/////////////////////////////////////////////////////////////////////////////////

;/////////////////////////////////////////////////////////////////////////////////
;*NOTES.
;*  i)    This code requires my COMatePLUS library (see the nxSoftware site) and Kiffi's 'ado constants' file
;*        (included with this package).
;*  ii)   This library is designed to 'mimick' the PB database library as close as possible in form and function.
;*        As such, this library wraps only a small part of ADO's functionality.
;*  iii)  When executing a 'SELECT' query, the record pointer is placed on the first record returned (if any).
;*        This differs from the PB database library (which places the pointer before the first record) and is forced upon me
;*        due to the fact that the default 'cursor type' does not allow backwards traversing of records.
;*        There is thus a function (ADOmate_IsEOF()) to check if the end of the recordset has been reached.
;*  iv)   Some of the library functions should not be exported in a dll as they are.
;*        The following functions would need 'wrapping' :
;*            ADOmate_ListOLEDBproviders()
;*            ADOmate_ListDatabaseTables() 
;*            ADOmate_DatabaseColumnName()
;*            ADOmate_GetDatabaseString
;*        because they effectively return strings to the client application without using a buffer created by the client.
;*  v)    Define the constant #ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL to skip error reporting for the various ADOmate_GetDatabase...() functions.
;*        This is for extra speed.
;/////////////////////////////////////////////////////////////////////////////////


;-=================
;-INCLUDES (internal)
  XIncludeFile "adoconstants.pbi"

;-INCLUDES (external)
;  IncludePath #PB_Compiler_Home+"\Includes"
    XIncludeFile "COMatePLUS.pbi"
;-=================

;-CONSTANTS 
  ;The following enumeration holds the error / status codes. Mostly for internal use although the function
  ;ADOmate_GetLastErrorCode() can be used to retrieve the last such code on a thread-by-thread basis.
  ;The function ADOmate_GetLastErrorDescription() will retrieve an appropriate textual description of the last error etc.
    Enumeration
      #ADOmate_OKAY                       = 0
      #ADOmate_COMateERROR                = -1
      #ADOmate_ADOXERROR                  = -2
      #ADOmate_OUTOFMEMORY                = -3
      #ADOmate_NOQUERYDEFINED             = -4
      #ADOmate_INVALIDARGUMENT            = -5
      #ADOmate_ARGUMENTOUTOFRANGE         = -6
      #ADOmate_UNSUPPORTEDBINARYFORMAT    = -7
      #ADOmate_UNABLETODETERMINEBLOBSIZE  = -8
      #ADOmate_UNKNOWNERROR               = -10
    EndEnumeration
    
  ;Use one of the following constants for the optional flags parameter with the ADOmate_DatabaseUpdate() function.
    Enumeration
      #ADOmate_DONOTUNBINDBLOBS             = 0  ;Default.
      #ADOmate_UNBINDBLOBSONLYIFSUCCESSFUL
      #ADOmate_UNBINDBLOBSREGARDLESS
    EndEnumeration


;-STRUCTURES
  ;The following structure holds data for each database.
    Structure _ADOmateConnection
      connectionObject.COMateObject
      commandObject.COMateObject
      recordSetObject.COMateObject
      numColumns.i
      ;For use with COMatePLUS statements.
        hStatementRetrieve.i
        hStatementNextRow.i
        hStatementIsEOF.i
        column.i
    EndStructure

  ;The following structure is used in thread local storage to store info on the latest error recorded within the current thread.
    Structure _ADOmateThreadErrors
      lastErrorCode.i
      lastError$
    EndStructure


;-GLOBALS/THREADED
    Global ADOmate_gErrorTLS.i  ;A TLS index used to store per-thread error info.
                                ;This index will not be removed by the ADOmate library, but by Windows at program end.

;-DECLARES.
  ;Public library functions.
    Declare.i ADOmate_GetLastErrorCode()
    Declare.s ADOmate_GetLastErrorDescription()

    Declare ADOmate_CloseDatabase(*connection._ADOmateConnection)
    Declare.i ADOmate_CreateDatabase(connection$)
    Declare.s ADOmate_DatabaseColumnName(*connection._ADOmateConnection, column)
    Declare.i ADOmate_DatabaseColumns(*connection._ADOmateConnection)
    Declare.i ADOmate_DatabaseColumnType(*connection._ADOmateConnection, column, blnReturnPBColumnType = #True)
    Declare.i ADOmate_DatabaseQuery(*connection._ADOmateConnection, request$, cursorType = #adOpenForwardOnly)
    Declare.i ADOmate_DatabaseUpdate(*connection._ADOmateConnection, request$, flags=#ADOmate_DONOTUNBINDBLOBS)
    Declare ADOmate_FinishDatabaseQuery(*connection._ADOmateConnection)
    Declare.i ADOmate_FirstDatabaseRow(*connection._ADOmateConnection)
    Declare.d ADOmate_GetDatabaseDouble(*connection._ADOmateConnection, column)
    Declare.d ADOmate_GetDatabaseDoubleByFieldName(*connection._ADOmateConnection, fieldName$)
    Declare.f ADOmate_GetDatabaseFloat(*connection._ADOmateConnection, column)
    Declare.f ADOmate_GetDatabaseFloatByFieldName(*connection._ADOmateConnection, fieldName$)
    Declare.l ADOmate_GetDatabaseLong(*connection._ADOmateConnection, column)
    Declare.l ADOmate_GetDatabaseLongByFieldName(*connection._ADOmateConnection, fieldName$)
    Declare.q ADOmate_GetDatabaseQuad(*connection._ADOmateConnection, column)
    Declare.q ADOmate_GetDatabaseQuadByFieldName(*connection._ADOmateConnection, fieldName$)
    Declare.s ADOmate_GetDatabaseString(*connection._ADOmateConnection, column)
    Declare.s ADOmate_GetDatabaseStringByFieldName(*connection._ADOmateConnection, fieldName$)
    Declare.i ADOmate_GetDatabaseVariant(*connection._ADOmateConnection, column)
    Declare.i ADOmate_GetDatabaseVariantByFieldName(*connection._ADOmateConnection, fieldName$)
    Declare.i ADOmate_IsEOF(*connection._ADOmateConnection)
    Declare.i ADOmate_ListDatabaseTables(*connection._ADOmateConnection, Array buffer.s(1), type$="")
    Declare.i ADOmate_NextDatabaseRow(*connection._ADOmateConnection)
    Declare.i ADOmate_OpenDatabase(connection$, user$="", password$="")
    Declare.i ADOmate_PreviousDatabaseRow(*connection._ADOmateConnection)

    Declare.i ADOmate_ListOLEDBproviders(Array buffer.s(1))

  ;Internal functions.
    Declare ADOmate_SetError(result)
    Declare ADOmate_SetConnectionStatements(*connection._ADOmateConnection)


;-=================
;-LIBRARY FUNCTIONS
;-=================

;------------------
;-Error retrieval functions
;------------------

;=================================================================================
;The following method returns the last #ADOmate_error code recorded by ADOmate against the underlying thread.
;This is completely threadsafe in that 2 threads using the same connection object (for example) will not overwrite each other's errors.
Procedure.i ADOmate_GetLastErrorCode()
  Protected *error._ADOmateThreadErrors
  If ADOmate_gErrorTLS <> -1
    *error = TlsGetValue_(ADOmate_gErrorTLS)
    If *error
      ProcedureReturn *error\lastErrorCode
    EndIf
  EndIf
EndProcedure
;=================================================================================


;=================================================================================
;The following method returns a description of the last error recorded by ADOmate against the underlying thread.
;This is completely threadsafe in that 2 threads using the same connection object (for example) will not overwrite each other's errors.
Procedure.s ADOmate_GetLastErrorDescription()
  Protected *error._ADOmateThreadErrors
  If ADOmate_gErrorTLS <> -1
    *error = TlsGetValue_(ADOmate_gErrorTLS)
    If *error
      ProcedureReturn *error\lastError$ 
    EndIf
  EndIf
EndProcedure
;=================================================================================


;------------------
;-Database functions
;------------------

;/////////////////////////////////////////////////////////////////////////////////
;The following function closes a given ADOmate connection.
;No return value.
;Errors can be queried using the two error retrieval functions.
Procedure ADOmate_CloseDatabase(*connection._ADOmateConnection)
  Protected error
  If *connection
    ;Close any recordset object.
      If *connection\recordsetObject
        *connection\recordsetObject\Invoke("Close")
        *connection\recordsetObject\Release()
      EndIf
    ;Close any command object.
      If *connection\commandObject
        *connection\commandObject\Release()
      EndIf
    ;Close any connection object.
      If *connection\connectionObject
        *connection\connectionObject\Invoke("Close")
        *connection\connectionObject\Release()
      EndIf
    ;Free any statement handles.
      If *connection\hStatementIsEOF
        COMate_FreeStatementHandle(*connection\hStatementIsEOF)
      EndIf
      If *connection\hStatementNextRow
        COMate_FreeStatementHandle(*connection\hStatementNextRow)
      EndIf
      If *connection\hStatementRetrieve
        COMate_FreeStatementHandle(*connection\hStatementRetrieve)
      EndIf
    FreeMemory(*connection)
    error = #ADOmate_OKAY
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  ADOmate_SetError(error)
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function attempts to create a new database as defined by the given connection string.
;Returns an ADOmate connection handle if successful or zero in the case of an error.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_CreateDatabase(connection$)
  Protected *connection._ADOmateConnection, *catalog.COMateObject
  ;Allocate memory for a connection object.
    *connection = AllocateMemory(SizeOf(_ADOmateConnection))
  If *connection
    ;Attempt to create the database.
      ;Create an ADOX (ADO extension) object used for working with database schemas etc.
        *catalog = COMate_CreateObject("ADOX.Catalog")
      If *catalog
        If SUCCEEDED(*catalog\Invoke("Create('" + connection$ + "')"))
          ;Now attempt to create an ADO connection object which can be used to work with SQL.
            *connection\connectionObject = COMate_CreateObject("ADODB.Connection")
            If *connection\connectionObject
              If SUCCEEDED(*connection\connectionObject\Invoke("Open('" + connection$ + "')"))
                ;Set the statements if not already done.
                  ADOmate_SetConnectionStatements(*connection)
                ADOmate_SetError(#ADOmate_OKAY)
              Else
                ADOmate_SetError(#ADOmate_COMateERROR)
                *connection\connectionObject\Invoke("Close")
                *connection\connectionObject\Release()
                FreeMemory(*connection)
              EndIf          
            Else
              ADOmate_SetError(#ADOmate_COMateERROR)
              FreeMemory(*connection)
              *connection = 0
            EndIf
        Else
          ADOmate_SetError(#ADOmate_COMateERROR)
          FreeMemory(*connection)
          *connection = 0
        EndIf
        *catalog\Release()
      Else
        ADOmate_SetError(#ADOmate_COMateERROR)
        FreeMemory(*connection)
        *connection = 0
      EndIf
  Else
    ADOmate_SetError(#ADOmate_OUTOFMEMORY)
    *connection = 0
  EndIf
  ProcedureReturn *connection
EndProcedure
;=================================================================================

;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns a column (zero-based index) name.
;Errors can be queried using the two error retrieval functions.
Procedure.s ADOmate_DatabaseColumnName(*connection._ADOmateConnection, column)
  Protected error, result$
  If *connection
    If *connection\recordsetObject
      If column>=0 And column < *connection\numColumns
        result$ = *connection\recordsetObject\GetStringProperty("Fields(" + Str(column) + ")\Name")
        If COMate_GetLastErrorCode() = #S_OK
          error = #ADOmate_OKAY
        Else
          result$ = ""
          error = #ADOmate_COMateERROR
        EndIf
      Else
        error = #ADOmate_ARGUMENTOUTOFRANGE
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  ADOmate_SetError(error)
  ProcedureReturn result$
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the number of columns within a currently active query.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_DatabaseColumns(*connection._ADOmateConnection)
  Protected error, result
  If *connection
    If *connection\recordsetObject
      result = *connection\numColumns
      error = #ADOmate_OKAY
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  ADOmate_SetError(error)
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the size of the specified column (zero-based index).
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_DatabaseColumnSize(*connection._ADOmateConnection, column)
  Protected result, error
  If *connection
    If *connection\recordsetObject
      If column>=0 And column < *connection\numColumns
        result = *connection\recordsetObject\GetIntegerProperty("Fields(" + Str(column) + ")\ActualSize")
        If COMate_GetLastErrorCode() = #S_OK
          error = #ADOmate_OKAY
        Else
          result = 0
          error = #ADOmate_COMateERROR
        EndIf
      Else
        error = #ADOmate_ARGUMENTOUTOFRANGE
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  ADOmate_SetError(error)
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns a column (zero-based index) type.
;Leave the optional parameter blnReturnPBColumnType = #True to have a PB database constant returned (#PB_Database_Long etc.)
;otherwise set it to #False to have the native ADO enumerated value returned.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_DatabaseColumnType(*connection._ADOmateConnection, column, blnReturnPBColumnType = #True)
  Protected result, error
  If *connection
    If *connection\recordsetObject
      If column>=0 And column < *connection\numColumns
        result = *connection\recordsetObject\GetIntegerProperty("Fields(" + Str(column) + ")\Type")
        If COMate_GetLastErrorCode() = #S_OK
          If blnReturnPBColumnType
            ;Here we must translate to a PB database column type.
              Select result 
                Case #adInteger, #adTinyInt, #adSmallInt, #adUnsignedTinyInt, #adUnsignedSmallInt, #adUnsignedInt
                  result = #PB_Database_Long
                Case #adBigInt, #adUnsignedBigInt
                  result = #PB_Database_Quad                
                Case #adSingle
                  result = #PB_Database_Float
                Case #adDouble, #adDecimal, #adNumeric
                  result = #PB_Database_Double
                Case #adBSTR, #adChar, #adVarChar, #adLongVarChar, #adWChar, #adVarWChar, #adLongVarWChar
                  result = #PB_Database_String          
                Case #adBinary, #adVarBinary, #adLongVarBinary
                  result = #PB_Database_Blob
                Default
                  result = 0
              EndSelect
          EndIf
          error = #ADOmate_OKAY
        Else
          result = 0
          error = #ADOmate_COMateERROR
        EndIf
      Else
        error = #ADOmate_ARGUMENTOUTOFRANGE
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  ADOmate_SetError(error)
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function attempts to execute a new query (any previous query is closed if the new query is successful) and
;create a corresponding recordset (which is hidden from the user).
;cursorType can equal #adOpenForwardOnly (default) or #adOpenKeyset or #adOpenDynamic or #adOpenStatic.
;Returns zero if an error - otherwise returns a COMate object housing the underlying ADO recordset object through which
;can be applied all the appropriate methods and properties etc. for advanced functionality.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_DatabaseQuery(*connection._ADOmateConnection, request$, cursorType = #adOpenForwardOnly)
  Protected rset.COMateObject, error
  If *connection And *connection\connectionObject And request$
    request$ = ReplaceString(request$, "'", "$0027")
    rset = COMate_CreateObject("ADODB.recordset")
    If rset
      If rset\SetProperty("CursorType = " + Str(cursorType)) = #S_OK And rset\Invoke("Open('" + request$ + "', " + Str(*connection\connectionObject) + " as COMateObject)") = #S_OK
        If *connection\recordsetObject
          *connection\recordsetObject\Invoke("Close")
          *connection\recordsetObject\Release()
        EndIf
        *connection\recordsetObject = rset
        *connection\numColumns = *connection\recordsetObject\GetIntegerProperty("Fields\Count")
        error = #ADOmate_OKAY
      Else
        ADOmate_SetError(#ADOmate_COMateERROR)
        rset\Release()
        ProcedureReturn 0
      EndIf
    Else
      error = #ADOmate_COMateERROR
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  ADOmate_SetError(error)
  ProcedureReturn rset  
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function attempts to execute an SQL statememt on the underlying database.
;Returns the number of rows affected.
;Note that this function will not destroy an existing recordset query (ADOmate_DatabaseQuery()) although it may invalidate it.
;Errors can be queried using the two error retrieval functions.
;The optional flags parameter is used to specify whether the blobs stored against the connection object should be unbound and deleted.
Procedure.i ADOmate_DatabaseUpdate(*connection._ADOmateConnection, request$, flags = #ADOmate_DONOTUNBINDBLOBS)
  Protected result, error
  Protected RecordsAffected
  If *connection And *connection\connectionObject And request$
    request$ = ReplaceString(request$, "'", "$0027")
    If *connection\commandObject
      If *connection\commandObject\SetProperty("CommandText = '" + request$ + "'") = #S_OK
        If *connection\commandObject\Invoke("Execute(" + Str(@RecordsAffected) + " ByRef, #OPT, " + Str(#adExecuteNoRecords) + ")") = #S_OK
          result = RecordsAffected
          If flags <> #ADOmate_DONOTUNBINDBLOBS
            flags = #ADOmate_UNBINDBLOBSREGARDLESS
          EndIf
          error = #ADOmate_OKAY
        Else
          error = #ADOmate_COMateERROR
        EndIf
      Else
        error = #ADOmate_COMateERROR
      EndIf
      ADOmate_SetError(error)
      If flags = #ADOmate_UNBINDBLOBSREGARDLESS
        *connection\commandObject\Release()
        *connection\commandObject = 0
      EndIf
      ProcedureReturn result
    ElseIf *connection\connectionObject\Invoke("Execute('" + request$ + "', " + Str(@RecordsAffected) + " ByRef)") = #S_OK
      result = RecordsAffected
      error = #ADOmate_OKAY
    Else
      error = #ADOmate_COMateERROR
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  ADOmate_SetError(error)
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function frees up a previous SQL recordset query.
;Note that closing the database or issuing another SQL query (with ADOmate_DatabaseQuery()) automatically frees any existing query.
Procedure ADOmate_FinishDatabaseQuery(*connection._ADOmateConnection)
  Protected error = #ADOmate_OKAY
  If *connection
    If *connection\recordsetObject
      *connection\recordsetObject\Invoke("Close")
      *connection\recordsetObject\Release()
      *connection\recordsetObject = 0
      *connection\numColumns = 0
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  ADOmate_SetError(error)
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function moves the internal recordset 'pointer' to the first record in the recordset.
;Returns zero if there is an error or no first row available.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_FirstDatabaseRow(*connection._ADOmateConnection)
  Protected result, error
  If *connection
    If *connection\recordsetObject
      If *connection\recordsetObject\Invoke("MoveFirst") = #S_OK
        result = 1
        error = #ADOmate_OKAY
      Else
        error = #ADOmate_COMateERROR
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified column as a pointer to blob memory.
;Free memory must be called on the pointer returned when you are finished.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_GetDatabaseBlob(*connection._ADOmateConnection, column)
  Protected error = #ADOmate_OKAY, numColumns, size, memPtr, *var.VARIANT, *sa.SAFEARRAY
  *var = ADOmate_GetDatabaseVariant(*connection, column)
  If *var
    If *var\vt & #VT_ARRAY
      size = *connection\recordsetObject\GetIntegerProperty("Fields(" + Str(column) + ")\ActualSize")
      If size > 0
        memPtr = AllocateMemory(size)
        If memPtr
          *sa = *var\parray
          If SafeArrayLock_(*sa) = #S_OK  ;ADOmate_GetDatabaseVariant() will have set a status code.
            CopyMemory(*sa\pvData, memPtr, size)
            SafeArrayUnlock_(*sa) 
          Else
            FreeMemory(memPtr)
            error = #ADOmate_UNKNOWNERROR
          EndIf         
        Else
          error = #ADOmate_OUTOFMEMORY
        EndIf
      ElseIf size = -1 ;#adUnknown
        error = #ADOmate_UNABLETODETERMINEBLOBSIZE
      EndIf
    ElseIf *var\vt <> #VT_EMPTY And *var\vt <> #VT_NULL
      error = #ADOmate_UNSUPPORTEDBINARYFORMAT
    EndIf  
    VariantClear_(*var)
    FreeMemory(*var)
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  GlobalSize.i = Size
  ProcedureReturn memPtr
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified field as a pointer to blob memory.
;Free memory must be called on the pointer returned when you are finished.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_GetDatabaseBlobByFieldName(*connection._ADOmateConnection, fieldName$)
  Protected error = #ADOmate_OKAY, numColumns, size, memPtr, *var.VARIANT, *sa.SAFEARRAY
  *var = ADOmate_GetDatabaseVariantByFieldName(*connection, fieldName$)
  If *var
    If *var\vt & #VT_ARRAY
      size = *connection\recordsetObject\GetIntegerProperty("Fields('" + fieldName$ + "')\ActualSize")
      If size > 0
        ;Size * 4
        memPtr = AllocateMemory(size)
        If memPtr
          *sa = *var\parray
          If SafeArrayLock_(*sa) = #S_OK  ;ADOmate_GetDatabaseVariant() will have set a status code.
            CopyMemory(*sa\pvData, memPtr, size)
            SafeArrayUnlock_(*sa) 
          Else
            FreeMemory(memPtr)
            error = #ADOmate_UNKNOWNERROR
          EndIf         
        Else
          error = #ADOmate_OUTOFMEMORY
        EndIf
      ElseIf size = -1 ;#adUnknown
        error = #ADOmate_UNABLETODETERMINEBLOBSIZE
      EndIf
    ElseIf *var\vt <> #VT_EMPTY And *var\vt <> #VT_NULL
      error = #ADOmate_UNSUPPORTEDBINARYFORMAT
    EndIf  
    VariantClear_(*var)
    FreeMemory(*var)
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  GlobalSize.i = Size
  ProcedureReturn memPtr
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified column in double format.
;Errors can be queried using the two error retrieval functions.
Procedure.d ADOmate_GetDatabaseDouble(*connection._ADOmateConnection, column)
  Protected result.d, error
  If *connection
    If *connection\recordsetObject
      If column>=0 And column < *connection\numColumns
        *connection\column = column
        result = *connection\recordsetObject\GetRealProperty("Fields(" + Str(column) + ")\Value", *connection\hStatementRetrieve)
        If comate_GetLastErrorCode() = #S_OK
          error = #ADOmate_OKAY
        Else
          error = #ADOmate_COMateERROR
        EndIf
      Else
        error = #ADOmate_ARGUMENTOUTOFRANGE
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified field in double format.
;Errors can be queried using the two error retrieval functions.
Procedure.d ADOmate_GetDatabaseDoubleByFieldName(*connection._ADOmateConnection, fieldName$)
  Protected result.d, error
  If *connection And FieldName$
    If *connection\recordsetObject
      result = *connection\recordsetObject\GetRealProperty("Fields('" + fieldName$ + "')\Value")
      If COMate_GetLastErrorCode() = #S_OK
        error = #ADOmate_OKAY
      Else
        error = #ADOmate_COMateERROR
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified column in float format.
;Errors can be queried using the two error retrieval functions.
Procedure.f ADOmate_GetDatabaseFloat(*connection._ADOmateConnection, column)
  Protected result.f, error
  If *connection
    If *connection\recordsetObject
      If column>=0 And column < *connection\numColumns
        *connection\column = column
        result = *connection\recordsetObject\GetRealProperty("Fields(" + Str(column) + ")\Value", *connection\hStatementRetrieve)
        If comate_GetLastErrorCode() = #S_OK
          error = #ADOmate_OKAY
        Else
          error = #ADOmate_COMateERROR
        EndIf
      Else
        error = #ADOmate_ARGUMENTOUTOFRANGE
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified field in float format.
;Errors can be queried using the two error retrieval functions.
Procedure.f ADOmate_GetDatabaseFloatByFieldName(*connection._ADOmateConnection, fieldName$)
  Protected result.f, error
  If *connection And FieldName$
    If *connection\recordsetObject
      result = *connection\recordsetObject\GetRealProperty("Fields('" + fieldName$ + "')\Value")
      If COMate_GetLastErrorCode() = #S_OK
        error = #ADOmate_OKAY
      Else
        error = #ADOmate_COMateERROR
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified column in long format.
;Errors can be queried using the two error retrieval functions.
Procedure.l ADOmate_GetDatabaseLong(*connection._ADOmateConnection, column)
  Protected result.l, error
  If *connection
    If *connection\recordsetObject
      If column>=0 And column < *connection\numColumns
        *connection\column = column
        result = *connection\recordsetObject\GetIntegerProperty("Fields(" + Str(column) + ")\Value", *connection\hStatementRetrieve)
        If comate_GetLastErrorCode() = #S_OK
          error = #ADOmate_OKAY
        Else
          error = #ADOmate_COMateERROR
        EndIf
      Else
        error = #ADOmate_ARGUMENTOUTOFRANGE
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified field in long format.
;Errors can be queried using the two error retrieval functions.
Procedure.l ADOmate_GetDatabaseLongByFieldName(*connection._ADOmateConnection, fieldName$)
  Protected result.l, error
  If *connection And FieldName$
    If *connection\recordsetObject
      result = *connection\recordsetObject\GetIntegerProperty("Fields('" + fieldName$ + "')\Value")
      If COMate_GetLastErrorCode() = #S_OK
        error = #ADOmate_OKAY
      Else
        error = #ADOmate_COMateERROR
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified column in quad format.
;Errors can be queried using the two error retrieval functions.
Procedure.q ADOmate_GetDatabaseQuad(*connection._ADOmateConnection, column)
  Protected result.q, error
  If *connection
    If *connection\recordsetObject
      If column>=0 And column < *connection\numColumns
        *connection\column = column
        result = *connection\recordsetObject\GetIntegerProperty("Fields(" + Str(column) + ")\Value", *connection\hStatementRetrieve)
        If comate_GetLastErrorCode() = #S_OK
          error = #ADOmate_OKAY
        Else
          error = #ADOmate_COMateERROR
        EndIf
      Else
        error = #ADOmate_ARGUMENTOUTOFRANGE
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified field in quad format.
;Errors can be queried using the two error retrieval functions.
Procedure.q ADOmate_GetDatabaseQuadByFieldName(*connection._ADOmateConnection, fieldName$)
  Protected result.q, error
  If *connection And FieldName$
    If *connection\recordsetObject
      result = *connection\recordsetObject\GetIntegerProperty("Fields('" + fieldName$ + "')\Value")
      If COMate_GetLastErrorCode() = #S_OK
        error = #ADOmate_OKAY
      Else
        error = #ADOmate_COMateERROR
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified column in string format.
;Errors can be queried using the two error retrieval functions.
Procedure.s ADOmate_GetDatabaseString(*connection._ADOmateConnection, column)
  Protected result$, error
  If *connection
    If *connection\recordsetObject
      If column>=0 And column < *connection\numColumns
        *connection\column = column
        result$ = *connection\recordsetObject\GetStringProperty("Fields(" + Str(column) + ")\Value", *connection\hStatementRetrieve)
        If COMate_GetLastErrorCode() = #S_OK
          error = #ADOmate_OKAY
        Else
          error = #ADOmate_COMateERROR
        EndIf
      Else
        error = #ADOmate_ARGUMENTOUTOFRANGE
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result$
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified field in string format.
;Errors can be queried using the two error retrieval functions.
Procedure.s ADOmate_GetDatabaseStringByFieldName(*connection._ADOmateConnection, fieldName$)
  Protected result$, error
  If *connection And FieldName$
    If *connection\recordsetObject
      result$ = *connection\recordsetObject\GetStringProperty("Fields('" + fieldName$ + "')\Value")
      If COMate_GetLastErrorCode() = #S_OK
        error = #ADOmate_OKAY
      Else
        error = #ADOmate_COMateERROR
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result$
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified column as a variant pointer. You must use VariantClear_() and then FreeMemory()
;on the pointer returned when you are finished with it.
;This is particularly useful for accessing blob fields directly without having to worry about memory buffers etc.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_GetDatabaseVariant(*connection._ADOmateConnection, column)
  Protected *var.VARIANT, error
  If *connection
    If *connection\recordsetObject
      If column>=0 And column < *connection\numColumns
        *connection\column = column
        *var = *connection\recordsetObject\GetVariantProperty("Fields(" + Str(column) + ")\Value", *connection\hStatementRetrieve)
        If *var
          error = #ADOmate_OKAY
        Else
          error = #ADOmate_COMateERROR
        EndIf
      Else
        error = #ADOmate_ARGUMENTOUTOFRANGE
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn *var
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns the contents of the specified column as a variant pointer. You must use VariantClear_() and then FreeMemory()
;on the pointer returned when you are finished with it.
;This is particularly useful for accessing blob fields directly without having to worry about memory buffers etc.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_GetDatabaseVariantByFieldName(*connection._ADOmateConnection, fieldName$)
  Protected *var.VARIANT, error
  If *connection
    If *connection\recordsetObject
      *var = *connection\recordsetObject\GetVariantProperty("Fields('" + fieldName$ + "')\Value")
      If *var
        error = #ADOmate_OKAY
      Else
        error = #ADOmate_COMateERROR
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn *var
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function returns #True if the current recordset is beyond the EOF etc.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_IsEOF(*connection._ADOmateConnection)
  Protected result=1, error
  If *connection
    If *connection\recordsetObject
      result = *connection\recordsetObject\GetIntegerProperty("EOF", *connection\hStatementIsEOF)
      If COMate_GetLastErrorCode() = #S_OK
        If result = -1
          result = 1
        EndIf
        error = #ADOmate_OKAY
      Else
        error = #ADOmate_COMateERROR
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  ADOmate_SetError(error)
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function fills the given string array with the names of all tables within the database.
;Leave type$ empty to list all tables (including system ones).
;Returns the number of tables returned or zero if there is an error (or simply no tables) in which case the string array is not
;touched at all.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_ListDatabaseTables(*connection._ADOmateConnection, Array buffer.s(1), type$="")
  Protected error, count, tablesSchema.COMateObject
  If *connection And *connection\connectionObject
    tablesSchema = *connection\connectionObject\GetObjectProperty("OpenSchema(" + Str(#adSchemaTables) + ")")
    If tablesSchema 
      type$ = LCase(type$)
      While tablesSchema\GetIntegerProperty("EOF", *connection\hStatementIsEOF) = #False
        If type$="" Or type$ = LCase(tablesSchema\GetStringProperty("Fields('TABLE_TYPE')\Value") )
          If ArraySize(buffer()) < count
            ReDim buffer(count)
          EndIf
          buffer(count) = tablesSchema\GetStringProperty("Fields('TABLE_NAME')\Value") 
          count+1
        EndIf
        tablesSchema\Invoke("MoveNext", *connection\hStatementNextRow)
      Wend
      tablesSchema\Release()
    Else
      error = #ADOmate_COMateERROR
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  ADOmate_SetError(error)
  ProcedureReturn count
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function moves the internal recordset 'pointer' to the next record in the recordset.
;Returns zero if there is an error or we are already at the last record.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_NextDatabaseRow(*connection._ADOmateConnection)
  Protected result, error
  If *connection
    If *connection\recordsetObject
      If *connection\recordsetObject\Invoke("MoveNext", *connection\hStatementNextRow) = #S_OK
        If *connection\recordsetObject\GetIntegerProperty("EOF", *connection\hStatementIsEOF) = 0
          result = 1
          error = #ADOmate_OKAY
        EndIf
      Else
        error = #ADOmate_COMateERROR
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function attempts to open a new connection through ADO.
;If successful, an ADOmate connection handle is returned. Zero is returned otherwise.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_OpenDatabase(connection$, user$="", password$="")
  Protected error, *connection._ADOmateConnection
  ;Allocate memory for a connection object.
    *connection = AllocateMemory(SizeOf(_ADOmateConnection))
  If *connection
    ;Now attempt to create an ADO connection object which can be used to work with SQL.
      *connection\connectionObject = COMate_CreateObject("ADODB.Connection")
      If *connection\connectionObject
        If user$=""
          user$ = "#empty"
        Else
          user$ = "'" + user$ + "'"
        EndIf
        If password$=""
          password$ = "#empty"
        Else
          password$ = "'" + password$ + "'"
        EndIf
        If SUCCEEDED(*connection\connectionObject\Invoke("Open('" + connection$ + "', " + user$ + ", " + password$ +")"))
          ;Set the statements if not already done.
            ADOmate_SetConnectionStatements(*connection)
          error = #ADOmate_OKAY
        Else
          error = #ADOmate_COMateERROR
          ADOmate_SetError(error)
          *connection\connectionObject\Invoke("Close")
          *connection\connectionObject\Release()
          FreeMemory(*connection)
          ProcedureReturn 0
        EndIf          
      Else
        error = #ADOmate_COMateERROR
        FreeMemory(*connection)
        *connection = 0
      EndIf
  Else
    error = #ADOmate_OUTOFMEMORY
    *connection = 0
  EndIf
  ADOmate_SetError(error)
  ProcedureReturn *connection
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function moves the internal recordset 'pointer' to the previous record in the recordset.
;Returns zero if there is an error or we are already at the first record.
;Errors can be queried using the two error retrieval functions.
;NOTE that the underlying recordset must have a cursor type other than the default #adOpenForwardOnly for this function
;to work.
Procedure.i ADOmate_PreviousDatabaseRow(*connection._ADOmateConnection)
  Protected result, error
  If *connection
    If *connection\recordsetObject
      If *connection\recordsetObject\Invoke("MovePrevious") = #S_OK
        result = 1
        error = #ADOmate_OKAY
      Else
        error = #ADOmate_COMateERROR
      EndIf
    Else
      error = #ADOmate_NOQUERYDEFINED
    EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  CompilerIf Defined(ADOmate_NOERRORREPORTINGDURINGRECORDRETRIEVAL, #PB_Constant)=0
    ADOmate_SetError(error)
  CompilerEndIf
  ProcedureReturn result
EndProcedure
;=================================================================================


;/////////////////////////////////////////////////////////////////////////////////
;The following function creates a variant containing 'blob' data and binds it to the relevant parameter.
;Returns zero if an error.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_SetDatabaseBlob(*connection._ADOmateConnection, statementIndex, buffer, bufferLength)
  Protected error, result, parameter.COMateObject, var.VARIANT, *sa.SAFEARRAY, saBound.SAFEARRAYBOUND, t1
  If *connection And *connection\connectionObject And buffer And bufferLength
    ;Need to wrap the buffer up in a safearray.
      With saBound
        \lLbound = 0
        \cElements = bufferLength
      EndWith
      *sa = SafeArrayCreate_(#VT_UI1, 1, saBound)
      If *sa
        ;We make the safe array point at the memory buffer holding the blob. I am surprised Windows allows us to do this!
        ;If this proves problematic then we shall have to just fill the safearray byte by byte.
        If SafeArrayLock_(*sa) = #S_OK
          t1 = *sa\pvData
          *sa\pvData = buffer
          ;Create a variant to hold the array.
            var\vt = #VT_ARRAY|#VT_UI1
            var\parray = *sa
          If *connection\commandObject = 0
            *connection\commandObject = COMate_CreateObject("ADODB.Command")
            If *connection\commandObject
              *connection\commandObject\SetProperty("ActiveConnection = " + Str(*connection\connectionObject) + " as COMateObject")
            EndIf
          EndIf
          If *connection\commandObject
            parameter = *connection\commandObject\GetObjectProperty("CreateParameter('@P" + Str(statementIndex) + "', " + Str(#adLongVarBinary) + ", " + Str(#adParamInput) + ", " + Str(bufferLength) + ", " + Str(var) + " as variant byref)")
            If parameter
              parameter\SetProperty("Attributes = " +Str(#adParamNullable + #adParamLong))
              *connection\commandObject\Invoke("Parameters\Append(" + Str(parameter) + " as COMateObject)")
              parameter\Release()
              result = #True
              error = #ADOmate_OKAY
            Else
              error = #ADOmate_COMateERROR
            EndIf
          Else
            error = #ADOmate_COMateERROR
          EndIf
          *sa\pvData = t1
          SafeArrayUnlock_(*sa)
          VariantClear_(var)
        Else
          SafeArrayDestroy_(*sa)
          error = #ADOmate_UNKNOWNERROR
        EndIf
      Else
        error = #ADOmate_OUTOFMEMORY
      EndIf
  Else
    error = #ADOmate_INVALIDARGUMENT
  EndIf
  ADOmate_SetError(error)
  ProcedureReturn result
EndProcedure
;=================================================================================


;------------------
;-Schema functions
;------------------

;/////////////////////////////////////////////////////////////////////////////////
;The following function fills the given string array with the names of all tables within the database defined by
;the given connection string.
;Leave type$ empty to list all tables (including system ones).
;Returns the number of tables returned or zero if there is an error (or simply no tables) in which case the string array is not
;touched at all.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_ListDatabaseTablesFromConnectionString(connection$, Array buffer.s(1), type$="")
  Protected count, adoCatalog.COMateObject, adoTable.COMateObject
  Protected enumTables.COMateEnumObject
  adoCatalog = COMate_CreateObject("ADOX.Catalog")
  If adoCatalog
    If adoCatalog\SetProperty("ActiveConnection = '" + connection$ + "'") = #S_OK
      enumTables = adoCatalog\CreateEnumeration("Tables") 
      If enumTables 
        type$ = LCase(type$)
        adoTable = enumTables\GetNextObject() 
        While adoTable
          If type$="" Or type$ = LCase(adoTable\GetStringProperty("Type"))
            If ArraySize(buffer()) < count
              ReDim buffer(count)
            EndIf
            buffer(count) = adoTable\GetStringProperty("Name") 
            count+1
          EndIf
          adoTable\Release() 
          adoTable = enumTables\GetNextObject() 
        Wend 
        enumTables\Release() 
        ADOmate_SetError(#ADOmate_OKAY)
      Else
        ADOmate_SetError(#ADOmate_COMateERROR)
      EndIf 
    Else
      ADOmate_SetError(#ADOmate_COMateERROR)
    EndIf
    adoCatalog\Release()
  Else
    ADOmate_SetError(#ADOmate_ADOXERROR)
  EndIf
  ProcedureReturn count
EndProcedure
;=================================================================================


;------------------
;-General functions
;------------------

;/////////////////////////////////////////////////////////////////////////////////
;The following function takes a string array and fills it with the names of all registered OLEDB providers on the local machine.
;Returns the number of providers or zero if there is an error (or simply no providers) in which case the string array is not
;touched at all.
;Errors can be queried using the two error retrieval functions.
Procedure.i ADOmate_ListOLEDBproviders(Array buffer.s(1))
  Protected count, result, lpcbName, cbData, subKey, buffer, enumIndex
  Protected hKey1, hKey2, hKey3
  lpcbName = 256
  cbData = 256
  subKey = AllocateMemory(lpcbName)
  If subKey
    buffer = AllocateMemory(cbData)
    If buffer
      result = #ADOmate_UNKNOWNERROR
      If RegOpenKeyEx_(#HKEY_CLASSES_ROOT, "CLSID", 0, #KEY_READ, @hKey1) = #ERROR_SUCCESS And hKey1
        enumIndex = 0
        result = RegEnumKeyEx_(hKey1, enumIndex, subKey, @lpcbName, 0, 0, 0, 0)
        While result = #ERROR_SUCCESS
          If RegOpenKeyEx_(hKey1, subKey, 0, #KEY_READ, @hKey2) = #ERROR_SUCCESS And hKey2
            If RegOpenKeyEx_(hKey2, "OLE DB Provider", 0, #KEY_READ, @hKey3) = #ERROR_SUCCESS And hKey3
              cbData = 1024
              If RegQueryValueEx_(hKey3, "", 0, 0, buffer, @cbData)=#ERROR_SUCCESS
                If ArraySize(buffer()) < count
                  ReDim buffer(count)
                EndIf
                buffer(count) = PeekS(buffer)
                count+1
              EndIf
              RegCloseKey_(hKey3)
            EndIf
            RegCloseKey_(hKey2)
          EndIf
        lpcbName = 1024
        enumIndex+1
        result = RegEnumKeyEx_(hKey1, enumIndex, subKey, @lpcbName, 0, 0, 0, 0)
        Wend
        RegCloseKey_(hKey1)
        If result = #ERROR_NO_MORE_ITEMS
          result = #ADOmate_OKAY
        Else
          result = #ADOmate_UNKNOWNERROR ;I can't be bothered to arse around with FormatMessage_() !
        EndIf
      EndIf
      FreeMemory(buffer)
    Else
      result = #ADOmate_OUTOFMEMORY
    EndIf  
    FreeMemory(subKey)  
  Else
    result = #ADOmate_OUTOFMEMORY
  EndIf
  ADOmate_SetError(result)
  ProcedureReturn count
EndProcedure
;=================================================================================


;-=================
;-UTILITY FUNCTIONS
;-=================

;///////////////////////////////////////////////////////////////////////////////////////////
;The following function takes charge of allocating thread local storage in which to store info on the latest operation etc.
Procedure ADOmate_SetError(result)
  Protected *error._ADOmateThreadErrors, Array.i
  If ADOmate_gErrorTLS = 0 Or COMate_gErrorTLS = -1
    ;Create a new TLS index to hold error information.
      ADOmate_gErrorTLS = TlsAlloc_()
  EndIf
  If ADOmate_gErrorTLS = -1
    ProcedureReturn
  EndIf
  ;Is there a TLS entry for this thread.
    *error = TlsGetValue_(ADOmate_gErrorTLS)
    If *error = 0 ;No existing entry.
      ;Attempt to allocate memory for a TLS entry for this thread.
        *error = AllocateMemory(SizeOf(_ADOmateThreadErrors))
      If *error
        If TlsSetValue_(ADOmate_gErrorTLS, *error) = 0
          FreeMemory(*error)          
          *error = 0
        EndIf
      EndIf
    EndIf
  If *error
    *error\lastErrorCode = result
    Select result
      Case #ADOmate_OKAY
        *error\lastError$ = "Okay."
      Case #ADOmate_COMateERROR
        *error\lastError$ = COMate_GetlastErrorDescription()
      Case #ADOmate_ADOXERROR
        *error\lastError$ = "Couldn't create the ADOX extension object! Make sure the latest version of MDAC is installed!"
      Case #ADOmate_OUTOFMEMORY
        *error\lastError$ = "Out of memory."
      Case #ADOmate_NOQUERYDEFINED
        *error\lastError$ = "No query has been executed."
      Case #ADOmate_INVALIDARGUMENT
        *error\lastError$ = "Invalid argument."
      Case #ADOmate_ARGUMENTOUTOFRANGE
        *error\lastError$ = "One (or more) arguments is/are out of range."
      Case #ADOmate_UNSUPPORTEDBINARYFORMAT
        *error\lastError$ = "A binary blob column was returned in an unsupported binary format. Use the ADOmate_GetDatabaseVariant() function instead."
      Case #ADOmate_UNABLETODETERMINEBLOBSIZE
        *error\lastError$ = "Unable to determine the size of a blob column."
      Case #ADOmate_UNKNOWNERROR
        *error\lastError$ = "Unknown/unexpected error."
    EndSelect
  EndIf
EndProcedure
;=================================================================================



;///////////////////////////////////////////////////////////////////////////////////////////
;The following function sets our threaded COMatePLUS statements.
;We do not check for errors because ADOmate will simply resort to invoking COMatePLUS methods without prepared statements if there is need etc.
Procedure ADOmate_SetConnectionStatements(*connection._ADOmateConnection)
  *connection\hStatementIsEOF = COMate_PrepareStatement("EOF")
  *connection\hStatementNextRow = COMate_PrepareStatement("MoveNext")
  *connection\hStatementRetrieve = COMate_PrepareStatement("Fields(" + Str(@*connection\column) + " BYREF)\Value")
EndProcedure
;=================================================================================

CompilerEndIf
; IDE Options = PureBasic 4.60 RC 1 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 47
; FirstLine = 46
; Folding = -------
; EnableUnicode
; EnableThread
; Executable = nxReportU.dll