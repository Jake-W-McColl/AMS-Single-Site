CompilerIf #PB_Compiler_EnableExplicit
  #PDF_ENABLE_EXPLICIT = 1
  EnableExplicit
CompilerElse
  #PDF_ENABLE_EXPLICIT = 0
  EnableExplicit
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  ;   CompilerError "Please run main file"
 CompilerEndIf

#PDF_NEWLINE = Chr(10)
#PDF_FONTSUP = -100
#PDF_FONTSUT = 50

#PDF_FONT_TIMES         = "Times-Roman"
#PDF_FONT_TIMESI        = "Times-Italic"
#PDF_FONT_TIMESB        = "Times-Bold"
#PDF_FONT_TIMESBI       = "Times-BoldItalic"
#PDF_FONT_HELVETICA     = "Helvetica"
#PDF_FONT_HELVETICAB    = "Helvetica-Bold"
#PDF_FONT_HELVETICAI    = "Helvetica-Oblique"
#PDF_FONT_HELVETICABI   = "Helvetica-BoldOblique"
#PDF_FONT_COURIER       = "Courier"
#PDF_FONT_COURIERB      = "Courier-Bold"
#PDF_FONT_COURIERI      = "Courier-Oblique"
#PDF_FONT_COURIERBI     = "Courier-BoldOblique"
#PDF_FONT_SYMBOL        = "Symbol"
#PDF_FONT_ZAPFDINGBATS  = "ZapfDingbats"

#PDF_VER = "2.26"

CompilerIf #PB_Compiler_Version>=430
  CompilerIf #PB_Compiler_Processor=#PB_Processor_x86
  #PUREPDF_VERSION        = "PurePDF v"+#PDF_VER+" For PureBasic X86"
  CompilerElse
  #PUREPDF_VERSION        = "PurePDF v"+#PDF_VER+" For PureBasic X64"
  CompilerEndIf
  Macro m_read
    Read.w vCharWidth
  EndMacro
CompilerElse
  Structure i
    l.l
  EndStructure
  #PB_Long=#Long
  Macro ListSize
    CountList
  EndMacro
  Macro m_read
    Read vCharWidth
  EndMacro
  #PUREPDF_VERSION        = "PurePDF v"+#PDF_VER+" For PureBasic"
CompilerEndIf

CompilerIf #PB_Compiler_OS=#PB_OS_MacOS
  Macro pdf_CallFunction
    CallFunctionFast
  EndMacro
CompilerElse
  Macro pdf_CallFunction
    CallFunctionFast
  EndMacro
CompilerEndIf

CompilerIf Defined(PurePDF_Include,#PB_Constant)
  XIncludeFile "PurePDF_res.pb"
CompilerEndIf

Structure TTF_Header
  sfnt_version.l
  numTables.w
  searchRange.w
  entrySelector.w
  rangeShift.w
EndStructure

Structure TTF_Header_Table
  tag.l
  checkSum.l
  offset.l
  length.l
EndStructure

Structure TTF_head_Header
  version.l
  fontrevision.l
  checkSumAdjustment.l
  magicNumber.l
  flags.w
  unitsPerEm.w
  created.q
  modified.q
  xMin.w
  yMin.w
  xMax.w
  yMax.w
  macStyle.u
  lowestRecPPEM.u
  fontDirectionHint.w
  indexToLocFormat.w
  glyphDataFormat.w
EndStructure

Structure TTF_hhea_Header
  Version.l
  Ascent.w
  Descent.w
  LineGap.w
  AdvanceWidthMax.u
  MinLeftSideBearing.w
  MinRightSideBearing.w
  XMaxExtent.w
  CaretSlopeRise.w
  CaretSlopeRun.w
  CaretOffset.w
  Reserved.w[4]
  MetricDataFormat.w
  NumberOfHMetrics.u
EndStructure

Structure TTF_maxp_Header
  version.l
  numGlyphs.u
  maxPoints.u
  maxContours.u
  maxCompositePoints.u
  maxCompositeContours.u
  maxZones.u
  maxTwilightPoints.u
  maxStorage.u
  maxFunctionDefs.u
  maxInstructionDefs.u
  maxStackElements.u
  maxSizeOfInstructions.u
  maxComponentElements.u
  maxComponentDepth.u
EndStructure

Structure TTF_NameRecord
  platformID.u
  platformSpecificID.u
  languageID.u
  nameID.u
  length.u
  offset.u
EndStructure

Structure TTF_name_Header
  format.u
  count.u
  stringOffset.u
  NameRecord.TTF_NameRecord[0]
EndStructure

CompilerIf Defined(FIXED,#PB_Structure)=0
  Structure FIXED
    fract.w
    Value.w
  EndStructure
CompilerEndIf

Structure TTF_post_Header
  format.FIXED
  italicAngle.FIXED
  underlinePosition.w
  underlineThickness.w
  isFixedPitch.l
  minMemType42.l
  maxMemType42.l
  minMemType1.l
  maxMemType1.l
EndStructure
  
Structure TTF_longhormetric
  advanceWidth.w
  lsb.w
EndStructure

Structure TTF_cmap_Header
  version.w
  numTables.w
EndStructure

Structure TTF_cmap_Header_Table
  platformID.w
  encodingID.w
  offset.l
EndStructure

Structure TTF_cmap_subtable
  format.w
  length.w
  language.w
EndStructure

Structure TTF_cmap_Format_0 Extends TTF_cmap_subtable
  glyphIdArray.a[256]
EndStructure

Structure TTF_cmap_Format_4 Extends TTF_cmap_subtable
  segCountX2.w
  searchRange.w
  entrySelector.w
  rangeShift.w
EndStructure

Structure TTF_Segment
  segment.w[0]
EndStructure

#GF_USED  = 1
#GF_FLOAT = 2
#MAXLEGALWIDTH = 10000
Structure TTF_CharacterMap
  List char_no.i()
  xMin.i
  yMin.i
  xMax.i
  yMax.i
  lsb.i
  ttf_pathlen.i
  Width.w
  flags.w
  ;oldwidth.i
  scaledwidth.i
EndStructure

Structure PDF_ImageStructure
  pMem.i
  MemSize.i
  Pal.MEM_DataStructure
  Datapic.MEM_DataStructure
  N.l
  ImageN.l
  Bpc.l
  x.l
  y.l
  Width.l
  Height.l
  FileName.s
  ColSpace.s
  Parms.s
  Filter.s
  ActualText.s
EndStructure

Structure PDF_FontStructure
  N.l
  FontN.l
  FontEmbed.l ; 1=Font embedding
  unicode.l
  numglyphs.l
  n_hmetrics.l
  indexToLocFormat.l
  unitsPerEm.l
  scale_factor.d
  original_scale_factor.d
  Ascent.l
  Descent.l
  CapHeight.l
  ItalicAngle.l
  StemV.l
  bbox.l[4]
  *cidtogidmap.TTF_Segment
  Array glyph_list.TTF_CharacterMap(0)
  Subfamily$
  Name$
  Style$
  FontKey$
  CharWidth.w[256]
EndStructure

Structure PDF_ObjectStructure
  Buffer.i ; Buffer
  Buflen.i ; Bufferlength
  pdfN.i   ; when ipdf_Put...() is called this is the pointer to the object
  vStyle.i   ; style
  Name$ ; Name of an object
  Desc$ ; Description (optional)
  CreationDate$ ; The date and time when the embedded file was created.
  ModDate$ ; The date and time when the embedded file was last modified.
EndStructure

Structure PDF_PageLinkStructure
  Type.l
  pdfN.l
  Page.l  
  DestPage.l
  fA0.f
  fA1.f
  fA2.f
  fA3.f
  x.f
  y.f
  w.f
  h.f
  Flags.l ; Annotation Flags
  ; Bit positions :
  ; 1 = Invisible
  ; 2 = Hidden
  ; 3 = Print
  ; 4 = NoZoom
  ; 5 = NoRotate
  ; 6 = NoView
  ; 7 = ReadOnly
  ; 8 = Locked
  ; 9 = ToggleNoView
  File.l ; listindex of embedded file
  FilepdfN.l
  Option1$ ; url$ / Filename$  / Text$
  Option2$ ;        Dir$       / Icon$
  Option3$ ;        Action$    / Title$
  Option4$ ;        Parameter$ / DateTime$
  ;Title$ = The text label to be displayed in the title bar of the annotation뭩
  ;         pop-up window when open And active. By convention, this entry identifies
  ;         the user who added the annotation.
  ;DateTime$ = The date and time when the annotation was most recently modified
EndStructure

Structure PDF_TocStructure
  Level.l
  Page.l
  Text$
EndStructure

Structure PDF_OutLineStructure 
  Level.l
  Y.f 
  wPage.l
  lParent.l 
  lLast.l
  lFirst.l 
  lPrev.l
  lNext.l 
  Text$
EndStructure 

Structure PDF_Pagestructure
  PMem.MEM_DataStructure
  OrientationChanges.l
  pdfN.l
  pdfWPt.f
  pdfHPt.f
EndStructure

;Internal function declarations
Declare ipdf_PutBookMarks()
Declare ipdf_PutCatalogBookMark()
Declare ipdf_EndDocBookMark()
Declare ipdf_PutCatalogDisplay()
Declare ipdf_PutJavaScript()
Declare ipdf_PutCatalogJavaScript()
Declare ipdf_SetProcPutResources(ProcAddress)
Declare ipdf_SetProcPutCatalog(ProcAddress)
Declare ipdf_SetProcEndDoc(ProcAddress)
Declare ipdf_SetProcEndPage(ProcAddress)
Declare ipdf_angle_endpage()
Declare ipdf_Transform(p1.f, p2.f, p3.f, p4.f, p5.f, p6.f)
Declare ipdf_ActualText(objlink,text$="")
Global pdfBuffer.MEM_DataStructure
Global pdfState.l
Global pdfPage.l
Global pdfError.l
Global pdfFontSize.f
Global pdfWs.f
Global pdfK.f
Global pdfFontSizePt.l
Global pdfH.f
Global pdfN.l
Global pdfX.f
Global pdfY.f
Global pdfLMargin.f
Global pdfTMargin.f
Global pdfDefOrientation$
Global pdfFontFamily$
Global pdfCurOrientation$
Global pdfWPt.f
Global pdfFwPt.f
Global pdfHPt.f
Global pdfFhPt.f
Global pdfW.f
Global pdfFw.f
Global pdfFh.f
Global pdfPageBreakTrigger.f
Global pdfBMargin.f
Global pdfZoomMode.l
Global pdfLayoutMode$
Global pdfTitle$
Global pdfSubject$
Global pdfAuthor$
Global pdfKeywords$
Global pdfCreator$
Global pdfAliasNbPages$
Global pdfRMargin.f
Global pdfCMargin.f
Global pdfAutoPageBreak.l
Global pdfInFooter.l
Global pdfLasth.f                  
Global pdfFontStyle$
Global pdfUnderline.l
Global pdfDrawColor$
Global pdfFillColor$             
Global pdfTextColor$              
Global pdfColorFlag.l              
Global pdfLineWidth.f
Global pdfNumbering.l
Global pdfNumberingFooter.l
Global pdfNumPageNum.l
Global ASCII85_Width
Global ASCII85_Pos
Global pdfOBJNames
Global pdfMultiCellNewLines

Global pCompress
Global pHeader
Global pFooter
Global pHeaderParamPtr
Global pFooterParamPtr
Global pAcceptPageBreak

Global vLocalDecimal.s
Global vpdfTimeZoneOffset.s

Global pdfOutlineRoot.l
Global pdfDisplayPreferences$
Global pdfJavaScript$
Global pdfJSNum.l

Global pdfAngle.f

;Merge of Mem.pb 9.11.2007 ABBKlaus
#PDF_MEMBLOCKMINSIZE=2048
Procedure MEM_DataInit(*aData.MEM_DataStructure, aSize)
  Protected vReturn,vCurSize,vTmp
  
  ;aSize = (Int(aSize/64000)+1)*64000
  If aSize % #PDF_MEMBLOCKMINSIZE
    aSize=((aSize/#PDF_MEMBLOCKMINSIZE)+1)*#PDF_MEMBLOCKMINSIZE
  EndIf
  
  vReturn = #True
  
  If *aData\pData = 0
    vCurSize = 0
    *aData\pData = AllocateMemory(aSize)
    If *aData\pData = 0
      pdfError = #PDF_ERROR_OUT_OF_MEMORY ; luis
      CallDebugger
      vReturn = #False
    EndIf
  Else
    vCurSize = *aData\lCurSize
    vTmp = ReAllocateMemory(*aData\pData, aSize)
    If vTmp
      *aData\pData = vTmp
    Else
      pdfError = #PDF_ERROR_OUT_OF_MEMORY ; luis
      CallDebugger
      vReturn = #False
    EndIf  
  EndIf
    
  If vReturn = #True
    *aData\lMaxSize = aSize
    *aData\lCurSize = vCurSize
  EndIf  
  
  ProcedureReturn vReturn
EndProcedure

Procedure MEM_DataAdd( *aDest.MEM_DataStructure, *aSource.MEM_DataStructure)
  Protected vSourceSize,vDestSize,vDestMaxSize
  
  vSourceSize    = *aSource\lCursize  
  vDestSize      = *aDest\lCurSize
  vDestMaxSize   = *aDest\lMaxsize  
    
  If vDestMaxSize < (vSourceSize + vDestSize)
    If MEM_DataInit(*aDest, vSourceSize + vDestSize) = #False
      pdfError = #PDF_ERROR_OUT_OF_MEMORY
      CallDebugger
      ProcedureReturn #False      
    EndIf
    *aDest\lCursize = vDestSize
  EndIf
  
  CopyMemory(*aSource\pData, *aDest\pData + vDestSize , vSourceSize)       
  *aDest\lCursize = vSourceSize + vDestSize   
  ProcedureReturn #True
EndProcedure

Procedure MEM_DataAddString(*aData.MEM_DataStructure, aString.s, Mode=#PB_Ascii)  
  Protected vLen,vTmp.MEM_DataStructure,vReturn,*mem
  
  vLen = StringByteLength(aString,Mode)
  Select Mode
    Case #PB_UTF8
      *mem=AllocateMemory(vLen+1)
      If *mem
        PokeS(*mem,aString,vLen,#PB_UTF8)
      EndIf
    Case #PB_Unicode
      *mem=AllocateMemory(vLen+2)
      If *mem
        PokeS(*mem,aString,vLen,Mode)
      EndIf
    Default ; ASCII
      *mem=AllocateMemory(vLen+1)
      If *mem
        PokeS(*mem,aString,vLen,Mode)
      EndIf
  EndSelect
  If *mem
    vTmp\pData = *mem
    vTmp\lCurSize  = vLen
    vTmp\lMaxSize  = vLen
    vReturn = MEM_DataAdd(*aData, vTmp)
    FreeMemory(*mem)
  EndIf
  ProcedureReturn vReturn
EndProcedure

;Constructor
;===========
ProcedureDLL pdf_Init()
  Global NewList Pages.PDF_Pagestructure()
  Global NewList Images.PDF_ImageStructure()
  Global NewList Fonts.PDF_FontStructure()
  Global NewList FontList.PDF_ObjectStructure()
  Global NewList FileList.PDF_ObjectStructure()
  Global NewList Offsets.l() 
  Global NewList PageLinks.PDF_PageLinkStructure()
  Global NewList pEndPage() 
  Global NewList pPutCatalog()
  Global NewList pPutResources()
  Global NewList pEndDoc()
  Global NewList pdfTOC.PDF_TocStructure()
  ;Bookmarks
  Global NewList OutLines.PDF_OutLineStructure()   ;Bookmark variable
  Global NewList Lru.l()                           ;Bookmark variable
  ipdf_SetProcPutResources(@ipdf_PutBookMarks())
  ipdf_SetProcPutResources(@ipdf_PutJavaScript())
  ipdf_SetProcPutCatalog(@ipdf_PutCatalogBookMark())
  ipdf_SetProcPutCatalog(@ipdf_PutCatalogDisplay())
  ipdf_SetProcPutCatalog(@ipdf_PutCatalogJavaScript())
  ipdf_SetProcEndDoc(@ipdf_EndDocBookMark())
  ;Draw
  ipdf_SetProcEndPage(@ipdf_angle_endpage())
EndProcedure

Procedure MEM_DataReplace(*aData.MEM_DataStructure, aSource.s, aDest.s) ; MOVE THIS PROCEDURE TO BE AFTER pdf_Init()
  Protected vSourceLen,vDestLen,vCurSize,vMaxSize,vCount,vFind,*tmp,vReturn,i,j,*vaSource
  Protected vLen,*vaDest,vaDestString,fontU ; Needed for Unicode to ASCII
 ;MEM_DataStructure is ASCII so we have play a bit with footer fonts() is declared in pdf_Init(), plan accordingly
  
  fontU= fonts()\unicode      ; find out if Unicode or ASCII FONT
  vLen = SizeOf(Character)    ; find out if Unicode or ASCII program  
  vSourceLen   = StringByteLength(aSource); changed to StringByteLength for Unicode
  *vaSource    = AllocateMemory(vSourceLen); created a temp buffer for Unicode
  If fontU=0                                
    PokeS(*vaSource,aSource,vSourceLen,#PB_String_NoZero|#PB_Ascii); font is ASCII 
  Else
    PokeS(*vaSource,aSource,vSourceLen,#PB_String_NoZero);saved Unicode string to mem to compare mem not string ;  
  vSourceLen - 1  
  EndIf
  If vlen=1 Or  fontU=0                      
    vSourceLen=(vSourceLen/vlen); ASCII font or ASCII program, resize source
  EndIf  
  
  vDestLen     = StringByteLength(aDest) ; changed to StringByteLength
  If fontU=0 And vlen=2 
    vDestLen=(vDestLen/vlen)+1 ;ASCII font Unicode program
  EndIf
  
  *vaDest=AllocateMemory(vDestLen)
  If fontU=0 
    PokeS(*vaDest,aDest,vDestLen,#PB_Ascii|#PB_String_NoZero) ; ASCII FONT
  Else
    PokeS(*vaDest,aDest,vDestLen,#PB_Unicode|#PB_String_NoZero); Unicode
  EndIf

  vCurSize     = *aData\lCursize  
  vMaxSize     = *aData\lMaxsize  
  vFind        = 0
  vReturn      = #True
  
  If (vDestLen > vSourceLen)
    For i = vCurSize To 0 Step -1
      vCount= 0
      If CompareMemory(*aData\pData + i - vSourceLen,*vaSource,vSourceLen)  
        vFind = vFind + 1  
        Break
      EndIf
    Next
    If (vFind > 0)
      vReturn = MEM_DataInit(*aData, vMaxSize + (vFind*(vDestLen - vSourceLen))) ; = #False
    EndIf  
  EndIf
  
  If vReturn = #True
    *tmp = AllocateMemory((vDestLen + vCurSize) - vSourceLen)
    If *tmp
      For i = vCurSize To 0 Step -1
        If CompareMemory(*aData\pData + i - vSourceLen,*vaSource,vSourceLen)
          CopyMemory(*aData\pData + i, *tmp, *aData\lCurSize - i)
          CopyMemory(*vaDest, *aData\pData + i - vSourceLen  , vDestLen ) ; 
          CopyMemory(*tmp, *aData\pData + (i-fontU) - vSourceLen + vDestLen, *aData\lCurSize - i) ; COPY according to ASCII or UNICODE font
          *aData\lCurSize = *aData\lCurSize + (vDestLen-vSourceLen)
          Break
        EndIf
      Next
      FreeMemory(*tmp)
    Else
      vReturn = #False
    EndIf
  EndIf
  FreeMemory(*vaSource) ; used to search as memory and not string
  FreeMemory(*vaDest)   ; Temp change to ASCII
  ProcedureReturn vReturn
EndProcedure



;Destructor
;==========
ProcedureDLL pdf_End()
  If pdfBuffer\pData
    FreeMemory(pdfBuffer\pData)
  EndIf
  pdfBuffer\pData=0
EndProcedure

;28/12/2006 : define decimal seperator
Procedure.s ipdf_LocalDecimal()
  Protected Buff.s="",cchData,Res,*Buffer
  CompilerIf #PB_Compiler_OS=#PB_OS_Windows
    cchData=GetLocaleInfo_(#LOCALE_USER_DEFAULT, #LOCALE_SDECIMAL, 0, 0)
    If cchData
      *Buffer=AllocateMemory(cchData*SizeOf(Character))
      If *Buffer
        Res=GetLocaleInfo_(#LOCALE_USER_DEFAULT, #LOCALE_SDECIMAL, *Buffer, cchData)
        If Res
          Buff=PeekS(*Buffer,Res)
        EndIf
        FreeMemory(*Buffer)
      EndIf
    EndIf
  CompilerElse ; Workaround for other OS큦 : return Komma
    Buff=","
  CompilerEndIf
  
  ProcedureReturn Buff
EndProcedure

Procedure.s ipdf_StrF(Value.f, NbDecimals)
  Protected vReturn.s
 
  If vLocalDecimal = "."
    vReturn = StrF(Value, NbDecimals)
  Else
    vReturn = ReplaceString(StrF(Value, NbDecimals),vLocalDecimal, ".")
  EndIf
  ProcedureReturn vReturn
EndProcedure

;Thanks to Rescator / skywalk / wilbert for the Procedures EndianW() / EndianL() / EndianQ()
Procedure.l ipdf_EndianL(value.l)
  ; Rescator : http://forums.purebasic.com/english/viewtopic.php?p=84270&sid=7f3f06eae02ad44b303655fb722bb0f0#p84270
  EnableASM
  MOV Eax,value
  BSWAP Eax
  DisableASM
  ProcedureReturn
EndProcedure

CompilerIf #PB_Compiler_Processor=#PB_Processor_x64
  Procedure.q ipdf_EndianQ(value.q)
    ; Rescator : http://www.purebasic.fr/english/viewtopic.php?p=84270#p84270
    EnableASM
    MOV rax, value
    BSWAP rax
    DisableASM
    ProcedureReturn
  EndProcedure
CompilerElse
  Procedure.q ipdf_EndianQ(value.q)
    ; Wilbert : http://www.purebasic.fr/english/viewtopic.php?p=361932#p361932
    Protected addr.l=@value
    EnableASM
    MOV edx, addr
    MOV eax, [edx + 4]
    MOV edx, [edx]
    BSWAP eax
    BSWAP edx
    DisableASM
    ProcedureReturn
  EndProcedure
CompilerEndIf

Procedure.w ipdf_EndianW(value.w)
  ; skywalk/wilbert : http://forums.purebasic.com/english/viewtopic.php?p=352259&sid=7f3f06eae02ad44b303655fb722bb0f0#p352259
  EnableASM
  ROL value, 8
  DisableASM
  ProcedureReturn value
EndProcedure

Procedure.s HexView(*Memory,flags) ; only used to debug memory locations
  Protected String.s
  Select flags
    Case #PB_Byte ; 0
      String="$"+RSet(Hex(PeekB(*Memory),#PB_Byte),2,"0")
    Case #PB_Word ; 1
      String="$"+RSet(Hex(PeekW(*Memory),#PB_Word),4,"0")
    Case #PB_Long ; 2
      String="$"+RSet(Hex(PeekL(*Memory),#PB_Long),8,"0")
    Case $102 ; #PB_Integer is the same as #PB_Long ! we have to created something unique ;-)
      CompilerIf #PB_Compiler_Processor=#PB_Processor_x64
        String="$"+RSet(Hex(PeekI(*Memory),#PB_Long),16,"0")
      CompilerElse
        String="$"+RSet(Hex(PeekI(*Memory),#PB_Quad),8,"0")
      CompilerEndIf
    Case #PB_Float ; 3
      String="$"+RSet(Hex(PeekI(*Memory),#PB_Long),16,"0")
    Case #PB_Quad ; 4
      String="$"+RSet(Hex(PeekQ(*Memory)),16,"0")
    Case #PB_String ; 5
    Case #PB_Double ; 6
      String="$"+RSet(Hex(PeekQ(*Memory)),16,"0")
    Case #PB_Character ; 7
      String="$"+RSet(Hex(PeekC(*Memory)),2*SizeOf(Character),"0")
    Case #PB_Ascii ; 8
      String="$"+RSet(Hex(PeekA(*Memory),#PB_Ascii),2,"0")
    Case #PB_Unicode ; 9
      String="$"+RSet(Hex(PeekU(*Memory),#PB_Unicode),4,"0")
  EndSelect
  ProcedureReturn String
EndProcedure

Procedure.s HexViewEndian(*Memory,flags) ; only used to debug memory locations
  Protected String.s
  Select flags
    Case #PB_Byte
      String="$"+RSet(Hex(PeekB(*Memory)),2,"0")
    Case #PB_Word
      String="$"+RSet(Hex(ipdf_EndianW(PeekW(*Memory)),#PB_Word),4,"0")
    Case #PB_Long
      String="$"+RSet(Hex(ipdf_EndianL(PeekL(*Memory)),#PB_Long),8,"0")
    Case #PB_Integer
      CompilerIf #PB_Compiler_Processor=#PB_Processor_x64
        String="$"+RSet(Hex(ipdf_EndianQ(PeekI(*Memory)),#PB_Integer),16,"0")
      CompilerElse
        String="$"+RSet(Hex(ipdf_EndianL(PeekL(*Memory)),#PB_Long),8,"0")
      CompilerEndIf
    Case #PB_Quad
      String="$"+RSet(Hex(ipdf_EndianQ(PeekQ(*Memory)),#PB_Quad),16,"0")
  EndSelect
  ProcedureReturn String
EndProcedure

Procedure ipdf_TTF_CalcTableChecksum(*Table,Length.l)
  Protected Sum.l
  Protected *Endptr = *Table+Length
  While (*Table < *EndPtr)
    Sum+(ipdf_EndianL(PeekL(*Table)))
    *Table+4
  Wend
  ProcedureReturn Sum
EndProcedure

Procedure ipdf_Handle_MS_Encoding(Array glyph_list.TTF_CharacterMap(1),cmap_n_segs,*cmap_seg_start.TTF_Segment,*cmap_seg_end.TTF_Segment,*cmap_idDelta.TTF_Segment,*cmap_idRangeOffset.TTF_Segment,*cmap_glyphIndexArray.TTF_Segment,nglyphs,Buffer,Buflen)
  Protected j, k, kk, set_ok, *glyphIndexAddress.TTF_Segment
  Protected s_start.u,s_end.u,ro.u,delta.w,n.u
  
  For j=0 To (cmap_n_segs-1)
    s_start=ipdf_EndianW(*cmap_seg_start\segment[j])&$FFFF
    s_end=ipdf_EndianW(*cmap_seg_end\segment[j])&$FFFF
    delta=ipdf_EndianW(*cmap_idDelta\segment[j])
    ro=ipdf_EndianW(*cmap_idRangeOffset\segment[j])&$FFFF
    
    ;Debug "j="+Str(j)+" s_start="+StrU(s_start,#PB_Unicode)+" s_end="+StrU(s_end,#PB_Unicode)
    
    For k = s_start To s_end
      If (ro=0)
        n=k+delta
      Else
        ;If ro>=nglyphs
        ;  Debug "Font contains a broken glyph code mapping, ignored"
        ;  Continue
        ;EndIf
        *glyphIndexAddress = (ro + 2 * (k - s_start) + @*cmap_idRangeOffset\segment[j])
        If delta<>0
          n+delta
          Debug "rangeoffset and delta both non-zero"
          CallDebugger
        EndIf
        If (*glyphIndexAddress >= Buffer) And *glyphIndexAddress =< (Buffer+Buflen-1)
          n=ipdf_EndianW(*glyphIndexAddress\segment[0])&$FFFF
        Else
          Debug "*glyphIndexAddress out of range error"
          CallDebugger
        EndIf
      EndIf
      If n<0 Or n>=nglyphs
        Debug "Font contains a broken glyph code mapping, ignored"
        CallDebugger
        Continue
      EndIf
      If n<>0
        AddElement(glyph_list(n)\char_no())
        glyph_list(n)\char_no()=k
      Else
        ; missing glyph
        ;Debug Str(j)+","+Str(k)+","+Str(n)
      EndIf
    Next
  Next
EndProcedure

Procedure ipdf_Handle_MAC_Encoding(Array glyph_list.TTF_CharacterMap(1),*subtable_F0.TTF_cmap_Format_0,Buffer,Buflen)
  Protected i,j,n,size.i=ipdf_EndianW(*subtable_F0\length)-6
  
  For j=0 To size-1
    n=*subtable_F0\glyphIdArray[j]
    ;If n=0; Or n=1
    ;  Continue
    ;EndIf
    AddElement(glyph_list(n)\char_no())
    glyph_list(n)\char_no()=j
  Next
EndProcedure

Procedure.i ipdf_TTF_SearchTagName(*TTF_Memory.TTF_Header,TagName.s)
  Protected Version,numTables,searchRange,entrySelector,rangeShift
  Protected *OffsetTable.TTF_Header_Table
  Protected tag.s,checkSum.l,offset.l,Tlength.l
  
  If *TTF_Memory
    Version       = ipdf_EndianL(*TTF_Memory\sfnt_version)
    numTables     = ipdf_EndianW(*TTF_Memory\numTables)
    searchRange   = ipdf_EndianW(*TTF_Memory\searchRange)
    entrySelector = ipdf_EndianW(*TTF_Memory\entrySelector)
    rangeShift    = ipdf_EndianW(*TTF_Memory\rangeShift)
    If Version = $10000 ; 0x00010000 for version 1.0 / can be 'true' or 'typ1' on Apple Systems
      *OffsetTable=*TTF_Memory+SizeOf(TTF_Header)
      While numTables>0
        tag      = PeekS(@*OffsetTable\tag,4,#PB_Ascii)
        checkSum = ipdf_EndianL(*OffsetTable\checkSum)
        offset   = ipdf_EndianL(*OffsetTable\offset)
        Tlength  = ipdf_EndianL(*OffsetTable\length)
        ;Debug "tag="+tag
        ;Debug "checkSum="+Hex(checkSum,#PB_Long)
        ;Debug "offset="+Hex(offset,#PB_Long)
        ;Debug "Tlength="+Hex(Tlength,#PB_Long)
        ;Calc.l      = ipdf_TTF_CalcTableChecksum(*TTF_Memory+offset,Tlength)
        ;Debug "Calc="+Hex(Calc,#PB_Long)
        ;If checkSum <> Calc
        ;  Debug Hex(checkSum,#PB_Long) + "<>" + Hex(Calc,#PB_Long)
        ;EndIf
        If tag = TagName
          ProcedureReturn *TTF_Memory+offset
        EndIf
        *OffsetTable+SizeOf(TTF_Header_Table)
        numTables-1
      Wend
    EndIf
  EndIf
EndProcedure

Procedure.i ipdf_TTF_Searchcmap(Array glyph_list.TTF_CharacterMap(1),*cmap.TTF_cmap_Header,nglyphs,Buffer,Buflen,platform=-1,encoding=-1,format=-1)
  Protected cmap_Version,cmap_numTables,i
  Protected *cmap_Table_Header.TTF_cmap_Header_Table,*subtable.TTF_cmap_subtable,*subtable_F0.TTF_cmap_Format_0
  Protected *subtable_F4.TTF_cmap_Format_4,*ptr.Word
  Protected platformID,encodingID,formatID,cmapoffset,formatF0,formatF0_length,formatF0_language
  Protected formatF4,formatF4_length,formatF4_language,formatF4_segCountX2,formatF4_segCount,formatF4_searchRange
  Protected formatF4_entrySelector,formatF4_rangeShift
  Protected cmap_seg_end,cmap_seg_start,cmap_idDelta,cmap_idRangeOffset,cmap_glyphIndexArray
  
  If *cmap
    cmap_Version   = ipdf_EndianW(*cmap\version)
    cmap_numTables = ipdf_EndianW(*cmap\numTables)
    ;Debug "cmap_Version="+Hex(cmap_Version,#PB_Word)
    ;Debug "cmap_numTables="+Hex(cmap_numTables,#PB_Word)
    *cmap_Table_Header=*cmap+SizeOf(TTF_cmap_Header)
    While cmap_numTables>0
      platformID   = ipdf_EndianW(*cmap_Table_Header\platformID)
      encodingID   = ipdf_EndianW(*cmap_Table_Header\encodingID)
      cmapoffset   = ipdf_EndianL(*cmap_Table_Header\offset)
      *subtable=*cmap+cmapoffset
      formatID     = ipdf_EndianW(*subtable\format)
      ;Debug "platformID="+Hex(platformID,#PB_Word)
      ;Debug "encodingID="+Hex(encodingID,#PB_Word)
      ;Debug "cmapoffset="+Hex(cmapoffset,#PB_Long)
      ;Debug "formatID="+Hex(format,#PB_Word)
      Select platformID
        Case 1
          ;Debug "platformID=Macintosh"
        Case 3
          ;Debug "platformID=Windows"
      EndSelect
      Select encodingID
        Case 0
          ;Debug "encodingID=Symbol"
        Case 1
          ;Debug "encodingID=Unicode BMP (UCS-2)"
        Case 2
          ;Debug "encodingID=ShiftJIS"
        Case 3
          ;Debug "encodingID=PRC"
        Case 4
          ;Debug "encodingID=Big5"
        Case 5
          ;Debug "encodingID=Wansung"
        Case 6
          ;Debug "encodingID=Johab"
        Case 7,8,9
          ;Debug "encodingID=Reserved"
        Case 10
          ;Debug "encodingID=Unicode UCS-4"
      EndSelect
      If platform<>-1 And (platform<>platformID)
        *cmap_Table_Header+SizeOf(TTF_cmap_Header_Table)
        cmap_numTables-1
        Continue
      EndIf
      If encoding<>-1 And (encoding<>encodingID)
        *cmap_Table_Header+SizeOf(TTF_cmap_Header_Table)
        cmap_numTables-1
        Continue
      EndIf
      If format<>-1 And (format<>formatID)
        *cmap_Table_Header+SizeOf(TTF_cmap_Header_Table)
        cmap_numTables-1
        Continue
      EndIf
      Select formatID
        Case 0 ; Format 0: Byte encoding table
          ;Debug "Format 0: Byte encoding table"
          *subtable_F0=*subtable
          formatF0=ipdf_Endianw(*subtable_F0\format)
          formatF0_length=ipdf_EndianW(*subtable_F0\length)
          formatF0_language=ipdf_EndianW(*subtable_F0\language)
          ;Debug "formatF0="+Hex(formatF0,#PB_Word)
          ;Debug "formatF0_length="+Hex(formatF0_length,#PB_Word)
          ;Debug "formatF0_language="+Hex(formatF0_language,#PB_Word)
          ipdf_Handle_MAC_Encoding(glyph_list(),*subtable_F0,Buffer,Buflen)
          ProcedureReturn #True
        Case 4 ; Format 4: Segment mapping to delta values
          ;Debug "Format 4: Segment mapping to delta values"
          *subtable_F4=*subtable
          formatF4=ipdf_Endianw(*subtable_F4\format)
          formatF4_length=ipdf_EndianW(*subtable_F4\length)
          formatF4_language=ipdf_EndianW(*subtable_F4\language)
          formatF4_segCountX2=ipdf_EndianW(*subtable_F4\segCountX2)
          formatF4_segCount=formatF4_segCountX2>>1
          formatF4_searchRange=ipdf_EndianW(*subtable_F4\searchRange)
          formatF4_entrySelector=ipdf_EndianW(*subtable_F4\entrySelector)
          formatF4_rangeShift=ipdf_EndianW(*subtable_F4\rangeShift)
          ;Debug "formatF4="+Hex(formatF4,#PB_Word)
          ;Debug "formatF4_length="+Hex(formatF4_length,#PB_Word)
          ;Debug "formatF4_language="+Hex(formatF4_language,#PB_Word)
          ;Debug "formatF4_segCountX2="+Hex(formatF4_segCountX2,#PB_Word)
          ;Debug "formatF4_searchRange="+Hex(formatF4_searchRange,#PB_Word)
          ;Debug "formatF4_entrySelector="+Hex(formatF4_entrySelector,#PB_Word)
          ;Debug "formatF4_rangeShift="+Hex(formatF4_rangeShift,#PB_Word)
          *ptr=*subtable+SizeOf(TTF_cmap_Format_4)
          cmap_seg_end=*ptr
          cmap_seg_start=*ptr+formatF4_segCountX2+2
          cmap_idDelta=*ptr+((formatF4_segCountX2*2)+2)
          cmap_idRangeOffset=*ptr+((formatF4_segCountX2*3)+2)
          cmap_glyphIndexArray=*ptr+((formatF4_segCountX2*4)+2)
          ;Debug "cmap_seg_end="+Hex(ipdf_EndianW(PeekW(cmap_seg_end)),#PB_Word)
          ;Debug "cmap_seg_start="+Hex(ipdf_EndianW(PeekW(cmap_seg_start)),#PB_Word)
          ;Debug "cmap_idDelta="+Hex(ipdf_EndianW(PeekW(cmap_idDelta)),#PB_Word)
          ;Debug "cmap_idRangeOffset="+Hex(ipdf_EndianW(PeekW(cmap_idRangeOffset)),#PB_Word)
          ipdf_Handle_MS_Encoding(glyph_list(),formatF4_segCount,cmap_seg_start,cmap_seg_end,cmap_idDelta,cmap_idRangeOffset,cmap_glyphIndexArray,nglyphs,Buffer,Buflen)
          ProcedureReturn #True
      EndSelect
      *cmap_Table_Header+SizeOf(TTF_cmap_Header_Table)
      cmap_numTables-1
    Wend
  EndIf
EndProcedure

Procedure.l ipdf_TTF_Create_cidtogidmap(Array glyph_list.TTF_CharacterMap(1))
  Protected *cidtogidmap.TTF_Segment,cidtogidmapSize=256*256*2,nsize=ArraySize(glyph_list()),i
  ;-* cidtogidmax
  If nsize
    *cidtogidmap=AllocateMemory(cidtogidmapSize)
    If *cidtogidmap
      For i=0 To nsize
        ForEach glyph_list(i)\char_no()
          If glyph_list(i)\char_no()>=0 And glyph_list(i)\char_no()<$FFFF
            ;Debug "i="+Str(i)+" / Char="+Str(glyph_list(i)\char_no())
            *cidtogidmap\segment[glyph_list(i)\char_no()]=ipdf_EndianW(i)&$FFFF
          EndIf
        Next
      Next
      CompilerIf #PB_Compiler_Debugger
;       If CreateFile(1,"cidtogidmap.txt")
;         WriteData(1,*cidtogidmap,cidtogidmapSize)
;         CloseFile(1)
;       EndIf
;       CallDebugger
      CompilerEndIf
    EndIf
  EndIf
  ProcedureReturn *cidtogidmap
EndProcedure

Procedure.i ipdf_TTF_iscale(unitsPerEm.l,val.i)
  Protected res.i
  If val>0
    ProcedureReturn Int((1000/unitsPerEm) * val + 0.5)
  Else
    ProcedureReturn Int((1000/unitsPerEm) * val - 0.5)
  EndIf
EndProcedure

Procedure.l ipdf_TTF_Handle_Head(List Fonts.PDF_FontStructure(),*Head.TTF_head_Header)
  Protected indexToLocFormat,unitsPerEm
  If *Head
    ;Debug "version="+HexViewEndian(@*head\version,#PB_Long)
    ;Debug "fontrevision="+HexViewEndian(@*head\fontrevision,#PB_Long)
    ;Debug "checkSumAdjustment="+HexViewEndian(@*head\checkSumAdjustment,#PB_Long)
    ;Debug "magicNumber="+HexViewEndian(@*head\magicNumber,#PB_Long)
    ;Debug "flags="+HexViewEndian(@*head\flags,#PB_Word)
    ;Debug "unitsPerEm="+StrU(ipdf_EndianW(*head\unitsPerEm),#PB_Word)
    ;Debug "created="+HexViewEndian(@*head\created,#PB_Quad)
    ;Debug "modified="+HexViewEndian(@*head\modified,#PB_Quad)
    ;Debug "xMin="+Str(ipdf_EndianW(*head\xMin))
    ;Debug "yMin="+Str(ipdf_EndianW(*head\yMin))
    ;Debug "xMax="+Str(ipdf_EndianW(*head\xMax))
    ;Debug "yMax="+Str(ipdf_EndianW(*head\yMax))
    ;Debug "macStyle="+HexViewEndian(@*head\macStyle,#PB_Word)
    ;Debug "lowestRecPPEM="+HexViewEndian(@*head\lowestRecPPEM,#PB_Word)
    ;Debug "fontDirectionHint="+HexViewEndian(@*head\fontDirectionHint,#PB_Word)
    ;Debug "indexToLocFormat="+HexViewEndian(@*head\indexToLocFormat,#PB_Word)
    ;Debug "glyphDataFormat="+HexViewEndian(@*head\glyphDataFormat,#PB_Word)
    Fonts()\indexToLocFormat = ipdf_EndianW(*Head\indexToLocFormat)
    Fonts()\unitsPerEm       = ipdf_EndianW(*head\unitsPerEm)&$FFFF
    If  Fonts()\unitsPerEm = 0 : Fonts()\unitsPerEm = 100 : EndIf ;/ PJ fix for crash on zero value...
      Fonts()\scale_factor     = 1000 / Fonts()\unitsPerEm
    
    Fonts()\bbox[0]          = ipdf_TTF_iscale(Fonts()\unitsPerEm,ipdf_EndianW(*head\xMin))
    Fonts()\bbox[1]          = ipdf_TTF_iscale(Fonts()\unitsPerEm,ipdf_EndianW(*head\yMin))
    Fonts()\bbox[2]          = ipdf_TTF_iscale(Fonts()\unitsPerEm,ipdf_EndianW(*head\xMax))
    Fonts()\bbox[3]          = ipdf_TTF_iscale(Fonts()\unitsPerEm,ipdf_EndianW(*head\yMax))
    If Fonts()\indexToLocFormat=0 Or Fonts()\indexToLocFormat=1
      ProcedureReturn #True
    EndIf
  EndIf
EndProcedure

Procedure.i ipdf_TTF_Searchhmtx(List Fonts.PDF_FontStructure(),*hmtx.TTF_longhormetric)
  Protected *hmtx_entry.TTF_longhormetric,*lsblist.TTF_Segment,i
  
  *hmtx_entry=*hmtx
  For i=0 To Fonts()\n_hmetrics-1
    Fonts()\glyph_list(i)\Width=ipdf_EndianW(*hmtx_entry\advanceWidth)
    Fonts()\glyph_list(i)\lsb=ipdf_EndianW(*hmtx_entry\lsb)
    *hmtx_entry+SizeOf(TTF_longhormetric)
  Next
  *lsblist=*hmtx_entry
  *hmtx_entry-SizeOf(TTF_longhormetric)
  For i=Fonts()\n_hmetrics To Fonts()\numglyphs-1
    Fonts()\glyph_list(i)\Width=ipdf_EndianW(*hmtx_entry\advanceWidth)
    Fonts()\glyph_list(i)\lsb=ipdf_EndianW(*lsblist\segment[i-Fonts()\n_hmetrics])
  Next
  For i=0 To Fonts()\numglyphs-1
    If Fonts()\glyph_list(i)\Width>0
      Fonts()\glyph_list(i)\scaledwidth=ipdf_TTF_iscale(Fonts()\unitsPerEm,Fonts()\glyph_list(i)\Width)
    EndIf
    ;glyph_list(i)\xMin=
    ;glyph_list(i)\xMax=
    ;glyph_list(i)\yMin=
    ;glyph_list(i)\yMax=
  Next
EndProcedure

Procedure.s ipdf_TTF_Handle_Name(List Fonts.PDF_FontStructure(),*name.TTF_name_Header,PID,PSID,LID,NID)
  Protected count=ipdf_EndianW(*name\count)&$FFFF
  Protected stringOffset=*name+ipdf_EndianW(*name\stringOffset)&$FFFF
  Protected platformID,platformSpecificID,languageID,nameID,offset,length
  Protected i,j,name$,res$
  
  ;Debug "count="+Str(count)
  If count>0
    For i=0 To count-1
      platformID=ipdf_EndianW(*name\NameRecord[i]\platformID)&$FFFF
      platformSpecificID=ipdf_EndianW(*name\NameRecord[i]\platformSpecificID)&$FFFF
      languageID=ipdf_EndianW(*name\NameRecord[i]\languageID)&$FFFF
      nameID=ipdf_EndianW(*name\NameRecord[i]\nameID)&$FFFF
      offset=ipdf_EndianW(*name\NameRecord[i]\offset)&$FFFF
      length=ipdf_EndianW(*name\NameRecord[i]\length)&$FFFF
      ;Debug "platformID="+Str(platformID)
      ;Debug "platformSpecificID="+Str(platformSpecificID)
      ;Debug "languageID="+Str(languageID)
      ;Debug "nameID="+Str(nameID)
      ;Debug "offset="+Str(offset)
      ;Debug "length="+Str(length)
      If length>0
        If platformID=3
          name$=""
          For j=0 To Int(length/2)-1
            name$+Chr(ipdf_EndianW(PeekU(stringOffset+offset+2*j))&$FFFF)
          Next
        Else
          name$=PeekS(stringOffset+offset,length,#PB_Ascii)
        EndIf
        ;Debug "ipdf_TTF_Handle_Name:["+Str(Len(name$))+"]"+name$
        ;CallDebugger
      Else
        Debug length
        CallDebugger
      EndIf
      If PID=platformID And PSID=platformSpecificID And LID=languageID And NID=nameID
        res$=name$
        Break
      EndIf
    Next
  EndIf
  ProcedureReturn res$
EndProcedure

; Procedure.l ipdf_Get_CharWidth(hDC,*Buffer,*Bufferlen)
;   Protected Len1,Len2,Mem1,Mem2,i
;   
;   CompilerIf #PB_Compiler_OS=#PB_OS_Windows
;     ;http://msdn.microsoft.com/library/en-us/gdi/fontext_8icz.asp
;     
;     ;BOOL GetCharABCWidths(
;     ;  HDC hdc,         // handle To DC
;     ;  UINT uFirstChar, // first character in range
;     ;  UINT uLastChar,  // last character in range
;     ;  LPABC lpabc      // array of character widths
;     ;);
;     If *Buffer=0 Or *Bufferlen=0
;       ProcedureReturn #False
;     EndIf
;     
;     Len1=256*12
;     Len2=256*2
;     Mem1=AllocateMemory(Len1)
;     Mem2=AllocateMemory(Len2)
;     
;     If Mem1>0 And Mem2>0 And GetCharABCWidths_(hDC,0,255,Mem1)
;       ;Debug "GetCharABCWidths_ Success"
;       For i=0 To 255
;         PokeW(Mem2+(i*2),(PeekL(Mem1+((i*12)+0))+PeekL(Mem1+((i*12)+4))+PeekL(Mem1+((i*12)+8)))&$FFFF)
;       Next
;       
;       PokeL(*Buffer,Mem2)
;       PokeL(*Bufferlen,Len2)
;       
;       FreeMemory(Mem1)
;       
;       ProcedureReturn #True
;     Else
;       Debug "GetCharABCWidths_() Failed"
;     EndIf
;   CompilerElse
;     ; Place other OS큦 code here
;     ProcedureReturn #False
;   CompilerEndIf
; EndProcedure

Procedure.l ipdf_Get_Font(hDC,*Buffer,*Bufferlen)
  Protected Len,Mem
  
  CompilerIf #PB_Compiler_OS=#PB_OS_Windows
    ;http://msdn.microsoft.com/library/en-us/gdi/fontext_8d7l.asp
    
    ;DWORD GetFontData(
    ;  HDC hdc,           // handle To DC
    ;  DWORD dwTable,     // metric table name
    ;  DWORD dwOffset,    // offset into table
    ;  LPVOID lpvBuffer,  // buffer For returned Data
    ;  DWORD cbData       // length of Data
    ;);
    If *Buffer=0 Or *Bufferlen=0
      ProcedureReturn #False
    EndIf
    
    Len=GetFontData_(hDC,0,0,#Null,#Null)
    If Len=#GDI_ERROR Or Len=-1
      Debug "GDI_ERROR"
      CallDebugger
    Else
      ;Debug Str(Len)+" Bytes needed for FontData"
      Mem=AllocateMemory(Len)
      If Mem And GetFontData_(hDC,0,0,Mem,Len)<>#GDI_ERROR
        ;Debug "GetFontData Success"
        PokeL(*Buffer,Mem)
        PokeL(*Bufferlen,Len)
        ProcedureReturn #True
      EndIf
    EndIf
  CompilerElse
    ; Place other OS큦 code here
    ProcedureReturn #False
  CompilerEndIf
EndProcedure

Procedure ipdf_ASCII85_Tuple(*NewData.MEM_DataStructure,Tuple.q,Count.l)
  Protected i,j
  Protected Dim buf(4)
  
  ;Debug "ASCII85_Tuple()"
  
  buf(0)=Tuple%85:Tuple/85
  buf(1)=Tuple%85:Tuple/85
  buf(2)=Tuple%85:Tuple/85
  buf(3)=Tuple%85:Tuple/85
  buf(4)=Tuple%85:Tuple/85
  
  i=Count
  j=0
  Repeat
    PokeB(*NewData\pData+*NewData\lCurSize,buf(4-j)+33)
    *NewData\lCurSize+1
    ;Result$+Chr(buf(4-j)+33)
    ASCII85_Pos+1
    If ASCII85_Width And ASCII85_Pos>=ASCII85_Width
      PokeB(*NewData\pData+*NewData\lCurSize,#LF)
      *NewData\lCurSize+1
      ;Result$+#LF$
      ASCII85_Pos=0
    EndIf
    If i>0
      i-1
      j+1
    Else
      Break
    EndIf
  ForEver
EndProcedure

Procedure.l ipdf_ASCII85_Encode(*aData.MEM_DataStructure,WidthP.l=73)
  Protected NewData.MEM_DataStructure,Count,Tuple.q,i,c.l
  
  ASCII85_Width=WidthP
  ASCII85_Pos=0
  
  If *aData\pData=0 Or *aData\lCurSize=0
    ProcedureReturn 0
  EndIf
  
  NewData\lCurSize=0
  NewData\lMaxSize=(*aData\lCurSize * 4)
  NewData\pData=AllocateMemory(NewData\lMaxSize)
  
  ;EncodedData$="<~"
  ;PokeB(NewData\pData+NewData\lCurSize,'<')
  ;NewData\lCurSize+1
  ;ASCII85_Pos+1
  ;PokeB(NewData\pData+NewData\lCurSize,'~')
  ;NewData\lCurSize+1
  ;ASCII85_Pos+1
  
  For i=0 To *aData\lCurSize-1
    c=PeekB(*aData\pData+i) & $FF
    
    Select Count
      Case 0
        Tuple|(c<<24)
        Count+1
      Case 1
        Tuple|(c<<16)
        Count+1
      Case 2
        Tuple|(c<<8)
        Count+1
      Case 3
        Tuple|c
        Count+1
        If Tuple=0
          PokeB(NewData\pData+NewData\lCurSize,122)
          NewData\lCurSize+1
          ;EncodedData$+"z"
          ASCII85_Pos+1
          ;Debug "---------z------------"
          If ASCII85_Width And ASCII85_Pos>=ASCII85_Width
            ASCII85_Pos=0
            PokeB(NewData\pData+NewData\lCurSize,#LF)
            NewData\lCurSize+1
            ;EncodedData$+#LF$
          EndIf
        Else
          ipdf_ASCII85_Tuple(NewData,Tuple,Count)
          ;EncodedData$+ipdf_ASCII85_Tuple(Tuple,Count)
        EndIf
        Tuple=0
        Count=0
    EndSelect
  Next
  If Count>0
    ipdf_ASCII85_Tuple(NewData,Tuple,Count)
    ;EncodedData$+ipdf_ASCII85_Tuple(Tuple,Count)
  EndIf
  
  If ASCII85_Width And ASCII85_Pos+2>ASCII85_Width
    PokeB(NewData\pData+NewData\lCurSize,#LF)
    NewData\lCurSize+1
    ;EncodedData$+#LF$
  EndIf
  
  PokeB(NewData\pData+NewData\lCurSize,126)
  NewData\lCurSize+1
  PokeB(NewData\pData+NewData\lCurSize,62)
  NewData\lCurSize+1
  ;EncodedData$+"~>"
  
  FreeMemory(*aData\pData)
  *aData\pData=NewData\pData
  *aData\lCurSize=NewData\lCurSize
  *aData\lMaxSize=NewData\lMaxSize
  
  ;ProcedureReturn EncodedData$
  ProcedureReturn #True
EndProcedure

Procedure ipdf_ASCII85_Free(*aData.MEM_DataStructure)
  If *aData And *aData\pData
    FreeMemory(*aData\pData)
    *aData\pData=0
  EndIf
EndProcedure

Procedure.l ipdf_ASCII85_Decode(*InputBuffer,InputLength,*OutputBuffer,*OutputLength)
  Protected tuple.q,c.l,count.l,err.l,*IPos,*OPos,i.l
  Protected Dim pow85.q(4)
  
  pow85(0)=85*85*85*85
  pow85(1)=85*85*85
  pow85(2)=85*85
  pow85(3)=85 
  pow85(4)=1
  
  *IPos=*InputBuffer
  *OPos=*OutputBuffer
  
  Repeat
    If (*IPos) >= (*IPos+InputLength)
      err=-4
      Break ; end reached !
    EndIf
    c=PeekB(*IPos) & $FF
    *IPos+1
    Select c
      Case 'z'
        If count<>0
          err=-1 ; z inside ascii85 5-tuple
          Break
        EndIf
        PokeL(*OPos,0)
        *OPos+4
      Case '~'
        If PeekB(*IPos)='>'
          If count
            count-1
            tuple+pow85(count)
            For i=0 To count-1
              PokeB(*OPos,PeekB(@tuple+3-i))
              *OPos+1
            Next
          EndIf
          PokeL(*OutputLength,*OPos-*OutputBuffer)
          Break ; Finished decoding !
        Else
          err=-2
          Break ; ~ without > in ascii85 section
        EndIf
      Case 0,8,9,10,11,12,13,177
        
      Default
        If c<'!' Or c>'u'
          err=-3 ; bad character in ascii85 region
          Break
        EndIf
        tuple+(c-'!')*pow85(count)
        ;Debug Str(count)+" "+Str(c)
        count+1
        If count=5
          PokeB(*OPos+0,PeekB(@tuple+3))
          PokeB(*OPos+1,PeekB(@tuple+2))
          PokeB(*OPos+2,PeekB(@tuple+1))
          PokeB(*OPos+3,PeekB(@tuple+0))
          *OPos+4
          count=0
          tuple=0
        EndIf
    EndSelect
    
  ForEver
  
  ProcedureReturn err
EndProcedure

Procedure.f ipdf_GetFontSize()
  ProcedureReturn pdfFontSize
EndProcedure

Procedure ipdf_GetNumberingFooter()
  ProcedureReturn pdfNumberingFooter
EndProcedure

Procedure ipdf_SetNumberingFooter(Value.l)
  pdfNumberingFooter = Value
EndProcedure

Procedure ipdf_GetNumbering()
  ProcedureReturn pdfNumbering
EndProcedure

Procedure.f ipdf_GetCMargin() ;Get cell margin.
  ProcedureReturn pdfCMargin
EndProcedure

Procedure.f ipdf_GetRMargin() ;Get right margin.
  ProcedureReturn pdfRMargin
EndProcedure

Procedure.f ipdf_GetLMargin() ;Get left margin.
  ProcedureReturn pdfLMargin
EndProcedure

Procedure.f ipdf_GetWs() ;Get word spacing. 
  ProcedureReturn pdfWs
EndProcedure

Procedure ipdf_SetWs(WordSpacing.f) ;Set word spacing. 
  pdfWs = WordSpacing
EndProcedure

Procedure.f ipdf_GetW() ;Get current width of page. 
  ProcedureReturn pdfW
EndProcedure

Procedure.f ipdf_GetH() ;Get current height of page.
  ProcedureReturn pdfH
EndProcedure

Procedure.f ipdf_GetK() ;Get scale factor.
  ProcedureReturn pdfK
EndProcedure

Procedure.l ipdf_GetN() ;Get object number
  ProcedureReturn pdfN
EndProcedure

Procedure.l ipdf_GetFontSizePt()
  ProcedureReturn pdfFontSizePt
EndProcedure

Procedure ipdf_Out(String$) ;Add a line to the document.
  If pdfState = 2
    SelectElement(Pages(), pdfPage - 1)
    MEM_DataAddString(Pages()\PMem, String$ + #PDF_NEWLINE)
  Else
    MEM_DataAddString(pdfBuffer, String$ + #PDF_NEWLINE)
  EndIf  
EndProcedure

Procedure ipdf_OutStream(*aData.MEM_DataStructure)
  If pdfState = 2
    SelectElement(Pages(), pdfPage - 1)    
    MEM_DataAdd(Pages()\PMem, *aData)  
  Else
    MEM_DataAdd(pdfBuffer, *aData)
  EndIf
  ipdf_Out("")
EndProcedure 

Procedure ipdf_PutStream(*aData.MEM_DataStructure)
  ipdf_Out("stream") 
  ipdf_OutStream(*aData) 
  ipdf_Out("endstream") 
EndProcedure 

Procedure.s ipdf_Dec2Oct(n.l) 
  ; http://www.purebasic.fr/german/viewtopic.php?t=384&highlight=dec2oct
  ; made by F. Weil
  ; modified by ABBKlaus
  Protected Res.l
  Protected R8.l
  Protected OUT.s
  OUT = ""
  While n > 0
    R8 = n >> 3 
    Res = R8 << 3 
    OUT = Str(n - Res) + OUT 
    n = R8 
  Wend 
  If OUT = "" 
    OUT = "0" 
  EndIf
  
  ProcedureReturn OUT 
EndProcedure 

Procedure.s ipdf_Escape(String$) ;Add \ before (, ) And \.
  Protected Char.c,Result$,i
  
  Result$=""
  
  For i=1 To Len(String$)
    Char=Asc(Mid(String$,i,1))
    Select Char
      Case 8 ; BS
        Result$+"\b"
      Case 9 ; TAB
        Result$+"\t"
      Case 10 ; LF
        Result$+"\n"
      Case 12 ; FF
        Result$+"\f"
      Case 13 ; CR
        Result$+"\r"
      Case '\'
        Result$+"\\"
      Case '('
        Result$+"\("
      Case ')'
        Result$+"\)"
      Case 128 To 511
        ;Debug Str(i)+":"+StrU(Char,#PB_Word)
        Result$+"\"+ipdf_Dec2Oct(Char)
      Default
        Result$+Chr(Char)
    EndSelect
  Next
  ProcedureReturn Result$
EndProcedure

Procedure ipdf_EscapeU(First$,Last$,Text$,*MEM.MEM_DataStructure,UnicodeHeader=#False)
  Protected i,j,sLen=Len(Text$),Char.u,PChar.b,*Ptr,Unicode,FUnicode
  
  If ListIndex(Fonts())<>-1
    If Fonts()\unicode=#True
      FUnicode=#True
    EndIf
  EndIf
  
  If UnicodeHeader=#True Or FUnicode=#True
    Unicode=#True
  EndIf
  
  *MEM\lCurSize=Len(First$)+StringByteLength(Text$)*4+Len(Last$)+SizeOf(Character)
  If UnicodeHeader
    *MEM\lCurSize+2
  EndIf
  *MEM\lMaxSize=*MEM\lCurSize
  *MEM\pData=AllocateMemory(*MEM\lMaxSize)
  If *MEM\pData
    *Ptr=*MEM\pData
    PokeS(*Ptr,First$,-1,#PB_Ascii):*Ptr+Len(First$)
    If UnicodeHeader
      PokeU(*Ptr,ipdf_EndianW($FEFF)):*Ptr+2
    EndIf
    For i=1 To sLen
      Char=Asc(Mid(Text$,i,1))
      If Unicode
        Char=ipdf_EndianW(Char)&$FFFF
      EndIf
      For j=0 To Unicode
        PChar=PeekB(@Char+j)
        Select PChar
          Case 8 ; BS = \b
            PokeB(*Ptr,'\'):*Ptr+1
            PokeB(*Ptr,'b'):*Ptr+1
          Case 9 ; TAB = \t
            PokeB(*Ptr,'\'):*Ptr+1
            PokeB(*Ptr,'t'):*Ptr+1
          Case 10 ; LF = \n
            PokeB(*Ptr,'\'):*Ptr+1
            PokeB(*Ptr,'n'):*Ptr+1
          Case 12 ; FF = \f
            PokeB(*Ptr,'\'):*Ptr+1
            PokeB(*Ptr,'f'):*Ptr+1
          Case 13 ; CR = \r
            PokeB(*Ptr,'\'):*Ptr+1
            PokeB(*Ptr,'r'):*Ptr+1
          Case 92 ; \ = \\
            PokeB(*Ptr,'\'):*Ptr+1
            PokeB(*Ptr,'\'):*Ptr+1
          Case 40 ; ( = \(
            PokeB(*Ptr,'\'):*Ptr+1
            PokeB(*Ptr,'('):*Ptr+1
          Case 41 ; ) = \)
            PokeB(*Ptr,'\'):*Ptr+1
            PokeB(*Ptr,')'):*Ptr+1
          Default
            PokeB(*Ptr,PChar):*Ptr+1
        EndSelect
      Next
    Next
    PokeS(*Ptr,Last$,-1,#PB_Ascii)
    *Ptr+Len(Last$)
    *MEM\lCurSize=*Ptr-*MEM\pData
  EndIf
  If *MEM\pData
    ProcedureReturn #True
  EndIf
EndProcedure

Procedure.s ipdf_TextString(String$)
  ProcedureReturn "(" + ipdf_Escape(String$) + ")"
EndProcedure 

Procedure.l ipdf_FileReadInt(MemoryID)
  Protected vResult.l
  vResult = (PeekB(MemoryID) & $FF) << 24
  vResult = vResult + (PeekB(MemoryID + 1) & $FF) << 16
  vResult = vResult + (PeekB(MemoryID + 2) & $FF) << 8
  vResult = vResult + (PeekB(MemoryID + 3) & $FF) 
  ProcedureReturn vResult
EndProcedure 

Procedure ipdf_ParsePNG(*aData.MEM_DataStructure)
  Protected vReturn,vCt,vCount,vNum,vType.s,trans$
  
  vReturn = #True
  Images()\Width = ipdf_FileReadInt(*aData\pData+16)
  Images()\Height = ipdf_FileReadInt(*aData\pData+20)
  Images()\Bpc = PeekB(*aData\pData+24) & $FF
  If Images()\Bpc>8
    pdfError=#PDF_ERROR_16BIT_DEPTH_PNG_NOT_SUPPORTED
    vReturn = #False
  Else
    vCt = PeekB(*aData\pData+25) & $FF
    Select vCt
      Case 0
        Images()\ColSpace = "DeviceGray"
        Images()\Parms = "/DecodeParms <</Predictor 15 /Colors 1 /BitsPerComponent " + Str(Images()\Bpc) + " /Columns " + Str(Images()\Width) + ">>"  
      Case 2
        Images()\ColSpace = "DeviceRGB" 
        Images()\Parms = "/DecodeParms <</Predictor 15 /Colors 3 /BitsPerComponent " + Str(Images()\Bpc) + " /Columns " + Str(Images()\Width) + ">>"          
      Case 3
        Images()\ColSpace = "Indexed"
        Images()\Parms = "/DecodeParms <</Predictor 15 /Colors 1 /BitsPerComponent " + Str(Images()\Bpc) + " /Columns " + Str(Images()\Width) + ">>"          
;       Case 4 ;-TODO ADDING TRANSPARENCY TO PNG 
;         Images()\ColSpace = "DeviceGray" 
;         Images()\Parms = "/DecodeParms <</Predictor 15 /Colors 1 /BitsPerComponent " + Str(Images()\Bpc) + " /Columns " + Str(Images()\Width) + ">>"            
;        Case 6
;         Images()\ColSpace = "DeviceRGB" 
;         Images()\Parms = "/DecodeParms <</Predictor 15 /Colors 3 /BitsPerComponent " + Str(Images()\Bpc) + " /Columns " + Str(Images()\Width) + ">>"        
       Default:
        pdfError = #PDF_ERROR_ALPHA_CHANNEL_PNG_NOT_SUPPORTED
        vReturn = #False
    EndSelect
    
    If vReturn = #True
      If (PeekB(*aData\pData+26) & $FF)<>0
        pdfError = #PDF_ERROR_UNKNOWN_COMPRESSION_PNG_METHOD
        vReturn = #False        
      Else
        If (PeekB(*aData\pData+27) & $FF)<>0
          pdfError = #PDF_ERROR_UNKNOWN_FILTER_PNG_METHOD
          vReturn = #False          
        Else
          If (PeekB(*aData\pData+28) & $FF)<>0
            pdfError = #PDF_ERROR_INTERLACING_PNG_NOT_SUPPORTED
            vReturn = #False          
          Else
            ;Scan chunks looking for palette, transparency and image Data
            vNum = 0 : vCount = 33            
            Repeat      
              vNum = ipdf_FileReadInt(*aData\pData+vCount)
              vCount = vCount + 4
              vType = Chr(PeekB(*aData\pData+vCount)) + Chr(PeekB(*aData\pData+vCount + 1)) + Chr(PeekB(*aData\pData+vCount + 2)) + Chr(PeekB(*aData\pData+vCount + 3))              
              Select vType
                Case "PLTE"
                  If MEM_DataInit(Images()\Pal, Images()\Pal\lCurSize + vNum)
                    CopyMemory(*aData\pData+vCount+4, Images()\Pal\pData + Images()\Pal\lCurSize, vNum)
                    Images()\Pal\lCurSize = Images()\Pal\lCurSize + vNum
                  Else
                    pdfError = #PDF_ERROR_OUT_OF_MEMORY
                    vReturn = #False
                    Break
                  EndIf
                Case "IDAT"
                  If MEM_DataInit(Images()\DataPic, Images()\DataPic\lCurSize + vNum )
                    CopyMemory(*aData\pData+vCount+4, Images()\DataPic\pData + Images()\DataPic\lCurSize, vNum)
                    Images()\DataPic\lCurSize = Images()\DataPic\lCurSize + vNum
                  Else
                    pdfError = #PDF_ERROR_OUT_OF_MEMORY
                    vReturn = #False
                    Break
                  EndIf
                Case "IEND"
                  Break
                Default
              EndSelect
              vCount = vCount + vNum + 8
            Until (vNum<=0)
            
            If (Images()\ColSpace="Indexed" And Images()\Pal\lCurSize = 0)
              If Images()\Pal\pData
                FreeMemory(Images()\Pal\pData)
              EndIf
              If Images()\DataPic\pData
                FreeMemory(Images()\DataPic\pData)
              EndIf
              pdfError = #PDF_ERROR_MISSING_PALETTE_IN_PNG
              vReturn = #False  
            EndIf
          EndIf 
        EndIf 
      EndIf
    EndIf   
  EndIf  
  ProcedureReturn vReturn
EndProcedure

Procedure ipdf_ParseJPG(*aData.MEM_DataStructure)  
  Protected vLength,vFound=#False,vResult=#False,vByte.b,*PTR.Unicode,vTest
  
  ;Debug "ipdf_ParseJPG()"
  
  *PTR=*aData\pData
  Repeat
    vTest=ipdf_EndianW(*PTR\u) & $FFFF
    Select vTest
      Case $FFD8
        ;Debug "Start of Image Tag"
        *PTR+2
      Case $FFE0
        ;Debug "JFIF tag"
        ;Debug PeekS(*PTR+4,5,#PB_Ascii) ; JFIF
        ;Debug "v"+Str(PeekB(*PTR+9))+".0"+Str(PeekB(*PTR+10))
        ;Debug "units="+Str(PeekB(*PTR+11)&$FF)+" (0=none/1=dots per inch/2=dots per cm)"
        ;Debug "Xdensity="+Str(ipdf_EndianW(PeekW(*PTR+12)))
        ;Debug "Ydensity="+Str(ipdf_EndianW(PeekW(*PTR+14)))
        ;Debug "Xthumbnail="+Str(PeekB(*PTR+16)&$FF)
        ;Debug "Ythumbnail="+Str(PeekB(*PTR+17)&$FF)
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFC0 ; Baseline DCT  
        ;Debug "Baseline DCT Tag"
        vFound = #True
        vResult = #True
        Images()\Bpc = PeekB(*PTR+4)
        Images()\Height = (PeekB(*PTR+5)&$FF)*$100 + (PeekB(*PTR+6)&$FF)
        Images()\Width  = (PeekB(*PTR+7)&$FF)*$100 + (PeekB(*PTR+8)&$FF)
        ; Gray = 1/Color = 3
        Select PeekB(*PTR + 9) & $FF
          Case 1
            Images()\ColSpace = "DeviceGray"
          Case 3
            Images()\ColSpace = "DeviceRGB"           
          Default:
            Images()\ColSpace = "DeviceCMYK"               
        EndSelect    
        Images()\DataPic\pData = *aData\pData
        Images()\DataPic\lCurSize = *aData\lCurSize
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFC1 ; Extended sequential DCT
        ;Debug "Extended sequential DCT Tag"
        vFound = #True
        vResult = #True
        Images()\Bpc = PeekB(*PTR+4)
        Images()\Height = (PeekB(*PTR+5)&$FF)*$100 + (PeekB(*PTR+6)&$FF)
        Images()\Width  = (PeekB(*PTR+7)&$FF)*$100 + (PeekB(*PTR+8)&$FF)
        ; Gray = 1/Color = 3
        Select PeekB(*PTR + 9) & $FF
          Case 1
            Images()\ColSpace = "DeviceGray"
          Case 3
            Images()\ColSpace = "DeviceRGB"           
          Default:
            Images()\ColSpace = "DeviceCMYK"               
        EndSelect    
        Images()\DataPic\pData = *aData\pData
        Images()\DataPic\lCurSize = *aData\lCurSize
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFC2 ; Progressive DCT
        ;Debug "Progressive DCT Tag"
        vFound = #True
        vResult = #True
        Images()\Bpc = PeekB(*PTR+4)
        Images()\Height = (PeekB(*PTR+5)&$FF)*$100 + (PeekB(*PTR+6)&$FF)
        Images()\Width  = (PeekB(*PTR+7)&$FF)*$100 + (PeekB(*PTR+8)&$FF)
        ; Gray = 1/Color = 3
        Select PeekB(*PTR + 9) & $FF
          Case 1
            Images()\ColSpace = "DeviceGray"
          Case 3
            Images()\ColSpace = "DeviceRGB"           
          Default:
            Images()\ColSpace = "DeviceCMYK"               
        EndSelect    
        Images()\DataPic\pData = *aData\pData
        Images()\DataPic\lCurSize = *aData\lCurSize
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFC3 ; Lossless (sequential)
        ;Debug "Lossless (sequential) Tag"
        CallDebugger
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFC5 ; Differential sequential DCT
        ;Debug "Differential sequential DCT Tag"
        CallDebugger
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFC6 ; Differential progressive DCT
        ;Debug "Differential progressive DCT Tag"
        CallDebugger
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFC7 ; Differential lossless (sequential)
        ;Debug "Differential lossless (sequential) Tag"
        CallDebugger
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFC8 ; Reserved for JPEG Extensions
        ;Debug "Reserved for JPEG Extensions Tag"
        CallDebugger
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFC9 ; Extended sequential DCT
        ;Debug "Extended sequential DCT Tag"
        CallDebugger
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFCA ; Progressive DCT
        ;Debug "Progressive DCT Tag"
        CallDebugger
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFCB ; Lossless (sequential)
        ;Debug "Lossless (sequential) Tag"
        CallDebugger
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFCD ; Differential sequential DCT
        ;Debug "Differential sequential DCT Tag"
        CallDebugger
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFCE ; Differential progressive DCT
        ;Debug "Differential progressive DCT Tag"
        CallDebugger
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFCF ; Differential lossless (sequential)
        ;Debug "Differential lossless (sequential) Tag"
        CallDebugger
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFC4 ; Define Huffman Table(s)
        ;Debug "Define Huffman Table(s) Tag"
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFCC ; Define arithmetic encoding(s)
        ;Debug "Define arithmetic encoding(s) Tag"
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFDB ; Define Quantization Table(s)
        ;Debug "Define Quantization Table(s) Tag"
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFE1 ; Exif Data
        ;Debug "Exif Data Tag"
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFEE ; Copyright
        ;Debug "Copyright Tag"
        ;Debug "Copyright="+PeekS(*PTR+4,-1,#PB_Ascii)
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFE2,$FFE3,$FFE4,$FFE5,$FFE6,$FFE7,$FFE8,$FFE9,$FFEA,$FFEB,$FFEC,$FFED,$FFEF ; 
        ;Debug "Application-specific Tag"
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFFE ; Comments
        ;Debug "Comments Tag"
        ;Debug PeekS(*PTR+4,-1,#PB_Ascii)
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFDA ; Start Of Scan
        ;Debug "Start of Scan Tag"
        *PTR+2
        *PTR+(ipdf_EndianW(*PTR\u)&$FFFF)
      Case $FFD9
        ;Debug "End of Image Tag"
        Break
      Default
        *PTR+1
    EndSelect
  Until (vFound=#True) Or (*PTR >= (*aData\pData+*aData\lCurSize))
  
  If vFound=#False
    pdfError = #PDF_ERROR_JPEG_FILE_IS_NOT_SUPPORTED
  EndIf
  
  ProcedureReturn vResult
EndProcedure

#META_EOF = $0000
#META_REALIZEPALETTE = $0035
#META_SETPALENTRIES = $0037
#META_SETBKMODE = $0102
#META_SETMAPMODE = $0103
#META_SETROP2 = $0104
#META_SETRELABS = $0105
#META_SETPOLYFILLMODE = $0106
#META_SETSTRETCHBLTMODE = $0107
#META_SETTEXTCHAREXTRA = $0108
#META_RESTOREDC = $0127
#META_RESIZEPALETTE = $0139
#META_DIBCREATEPATTERNBRUSH = $0142
#META_SETLAYOUT = $0149
#META_SETBKCOLOR = $0201
#META_SETTEXTCOLOR = $0209
#META_OFFSETVIEWPORTORG = $0211
#META_LINETO = $0213
#META_MOVETO = $0214
#META_OFFSETCLIPRGN = $0220
#META_FILLREGION = $0228
#META_SETMAPPERFLAGS = $0231
#META_SELECTPALETTE = $0234
#META_POLYGON = $0324
#META_POLYLINE = $0325
#META_SETTEXTJUSTIFICATION = $020A
#META_SETWINDOWORG = $020B
#META_SETWINDOWEXT = $020C
#META_SETVIEWPORTORG = $020D
#META_SETVIEWPORTEXT = $020E
#META_OFFSETWINDOWORG = $020F
#META_SCALEWINDOWEXT = $0410
#META_SCALEVIEWPORTEXT = $0412
#META_EXCLUDECLIPRECT = $0415
#META_INTERSECTCLIPRECT = $0416
#META_ELLIPSE = $0418
#META_FLOODFILL = $0419
#META_FRAMEREGION = $0429
#META_ANIMATEPALETTE = $0436
#META_TEXTOUT = $0521
#META_POLYPOLYGON = $0538
#META_EXTFLOODFILL = $0548
#META_RECTANGLE = $041B
#META_SETPIXEL = $041F
#META_ROUNDRECT = $061C
#META_PATBLT = $061D
#META_SAVEDC = $001E
#META_PIE = $081A
#META_STRETCHBLT = $0B23
#META_ESCAPE = $0626
#META_INVERTREGION = $012A
#META_PAINTREGION = $012B
#META_SELECTCLIPREGION = $012C
#META_SELECTOBJECT = $012D
#META_SETTEXTALIGN = $012E
#META_ARC = $0817
#META_CHORD = $0830
#META_BITBLT = $0922
#META_EXTTEXTOUT = $0a32
#META_SETDIBTODEV = $0d33
#META_DIBBITBLT = $0940
#META_DIBSTRETCHBLT = $0b41
#META_STRETCHDIB = $0f43
#META_DELETEOBJECT = $01f0
#META_CREATEPALETTE = $00f7
#META_CREATEPATTERNBRUSH = $01F9
#META_CREATEPENINDIRECT = $02FA
#META_CREATEFONTINDIRECT = $02FB
#META_CREATEBRUSHINDIRECT = $02FC
#META_CREATEREGION = $06FF

Structure STR_GDIOBJECTS
  ;Idx.l
  deleted.l
  Type.l
  Style.l
  width.f
  dummy.l
  r.a
  g.a
  b.a
  a.a
  hatch.u
EndStructure

Procedure.i ipdf_AddGDIObject(List GDIObjects.STR_GDIOBJECTS())
  Protected found.l=#False
  
  If ListSize(GDIObjects())=0
    AddElement(GDIObjects())
  Else
    ForEach GDIObjects()
      If GDIObjects()\deleted=#True
        GDIObjects()\deleted=#False
        found=#True
        Break
      EndIf
    Next
    If found=#False
      AddElement(GDIObjects())
    EndIf
  EndIf
  ProcedureReturn ListIndex(GDIObjects())
EndProcedure

Procedure.f ipdf_Point_Distance(X1.f, Y1.f, X2.f, Y2.f)
  Protected a.f, b.f
  
  a = Abs(X2 - X1)
  b = Abs(Y2 - Y1)
  
  ProcedureReturn Sqr(a * a + b * b)
EndProcedure

Procedure.f ipdf_GetAngle_Points(X1.f, Y1.f, X2.f, Y2.f) 
  Protected n1.f,n2.f,angle.f
  
  n1.f = Sqr((x1*x1)+(y1*y1))
  n2.f = Sqr((x2*x2)+(y2*y2))
  angle.f = (ACos((x1*x2+y1*y2)/(n1*n2)) * 180) / #PI
  
  ProcedureReturn angle
EndProcedure 

Procedure ipdf_ParseWMF(*aData.MEM_DataStructure)
  ;-* WMF
  Protected vResult,*WMF_PTR=*aData\pData
  Protected NewList GDIObjects.STR_GDIOBJECTS()
  Protected wo_x,wo_y ; window origin
  Protected we_x,we_y ; window extend
  Protected polyfillmode
  Protected nullPen = #False
  Protected nullBrush = #False
  Protected endRecord = #False
  Protected bkMode.w,bkColor.l,textalign.w
  Protected size.l,func.w,idx.w,funcidx.l,DrawMode.w,databuffer.s
  Protected numpoints,i,j,px,py,x,y,w,h,numpolygons,adjustment,da.s
  Protected x1,y1,x2,y2,x3,y3,x4,y4
  Protected fCenterX.f,fCenterY.f,fRadialX.f,fRadialY.f,fPosX1.f,fPosY1.f,fPosX2.f,fPosY2.f,fAngle1.f,fAngle2.f
  
  If PeekL(*WMF_PTR)&$FFFFFFFF=$9AC6CDD7
    *WMF_PTR+40
  Else
    *WMF_PTR+18
  EndIf
  
  While (*WMF_PTR < (*aData\pData + *aData\lCurSize)) And (endRecord = #False)
    funcidx+1
    size=PeekL(*WMF_PTR+0)
    func=PeekW(*WMF_PTR+4)
    Select func
      Case #META_SETWINDOWORG
        ;Debug "SetWindowOrg $"+Hex(#META_SETWINDOWORG)
        If Not Len(databuffer)
          wo_y=PeekW(*WMF_PTR+6)
          wo_x=PeekW(*WMF_PTR+8)
          ;Debug "wo_x="+Str(wo_x)
          ;Debug "wo_y="+Str(wo_y)
        EndIf
      Case #META_SETWINDOWEXT
        ;Debug "SetWindowExt $"+Hex(#META_SETWINDOWEXT)
        If Not Len(databuffer)
          we_y=PeekW(*WMF_PTR+6)
          we_x=PeekW(*WMF_PTR+8)
          ;Debug "we_x="+Str(we_x)
          ;Debug "we_y="+Str(we_y)
        EndIf
      Case #META_CREATEBRUSHINDIRECT
        ;Debug "CreateBrushIndirect"
        ipdf_AddGDIObject(GDIObjects())
        GDIObjects()\Type='B'
        GDIObjects()\Style=PeekW(*WMF_PTR+6) ; BrushStyle (2 Bytes)
        GDIObjects()\r=PeekA(*WMF_PTR+8) ; ColorRef (4 Bytes)
        GDIObjects()\g=PeekA(*WMF_PTR+9)
        GDIObjects()\b=PeekA(*WMF_PTR+10)
        GDIObjects()\a=PeekA(*WMF_PTR+11)
        GDIObjects()\hatch=PeekW(*WMF_PTR+12)&$FFFF ; BrushHatch (2 Bytes)
        ;Debug "CreateBrushIndirect $"+Hex(#META_CREATEBRUSHINDIRECT)+" "+Str(ListIndex(GDIObjects()))+" : S="+Str(GDIObjects()\Style)+" R="+StrU(GDIObjects()\r,#PB_Ascii)+" G="+StrU(GDIObjects()\g,#PB_Ascii)+" B="+StrU(GDIObjects()\b,#PB_Ascii)
      Case #META_CREATEPENINDIRECT
        ;Debug "CreatePenIndirect"
        ipdf_AddGDIObject(GDIObjects())
        GDIObjects()\Type='P'
        GDIObjects()\Style=PeekW(*WMF_PTR+6)
        GDIObjects()\width=PeekW(*WMF_PTR+8) / (20 * pdfK)
        GDIObjects()\r=PeekA(*WMF_PTR+12)&$FF
        GDIObjects()\g=PeekA(*WMF_PTR+13)&$FF
        GDIObjects()\b=PeekA(*WMF_PTR+14)&$FF
        GDIObjects()\a=PeekA(*WMF_PTR+15)&$FF
        ;ShowMemoryViewer(*WMF_PTR,size*2)
        Debug "CreatePenIndirect $"+Hex(#META_CREATEPENINDIRECT)+" "+Str(ListIndex(GDIObjects()))+" : S="+Str(GDIObjects()\Style)+" W="+StrF(GDIObjects()\width,2)+" R="+StrU(GDIObjects()\r,#PB_Ascii)+" G="+StrU(GDIObjects()\g,#PB_Ascii)+" B="+StrU(GDIObjects()\b,#PB_Ascii)
      Case $06fe ; CreateBitmap
        ;Debug "CreateBitmap"
        ipdf_AddGDIObject(GDIObjects())
        GDIObjects()\Type='D' ; dummyobject
        CallDebugger
      Case $02fd ; CreateBitmapIndirect
        ;Debug "CreateBitmapIndirect"
        ipdf_AddGDIObject(GDIObjects())
        GDIObjects()\Type='D' ; dummyobject
        CallDebugger
      Case $00f8 ; CreateBrush
        ;Debug "CreateBrush"
        ipdf_AddGDIObject(GDIObjects())
        GDIObjects()\Type='D' ; dummyobject
        CallDebugger
      Case #META_CREATEFONTINDIRECT
        ;Debug "CreateFontIndirect $"+Hex(#META_CREATEFONTINDIRECT)
        ;Debug "size=$"+Hex(size)
        ;Debug "*WMF_PTR=$"+Hex(*WMF_PTR-*aData\pData)
        ;Debug PeekW(*WMF_PTR+6) ; Height
        ;Debug PeekW(*WMF_PTR+8) ; Width
        ;Debug PeekW(*WMF_PTR+10) ; Escapement
        ;Debug PeekW(*WMF_PTR+12) ; Orientation
        ;Debug PeekW(*WMF_PTR+14) ; Weight
        ;Debug PeekB(*WMF_PTR+16) ; Italic
        ;Debug PeekB(*WMF_PTR+17) ; Underline
        ;Debug PeekB(*WMF_PTR+18) ; StrikeOut
        ;Debug PeekB(*WMF_PTR+19) ; CharSet
        ;Debug PeekB(*WMF_PTR+20) ; OutPrecision
        ;Debug PeekB(*WMF_PTR+21) ; ClipPrecision
        ;Debug PeekB(*WMF_PTR+22) ; Quality
        ;Debug PeekB(*WMF_PTR+23) ; PitchAndFamily
        ;Debug PeekB(*WMF_PTR+24) ; FaceName
        ;Debug PeekS(*WMF_PTR+24,size*2-24,#PB_Ascii)
        ;Debug *WMF_PTR+size*2
        ipdf_AddGDIObject(GDIObjects())
        GDIObjects()\Type='D' ; dummyobject
        ;CallDebugger
      Case #META_CREATEPALETTE
        ;Debug "CreatePalette"
        ipdf_AddGDIObject(GDIObjects())
        GDIObjects()\Type='D' ; dummyobject
        ;CallDebugger
      Case #META_CREATEPATTERNBRUSH
        ;Debug "CreatePatternBrush"
        ipdf_AddGDIObject(GDIObjects())
        GDIObjects()\Type='D' ; dummyobject
        CallDebugger
      Case #META_CREATEREGION
        ;Debug "CreateRegion"
        ipdf_AddGDIObject(GDIObjects())
        GDIObjects()\Type='D' ; dummyobject
        CallDebugger
      Case #META_DIBCREATEPATTERNBRUSH
        ;Debug "DibCreatePatternBrush"
        ipdf_AddGDIObject(GDIObjects())
        GDIObjects()\Type='D' ; dummyobject
        CallDebugger
      Case #META_SETPOLYFILLMODE
        ;Debug "SetPolyFillMode $"+Hex(#META_SETPOLYFILLMODE)
        polyfillmode=PeekW(*WMF_PTR+6)
        Debug "polyfillmode="+Str(polyfillmode)
      Case #META_DELETEOBJECT
        ;Debug "DeleteObject"
        idx=PeekW(*WMF_PTR+6)
        If SelectElement(GDIObjects(),idx)
          ClearStructure(@GDIObjects(),STR_GDIOBJECTS)
          GDIObjects()\deleted=#True
          ;Debug "DeleteObject $"+Hex(#META_DELETEOBJECT)+" idx="+Str(idx)+" ok"
        Else
          ;Debug "DeleteObject idx="+Str(idx)+" failed!"
          CallDebugger
        EndIf
      Case #META_SELECTOBJECT
        ;Debug "SelectObject"
        idx=PeekW(*WMF_PTR+6)
        If SelectElement(GDIObjects(),idx)
          ;Debug "SelectObject $"+Hex(#META_SELECTOBJECT)+" idx="+Str(idx)+" ok T="+Chr(GDIObjects()\Type)+" S="+Str(GDIObjects()\Style)
          da="[] 0 d"
          Select GDIObjects()\Type
            Case 'B'
              nullBrush=#False
              If GDIObjects()\Style=1 ; BS_NULL
                nullBrush=#True
              Else
                databuffer+StrF(GDIObjects()\r/255,3)+" "+StrF(GDIObjects()\g/255,3)+" "+StrF(GDIObjects()\b/255,3)+" rg"+#PDF_NEWLINE
                databuffer+da+#PDF_NEWLINE
              EndIf
            Case 'P'
              nullPen=#False
              Select GDIObjects()\Style
                Case 0 ; PS_SOLID
                Case 1 ; PS_DASH
                  da="["+StrF(3*20*pdfK,3)+" "+StrF(1*20*pdfK,3)+"] 0 d"
                Case 2 ; PS_DOT
                  da="["+StrF(0.5*20*pdfK,3)+" "+StrF(0.5*20*pdfK,3)+"] 0 d"
                Case 3 ; PS_DASHDOT
                  da="["+StrF(2*20*pdfK,3)+" "+StrF(1*20*pdfK,3)+" "+StrF(0.5*20*pdfK,3)+" "+StrF(1*20*pdfK,3)+"] 0 d"
                Case 4 ; PS_DASHDOTDOT
                  da="["+StrF(2*20*pdfK,3)+" "+StrF(1*20*pdfK,3)+" "+StrF(0.5*20*pdfK,3)+" "+StrF(1*20*pdfK,3)+" "+StrF(0.5*20*pdfK,3)+" "+StrF(1*20*pdfK,3)+"] 0 d"
                Case 5 ; PS_NULL
                  nullPen=#True
              EndSelect
              If nullPen=#False 
                databuffer+StrF(GDIObjects()\r/255,3)+" "+StrF(GDIObjects()\g/255,3)+" "+StrF(GDIObjects()\b/255,3)+" RG"+#PDF_NEWLINE
                databuffer+StrF(GDIObjects()\width*pdfK,2)+" w"+#PDF_NEWLINE
                databuffer+da+#PDF_NEWLINE
              EndIf
          EndSelect
        Else
          ;Debug "SelectObject idx="+Str(idx)+" failed!"
          CallDebugger
        EndIf
      Case #META_POLYGON,#META_POLYLINE
        ;Debug "Polyline , Polygon"
        numpoints=PeekW(*WMF_PTR+6)
        For i=numpoints-1 To 0 Step -1
          px=PeekW(*WMF_PTR+8+4*i)
          py=PeekW(*WMF_PTR+10+4*i)
          If i < (numpoints-1)
            databuffer+Str(px)+" "+Str(py)+" l"+#PDF_NEWLINE ; LineTo
          Else
            databuffer+Str(px)+" "+Str(py)+" m"+#PDF_NEWLINE ; MoveTo
          EndIf
        Next
        If func=#META_POLYLINE
          ;Debug "POLYLINE $"+Hex(#META_POLYLINE)
          databuffer+"s"
        ElseIf func=#META_POLYGON
          ;Debug "POLYGON $"+Hex(#META_POLYGON)
          If nullPen
            If nullBrush
              databuffer+"n" ; no op
            Else
              databuffer+"f" ; fill
              If polyfillmode
                databuffer+"*"
              EndIf
            EndIf
          Else
            If nullBrush
              databuffer+"s" ; stroke
            Else
              databuffer+"b" ; stroke and fill
              If polyfillmode
                databuffer+"*"
              EndIf
            EndIf
          EndIf
        EndIf
        databuffer+#PDF_NEWLINE
      Case #META_POLYPOLYGON
        ;Debug "PolyPolygon $"+Hex(#META_POLYPOLYGON)
        numpolygons=PeekW(*WMF_PTR+6)
        ;Debug "numpolygons="+Str(numpolygons)
        adjustment=numpolygons*2
        For j=0 To numpolygons-1
          numpoints=PeekW(*WMF_PTR+8+j*2)
          ;Debug "numpoints="+Str(numpoints)
          For i=numpoints-1 To 0 Step -1
            px=PeekW(*WMF_PTR+8+4*i+adjustment)
            py=PeekW(*WMF_PTR+10+4*i+adjustment)
            If (i+1)=numpoints
              databuffer+Str(px)+" "+Str(py)+" m"+#PDF_NEWLINE ; MoveTo
              ;Debug Str(px)+" "+Str(py)+" m"
            Else
              databuffer+Str(px)+" "+Str(py)+" l"+#PDF_NEWLINE ; LineTo
              ;Debug Str(px)+" "+Str(py)+" l"
            EndIf
          Next
          adjustment+numpoints*4
        Next
        If nullPen
          If nullBrush
            databuffer+"n" ; no op
          Else
            databuffer+"f" ; fill
            If polyfillmode=1
              databuffer+"*"
            EndIf
          EndIf
        Else
          If nullBrush
            databuffer+"s" ; stroke
          Else
            databuffer+"b" ; stroke and fill
            If polyfillmode=1
              databuffer+"*"
            EndIf
          EndIf
        EndIf
        databuffer+#PDF_NEWLINE
; 					$coords = unpack('s'.($size-3), $parms);
; 					$numpolygons = $coords[1];
; 					$adjustment = $numpolygons;
; 					For ($j = 1; $j <= $numpolygons; $j++)
; 					{
; 						$numpoints = $coords[$j + 1];
; 						For ($i = $numpoints; $i > 0; $i--)
; 						{
; 							$px = $coords[2*$i   + $adjustment];
; 							$py = $coords[2*$i+1 + $adjustment];
; 
; 							If ($i == $numpoints)
; 								$data .= $this->MoveTo($px, $py);
; 							Else
; 								$data .= $this->LineTo($px, $py);
; 						}
; 						$adjustment += $numpoints * 2;
; 					}
; 					If ($nullPen)
; 					{
; 						If ($nullBrush)
; 							$op = 'n';  // no op
; 						Else
; 							$op = 'f';  // fill
; 					}
; 					Else
; 					{
; 						If ($nullBrush)
; 							$op = 's';  // stroke
; 						Else
; 							$op = 'b';  // stroke and fill
; 					}
; 					If ($polyFillMode==1 && ($op=='b' || $op=='f')) 
; 						$op .= '*';  // use even-odd fill rule
; 					$data .= $op."\n";
; 
      Case #META_SETRELABS
        ;Debug "#META_SETRELABS: The META_SETRELABS record is reserved and not supported."
      Case #META_SETROP2
        ;Debug "#META_SETROP2"
        DrawMode=PeekW(*WMF_PTR+6)
        ;Debug "SETROP2 DrawMode=$"+RSet(Hex(DrawMode,#PB_Word),4,"0")
      Case #META_SETBKMODE
        ;Debug "#META_SETBKMODE"
        bkMode=PeekW(*WMF_PTR+6)
        ;Debug "SETBKMODE bkMode=$"+RSet(Hex(bkMode,#PB_Word),4,"0")
        ;CallDebugger
      Case #META_SETBKCOLOR
        ;Debug "#META_SETBKCOLOR"
        bkColor=PeekL(*WMF_PTR+6)
        ;Debug "SETBKCOLOR bkColor=$"+RSet(Hex(bkColor,#PB_Long),8,"0")
        ;CallDebugger
      Case #META_SETTEXTALIGN
        ;Debug "#META_SETTEXTALIGN"
        textalign=PeekW(*WMF_PTR+6)
        ;Debug "SETTEXTALIGN textalign=$"+RSet(Hex(textalign,#PB_Word),4,"0")
        ;CallDebugger
      Case #META_EOF
        ;Debug "endRecord"
        endRecord = #True
      Case #META_ESCAPE
        ;Debug "ESCAPE"
      Case #META_SELECTPALETTE
        ;Debug "SELECTPALETTE"
      Case #META_REALIZEPALETTE
        ;Debug "REALIZEPALETTE"
      Case #META_SETTEXTCOLOR
        ;Debug "SETTEXTCOLOR"
      Case #META_SAVEDC
        ;Debug "SAVEDC"
      Case #META_INTERSECTCLIPRECT
        ;Debug "INTERSECTCLIPRECT"
      Case #META_RESTOREDC
        ;Debug "RESTOREDC"
      Case #META_SETMAPMODE
        ;Debug "SETMAPMODE"
      Case #META_SETSTRETCHBLTMODE
        ;Debug "SETSTRETCHBLTMODE"
      Case #META_RECTANGLE
        py=PeekW(*WMF_PTR+6) ; y Lower Right corner
        px=PeekW(*WMF_PTR+8) ; x Lower Right corner
        y=PeekW(*WMF_PTR+10) ; y Upper Left corner
        x=PeekW(*WMF_PTR+12) ; x Upper Left corner
        w=px-x
        h=py-y
        ;Debug "RECTANGLE px="+Str(px)+" py="+Str(py)+" x="+Str(x)+" y="+Str(y)
        databuffer+Str(x)+" "+Str(y)+" "+Str(w)+" "+Str(h)+" re"+#PDF_NEWLINE
        If nullPen
          If nullBrush
            databuffer+"n" ; no op
          Else
            databuffer+"f" ; fill
            If polyfillmode=1
              databuffer+"*"
            EndIf
          EndIf
        Else
          If nullBrush
            databuffer+"s" ; stroke
          Else
            databuffer+"b" ; stroke and fill
            If polyfillmode=1
              databuffer+"*"
            EndIf
          EndIf
        EndIf
        databuffer+#PDF_NEWLINE
      Case #META_MOVETO
        ;Debug "MOVETO"
        databuffer+Str(PeekW(*WMF_PTR+8))+" "+Str(PeekW(*WMF_PTR+6))+" m"+#PDF_NEWLINE
      Case #META_LINETO
        ;Debug "LINETO"
        databuffer+Str(PeekW(*WMF_PTR+8))+" "+Str(PeekW(*WMF_PTR+6))+" l"+#PDF_NEWLINE
        If nullPen
          If nullBrush
            databuffer+"n" ; no op
          Else
            databuffer+"f" ; fill
            If polyfillmode
              databuffer+"*"
            EndIf
          EndIf
        Else
          If nullBrush
            databuffer+"s" ; stroke
          Else
            databuffer+"b" ; stroke and fill
            If polyfillmode
              databuffer+"*"
            EndIf
          EndIf
        EndIf
        databuffer+#PDF_NEWLINE
      Case #META_ARC
        ;Debug "ARC funcidx="+Str(funcidx)
        ; Attention : buggy code ahead ;-)
        CallDebugger
        If 1;funcidx=66 ; 30 31 47 48 49 65 66 81 82
          ;-* WMF ARC
          y1=PeekW(*WMF_PTR+6) ; YRadial2
          x1=PeekW(*WMF_PTR+8) ; XRadial2
          y2=PeekW(*WMF_PTR+10) ; YRadial1
          x2=PeekW(*WMF_PTR+12) ; XRadial1
          y3=PeekW(*WMF_PTR+14) ; BottomRect
          x3=PeekW(*WMF_PTR+16) ; RightRect
          y4=PeekW(*WMF_PTR+18) ; TopRect
          x4=PeekW(*WMF_PTR+20) ; LeftRect
          Debug "XRadial2="+Str(x1)
          Debug "YRadial2="+Str(y1)
          Debug "XRadial1="+Str(x2)
          Debug "YRadial1="+Str(y2)
          Debug "RightRect="+Str(x3)
          Debug "BottomRect="+Str(y3)
          Debug "LeftRect="+Str(x4)
          Debug "TopRect="+Str(y4)
          fCenterX=x4+Abs((x3-x4)/2)
          fCenterY=y4+Abs((y3-y4)/2)
          fRadialX=Abs(x3-fCenterX)
          fRadialY=Abs(y3-fCenterY)
          fPosX1=x2-fCenterX
          fPosY1=y2-fCenterY
          fPosX2=x1-fCenterX
          fPosY2=y1-fCenterY
          Protected Line1.f,Line2.f
          Line1=ipdf_Point_Distance(0,0,fPosX1,fPosY1)
          Line2=ipdf_Point_Distance(0,0,fPosX2,fPosY2)
          Debug "Line1="+StrF(Line1)
          Debug "Line2="+StrF(Line2)
          Debug "fPosX1="+StrF(fPosX1)
          Debug "fPosY1="+StrF(fPosY1)
          Debug "fPosX2="+StrF(fPosX2)
          Debug "fPosY2="+StrF(fPosY2)
          
          If fPosX1>=0 And fPosY1>=0 ; Quadrant 1
            Debug "Q1"
            fAngle1=ipdf_GetAngle_Points(0,-fRadialY,fPosX1,fPosY1)-90
          ElseIf fPosX1>=0 And fPosY1<0 ; Quadrant 2
            Debug "Q2"
            fAngle1=ipdf_GetAngle_Points(0,-fRadialY,fPosX1,fPosY1)+270
          ElseIf fPosX1<0 And fPosY1<0 ;  Quadrant 3
            Debug "Q3"
            fAngle1=ipdf_GetAngle_Points(0,-fRadialY,-fPosX1,-fPosY1)-90
          Else ; Quadrant 4
            Debug "Q4"
            fAngle1=ipdf_GetAngle_Points(0,-fRadialY,-fPosX1,fPosY1)-90
          EndIf
          
          If fPosX2>=0 And fPosY2>=0 ; Quadrant 1
            Debug "Q1"
            fAngle2=ipdf_GetAngle_Points(0,-fRadialY,fPosX2,fPosY2)-90
          ElseIf fPosX2>=0 And fPosY2<0 ; Quadrant 2
            Debug "Q2"
            fAngle2=ipdf_GetAngle_Points(0,-fRadialY,fPosX2,fPosY2)+90
          ElseIf fPosX2<0 And fPosY2<0 ;  Quadrant 3
            Debug "Q3"
            fAngle2=ipdf_GetAngle_Points(0,-fRadialY,fPosX2,-fPosY2)-90
          Else ; Quadrant 4
            Debug "Q4"
            fAngle2=ipdf_GetAngle_Points(0,-fRadialY,fPosX2,fPosY2)-90
          EndIf
          Debug "fAngle1="+StrF(fAngle1)
          Debug "fAngle2="+StrF(fAngle2)
          
          ;CallDebugger
          Protected MyArcX.f,MyArcy.f,af.f,bf.f,d.f,xc.f, yc.f, rx.f, ry.f, a.f, b.f,cw.l=#True, o.f=90
          xc=fCenterX
          yc=fCenterY
          rx=fRadialX
          ry=fRadialY
          a=fAngle1
          b=fAngle2
          If cw = #True
            d = b
            b = o - a
            a = o - d
          Else
            b = b + o
            a = a + o
          EndIf
          a = (Mod(a,360)) + 360
          b = (Mod(b,360)) + 360
          If a > b
            b = b + 360
          EndIf
          bf = b/360*2*#PI
          af = a/360*2*#PI
          d = bf - af
          If d = 0
            d = 2 * #PI
          EndIf
          If Sin(d/2) 
            MyArcX = 4/3*(1-Cos(d/2))/Sin(d/2)*rx
            MyArcY = 4/3*(1-Cos(d/2))/Sin(d/2)*ry
          EndIf
          databuffer+StrF(xc+rx*Cos(af),3)+" "+StrF(yc-ry*Sin(af),3)+" m"+#PDF_NEWLINE
          If ( d < (#PI/2)) 
            databuffer+StrF(xc+rx*Cos(af)+MyArcX*Cos(#PI/2+af),3)+" "+StrF(yc-ry*Sin(af)-MyArcY*Sin(#PI/2+af),3)+" "+StrF(xc+rx*Cos(bf)+MyArcX*Cos(bf-#PI/2),3)+" "+StrF(yc-ry*Sin(bf)-MyArcY*Sin(bf-#PI/2),3)+" "+StrF(xc+rx*Cos(bf),3)+" "+StrF(yc-ry*Sin(bf),3)+" c"+#PDF_NEWLINE
          Else
            bf = af + d/4
            MyArcX = 4/3*(1-Cos(d/8))/Sin(d/8)*rx
            MyArcY = 4/3*(1-Cos(d/8))/Sin(d/8)*ry
            databuffer+StrF(xc+rx*Cos(af)+MyArcX*Cos(#PI/2+af),3)+" "+StrF(yc-ry*Sin(af)-MyArcY*Sin(#PI/2+af),3)+" "+StrF(xc+rx*Cos(bf)+MyArcX*Cos(bf-#PI/2),3)+" "+StrF(yc-ry*Sin(bf)-MyArcY*Sin(bf-#PI/2),3)+" "+StrF(xc+rx*Cos(bf),3)+" "+StrF(yc-ry*Sin(bf),3)+" c"+#PDF_NEWLINE
            af = bf
            bf = af + d/4
            databuffer+StrF(xc+rx*Cos(af)+MyArcX*Cos(#PI/2+af),3)+" "+StrF(yc-ry*Sin(af)-MyArcY*Sin(#PI/2+af),3)+" "+StrF(xc+rx*Cos(bf)+MyArcX*Cos(bf-#PI/2),3)+" "+StrF(yc-ry*Sin(bf)-MyArcY*Sin(bf-#PI/2),3)+" "+StrF(xc+rx*Cos(bf),3)+" "+StrF(yc-ry*Sin(bf),3)+" c"+#PDF_NEWLINE
            af = bf
            bf = af + d/4
            databuffer+StrF(xc+rx*Cos(af)+MyArcX*Cos(#PI/2+af),3)+" "+StrF(yc-ry*Sin(af)-MyArcY*Sin(#PI/2+af),3)+" "+StrF(xc+rx*Cos(bf)+MyArcX*Cos(bf-#PI/2),3)+" "+StrF(yc-ry*Sin(bf)-MyArcY*Sin(bf-#PI/2),3)+" "+StrF(xc+rx*Cos(bf),3)+" "+StrF(yc-ry*Sin(bf),3)+" c"+#PDF_NEWLINE
            af= bf
            bf = af + d/4
            databuffer+StrF(xc+rx*Cos(af)+MyArcX*Cos(#PI/2+af),3)+" "+StrF(yc-ry*Sin(af)-MyArcY*Sin(#PI/2+af),3)+" "+StrF(xc+rx*Cos(bf)+MyArcX*Cos(bf-#PI/2),3)+" "+StrF(yc-ry*Sin(bf)-MyArcY*Sin(bf-#PI/2),3)+" "+StrF(xc+rx*Cos(bf),3)+" "+StrF(yc-ry*Sin(bf),3)+" c"+#PDF_NEWLINE
          EndIf  
          databuffer+"S"+#PDF_NEWLINE ; stroke
        EndIf
      Default
        ;Debug "unkown function ! FUNC = $"+RSet(Hex(func,#PB_Unicode),4,"0")
        CallDebugger
    EndSelect
    ;ShowMemoryViewer(*WMF_PTR,2*size)
    ;CallDebugger
    *WMF_PTR+2*size
  Wend
  
  If Len(databuffer)
    Images()\Datapic\lCurSize=Len(databuffer)
    Images()\Datapic\lMaxSize=Images()\Datapic\lCurSize+1
    Images()\Datapic\pData=AllocateMemory(Images()\Datapic\lMaxSize)
    PokeS(Images()\Datapic\pData,databuffer,-1,#PB_Ascii)
    Images()\x=wo_x
    Images()\y=wo_y
    Images()\Width=we_x
    Images()\Height=we_y
    vResult=#True
  EndIf
  
  ProcedureReturn vResult
EndProcedure

Procedure ipdf_ParseImage(FileName$)
  Protected vReturn,vSize,vData.MEM_DataStructure,vLength,File
  
  vReturn = #True
  
  If Images()\pMem=0
    ; Read Image as File
    File=ReadFile(#PB_Any, FileName$)
    If File
      vSize = FileSize(FileName$)
      If MEM_DataInit(vData,vSize)
        vLength = ReadData(File,vData\pData , vSize)
        vData\lCurSize = vSize
      Else
        pdfError = #PDF_ERROR_OUT_OF_MEMORY
        vReturn = #False
      EndIf
      CloseFile(File)
    Else
      vReturn = #False
    EndIf
  Else
    ; Read Image from Mem
    ;Debug "ipdf_ParseImage() Read Image from Mem"
    If Images()\MemSize<>0
      ;Debug "Mem="+Str(Images()\pMem)
      ;Debug "MemSize="+Str(Images()\MemSize)
      vSize=Images()\MemSize ; luis - added this line
      If MEM_DataInit(vData,vSize)
        CopyMemory(Images()\pMem , vData\pData , Images()\MemSize)
        vLength = Images()\MemSize
        vSize = Images()\MemSize
        vData\lCurSize = Images()\MemSize
      Else
        pdfError = #PDF_ERROR_OUT_OF_MEMORY
        vReturn = #False
      EndIf
    Else
      vReturn = #False
    EndIf
  EndIf
  
  If vReturn = #True
    If vLength <> vSize
      pdfError = #PDF_ERROR_PROBLEM_READING_IMAGE_FILE_IN_MEMORY
      vReturn = #False
    Else
      ;Check JPEG2000 / JPEG / PNG
      Select PeekL(vData\pData) & $FFFFFFFF
        Case $51FF4FFF ; JPEG2000 (Experimental)
          Images()\Filter = "JPXDecode"
          Images()\Bpc = 8 ; ?
          Images()\Width = ipdf_EndianL(PeekL(vData\pData+8)) ; +8 / +24 ?
          Images()\Height = ipdf_EndianL(PeekL(vData\pData+12)) ; +12 / +28 ?
          Images()\ColSpace = "DeviceRGB" ; DeviceRGB DeviceCMYK DeviceGray ?
          Images()\DataPic\pData= vData\pData
          Images()\DataPic\lCurSize = vData\lCurSize
          vReturn = #True
        Case $E0FFD8FF ; JPEG
          Images()\Filter = "DCTDecode"
          vReturn = ipdf_ParseJPG(vData)
          If vReturn = #False
            pdfError = #PDF_ERROR_NOT_A_JPEG_FILE
            ;pdfError = #PDF_ERROR_JFIF_MARKER_IS_MISSING
          EndIf
        Case $474E5089 ; PNG
          If ipdf_EndianL(PeekL(vData\pData+12))=$49484452 ; IHDR
            Images()\Filter = "FlateDecode"
            vReturn = ipdf_ParsePNG(vData)
            If vReturn = #True And vData\pData
              FreeMemory(vData\pData) ; luis - added this line 
              vData\pData=0
            EndIf
          Else
            pdfError = #PDF_ERROR_INCORRECT_PNG_FILE
            vReturn = #False
          EndIf
        Case $9AC6CDD7 ; WMF
          Images()\Filter = "WMF"
          vReturn = ipdf_ParseWMF(vData)
          If vReturn = #True And vData\pData
            FreeMemory(vData\pData)
            vData\pData=0
          Else
            pdfError = #PDF_ERROR_INCORRECT_WMF_FILE
          EndIf
        Default
          pdfError = #PDF_ERROR_NOT_A_JPEG_OR_PNG_FILE
          vReturn = #False
      EndSelect
    EndIf
  Else
    pdfError = #PDF_ERROR_ERROR_OPENING_IMAGE_FILE
    vReturn = #False
  EndIf
  
  If vReturn = #False And vData\pData
    FreeMemory(vData\pData)
    vData\pData=0
  EndIf
  
  ProcedureReturn vReturn
EndProcedure
Procedure.f ipdf_GetPageWidth()
ProcedureReturn pages()\pdfwPt
EndProcedure 
Procedure.f ipdf_GetPageHeight()
ProcedureReturn pages()\pdfHPt
EndProcedure 


Procedure.d ipdf_GetStringWidth(String$,Scale=#True)
  Protected vLen.l,Width.l,vReturn.d,i,Char.c,Glyph.u,Found
  ;-* ipdf_GetStringWidth
  vLen.l  = Len(String$)
  
  If Fonts()\cidtogidmap
    For i=1 To vLen
      Char=Asc(Mid(String$,i,1))
      Glyph=ipdf_EndianW(Fonts()\cidtogidmap\segment[Char])&$FFFF
      If #PB_Compiler_Unicode=0 Or Glyph<>0
        Width+Fonts()\glyph_list(Glyph)\scaledwidth
      Else
        Width+1000
      EndIf
    Next
  Else
    For i=1 To vLen
      Char=Asc(Mid(String$,i,1))
      If Char>255
        Width + 600 ; for Unicode characters
      Else
        Width + Fonts()\CharWidth[Asc(Mid(String$,i,1))]
      EndIf
    Next
  EndIf
  
  If Scale
    vReturn = (Width * pdfFontSize) / 1000
  Else
    vReturn = Width
  EndIf
  
  ProcedureReturn vReturn
EndProcedure

Procedure.s ipdf_DoUnderline(x.f, y.f, Text$)
  Protected vWidth.f
    
  vWidth = ipdf_GetStringWidth(Text$) + (pdfWs*CountString(Text$," "))
  ; Take fontstyle into account Bold=Line is double in height
  If CountString(pdfFontStyle$,"B")
    ProcedureReturn ipdf_StrF(x*pdfK,2) + " " + ipdf_StrF((pdfH-(y-#PDF_FONTSUP/1000*pdfFontSize))*pdfK,2) + " " + ipdf_StrF(vWidth*pdfK,2) + " " + ipdf_StrF((-#PDF_FONTSUT/1000*pdfFontSizePt)*2,2) + " re f"
  Else
    ProcedureReturn ipdf_StrF(x*pdfK,2) + " " + ipdf_StrF((pdfH-(y-#PDF_FONTSUP/1000*pdfFontSize))*pdfK,2) + " " + ipdf_StrF(vWidth*pdfK,2) + " " + ipdf_StrF(-#PDF_FONTSUT/1000*pdfFontSizePt,2) + " re f"
  EndIf
EndProcedure 

Procedure ipdf_NewObj() ;Begin a new object.
  SelectElement(Offsets(), pdfN - 1)
  pdfN = pdfN + 1
  AddElement(Offsets())    
  SelectElement(Offsets(), pdfN - 1)
  Offsets() = pdfBuffer\lCurSize 
  ipdf_Out(Str(pdfN) + " 0 obj")
EndProcedure

Procedure ipdf_EndPage() ;End of page contents.
  ForEach pEndPage()
    pdf_CallFunction(pEndPage())
  Next
  pdfState = 1
EndProcedure

Procedure ipdf_BeginPage(Orientation$,Format$)
  AddElement(Pages())
  pdfPage = ListSize(Pages())
  If MEM_DataInit(Pages()\PMem,#PDF_MEMBLOCKMINSIZE) = #False
    pdfError = #PDF_ERROR_OUT_OF_MEMORY
    ProcedureReturn #False
  EndIf
  Pages()\OrientationChanges = #False
  pdfState = 2
  pdfX = pdfLMargin
  pdfY = pdfTMargin
  pdfFontFamily$ = ""
  ;Page format
  If Trim(Format$)<>""
    pdfFwPt = ValF(StringField(Format$, 1, ","))
    pdfFhPt = ValF(StringField(Format$, 2, ","))      
    pdfFw = pdfFwPt/pdfK
    pdfFh = pdfFhPt/pdfK
    Pages()\OrientationChanges = #True
    Orientation$=UCase(Orientation$)
    If (Orientation$ ="L" Or Orientation$ = "LANDSCAPE")
      pdfDefOrientation$="L"
      pdfWPt = pdfFhPt
      pdfHPt = pdfFwPt
    Else
      pdfDefOrientation$="P"
      pdfWPt = pdfFwPt
      pdfHPt = pdfFhPt 
    EndIf 
    pdfCurOrientation$ = pdfDefOrientation$
    pdfW = pdfWPt/pdfK
    pdfH = pdfHPt/pdfK
  EndIf
  
  If Trim(Orientation$) = ""
    Orientation$ = pdfDefOrientation$
  Else
    Orientation$ = Left(UCase(Orientation$),1)
    If Orientation$ <> pdfDefOrientation$
      Pages()\OrientationChanges = #True
    EndIf
  EndIf
  
  If (Orientation$ <> pdfCurOrientation$)
    ; Change orientation
    If Orientation$ = "P"
      pdfWPt = pdfFwPt
      pdfHPt = pdfFhPt
      pdfW = pdfFw
      pdfH = pdfFh
    Else
      pdfWPt = pdfFhPt
      pdfHPt = pdfFwPt
      pdfW = pdfFh
      pdfH = pdfFw    
    EndIf
    pdfPageBreakTrigger = pdfH - pdfBMargin    
    pdfCurOrientation$ = Orientation$
  EndIf
  
  Pages()\pdfWPt=pdfWPt
  Pages()\pdfHPt=pdfHPt
  
  ProcedureReturn #True
EndProcedure

Procedure ipdf_BeginDoc()
  pdfState = 1  
  ipdf_Out("%PDF-1.3")
EndProcedure

Procedure ipdf_PutTrailer()
  ipdf_Out("/Size " + Str(pdfN + 1))
  ipdf_Out("/Root " + Str(pdfN) + " 0 R")  
  ipdf_Out("/Info " + Str(pdfN - 1) + " 0 R") 
  ;If encrypted
    ;$this->_out('/Encrypt '.$this->enc_obj_id.' 0 R'); 
  ;  ipdf_Out("/Encrypt " + Str(enc_obj_id) + " 0 R") 
    ;$this->_out('/ID [()()]'); 
  ;  ipdf_Out("/ID [()()]") 
  ;EndIf 
EndProcedure

Procedure ipdf_PutCatalog()
  ipdf_Out("/Type /Catalog")
  ipdf_Out("/Pages 1 0 R")
  
  If pdfOBJNames
    ipdf_Out("/Names "+Str(pdfOBJNames)+" 0 R")
  EndIf
  
  Select pdfZoomMode
    Case #PDF_ZOOM_FULLPAGE
      ipdf_Out("/OpenAction [3 0 R /Fit]")
    Case #PDF_ZOOM_FULLWIDTH
      ipdf_Out("/OpenAction [3 0 R /FitH null]")
    Case #PDF_ZOOM_REAL
      ipdf_Out("/OpenAction [3 0 R /XYZ null null 1]")
    Case #PDF_ZOOM_FULLSCREEN    ; <-- luis
      ipdf_Out("/PageMode/FullScreen")  ; <-- luis
    Default:
      ipdf_Out("/OpenAction [3 0 R /XYZ null null " + ipdf_StrF(pdfZoomMode/100,2) +  "]")
  EndSelect    
  ipdf_Out("/PageLayout " + pdfLayoutMode$)
  ForEach pPutCatalog()    
    pdf_CallFunction(pPutCatalog())
  Next
EndProcedure
Procedure ipdf_putextgstates()

EndProcedure

Procedure ipdf_PutFonts()
  Protected tempfontname$,HexData$,ZIP,i,j,FontWidth,FontDescriptor,CIDToGIDMap,Glyph,Width
  Protected packmem.MEM_DataStructure,ASCII85.MEM_DataStructure
  Protected fontembed=#True
  
  ;Font Data
  ForEach FontList()
    If fontembed
      ipdf_NewObj()
      FontList()\pdfN=pdfN
      ipdf_Out("<<")
      ZIP=0
      If pCompress
        packmem\pData=FontList()\Buffer
        packmem\lMaxSize=FontList()\Buflen
        packmem\lCurSize=FontList()\Buflen
        ZIP=pdf_CallFunction(pCompress,packmem)
        If ZIP
          ;Store encoded data
          ;FreeMemory(FontList()\Buffer)
          ipdf_Out("/Filter /FlateDecode")
          ipdf_Out("/Length "+Str(packmem\lCurSize+2))
          ipdf_Out("/Length1 "+Str(FontList()\Buflen))
          FontList()\Buffer=packmem\pData
          FontList()\Buflen=packmem\lCurSize+2
          ipdf_Out(">>")
          ipdf_PutStream(packmem)
        EndIf
      EndIf
      If Not ZIP
        ;encode with ASCII85
        ASCII85\pData=FontList()\Buffer
        ASCII85\lCurSize=FontList()\Buflen
        ASCII85\lMaxSize=FontList()\Buflen
        ipdf_ASCII85_Encode(ASCII85)
        FontList()\Buffer=ASCII85\pData
        ipdf_Out("/Filter /ASCII85Decode")
        ipdf_Out("/Length "+Str(ASCII85\lCurSize))
        ipdf_Out("/Length1 "+Str(FontList()\Buflen))
        ipdf_Out(">>")
        ipdf_PutStream(ASCII85)
      EndIf
      ipdf_Out("endobj")
    Else
      FontList()\pdfN=-1
    EndIf
    FreeMemory(FontList()\Buffer) ; Free memory of FontData
    FontList()\Buffer=0
  Next
  
  ForEach Fonts()
    tempfontname$=ReplaceString(Fonts()\Name$," ","#20")
    If Fonts()\Fontembed
      If Fonts()\unicode
        ipdf_NewObj()
        CIDToGIDMap=pdfN
        ;cidtogidmap
        ipdf_Out("<<")
        ZIP=0
        If pCompress
          packmem\pData=Fonts()\cidtogidmap
          packmem\lMaxSize=256*256*2
          packmem\lCurSize=256*256*2
          ZIP=pdf_CallFunction(pCompress,packmem)
          If ZIP
            ;Store encoded data
            ;FreeMemory(Fonts()\cidtogidmap)
            ipdf_Out("/Filter /FlateDecode")
            ipdf_Out("/Length "+Str(packmem\lCurSize+2))
            ipdf_Out("/Length1 "+Str(256*256*2))
            Fonts()\cidtogidmap=packmem\pData
            ipdf_Out(">>")
            ipdf_PutStream(packmem)
          EndIf
        EndIf
        If Not ZIP
          ;encode with ASCII85
          ASCII85\pData=Fonts()\cidtogidmap
          ASCII85\lCurSize=256*256*2
          ASCII85\lMaxSize=256*256*2
          ipdf_ASCII85_Encode(ASCII85)
          Fonts()\cidtogidmap=ASCII85\pData
          ipdf_Out("/Filter /ASCII85Decode")
          ipdf_Out("/Length "+Str(ASCII85\lCurSize))
          ipdf_Out("/Length1 "+Str(256*256*2))
          ipdf_Out(">>")
          ipdf_PutStream(ASCII85)
        EndIf
        ipdf_Out("endobj")
      Else
        ;Font-Width
        ipdf_NewObj()
        FontWidth=pdfN
        HexData$="["
        If Fonts()\cidtogidmap
          For i=0 To 255
            Glyph=ipdf_EndianW(Fonts()\cidtogidmap\segment[i])&$FFFF
            Width=Fonts()\glyph_list(Glyph)\scaledwidth
            HexData$+StrU(Width,#PB_Word)+" "
          Next
        EndIf
        HexData$+"]"
        ipdf_Out(HexData$)
        ipdf_Out("endobj")
      EndIf
    EndIf
    
    If Fonts()\Fontembed
      ;Embedded font
      ipdf_NewObj()
      Fonts()\N = pdfN
      If Fonts()\unicode
        ; Page 279
        ipdf_Out("<</Type /Font")
        ipdf_Out("/Subtype /Type0")
        ipdf_Out("/BaseFont /"+tempfontname$+"-UCS")
        ipdf_Out("/Encoding /Identity-H")
        ipdf_Out("/DescendantFonts ["+Str(pdfN+1)+" 0 R]")
        ipdf_Out("/ToUnicode "+Str(pdfN+2)+" 0 R") 
        ipdf_Out(">>")
        ipdf_Out("endobj")
        
        ipdf_NewObj()
        ; PDF-Reference : PDF32000_2008.pdf page 269
        ipdf_Out("<</Type /Font")
        ipdf_Out("/Subtype /CIDFontType2")
        ipdf_Out("/BaseFont /"+tempfontname$)
        ipdf_Out("/CIDSystemInfo <</Registry (Adobe) /Ordering (UCS) /Supplement 0>>")
        ipdf_Out("/FontDescriptor "+Str(pdfN+2)+" 0 R")
        ; Font-Width
        HexData$="/W ["
        For i=0 To fonts()\numglyphs-1
          ForEach Fonts()\glyph_list(i)\char_no()
            HexData$+StrU(Fonts()\glyph_list(i)\char_no(),#PB_Long)+" ["+StrU(Fonts()\glyph_list(i)\scaledwidth,#PB_Long)+"] "
          Next
        Next
        HexData$+"]"
        ipdf_Out(HexData$)
        ipdf_Out("/CIDToGIDMap "+Str(CIDToGIDMap)+" 0 R")
        ipdf_Out(">>")
        ipdf_Out("endobj")
        
        ipdf_NewObj()
        ipdf_Out("<<")
        ipdf_Out("/Length 345")
        ipdf_Out(">>")        
        ipdf_Out("stream")
        ipdf_Out("/CIDInit /ProcSet findresource begin")
        ipdf_Out("12 dict begin")
        ipdf_Out("begincmap")
        ipdf_Out("/CIDSystemInfo")
        ipdf_Out("<</Registry (Adobe)")
        ipdf_Out("/Ordering (UCS)")
        ipdf_Out("/Supplement 0")
        ipdf_Out(">> def")
        ipdf_Out("/CMapName /Adobe-Identity-UCS def")
        ipdf_Out("/CMapType 2 def")
        ipdf_Out("1 begincodespacerange")
        ipdf_Out("<0000> <FFFF>")
        ipdf_Out("endcodespacerange")
        ipdf_Out("1 beginbfrange")
        ipdf_Out("<0000> <FFFF> <0000>")
        ipdf_Out("endbfrange")
        ipdf_Out("endcmap")
        ipdf_Out("CMapName currentdict /CMap defineresource pop")
        ipdf_Out("end")
        ipdf_Out("end")
        ipdf_Out("endstream")
        ipdf_Out("endobj")
      Else
        ipdf_Out("<</Type /Font")
        ipdf_Out("/Subtype /TrueType")
        ipdf_Out("/Name /F" + Str(Fonts()\FontN))
        ipdf_Out("/BaseFont /"+tempfontname$)
        ipdf_Out("/Encoding /WinAnsiEncoding")
        ipdf_Out("/FirstChar 0")
        ipdf_Out("/LastChar 255")
        ipdf_Out("/Widths " + Str(FontWidth) + " 0 R")
        ipdf_Out("/FontDescriptor " + Str(pdfN+1) + " 0 R")
        ipdf_Out(">>")
        ipdf_Out("endobj")
      EndIf
      ;Font Descriptor
      ipdf_NewObj()
      FontDescriptor=pdfN
      ipdf_Out("<</Type /FontDescriptor")
      ipdf_Out("/FontName /"+tempfontname$)
      ipdf_Out("/Ascent "+Str(Fonts()\Ascent))
      ipdf_Out("/Descent "+Str(Fonts()\Descent))
      ipdf_Out("/CapHeight "+Str(Fonts()\CapHeight))
      ;Font flags :
      ;Bit-Position   Name
      ;1  1           FixedPitch
      ;2  2           Serif
      ;3  4           Symbolic
      ;4  8           Script
      ;6  32          Nonsymbolic
      ;7  64          Italic
      ;17 65536       AllCap
      ;18 131072      SmallCap
      ;19 262144      ForceBold
      ipdf_Out("/Flags 4")
      ipdf_Out("/FontBBox ["+Str(Fonts()\bbox[0])+" "+Str(Fonts()\bbox[1])+" "+Str(Fonts()\bbox[2])+" "+Str(Fonts()\bbox[3])+"]")
      ipdf_Out("/ItalicAngle "+ipdf_StrF(Fonts()\ItalicAngle,2))
      ipdf_Out("/StemV "+Str(Fonts()\StemV))
      ipdf_Out("/MissingWidth "+Str(Fonts()\glyph_list(0)\scaledwidth))
      If FontList()\pdfN<>-1
        ForEach FontList()
          If UCase(FontList()\Name$)=UCase(Fonts()\Name$)
            ipdf_Out("/FontFile2 " + Str(FontList()\pdfN) + " 0 R")
            Break
          EndIf
        Next
      EndIf
      ipdf_Out(">>")
      ipdf_Out("endobj")
    Else
      ;Standard font
      ipdf_NewObj()
      Fonts()\N = pdfN
      ipdf_Out("<</Type /Font")
      ipdf_Out("/BaseFont /" + tempfontname$)
      ipdf_Out("/Subtype /Type1")
      If (Fonts()\Name$<> #PDF_FONT_SYMBOL And Fonts()\Name$<> #PDF_FONT_ZAPFDINGBATS)
        ipdf_Out("/Encoding /WinAnsiEncoding")
      EndIf
      ipdf_Out(">>")
      ipdf_Out("endobj")
    EndIf
    If Fonts()\cidtogidmap
      FreeMemory(Fonts()\cidtogidmap) ; Release cidtogidmap memory
      Fonts()\cidtogidmap=0
    EndIf
  Next
EndProcedure

Procedure ipdf_PutFiles()
  Protected ZIP,packmem.MEM_DataStructure,ASCII85.MEM_DataStructure,Kids
  
  ;Debug "ipdf_PutFiles()"
  
  ForEach FileList()
    ipdf_NewObj()
    FileList()\pdfN=pdfN
    ipdf_Out("<</F("+FileList()\Name$+")/EF<</F "+Str(pdfN+1)+" 0 R>>/Desc ("+FileList()\Desc$+")/Type/Filespec>>")
    ipdf_Out("endobj")
    ipdf_NewObj()
    ipdf_Out("<</Type/EmbeddedFile/Params<<")
    ipdf_Out("/Size "+Str(FileList()\Buflen))
    ipdf_Out("/CreationDate ("+FileList()\CreationDate$+")")
    ipdf_Out("/ModDate ("+FileList()\ModDate$+")")
    ipdf_Out(">>")
    ZIP=0
    If pCompress
      packmem\pData=FileList()\Buffer
      packmem\lMaxSize=FileList()\Buflen
      packmem\lCurSize=FileList()\Buflen
      ZIP=pdf_CallFunction(pCompress,packmem)
      If ZIP
        ;Store encoded data
        ;FreeMemory(FileList()\Buffer)
        ipdf_Out("/Length "+Str(packmem\lCurSize+2))
        ;ipdf_Out("/Length1 "+Str(FileList()\Buflen))
        FileList()\Buffer=packmem\pData
        FileList()\Buflen=packmem\lCurSize+2
        ipdf_Out("/Filter/FlateDecode")
        ipdf_Out(">>")
        ipdf_PutStream(packmem)
        ZIP=1
      EndIf
    EndIf
    If Not ZIP
      ;encode with ASCII85
      ASCII85\pData=FileList()\Buffer
      ASCII85\lCurSize=FileList()\Buflen
      ASCII85\lMaxSize=FileList()\Buflen
      ipdf_ASCII85_Encode(ASCII85)
      FileList()\Buffer=ASCII85\pData
      ipdf_Out("/Length "+Str(ASCII85\lCurSize))
      ;ipdf_Out("/Length1 "+Str(FileList()\Buflen))
      ipdf_Out("/Filter/ASCII85Decode")
      ipdf_Out(">>")
      ipdf_PutStream(ASCII85)
    EndIf
    ipdf_Out("endobj")
    If FileList()\Buffer
      FreeMemory(FileList()\Buffer)
    EndIf
  Next
  
  ;Names
  If ListSize(FileList())
    ipdf_NewObj()
    Kids=pdfN
    ipdf_Out("<</Kids ["+Str(pdfN+1)+" 0 R]>>")
    ipdf_Out("endobj")
    
    ipdf_NewObj()
    ipdf_Out("<<")
    ipdf_Out("/Names [")
    ForEach FileList()
      ipdf_Out("("+FileList()\Name$+") "+Str(FileList()\pdfN)+" 0 R")
    Next
    ipdf_Out("]")
    ipdf_Out("/Limits [")
    FirstElement(FileList())
    ipdf_Out("("+FileList()\Name$+")")
    LastElement(FileList())
    ipdf_Out("("+FileList()\Name$+")")
    ipdf_Out("]")
    ipdf_Out(">>")
    ipdf_Out("endobj")
    
    ipdf_NewObj()
    pdfOBJNames=pdfN
    ipdf_Out("<</EmbeddedFiles "+Str(Kids)+" 0 R>>")
    ipdf_Out("endobj")
  EndIf
EndProcedure

Procedure ipdf_EmbedFile(Filename$,Description$="")
  Protected *Filebuffer,FileLength,File,fileobject
  
  If FileSize(Filename$)>0
    File=ReadFile(#PB_Any,Filename$)
    If File
      FileLength=Lof(File)
      *Filebuffer=AllocateMemory(FileLength)
      ReadData(File,*Filebuffer,FileLength)
      CloseFile(File)
    EndIf
  EndIf
  
  If Not *Filebuffer
    pdfError = #PDF_ERROR_FILE_OPEN_ERROR
    ProcedureReturn #False
  EndIf
  
  AddElement(FileList())
  
  FileList()\Name$  = ipdf_Escape(GetFilePart(Filename$))
  FileList()\Desc$  = ipdf_Escape(Description$)
  FileList()\CreationDate$ = FormatDate("D:%yyyy%mm%dd%hh%ii%ssZ",GetFileDate(Filename$, #PB_Date_Created))
  FileList()\ModDate$ = FormatDate("D:%yyyy%mm%dd%hh%ii%ssZ",GetFileDate(Filename$, #PB_Date_Modified))
  FileList()\Buffer = *Filebuffer
  FileList()\Buflen = FileLength
  FileList()\pdfN   = 0
  
  ProcedureReturn ListSize(FileList())
EndProcedure

Procedure ipdf_SetFontData(FontName$,Style$,FontKey$)
  Protected vCharWidth,vDefault,vStyle,vFound,Font,hDC,Mem,Len,j, fontNS$
  
  AddElement(Fonts())
  Fonts()\FontN = ListSize(Fonts())
  Fonts()\FontKey$ = FontKey$
  Fonts()\Style$ = Style$
  vDefault = #False
  
  fontNS$=UCase(FontName$+Style$)         
  Select fontNS$
    Case "COURIER"
      Fonts()\Name$ = #PDF_FONT_COURIER
      vDefault = #True
    Case "COURIERB"
      Fonts()\Name$ = #PDF_FONT_COURIERB
      vDefault = #True
    Case "COURIERI"
      Fonts()\Name$ = #PDF_FONT_COURIERI
      vDefault = #True
    Case "COURIERBI"
      Fonts()\Name$ = #PDF_FONT_COURIERBI
      vDefault = #True                  
    Case "HELVETICA"  
      Fonts()\Name$ = #PDF_FONT_HELVETICA
      Restore Helvetica                      
    Case "HELVETICAB"  
      Fonts()\Name$ = #PDF_FONT_HELVETICAB
      Restore HelveticaB
    Case "HELVETICAI"  
      Fonts()\Name$ = #PDF_FONT_HELVETICAI
      Restore HelveticaI     
    Case "HELVETICABI"  
      Fonts()\Name$ = #PDF_FONT_HELVETICABI
      Restore HelveticaBI 
    Case "ZAPFDINGBATS"  
      Fonts()\Name$ = #PDF_FONT_ZAPFDINGBATS
      Restore Zapfdingbats   
    Case "TIMES"  
      Fonts()\Name$ = #PDF_FONT_TIMES
      Restore Times
    Case "TIMESI"  
      Fonts()\Name$ = #PDF_FONT_TIMESI
      Restore TimesI    
    Case "TIMESBI"  
      Fonts()\Name$ = #PDF_FONT_TIMESBI
      Restore TimesBI      
    Case "TIMESB"  
      Fonts()\Name$ = #PDF_FONT_TIMESB
      Restore TimesB   
    Case "SYMBOL"  
      Fonts()\Name$ = #PDF_FONT_SYMBOL
      Restore Symbol
    Default ; Font is unknown = Font embedding
      CompilerIf #PB_Compiler_OS=#PB_OS_Windows
        vDefault = 3
      CompilerElse
        Fonts()\Name$ = #PDF_FONT_COURIER
        vDefault = #True
      CompilerEndIf
  EndSelect
  
  Select vDefault
    Case #True
      For j = 0 To 255  
        Fonts()\CharWidth[j] = 600
      Next
      Fonts()\FontEmbed=0
    Case #False
      For j = 0 To 255
        ;Read.w vCharWidth
        m_read ; use macro for different pb versions !
        Fonts()\CharWidth[j] = vCharWidth
      Next
      Fonts()\FontEmbed=0
      CompilerIf #PB_Compiler_OS=#PB_OS_Windows
      Case 3 ; Embed the Font
        Protected *cmap.TTF_cmap_Header,*head.TTF_head_Header
        Protected *hhea.TTF_hhea_Header,*hmtx.TTF_longhormetric
        Protected *maxp.TTF_maxp_Header,*name.TTF_name_Header
        Protected *post.TTF_post_Header
        Protected *cidtogidmap,i,post_format.d,nChars,*TextFace
        
        vStyle=0
        Select Style$
          Case "B"
            vStyle|#PB_Font_Bold
          Case "I"
            vStyle|#PB_Font_Italic
          Case "BI","IB"
            vStyle|#PB_Font_Bold|#PB_Font_Italic
        EndSelect
        
        If pdfUnderline
          vStyle|#PB_Font_Underline
        EndIf
        
        Font=LoadFont(#PB_Any,FontName$,750,vStyle)
        If Font
          hDC=CreateDC_("DISPLAY",#Null,#Null,#Null)
          If hDC
            SelectObject_(hDC,FontID(Font))
            
            nChars=GetTextFace_(hDC,0,0)
            If nChars>0
              *TextFace=AllocateMemory(nChars*SizeOf(Character))
              If *TextFace
                If GetTextFace_(hDC,nChars,*TextFace)
                  FontName$=PeekS(*TextFace,nChars)
                EndIf
                FreeMemory(*TextFace)
              EndIf
            EndIf
            Fonts()\FontEmbed=1
            Fonts()\Name$ = FontName$
            vFound=#False
            ForEach FontList()
              If FontList()\Name$ = FontName$
                If FontList()\vStyle = vStyle
                  vFound=#True
                  Break
                EndIf
              EndIf
            Next
            
            ; if Font is not already defined load it into memory
            If vFound=#False
              Mem=0:Len=0
              If ipdf_Get_Font(hDC,@Mem,@Len)
                AddElement(FontList())
                FontList()\Name$  = Fonts()\Name$
                FontList()\Buffer = Mem
                FontList()\Buflen = Len
                FontList()\pdfN   = 0
                FontList()\vStyle = vStyle
                ;-* Try to get TTF-Metrics and check for Unicode font
                ;Debug "Fontname="+FontList()\Name$
                *cmap=ipdf_TTF_SearchTagName(FontList()\Buffer,"cmap")
                *head=ipdf_TTF_SearchTagName(FontList()\Buffer,"head")
                *hhea=ipdf_TTF_SearchTagName(FontList()\Buffer,"hhea")
                *hmtx=ipdf_TTF_SearchTagName(FontList()\Buffer,"hmtx")
                *maxp=ipdf_TTF_SearchTagName(FontList()\Buffer,"maxp")
                *name=ipdf_TTF_SearchTagName(FontList()\Buffer,"name")
                *post=ipdf_TTF_SearchTagName(FontList()\Buffer,"post")
                If *cmap And *head And *hhea And *hmtx And *maxp And *name
                  Fonts()\numglyphs=ipdf_EndianW(*maxp\numGlyphs)&$FFFF
                  Fonts()\n_hmetrics=ipdf_EndianW(*hhea\numberOfHMetrics)&$FFFF
                  If ipdf_TTF_Handle_Head(Fonts(),*head)
                    ReDim Fonts()\glyph_list(Fonts()\numglyphs-1)
                    For i=0 To Fonts()\numglyphs-1
                      ;glyph 0 = .notdef
                      ;glyph 1 = .null
                      ;Fonts()\glyph_list(i)\char_no=-1
                      Fonts()\glyph_list(i)\flags=#GF_FLOAT|#GF_USED
                    Next
                    If ipdf_TTF_Searchcmap(Fonts()\glyph_list(),*cmap,Fonts()\numglyphs,Fontlist()\Buffer,Fontlist()\Buflen,-1,1,4)
                      If #PB_Compiler_Unicode
                        Fonts()\unicode=#True
                      EndIf
                    EndIf
                    ipdf_TTF_Searchhmtx(Fonts(),*hmtx)
                    Fonts()\cidtogidmap=ipdf_TTF_Create_cidtogidmap(Fonts()\glyph_list())
                    Fonts()\Ascent=ipdf_TTF_iscale(Fonts()\unitsPerEm,ipdf_EndianW(*hhea\Ascent))
                    Fonts()\Descent=ipdf_TTF_iscale(Fonts()\unitsPerEm,ipdf_EndianW(*hhea\Descent))
                    Fonts()\CapHeight=Fonts()\Ascent
                    If *post=0
                      Fonts()\ItalicAngle=0
                    Else
                      post_format=ipdf_EndianW(*post\format\fract)+Int(ipdf_EndianW(*post\format\Value)/65536)
                      ;Debug post_format
                      Fonts()\ItalicAngle=ipdf_EndianW(*post\italicAngle\fract)+Int(ipdf_EndianW(*post\italicAngle\Value)/65536)
                    EndIf
                    Fonts()\StemV=0
                    Fonts()\Subfamily$=ipdf_TTF_Handle_Name(Fonts(),*name,1,0,0,2)
                    If Len(Fonts()\Subfamily$)=0
                      Fonts()\Subfamily$=ipdf_TTF_Handle_Name(Fonts(),*name,3,1,1033,2)
                    EndIf
                    If FindString(LCase(Fonts()\Subfamily$),"bold",1) Or FindString(LCase(Fonts()\Subfamily$),"black",1)
                      Fonts()\StemV=120
                    Else
                      Fonts()\StemV=70
                    EndIf
                  EndIf
                EndIf
              EndIf
            EndIf
            DeleteDC_(hDC)
          EndIf
          FreeFont(Font)
        EndIf
      CompilerEndIf
  EndSelect
EndProcedure

Procedure ipdf_PutInfo()
  Protected MEM.MEM_DataStructure
  If ipdf_EscapeU("/Producer (",")",#PUREPDF_VERSION,MEM,#True)
    ipdf_OutStream(MEM)
    FreeMemory(MEM\pData)
  EndIf
  If Trim(pdfTitle$) <> ""
    If ipdf_EscapeU("/Title (",")",pdfTitle$,MEM,#True)
      ipdf_OutStream(MEM)
      FreeMemory(MEM\pData)
    EndIf
  EndIf
  If Trim(pdfSubject$) <> ""
    If ipdf_EscapeU("/Subject (",")",pdfSubject$,MEM,#True)
      ipdf_OutStream(MEM)
      FreeMemory(MEM\pData)
    EndIf
  EndIf
  If Trim(pdfAuthor$) <> ""
    If ipdf_EscapeU("/Author (",")",pdfAuthor$,MEM,#True)
      ipdf_OutStream(MEM)
      FreeMemory(MEM\pData)
    EndIf
  EndIf
  If Trim(pdfKeywords$) <> ""
    If ipdf_EscapeU("/Keywords (",")",pdfKeywords$,MEM,#True)
      ipdf_OutStream(MEM)
      FreeMemory(MEM\pData)
    EndIf
  EndIf
  If Trim(pdfCreator$) <> ""
    If ipdf_EscapeU("/Creator (",")",pdfCreator$,MEM,#True)
      ipdf_OutStream(MEM)
      FreeMemory(MEM\pData)
    EndIf
  EndIf
  ipdf_Out("/CreationDate (D:" + FormatDate("%yyyy%mm%dd%hh%ii%ss", Date())+")")
EndProcedure

Procedure ipdf_PutImages()
  Protected packmem.MEM_DataStructure,ZIP
  
  ForEach Images()
    Debug "Image="+Str(ListIndex(Images()))+":pData="+Str(Images()\Datapic\pData)+" Size="+Str(Images()\Datapic\lCurSize)
    If pdfError=0
      ipdf_NewObj()
      Images()\N = pdfN
      ipdf_Out("<</Type /XObject")
      If Images()\Filter="WMF"
        ipdf_Out("/Subtype /Form")
        ipdf_Out("/BBox ["+Str(Images()\x)+" "+Str(Images()\y)+" "+Str(Images()\Width+Images()\x)+" "+Str(Images()\Height+Images()\y)+"]") ; <- change here
        If pCompress
          packmem\pData=Images()\Datapic\pData
          packmem\lMaxSize=Images()\Datapic\lMaxSize
          packmem\lCurSize=Images()\Datapic\lCurSize
          ZIP=pdf_CallFunction(pCompress,packmem)
          If ZIP
            Images()\Datapic\pData=packmem\pData
            Images()\Datapic\lMaxSize=packmem\lMaxSize
            Images()\Datapic\lCurSize=packmem\lCurSize
            ipdf_Out("/Filter /FlateDecode")
          EndIf
        EndIf
        ipdf_Out("/Length "+Str(Images()\Datapic\lCurSize) + ">>")
        ipdf_PutStream(Images()\Datapic)
        ipdf_Out("endobj")
      Else
        ipdf_Out("/Subtype /Image")
        ipdf_Out("/Width " + Str(Images()\Width))
        ipdf_Out("/Height " + Str(Images()\Height))
        If Images()\ColSpace = "Indexed"
          ipdf_Out("/ColorSpace [/Indexed /DeviceRGB " + Str(Images()\Pal\lCurSize/3 - 1) + " " + Str(pdfN + 1) + " 0 R]")            
        Else  
          ipdf_Out("/ColorSpace /" + Images()\ColSpace)
          If Images()\ColSpace = "DeviceCMYK"
            ipdf_Out("/Decode [1 0 1 0 1 0 1 0]")
          EndIf
        EndIf
        ipdf_Out("/BitsPerComponent " + Str(Images()\Bpc))
        ipdf_Out("/Filter /" + Images()\Filter)
        If Images()\Parms <> ""
          ipdf_Out(Images()\Parms)
        EndIf
        ipdf_Out("/Length "+Str(Images()\Datapic\lCurSize) + ">>")
        ipdf_PutStream(Images()\Datapic)
        If pdfError<>0
          Debug "pdfError="+Str(pdfError)
          CallDebugger
          Break
        EndIf
        ipdf_Out("endobj")
        ;Palette
        If(Images()\ColSpace="Indexed")
          ipdf_NewObj()
          ipdf_Out("<<"+"/Length "+Str(Images()\Pal\lCurSize)+">>")     
          ipdf_PutStream(Images()\Pal)
          ipdf_Out("endobj")
        EndIf
		ipdf_NewObj()
		ipdf_Out("<</BBox "+Str(Images()\N)+" 0 R /Height "+StrF(Images()\height)+"/O/Layout/Width "+StrF(Images()\Width)+">>") ; <- change here
		ipdf_Out("endobj")
      EndIf
    Else
      Debug "pdfError="+Str(pdfError)
      CallDebugger
    EndIf
    If Images()\Pal\pData
      FreeMemory(Images()\Pal\pData)
      Images()\Pal\pData=0
    EndIf
    If Images()\Datapic\pData
      FreeMemory(Images()\Datapic\pData)
      Images()\Datapic\pData=0
    EndIf
	If images()\ActualText
	ipdf_ActualText(Images()\N,images()\ActualText)
	EndIf
  Next
EndProcedure

Procedure ipdf_PutResources()
  ipdf_putextgstates()
  ipdf_PutFonts()
  ipdf_PutImages()
  ;Resource dictionary
  SelectElement(Offsets(),1)
  Offsets() = pdfBuffer\lCurSize
  ipdf_Out("2 0 obj")
  ipdf_Out("<<")
  ipdf_Out("/ProcSet [/PDF /Text /ImageB /ImageC /ImageI]")
  ipdf_Out("/Font <<")
  ForEach Fonts()
    ipdf_Out("/F" + Str(Fonts()\FontN) + " " + Str(Fonts()\N) + " 0 R")
  Next
  ipdf_Out(">>")
  If (ListSize(Images()) > 0)
    ipdf_Out("/XObject <<")
    ForEach Images()
      If Images()\Filter="WMF"
        ipdf_Out("/FO" + Str(Images()\ImageN) + " " + Str(Images()\N) + " 0 R")
      Else
        ipdf_Out("/I" + Str(Images()\ImageN) + " " + Str(Images()\N) + " 0 R")
      EndIf
    Next
    ipdf_Out(">>")
  EndIf  
  ipdf_Out(">>")
  ipdf_Out("endobj")   
  
  ForEach pPutResources()    
    pdf_CallFunction(pPutResources())
  Next
EndProcedure

Procedure ipdf_PutPages()
  Protected i,lsAnnots.s,lsRect.s,lsKids.s,lh.f,lsFilter.s,MEM.MEM_DataStructure
  
  If (pdfAliasNbPages$ <> "")
    ; Replace number of pages
    ForEach Pages()
      MEM_DataReplace(Pages()\PMem, pdfAliasNbPages$, Str(ListSize(Pages())))
    Next
  EndIf
  
  If (pdfDefOrientation$="P")
    pdfwPt = pdfFwPt
    pdfhPt = pdfFhPt
  Else
    pdfwPt = pdfFhPt
    pdfhPt = pdfFwPt
  EndIf
  
  ;put PopUp actions
  ForEach PageLinks()
    lsAnnots = ""
    If PageLinks()\Type=#PDF_POPUP_ACTIONS
      ipdf_NewObj()
      PageLinks()\pdfN = pdfN
      lsAnnots = "<</Type /Annot /Subtype /Popup /Rect ["
      lsAnnots + ipdf_StrF(PageLinks()\fA0,2) + " " + ipdf_StrF(PageLinks()\fA1,2) + " "
      lsAnnots + ipdf_StrF(PageLinks()\fA0 + PageLinks()\w,2) + " " + ipdf_StrF((PageLinks()\fA1 - PageLinks()\h),2)
      lsAnnots + "] "
      lsAnnots + "/F "+StrU(PageLinks()\Flags,#PB_Long)+" "
      lsAnnots + "/Parent "+Str(PageLinks()\pdfN+1)+" 0 R"
      lsAnnots + ">>" + #PDF_NEWLINE
      lsAnnots + "endobj"
      ipdf_Out(lsAnnots)
      ipdf_NewObj()
      lsAnnots = "<</Type /Annot /Subtype /Text /Rect ["
      lsAnnots + ipdf_StrF(PageLinks()\fA0,2) + " " + ipdf_StrF(PageLinks()\fA1 - PageLinks()\fA3,2) + " "
      lsAnnots + ipdf_StrF(PageLinks()\fA0 + PageLinks()\fA2,2) + " " + ipdf_StrF(PageLinks()\fA1,2)
      lsAnnots + "] "
      lsAnnots + "/Name /"+PageLinks()\Option1$+" "
      ;lsAnnots + "/C [1 1 0] "
      lsAnnots + "/F "+StrU(PageLinks()\Flags,#PB_Long)+" "
      lsAnnots + "/Popup "+Str(PageLinks()\pdfN)+" 0 R "
      lsAnnots + "/T "+ipdf_TextString(PageLinks()\Option3$)+" "
      lsAnnots + "/M "+ipdf_TextString(PageLinks()\Option4$)+" "
      lsAnnots + "/Contents " + ipdf_TextString(PageLinks()\Option2$)
      lsAnnots + ">>" + #PDF_NEWLINE
      lsAnnots + "endobj"
      ipdf_Out(lsAnnots)
    EndIf
  Next
  
  lsKids = ""
  ForEach Pages()
    ipdf_NewObj()
    Pages()\pdfN=pdfN
    lsKids + Str(pdfN) + " 0 R "
    ipdf_Out("<</Type /Page")
    ipdf_Out("/Parent 1 0 R")
    ipdf_Out("/MediaBox [0 0 " + ipdf_StrF(Pages()\pdfWPt,2) + " " + ipdf_StrF(Pages()\pdfHPt,2) + "]")
    lh  = pdfH
    ipdf_Out("/Resources 2 0 R")
    lsAnnots = ""
    ForEach PageLinks()
      If (PageLinks()\Page = ListIndex(Pages())+1)
        Select PageLinks()\Type
          Case #PDF_URI_ACTIONS
            lsAnnots+"<</Type /Annot /Subtype /Link /Rect ["
            lsAnnots+ipdf_StrF(PageLinks()\fA0,2)+" "+ipdf_StrF(PageLinks()\fA1,2)+" "
            lsAnnots+ipdf_StrF(PageLinks()\fA0+PageLinks()\fA2,2)+" "+ipdf_StrF(PageLinks()\fA1-PageLinks()\fA3,2)
            lsAnnots+"] /Border [0 0 0] "
            If (Trim(PageLinks()\Option1$) <> "")
              lsAnnots+"/A <</S /URI /URI "+ipdf_TextString(PageLinks()\Option1$)+">>>>"
            Else
              If Pages()\OrientationChanges = #True
                pdfH=pdfWPt
              Else
                pdfH=pdfHPt
              EndIf
              lsAnnots+"/Dest ["+Str(1+2*PageLinks()\DestPage)
              lsAnnots+" 0 R /XYZ 0 "+ipdf_StrF(pdfH-PageLinks()\y*pdfK,2)
              lsAnnots+" null]>>"
            EndIf
            lsAnnots + #PDF_NEWLINE
          Case #PDF_LAUNCH_ACTIONS
            lsAnnots+"<</Type /Annot /Subtype /Link /Rect ["
            lsAnnots+ipdf_StrF(PageLinks()\fA0,2)+" "+ipdf_StrF(PageLinks()\fA1,2)+" "
            lsAnnots+ipdf_StrF(PageLinks()\fA0+PageLinks()\fA2,2)+" "+ipdf_StrF(PageLinks()\fA1-PageLinks()\fA3,2)
            lsAnnots+"] /Border [0 0 0] "
            lsAnnots+"/A <</Type /Action /S /Launch /Win <<"
            lsAnnots+"/F "+ipdf_TextString(PageLinks()\Option1$)
            If PageLinks()\Option2$<>""
              lsAnnots+"/D "+ipdf_TextString(PageLinks()\Option2$)
            EndIf
            If PageLinks()\Option3$<>""
              lsAnnots+"/O "+ipdf_TextString(PageLinks()\Option3$)
            EndIf
            If PageLinks()\Option4$<>""
              lsAnnots+"/P "+ipdf_TextString(PageLinks()\Option4$)
            EndIf
            lsAnnots+">>>>>>" + #PDF_NEWLINE
          Case #PDF_TEXT_ACTIONS
            lsAnnots+"<</Type /Annot /Subtype /Text /Name /"+PageLinks()\Option1$+" /Rect ["
            lsAnnots+ipdf_StrF(PageLinks()\fA0,2)+" "+ipdf_StrF(PageLinks()\fA1 - PageLinks()\fA3,2)+" "
            lsAnnots+ipdf_StrF(PageLinks()\fA0+PageLinks()\fA2,2)+" "+ipdf_StrF(PageLinks()\fA1,2)
            lsAnnots+"] /Border [0 0 0] "
            ;lsAnnots+"/C [1 1 0] "
            lsAnnots+"/Contents "+ipdf_TextString(PageLinks()\Option2$)+" "
            lsAnnots+"/F "+StrU(PageLinks()\Flags,#PB_Long)+" "
            lsAnnots+"/T "+ipdf_TextString(PageLinks()\Option3$)+" "
            lsAnnots+"/M "+ipdf_TextString(PageLinks()\Option4$)+" "
            lsAnnots+">>"+#PDF_NEWLINE
          Case #PDF_POPUP_ACTIONS
            lsAnnots+Str(PageLinks()\pdfN)+" 0 R " + Str(PageLinks()\pdfN+1)+" 0 R" + #PDF_NEWLINE
          Case #PDF_FILE_ACTIONS
            Debug "#PDF_FILE_ACTIONS"
            If PageLinks()\File;-*
              Debug ListSize(FileList())
              Debug PageLinks()\File
              If PageLinks()\File =< ListSize(FileList())
                SelectElement(FileList(),PageLinks()\File-1)
                PageLinks()\FilepdfN=FileList()\pdfN
                ;lsAnnots+"<</Type /Annot /Contents ("+ipdf_Escape(FileList()\Name$)+") "
                ;lsAnnots+"/C [0.25 0.3333328 1] "
                ;lsAnnots+"/Rect ["
                ;lsAnnots+ipdf_StrF(PageLinks()\fA0,2)+" "+ipdf_StrF(PageLinks()\fA1,2)+" "
                ;lsAnnots+ipdf_StrF(PageLinks()\fA0+PageLinks()\fA2,2)+" "+ipdf_StrF(PageLinks()\fA1-PageLinks()\fA3,2)
                ;lsAnnots+ipdf_StrF(PageLinks()\fA0+PageLinks()\fA2,2)+" "+ipdf_StrF(PageLinks()\fA1,2)+" "
                ;lsAnnots+ipdf_StrF(PageLinks()\fA0+PageLinks()\fA2+16,2)+" "+ipdf_StrF(PageLinks()\fA1-PageLinks()\fA3,2)
                ;lsAnnots+"] "
                ;lsAnnots+"/Name /GraphPushPin "
                ;lsAnnots+"/Subtype /FileAttachment "
                ;lsAnnots+"/FS "+Str(PageLinks()\FilepdfN)+" 0 R"
                ;lsAnnots+">>"
                lsAnnots+"<</Type /Annot /Subj ("+PageLinks()\Option1$+") "
                lsAnnots+"/Subtype /FileAttachment /FS "+Str(PageLinks()\FilepdfN)+" 0 R "
                lsAnnots+"/Contents "+ipdf_TextString(PageLinks()\Option2$)+" "
                lsAnnots+"/Name /"+PageLinks()\Option1$+" "
                lsAnnots+"/T "+ipdf_TextString(PageLinks()\Option3$)+" "
                lsAnnots+"/M "+ipdf_TextString(PageLinks()\Option4$)+" "
                lsAnnots+"/Rect ["
                If PageLinks()\x<>-1
                  lsAnnots+ipdf_StrF(PageLinks()\x*pdfK,2)+" "+ipdf_StrF(PageLinks()\fA1,2)+" "
                  lsAnnots+ipdf_StrF(PageLinks()\x*pdfK+PageLinks()\w,2)+" "+ipdf_StrF(PageLinks()\fA1-PageLinks()\h,2)
                Else
                  lsAnnots+ipdf_StrF(PageLinks()\fA0+PageLinks()\fA2,2)+" "+ipdf_StrF(PageLinks()\fA1,2)+" "
                  lsAnnots+ipdf_StrF(PageLinks()\fA0+PageLinks()\fA2+PageLinks()\w,2)+" "+ipdf_StrF(PageLinks()\fA1-PageLinks()\h,2)
                EndIf
                lsAnnots+"] "
                lsAnnots+">>"+#PDF_NEWLINE
              EndIf
            EndIf
        EndSelect
      EndIf
    Next   
    If lsAnnots
      ipdf_Out("/Annots [" + #PDF_NEWLINE + lsAnnots + "]") 
    EndIf
    pdfH = lh
    ipdf_Out("/Contents " + Str(pdfN + 1) + " 0 R>>")
    ipdf_Out("endobj")
    ; Page content
    lsFilter=""
    If pCompress
      MEM\pData    = Pages()\PMem\pData
      MEM\lCurSize = Pages()\PMem\lCurSize
      MEM\lMaxSize = Pages()\PMem\lMaxSize
      If pdf_CallFunction(pCompress,MEM)
        ;FreeMemory(Pages()\pData)
        Pages()\PMem\pData    = MEM\pData
        Pages()\PMem\lCurSize = MEM\lCurSize
        Pages()\PMem\lMaxSize = MEM\lMaxSize
        lsFilter = "/Filter /FlateDecode "
      EndIf
    EndIf
    ipdf_NewObj()
    ipdf_Out("<<" + lsFilter + "/Length " + Str(Pages()\PMem\lCurSize) + ">>")
    ipdf_PutStream(Pages()\PMem)
    ipdf_Out("endobj")
    If Pages()\PMem\pData
      FreeMemory(Pages()\PMem\pData)
    EndIf
  Next
  ; Pages root 
  SelectElement(Offsets(), 0)
  Offsets() = pdfBuffer\lCurSize   
  ipdf_Out("1 0 obj")
  ipdf_Out("<</Type /Pages")
  ipdf_Out("/Kids ["+Trim(lsKids)+"]")
  ipdf_Out("/Count "+Str(ListSize(Pages())))
  ipdf_Out(">>")
  ipdf_Out("endobj") 
EndProcedure

Procedure ipdf_EndDoc()
  Protected i,startxref
  
  ipdf_PutFiles()
  ipdf_PutPages()
  ipdf_PutResources()
  ;Info
  ipdf_NewObj() 
  ipdf_Out("<<")
  ipdf_PutInfo()
  ipdf_Out(">>")
  ipdf_Out("endobj")
  ;Catalog
  ipdf_NewObj()
  ipdf_Out("<<")
  ipdf_PutCatalog()
  ipdf_Out(">>")
  ipdf_Out("endobj")
  ;Cross-ref
  startxref=pdfBuffer\lCurSize
  ipdf_Out("xref")
  ipdf_Out("0 " + Str(pdfN+1))
  ipdf_Out("0000000000 65535 f ")
  For i=1 To pdfN    
    SelectElement(Offsets(), i-1)
    ipdf_Out(RSet(Str(Offsets()), 10, "0") + " 00000 n ")
  Next
  ;Trailer
  ipdf_Out("trailer")
  ipdf_Out("<<")
  ipdf_PutTrailer()
  ipdf_Out(">>")
  ipdf_Out("startxref")
  ipdf_Out(Str(startxref))
  ipdf_Out("%%EOF")
  pdfState=3
  
  ForEach pEndDoc()
    pdf_CallFunction(pEndDoc())
  Next
  pdfOBJNames=0
  ;-* Cleanup
  pdfJavaScript$=""
  ClearList(Pages())
  ClearList(Offsets())
  ClearList(PageLinks())
  ClearList(Fonts())
  ClearList(FontList())
  ClearList(Images())
  ClearList(FileList())
  ClearList(pEndPage())
  ClearList(pPutCatalog())
  ClearList(pPutResources())
  ClearList(pEndDoc())
  ClearList(pdfTOC())
EndProcedure

Procedure ipdf_SetMargins(LeftMargin.f, TopMargin.f, RightMargin.f=-1)
  pdfLMargin = LeftMargin
  pdfTMargin = TopMargin
  If(RightMargin=-1)
    RightMargin = LeftMargin
  EndIf
  pdfRMargin = RightMargin
EndProcedure

Procedure ipdf_SetLeftMargin(LeftMargin.f)
  pdfLMargin = LeftMargin
  If(pdfPage>0 And pdfX<LeftMargin)
    pdfX=LeftMargin
  EndIf
EndProcedure

Procedure ipdf_SetTopMargin(TopMargin.f)
  pdfTMargin = TopMargin
EndProcedure

Procedure ipdf_SetRightMargin(RightMargin.f)
  pdfRMargin = RightMargin
EndProcedure

Procedure ipdf_SetCellMargin(CellMargin.f)
  pdfCMargin = CellMargin
EndProcedure

Procedure ipdf_SetAutoPageBreak(Auto.l, Margin.f=0)
  pdfAutoPageBreak = Auto
  pdfBMargin = Margin
  pdfPageBreakTrigger = pdfH - Margin
EndProcedure

Procedure ipdf_SetDisplayMode(Zoom.l, Layout$=#PDF_LAYOUT_CONTINUOUS)
  pdfZoomMode = Zoom  
  Select Layout$
    Case #PDF_LAYOUT_SINGLE
    Case #PDF_LAYOUT_CONTINUOUS
    Case #PDF_LAYOUT_TWO 
    Default
      Layout$ = #PDF_LAYOUT_CONTINUOUS
  EndSelect
  pdfLayoutMode$ = Layout$
EndProcedure

Procedure ipdf_Create(Orientation$="", Unit$="", Format$="")
  Protected lfMargin.f,mode,vBias
  If pdfState=3
    ProcedureReturn #False
  EndIf
  vLocalDecimal = ipdf_LocalDecimal()
  CompilerIf #PB_Compiler_OS=#PB_OS_Windows
    Protected vTZ.TIME_ZONE_INFORMATION
    mode=GetTimeZoneInformation_(vTZ)
    Select mode
      Case #TIME_ZONE_ID_STANDARD
        vBias - vTZ\Bias - vTZ\StandardBias
      Case #TIME_ZONE_ID_DAYLIGHT
        vBias - vTZ\Bias - vTZ\DaylightBias
      Default
        vBias - vTZ\Bias
    EndSelect
    
    If vBias < 0
      vpdfTimeZoneOffset="-"+FormatDate("%hh'%ii'",Abs(vTZ\Bias*60))
    ElseIf vBias > 0
      vpdfTimeZoneOffset="+"+FormatDate("%hh'%ii'",Abs(vTZ\Bias*60))
    Else
      vpdfTimeZoneOffset="Z"
    EndIf
  CompilerElse
    ; Place other OS큦 code here
    vpdfTimeZoneOffset="Z"
  CompilerEndIf
  
  pHeader = 0
  pFooter = 0
  pHeaderParamPtr = 0
  pFooterParamPtr = 0
  pAcceptPageBreak = 0
  pCompress = 0
  
  AddElement(Offsets())
  AddElement(Offsets())
  
  If pdfBuffer\pData
    FreeMemory(pdfBuffer\pData)
  EndIf
  pdfBuffer\pData = 0
  If MEM_DataInit(pdfBuffer, 65536) = #False
    pdfError = #PDF_ERROR_OUT_OF_MEMORY
    ProcedureReturn #False
  EndIf
  If Orientation$ = "" : Orientation$ = "P" : EndIf
  If Unit$ = "" : Unit$  = "mm" : EndIf
  If Format$ = "" : Format$ = #PDF_PAGE_FORMAT_A4 :EndIf 
  
  pdfPage = 0 
  pdfN = 2
  pdfState = 0
  pdfInFooter = #False
  pdfLasth = 0
  pdfFontFamily$=""
  pdfFontStyle$=""
  pdfFontSizePt=12
  pdfUnderline=#False
  pdfDrawColor$="0 G"
  pdfFillColor$="0 g"
  pdfTextColor$="0 g"
  pdfColorFlag=#False
  pdfWs=0
  pdfError = 0
  pdfNumbering = #False
  pdfNumberingFooter = #False
  pdfNumPageNum = 1 
  
  ;Scale factor
  Select Unit$
    Case "pt"
      pdfK = 1
    Case "mm"
      pdfK = 72/25.4
    Case "cm"
      pdfK = 72/2.54
    Case "in"
      pdfK = 72
    Default
      pdfK = 72/25.4
  EndSelect   
  
  ;Page format
  pdfFwPt = ValF(StringField(Format$, 1, ","))
  pdfFhPt = ValF(StringField(Format$, 2, ","))      
  pdfFw = pdfFwPt/pdfK
  pdfFh = pdfFhPt/pdfK
  
  ;Page orientation
  Orientation$=UCase(Orientation$)
  If (Orientation$ ="L" Or Orientation$ = "LANDSCAPE")
    pdfDefOrientation$="L"
    pdfWPt = pdfFhPt
    pdfHPt = pdfFwPt
  Else
    pdfDefOrientation$="P"
    pdfWPt = pdfFwPt
    pdfHPt = pdfFhPt 
  EndIf 
  pdfCurOrientation$ = pdfDefOrientation$
  pdfW = pdfWPt/pdfK
  pdfH = pdfHPt/pdfK
  
  ;Page margins (1 cm)
  lfMargin=28.35/pdfK
  ipdf_SetMargins(lfMargin,lfMargin,-1)
  ;Interior cell margin (1 mm)
  pdfCMargin =  lfMargin/10
  ;Line width (0.2 mm)
  pdfLineWidth = 0.567/pdfK  
  ;Automatic page Break
  ipdf_SetAutoPageBreak(#True ,2*lfMargin)
  ;Full width display mode
  ipdf_SetDisplayMode(#PDF_ZOOM_FULLWIDTH, #PDF_LAYOUT_CONTINUOUS)  
  
  If pdfState=0
    ipdf_BeginDoc()
  EndIf
  
  ProcedureReturn #True
EndProcedure

Procedure ipdf_SetProcCompression(ProcAddress)
  pCompress = ProcAddress
EndProcedure

Procedure ipdf_SetProcHeader(ProcAddress, StructAddress = #Null)
  pHeader = ProcAddress
  pHeaderParamPtr = StructAddress
EndProcedure

Procedure ipdf_SetProcFooter(ProcAddress, StructAddress = #Null)
  pFooter = ProcAddress
  pFooterParamPtr = StructAddress
EndProcedure

Procedure ipdf_SetProcAcceptPageBreak(ProcAddress)
  pAcceptPageBreak = ProcAddress
EndProcedure

Procedure ipdf_SetProcEndPage(ProcAddress) ;Set endpage procedure.
  AddElement(pEndPage())
  pEndPage() = ProcAddress
EndProcedure

Procedure ipdf_SetProcEndDoc(ProcAddress) ;Set enddoc procedure.
  AddElement(pEndDoc())
  pEndDoc() = ProcAddress
EndProcedure

Procedure ipdf_SetProcPutCatalog(ProcAddress) ;Set putcatalog procedure.
  AddElement(pPutCatalog())
  pPutCatalog() = ProcAddress
EndProcedure

Procedure ipdf_SetProcPutResources(ProcAddress) ;Set putresources procedure.
  AddElement(pPutResources())
  pPutResources() = ProcAddress
EndProcedure

Procedure ipdf_ClearProcEndPage() ;Clears the endpage commands
  ClearList(pEndPage())
EndProcedure

Procedure ipdf_ClearProcEndDoc() ;Clears the enddoc commands
  ClearList(pEndDoc())
EndProcedure

Procedure ipdf_ClearProcCatalog() ;Clears the catalog commands
  ClearList(pPutCatalog())
EndProcedure

Procedure ipdf_ClearProcResources() ;Clears the resource commands
  ClearList(pPutResources())
EndProcedure

Procedure ipdf_SetTitle(Title$) ;Defines the title of the document.
  pdfTitle$ = Title$
EndProcedure

Procedure ipdf_SetSubject(Subject$)
  pdfSubject$ = subject$
EndProcedure

Procedure ipdf_SetAuthor(Author$)
  pdfAuthor$ = Author$
EndProcedure

Procedure ipdf_SetKeywords(Keywords$)
  pdfKeywords$ = keywords$
EndProcedure

Procedure ipdf_SetCreator(Creator$)
  pdfCreator$ = creator$
EndProcedure

Procedure ipdf_AliasNbPages(Alias$="{nb}")
  pdfAliasNbPages$ = Alias$
EndProcedure

Procedure.l ipdf_GetPageNo()
  ProcedureReturn pdfPage
EndProcedure

Procedure.f ipdf_GetX()
  ProcedureReturn pdfX
EndProcedure

Procedure.f ipdf_GetY()
  ProcedureReturn pdfY
EndProcedure

Procedure ipdf_SetX(X.f)
  If(x>=0)
    pdfX = x
  Else
    pdfX = pdfW + x
  EndIf
EndProcedure

Procedure ipdf_SetY(Y.f,resetx=#True)
If (resetx=#True)
  pdfX = pdfLMargin
EndIf
  If(y>=0)
    pdfY = y
  Else
    pdfY = pdfH + y
  EndIf
EndProcedure

Procedure ipdf_SetXY(X.f,Y.f)
  ipdf_SetY(Y,#False) ; must be first !
  ipdf_SetX(X) ; second
EndProcedure

Procedure ipdf_Skew(AngleX.f, AngleY.f=0, X.f=-1, Y.f=-1)
  Protected p1.f,p2.f,p3.f,p4.f,p5.f,p6.f
  
  If (x=-1) 
    x=ipdf_GetX()
  EndIf 
  If (y=-1) 
    y=ipdf_GetY()
  EndIf 
  If (AngleX<=-90) Or (AngleX>=90) Or (AngleY<=-90) Or (AngleY>=90)   
    ProcedureReturn -1
  EndIf
  y = (pdfH - y)*pdfK
  x = x*pdfK
	;Calculate elements of transformation matrix 
	p1.f = 1
	p2.f = Tan(AngleY*#PI/180)
	p3.f = Tan(AngleX*#PI/180)
	p4.f = 1
	p5.f = -y*(p3)
	p6.f = -x*(p2)
	;Scale the coordinate system
	ipdf_Transform(p1, p2, p3, p4, p5, p6)
EndProcedure

Procedure.l ipdf_AcceptPageBreak()
  If pAcceptPageBreak
    ProcedureReturn pdf_CallFunction(pAcceptPageBreak)
  Else
    ProcedureReturn pdfAutoPageBreak
  EndIf
EndProcedure

Procedure ipdf_SetTextColor(Red.f, Green.f=-1, Blue.f=-1)
  ;Set color For text
  If((Red=0 And Green=0 And Blue=0) Or Green=-1)
    pdfTextColor$= ipdf_StrF(Red/255,3) + " g"
  Else
    pdfTextColor$= ipdf_StrF(Red/255,3) + " " + ipdf_StrF(Green/255,3) + " " + ipdf_StrF(Blue/255,3) + " rg"
  EndIf  
  If (pdfFillColor$ <> pdfTextColor$)
    pdfColorFlag = #True
  EndIf
EndProcedure

Procedure ipdf_SetTextColorCMYK(Cyan.f, Magenta.f, Yellow.f, Black.f)
  ;Set color For text
  pdfTextColor$=ipdf_StrF(Cyan,2)+" "+ipdf_StrF(Magenta,2)+" "+ipdf_StrF(Yellow,2)+" "+ipdf_StrF(Black,2)+" "+" k"
  If (pdfFillColor$ <> pdfTextColor$)
    pdfColorFlag = #True
  EndIf
EndProcedure

Procedure ipdf_SetDrawColor(Red.f, Green.f=-1, Blue.f=-1)
  ;Set color For all stroking operations  
  If(((Red=0) And (Green=0) And (Blue=0)) Or (Green=-1))
    pdfDrawColor$= ipdf_StrF(Red/255,3) + " G"
  Else
    pdfDrawColor$= ipdf_StrF(Red/255,3) + " " + ipdf_StrF(Green/255,3) + " " + ipdf_StrF(Blue/255,3) + " RG"
  EndIf
  If (pdfPage > 0)
    ipdf_Out(pdfDrawColor$)
  EndIf
EndProcedure

Procedure ipdf_SetDrawColorCMYK(Cyan.f, Magenta.f, Yellow.f, Black.f)
  ;Set color For all stroking operations  
  pdfDrawColor$=ipdf_StrF(Cyan, 2)+" "+ipdf_StrF(Magenta,2)+" "+ipdf_StrF(Yellow,2)+" "+ipdf_StrF(Black,2)+" "+" K"
  If (pdfPage > 0)
    ipdf_Out(pdfDrawColor$)
  EndIf
EndProcedure

Procedure ipdf_SetFillColor(Red.f, Green.f=-1, Blue.f=-1)
  ;Set color For all filling operations
  If((Red=0 And Green=0 And Blue=0) Or Green=-1)
    pdfFillColor$= ipdf_StrF(Red/255,3) + " g"
  Else
    pdfFillColor$= ipdf_StrF(Red/255,3) + " " + ipdf_StrF(Green/255,3) + " " + ipdf_StrF(Blue/255,3) + " rg"
  EndIf  
  If (pdfFillColor$ <> pdfTextColor$)
    pdfColorFlag = #True
  EndIf
  If(pdfPage>0)
    ipdf_Out(pdfFillColor$)
  EndIf
EndProcedure

Procedure ipdf_SetFillColorCMYK(Cyan.f, Magenta.f, Yellow.f, Black.f)
  ;Set color For all filling operations
  pdfFillColor$=ipdf_StrF(Cyan,2)+" "+ipdf_StrF(Magenta,2)+" "+ipdf_StrF(Yellow,2)+" "+ipdf_StrF(Black,2)+" "+" k"
  If (pdfFillColor$ <> pdfTextColor$)
    pdfColorFlag = #True
  EndIf
  If(pdfPage>0)
    ipdf_Out(pdfFillColor$)
  EndIf
EndProcedure

Procedure ipdf_Ln(Height.f=-1)
  pdfX = pdfLMargin
  If Height<0
    pdfY + pdfLasth
  Else
    pdfY + Height
  EndIf
EndProcedure

Procedure ipdf_SetFont(Family$, Style$="", Size.l=0)
  Protected vFontKey.s,vFound,uFamily$
  
  uFamily$=UCase(Family$)
  ; Select a font, size given in points
  Family$ = Trim(Family$)
  If Family$ = ""
    Family$ = pdfFontFamily$    
  EndIf
  Select uFamily$
    Case "ARIAL"
      Family$ = "HELVETICA"
    Case "SYMBOL"
      Style$ = ""
    Case "ZAPFDINGBATS"
      Style$ = ""  
  EndSelect
  
  Style$ = Trim(UCase(Style$))
  If (FindString(Style$,"U",1) > 0)
    pdfUnderline = #True
    Style$ = ReplaceString(Style$, "U", "")
  Else
    pdfUnderline =#False
  EndIf    
  If Style$ = "IB"
    Style$ = "BI"
  EndIf
  
  If Size = 0
    Size = pdfFontSizePt
  EndIf
  
  ;Test if font is already selected
  If (UCase(pdfFontFamily$) = UCase(Family$) And pdfFontStyle$ = Style$ And pdfFontSizePt = Size)
    ;Do nothing
  Else
    ;Test if used For the first time
    vFontKey = UCase(RSet(Style$,3,"_")+"+"+Family$) ; BI_+Fontname
    vFound = #False
    ForEach Fonts()
      If (Fonts()\Fontkey$ = vFontKey)
        vFound = #True
        Break
      EndIf
    Next
    If vFound = #False
      ipdf_SetFontData(Family$,Style$,vFontKey)
    EndIf
    ; Select it
    pdfFontFamily$ = Family$
    pdfFontStyle$ = Style$
    pdfFontSizePt = Size
    pdfFontSize = Size/pdfK
    If (pdfPage >0)
      ipdf_Out("BT /F" + Str(Fonts()\FontN) + " " + ipdf_StrF(pdfFontSizePt,2) + " Tf ET")
    EndIf
  EndIf
EndProcedure

Procedure ipdf_AddPage(Orientation$="",Format$="")
  Protected lsFamily.s,lsStyle.s,lbSize,lfLw.f,lsdc.s,lsfc.s,lstc.s,lbcf
  
  ;Start a new page
  If(pdfState=0)
    ipdf_Create()
  EndIf
  
  lsFamily = pdfFontFamily$
  lsStyle = pdfFontStyle$
  If pdfUnderline = #True
    lsStyle = lsStyle + "U"
  EndIf  
  lbSize = pdfFontSizePt
  lflw = pdfLineWidth
  lsdc = pdfDrawColor$
  lsfc = pdfFillColor$
  lstc = pdfTextColor$
  lbcf = pdfColorFlag
  
  If(pdfPage>0)
    ;Page footer
    pdfInFooter = #True
    If pFooter
      If pFooterParamPtr <> #Null
        pdf_CallFunction(pFooter, pFooterParamPtr)
      Else
        pdf_CallFunction(pFooter)
      EndIf
    EndIf
    pdfInFooter = #False
    ;Close page
    ipdf_EndPage()
  EndIf
  ;Start new page
  If ipdf_BeginPage(Orientation$,Format$) = #False
    ProcedureReturn #False
  EndIf
  ;Set line cap style To square
  ipdf_Out("2 J")
  ;Set line width
  pdfLineWidth = lflw
  ipdf_Out(ipdf_StrF(lflw * pdfK,2) + " w")
  ;Set font
  If(Trim(lsFamily) <> "")
    ipdf_SetFont(lsFamily, lsStyle, lbSize)
  EndIf  
  ;Set colors
  pdfDrawColor$ = lsdc 
  If (lsdc <> "0 G")
    ipdf_Out(lsdc)
  EndIf  
  pdfFillColor$ = lsfc
  If (lsfc <> "0 g")
    ipdf_Out(lsfc)
  EndIf  
  pdfTextColor$ = lstc
  pdfColorFlag = lbcf
  ; Page header
  If pHeader
    If pHeaderParamPtr <> #Null
      pdf_CallFunction(pHeader, pHeaderParamPtr)
    Else
      pdf_CallFunction(pHeader)
    EndIf
  EndIf
  ;Restore line width
  If(pdfLineWidth<>lflw)
    pdfLineWidth = lflw
    ipdf_Out(ipdf_StrF(lflw*pdfK,2) + " w")
  EndIf
  ; Restore font
  If(lsFamily <> "")
    ipdf_SetFont(lsFamily,lsStyle,lbSize)
  EndIf
  ;Restore colors
  If(pdfDrawColor$ <> lsdc)
    pdfDrawColor$=lsdc
    ipdf_Out(lsdc)
  EndIf
  If(pdfFillColor$ <> lsfc)
    pdfFillColor$ = lsfc
    ipdf_Out(lsfc)
  EndIf
  pdfTextColor$ = lstc
  pdfColorFlag = lbcf  
  If pdfNumbering=#True
    pdfNumPageNum = pdfNumPageNum + 1
  EndIf
  
  ProcedureReturn #True
EndProcedure

Procedure ipdf_Close() ;Terminates the PDF document.
  ;Terminate document
  If(pdfState=3)
    ;Do nothing
  Else
    If(pdfPage=0)
      ipdf_AddPage("")
    EndIf  
    ;Page footer
    pdfInFooter=#True 
    If pFooter
      If pFooterParamPtr <> #Null
        pdf_CallFunction(pFooter, pFooterParamPtr)
      Else
        pdf_CallFunction(pFooter)
      EndIf
    EndIf
    pdfInFooter=#False
    ;Close page
    ipdf_EndPage();
    ;Close document
    ipdf_EndDoc()
  EndIf
EndProcedure

Procedure ipdf_Save(FileName$)
  Protected File,cbBytes
  
  ipdf_Close()
  pdfState=3
  If Len(FileName$)>0 And pdfError<>#PDF_ERROR_OUT_OF_MEMORY
    If CheckFilename(GetFilePart(Filename$)) = 1
      File=CreateFile(#PB_Any, FileName$)
      If File
        WriteData(File,pdfBuffer\pData, pdfBuffer\lCurSize)
        CloseFile(File)
      Else
        pdfError = #PDF_ERROR_ERROR_CREATING_FILE
        ProcedureReturn #False
      EndIf      
    Else
      pdfError = #PDF_ERROR_FILENAME_IS_NOT_CORRECT
      ProcedureReturn #False 
    EndIf
  EndIf
  If pdfBuffer\pData
    FreeMemory(pdfBuffer\pData)
  EndIf
  pdfBuffer\pData=0
  pdfState=0
  pdferror=0
  ProcedureReturn #True
EndProcedure

Procedure ipdf_Text(X.f,Y.f,Text$) ;Prints a character string.
  Protected sLen=Len(Text$),First$,Last$,i,MEM.MEM_DataStructure
  ;-* ipdf_Text
  If sLen=0
    ProcedureReturn
  EndIf
  If pdfColorFlag=#True
    First$ = "q " + pdfTextColor$ + " "
  EndIf
  First$ + "BT " + ipdf_StrF(x*pdfK,2) + " " + ipdf_StrF((pdfH - y)*pdfK,2) 
  First$ + " Td ("
  ;String2$ + ipdf_Escape(Text$)
  Last$ + ") Tj ET"
  If pdfUnderline=#True
    Last$ + " " + ipdf_DoUnderline(x,y,Text$)
  EndIf
  If pdfColorFlag=#True
    Last$ + " Q"
  EndIf
  If ipdf_EscapeU(First$,Last$,Text$,MEM)
    ipdf_OutStream(MEM)
    FreeMemory(MEM\pData)
  EndIf
EndProcedure
  
Procedure ipdf_SetLineWidth(Width.f)
  pdfLineWidth = Width
  If(pdfPage>0)
    ipdf_Out(ipdf_StrF(Width*pdfK,2) + " w")
  EndIf
EndProcedure

Procedure ipdf_PathRect(x.f,y.f,w.f,h.f)
  ipdf_Out(ipdf_StrF(x*pdfK,2) + " " + ipdf_StrF((pdfH-y)*pdfK,2) + " " + ipdf_StrF(w*pdfK,2) + " " + ipdf_StrF(-h*pdfK,2) + " re")
EndProcedure

Procedure ipdf_Rect(x.f,y.f,w.f,h.f,Style$="")
  ;Draw a rectangle
  ipdf_PathRect(x,y,w,h)
  Select Style$
    Case #PDF_STYLE_FILL
      ipdf_Out("f")
    Case #PDF_STYLE_DRAWANDFILL
      ipdf_Out("B")
    Default
      ipdf_Out("S")
  EndSelect
EndProcedure

Procedure ipdf_SetFontSize(Size.l)
  If(pdfFontSizePt<>Size)
    pdfFontSizePt = size
    pdfFontSize = size/pdfK
    If pdfPage > 0
      ipdf_Out("BT /F" + Str(fonts()\FontN) + " " + ipdf_StrF(pdfFontSizePt,2) + " Tf ET")  
    EndIf
  EndIf
EndProcedure

Procedure.l ipdf_AddLink()
  AddElement(PageLinks())
  ProcedureReturn ListSize(PageLinks())
EndProcedure

Procedure ipdf_SetLink(pLink.l, y.f=-1, page.l=-1, url$="")
  If pLink
    If (y=-1)
      y = pdfY
    EndIf
    If page=-1
      page = pdfPage
    EndIf
    SelectElement(PageLinks(),pLink-1)
    PageLinks()\Type = #PDF_URI_ACTIONS
    PageLinks()\DestPage = page
    PageLinks()\Y = y
    PageLinks()\Option1$ = url$
  EndIf
EndProcedure

Procedure ipdf_SetALaunch(pLink.l, y.f=-1, Page.l=-1, Filename$="", Dir$="", Action$="O", Parameter$="")
  If pLink
    If (y=-1)
      y = pdfY
    EndIf
    If page=-1
      page = pdfPage
    EndIf
    Action$=UCase(Left(Action$,1))
    If Action$="P"
      Action$="Print"
    Else
      Action$="Open"
    EndIf
    SelectElement(PageLinks(),pLink-1)
    PageLinks()\Type = #PDF_LAUNCH_ACTIONS
    PageLinks()\DestPage = page
    PageLinks()\Y = y
    PageLinks()\Option1$ = Filename$
    PageLinks()\Option2$ = Dir$
    PageLinks()\Option3$ = Action$
    PageLinks()\Option4$ = Parameter$
  EndIf
EndProcedure

Procedure ipdf_SetAText(pLink.l, y.f=-1, Page.l=-1, Text$="", Title$="", DateTime.l=0, Icon$="Note", Flags.l=0)
  If pLink
    If (y=-1)
      y = pdfY
    EndIf
    If page=-1
      page = pdfPage
    EndIf
    Select UCase(Icon$)
      Case "COMMENT"
        Icon$="Comment"
      Case "KEY"
        Icon$="Key"
      Case "NOTE"
        Icon$="Note"
      Case "HELP"
        Icon$="Help"
      Case "NEWPARAGRAPH"
        Icon$="NewParagraph"
      Case "PARAGRAPH"
        Icon$="Paragraph"
      Case "INSERT"
        Icon$="Insert"
      Default
        Icon$="Note"
    EndSelect
    SelectElement(PageLinks(),pLink-1)
    PageLinks()\Type = #PDF_TEXT_ACTIONS
    PageLinks()\DestPage = page
    PageLinks()\Y = y
    PageLinks()\Flags = Flags
    PageLinks()\Option1$ = Icon$
    PageLinks()\Option2$ = Text$
    PageLinks()\Option3$ = Title$
    PageLinks()\Option4$ = "D:"+FormatDate("%yyyy%mm%dd%hh%ii%ss",DateTime)+vpdfTimeZoneOffset
  EndIf
EndProcedure

Procedure ipdf_SetAPopUp(pLink.l, y.f=-1, Page.l=-1, Text$="", Title$="", w.f=200, h.f=200, DateTime.l=0, Icon$="Note", Flags.l=0)
  If pLink
    If (y=-1)
      y = pdfY
    EndIf
    If page=-1
      page = pdfPage
    EndIf
    Select UCase(Icon$)
      Case "COMMENT"
        Icon$="Comment"
      Case "KEY"
        Icon$="Key"
      Case "NOTE"
        Icon$="Note"
      Case "HELP"
        Icon$="Help"
      Case "NEWPARAGRAPH"
        Icon$="NewParagraph"
      Case "PARAGRAPH"
        Icon$="Paragraph"
      Case "INSERT"
        Icon$="Insert"
      Default
        Icon$="Note"
    EndSelect
    SelectElement(PageLinks(),pLink-1)
    PageLinks()\Type = #PDF_POPUP_ACTIONS
    PageLinks()\DestPage = page
    PageLinks()\Y = y
    PageLinks()\Flags = Flags
    PageLinks()\w = w * pdfK
    PageLinks()\h = h * pdfK
    PageLinks()\Option1$ = Icon$
    PageLinks()\Option2$ = Text$
    PageLinks()\Option3$ = Title$
    PageLinks()\Option4$ = "D:"+FormatDate("%yyyy%mm%dd%hh%ii%ss",DateTime)+vpdfTimeZoneOffset
  EndIf
EndProcedure

Procedure ipdf_SetAFile(pLink.l, File.l, x.f=-1, Page.l=-1, Text$="", Title$="", w.f=16, h.f=16, DateTime.l=0, Icon$="GraphPushPin", Flags.l=0)
  If (pLink And File) ;-*
    If page=-1
      page = pdfPage
    EndIf
    Select UCase(Icon$)
      Case "GRAPH"
        Icon$="Graph"
      Case "PAPERCLIP"
        Icon$="Paperclip"
      Case "GRAPHPUSHPIN"
        Icon$="GraphPushPin"
      Case "TAG"
        Icon$="Tag"
      Default
        Icon$="GraphPushPin"
    EndSelect
    SelectElement(PageLinks(),pLink-1)
    PageLinks()\Type = #PDF_FILE_ACTIONS
    PageLinks()\File = File
    PageLinks()\DestPage = page
    PageLinks()\x = x
    PageLinks()\Flags = Flags
    PageLinks()\w = w * pdfK
    PageLinks()\h = h * pdfK
    PageLinks()\Option1$ = Icon$
    PageLinks()\Option2$ = Text$
    PageLinks()\Option3$ = Title$
    PageLinks()\Option4$ = "D:"+FormatDate("%yyyy%mm%dd%hh%ii%ss",DateTime)+vpdfTimeZoneOffset
  EndIf
EndProcedure

Procedure ipdf_Link(X.f, Y.f, W.f, H.f, Link.l)
  Protected PLType,PLDestPage,PLy,PL1$
  If Link>0
    SelectElement(PageLinks(), Link-1)
    ;If this link was used before copy data and create a new link
    ;This will work with pages and URLS only 
    If PageLinks()\Page>0
      PLType=PageLinks()\Type
      PLDestPage=PageLinks()\DestPage
      PLy=PageLinks()\y
      PL1$=PageLinks()\Option1$
      AddElement(pagelinks())
      PageLinks()\Type = PLType
      PageLinks()\DestPage = PLDestPage
      PageLinks()\Y = PLy
      PageLinks()\Option1$ = PL1$
    EndIf
    If pdfCurOrientation$="P"
      PageLinks()\fA0 = x*pdfK
      PageLinks()\fA1 = pdfFhPt - y*pdfK
      PageLinks()\fA2 = w*pdfK
      PageLinks()\fA3 = h*pdfK
      PageLinks()\Page = pdfPage
    Else
      PageLinks()\fA0 = x*pdfK
      PageLinks()\fA1 = pdfFwPt - y*pdfK
      PageLinks()\fA2 = w*pdfK
      PageLinks()\fA3 = h*pdfK
      PageLinks()\Page = pdfPage
    EndIf
  EndIf
EndProcedure

Procedure ipdf_Cell(w.f,h.f=0,Text$="",Border.l=0,Ln.f=0,Align$="",Fill.l=0,Link.l=0)
  ;Output a cell
  Protected l_k.f,l_x.f,l_y.f,l_ws.f,l_dx.f,wMax.f,wLink.f,TextLen.f
  Protected l_s.s,l_op.s,l_txt.s,First$,Last$,MEM.MEM_DataStructure,sLen
  
  If Right(Text$,1)=Chr(10)
    Text$=Mid(Text$,1,Len(Text$)-1)
  EndIf
  If Right(Text$,1)=Chr(13)
    Text$=Mid(Text$,1,Len(Text$)-1)
  EndIf
  sLen=Len(Text$)
  
  l_k = pdfK  
  If ((pdfY+h) > pdfPageBreakTrigger) And (pdfInFooter=#False) And (ipdf_AcceptPageBreak()=#True)
    ;Automatic page Break    
    l_x = pdfX
    l_ws = pdfWs
    If(l_ws>0)
      pdfWs=0
      ipdf_Out("0 Tw")
    EndIf
    ipdf_AddPage(pdfCurOrientation$)  
    pdfX = l_x
    If l_ws>0
      pdfWs=l_ws
      ipdf_Out(ipdf_StrF(l_ws*l_k,3) + " Tw")
    EndIf  
  EndIf
  If w=0
    w = pdfW - pdfRMargin - pdfX
  EndIf
  
  If (Fill=1 Or Border=1)
    First$ + ipdf_StrF(pdfX*l_k,2) + " " + ipdf_StrF((pdfH-pdfY)*l_k,2) + " " + ipdf_StrF(w*l_k,2) + " " + ipdf_StrF(-H*l_k,2) + " re "
    If (Fill=1)
      If (Border=1)
        First$+"B "
      Else
        First$+"f "
      EndIf
    Else
      First$+"S "
    EndIf  
  EndIf
  If Border < 0
    l_x=pdfX
    l_y=pdfY
    ;L
    If -Border & -#PDF_CELL_LEFTBORDER
      First$ + ipdf_StrF(l_x*l_k,2) + " " + ipdf_StrF((pdfH - l_y)*l_k,2) + " m " + ipdf_StrF(l_x*l_k,2) + " " + ipdf_StrF((pdfH-(l_y+H))*l_k,2) + " l S "
    EndIf
    ;T
    If -Border & -#PDF_CELL_TOPBORDER
      First$ + ipdf_StrF(l_x*l_k,2) + " " + ipdf_StrF((pdfH - l_y)*l_k,2) + " m " + ipdf_StrF((l_x+W)*l_k,2) + " " + ipdf_StrF((pdfH- l_y)*l_k,2) + " l S "
    EndIf
    ;R
    If -Border & -#PDF_CELL_RIGHTBORDER
      First$ + ipdf_StrF((l_x+W)*l_k,2) + " " + ipdf_StrF((pdfH - l_y)*l_k,2) + " m " + ipdf_StrF((l_x+W)*l_k,2) + " " + ipdf_StrF((pdfH- (l_y+H))*l_k,2) + " l S "
    EndIf
    ;B
    If -Border & -#PDF_CELL_BOTTOMBORDER
      First$ + ipdf_StrF(l_x*l_k,2) + " " + ipdf_StrF((pdfH - (l_y+H))*l_k,2) + " m " + ipdf_StrF((l_x+W)*l_k,2) + " " + ipdf_StrF((pdfH- (l_y+H))*l_k,2) + " l S "
    EndIf
  EndIf
  If sLen
    TextLen = ipdf_GetStringWidth(Text$)
    If (Align$ = #PDF_ALIGN_RIGHT)
      l_dx = W - pdfCMargin - TextLen
    ElseIf (Align$ = #PDF_ALIGN_CENTER)  
      l_dx = (W - TextLen)/2
    ElseIf (Align$ = #PDF_ALIGN_FORCEDJUSTIFIED)
      wMax = W - (2 * pdfCMargin)   
      pdfWs = (wMax-TextLen)   
      If CountString(Text$," ")> 0
        pdfWs = pdfWs/CountString(Text$," ")              
      EndIf
      ipdf_Out(ipdf_StrF((pdfWs*pdfK),3) + " Tw")
      l_dx = pdfCMargin
    Else
      l_dx = pdfCMargin
    EndIf
    ;-* ipdf_Cell
    
    ;eText$= ipdf_Escape(Text$);
    
    If pdfColorFlag=#True
      First$ + "q " + pdfTextColor$ + " "
    EndIf
    First$ + "BT " + ipdf_StrF((pdfX+l_dx)*l_k,2) + " " + ipdf_StrF(((pdfH-(pdfY+0.5*H+0.3*pdfFontSize))*l_k) ,2) + " Td ("
    Last$+") Tj ET"
    If pdfUnderline=#True
      Last$ + " "
      Last$ +  ipdf_DoUnderline(pdfX + l_dx, pdfY + 0.5*H+0.3*pdfFontSize,Text$)
    EndIf
    If pdfColorFlag=#True
      Last$ + " Q"
    EndIf  
    If Link > 0
      If Align$ = #PDF_ALIGN_FORCEDJUSTIFIED
        wLink = wMax
      Else
        wLink = TextLen
      EndIf
      ipdf_Link(pdfX+l_dx,pdfY+0.5*H-0.5*pdfFontSize,wlink,pdfFontSize,Link)
    EndIf
  EndIf
  If ipdf_EscapeU(First$,Last$,Text$,MEM)
    ipdf_OutStream(MEM)
    FreeMemory(MEM\pData)
  EndIf
  If Align$ = #PDF_ALIGN_FORCEDJUSTIFIED
    ipdf_Out("0 Tw")
    pdfWs = 0
  EndIf
  pdfLasth = H
  If (Ln>0)
    ;Go To Next line
    pdfY = pdfY + H
    If (Ln=1)
      pdfX = pdfLMargin
    EndIf  
  Else
    pdfX = pdfX + W
  EndIf      
EndProcedure

Procedure.s ipdf_MultiCell(w.f,h.f,Text$,Border.l=0,Align$="",fill.l=0,indent.f=0,maxline.l=0)
  Protected wMax.f,wMaxOther.f,wFirst.f,wOther.f,wMaxFirst.f,sep,s.s,nb,first,savex.f,b,b2,i,j,l,ns,nl,c.s,ls
  
  pdfMultiCellNewLines=0
  ;Output text with automatic Or explicit line breaks 
  If w=0
    w=pdfW - pdfRMargin - pdfX
  EndIf
  
  wFirst = w - indent
  wOther = w
  wMaxFirst = (wFirst-2*pdfCMargin)*1000/pdfFontSize
  wMaxOther = (wOther-2*pdfCMargin)*1000/pdfFontSize
  s = Text$
  nb  = Len(s)
  If nb>0 And Right(s,1) = #PDF_NEWLINE
    nb - 1
  EndIf
  b = 0
  If Border <> 0
    If Border = 1
      Border = #PDF_CELL_LEFTBORDER + #PDF_CELL_RIGHTBORDER + #PDF_CELL_TOPBORDER + #PDF_CELL_BOTTOMBORDER
      b = #PDF_CELL_LEFTBORDER + #PDF_CELL_RIGHTBORDER + #PDF_CELL_TOPBORDER
      b2 = #PDF_CELL_LEFTBORDER + #PDF_CELL_RIGHTBORDER
    Else 
      b2=0 
      If -Border & -#PDF_CELL_LEFTBORDER
        b2+#PDF_CELL_LEFTBORDER 
      EndIf 
      If -Border & -#PDF_CELL_RIGHTBORDER
        b2+#PDF_CELL_RIGHTBORDER 
      EndIf 
      If -Border & -#PDF_CELL_TOPBORDER
        b2+#PDF_CELL_TOPBORDER 
      EndIf 
      b=b2 
    EndIf  
  EndIf 
  sep=-1 
  i=1 
  j=0 
  l=0 
  ns=0 
  nl=1 
  c.s=""
  first = #True
  While i < nb
    ;Get Next character 
    c = Mid(s,i,1)
    If c = Chr(10)
            
      ;Explicit line Break 
      If pdfWs>0
        pdfWs = 0
        ipdf_Out("0 Tw")
      EndIf
      ipdf_Cell(w,h,Mid(s,j,i-j),b,2,align$,fill)
      i + 1
      sep = -1
      j = i
      l = 0
      ns =0
      nl + 1
      If nl=2 And Border <> 0
        b = b2
      EndIf
      Continue
    EndIf
    If c=" "
      sep = i
      ls = l
      ns + 1
    EndIf
    
    l+ipdf_GetStringWidth(c,#False) ; fonts()\CharWidth[Asc(c)]
    
    If first = #True
      wMax = wMaxFirst
      w = wFirst
    Else
      wMax = wMaxOther
      w = wOther
    EndIf
    
    If l>wmax 
      ;Automatic line Break 
      If(sep=-1) 
        If(i=j) 
          i + 1 
        EndIf  
        If(pdfWs>0) 
          pdfWs=0 
          ipdf_Out("0 Tw") 
        EndIf 
        saveX = pdfX
        If (first=#True And indent > 0)
          ipdf_SetX(pdfX + indent) 
          first = #False 
        EndIf             
        ipdf_Cell(w,h,Mid(s,j,i-j),b,2,align$,fill)      
        If j = 0: i + 1:EndIf ;>> If the first word is too long start on next character      
      Else 
        If(align$="J") 
          If (ns>1) 
             pdfWs = (wmax-ls)/1000*pdfFontSize/(ns-1) 
          Else 
             pdfWs = 0 
          EndIf 
          ipdf_Out(ipdf_StrF(pdfWs*pdfK,3) + " Tw") 
        EndIf  
        saveX = pdfX
        If (first=#True And indent > 0)
          ipdf_SetX(pdfX + indent) 
          first = #False 
        EndIf         
        ipdf_Cell(w,h,Mid(s,j,sep-j),b,2,align$,fill) 
        If (first = #False) 
          ipdf_SetX(saveX) 
        EndIf 
        i = sep + 1 
      EndIf 
      sep = -1
      j = i
      l = 0
      ns = 0
      nl + 1 
      If Border <> 0 And nl=2
        b=b2
      EndIf
      If maxLine > 0 And nl > maxLine
        pdfMultiCellNewLines=nl-1
        ProcedureReturn Right(s, Len(s) - i)
      EndIf 
    Else 
      i + 1 
    EndIf 
  Wend  
  
  ;Last chunk 
  If(pdfWs>0) 
    pdfWs=0 
    ipdf_Out("0 Tw"); 
  EndIf 
  If -Border & -#PDF_CELL_BOTTOMBORDER And border <> 0
    b+#PDF_CELL_BOTTOMBORDER 
  EndIf 
  ipdf_Cell(w,h,Mid(s,j,i-j + 1),b,2,align$,fill) 
  pdfX=pdfLMargin
  pdfMultiCellNewLines=nl
  
  ProcedureReturn ""
EndProcedure

Procedure ipdf_Write(h.f, Text$, link.l=0)
  Protected c.s,s.s,w.f,wmax.f,l.f,nb.l,sep.l,i.l,j.l,nl.l
  
  ;Output text in flowing mode
  
  w = pdfW - pdfRMargin - pdfX
  wmax = (w - 2 * pdfCMargin) * 1000 / pdfFontSize
  s = Text$
;  s = ReplaceString(txt,"\r","")
  nb = Len(s)
  sep = -1
  i=1
  j=1
  l=0
  nl=1
  
  While (i<=nb)
    ;Get Next character
    c = Mid(Text$,i,1)
    If c = #PDF_NEWLINE
      ;Explicit line Break
      ipdf_Cell(w, h, Mid(Text$, j, i-j), 0, 2, "", 0, link)
      i = i + 1
      sep = -1
      j = i
      l = 0
      If (nl = 1)
        pdfX = pdfLMargin
        w = pdfW - pdfRMargin - pdfX
        wmax = (w - 2 * pdfCMargin) * 1000 / pdfFontSize
      EndIf
      nl = nl + 1
      Continue
    EndIf
    If (c = " "  )
      sep = i
    EndIf
    l + ipdf_GetStringWidth(c,#False) ; Fonts()\CharWidth[Asc(c)]
    If (l>wmax)
      ;Automatic line Break
      If (sep = -1)
        If (pdfX > pdfLMargin)  
          ;Move To Next line
          pdfX = pdfLMargin
          pdfY = pdfY + h
          w = pdfW - pdfRMargin - pdfX
          wmax = (w - 2 * pdfCMargin) * 1000 / pdfFontSize
          i + 1
          nl + 1
          Continue
        EndIf
        If (i=j)
          i + 1
        EndIf  
        ipdf_Cell(w,h,Mid(Text$,j,i-j),0,2,"",0,link)  
      Else
        ipdf_Cell(w,h,Mid(Text$,j,sep-j),0,2,"",0,link)  
        i = sep + 1
      EndIf  
      sep = -1
      j=i
      l=0
      If (nl=1)
        pdfX = pdfLMargin
        w = pdfW - pdfRMargin - pdfX
        wmax = (w - 2 * pdfCMargin) * 1000 / pdfFontSize
      EndIf
      nl + 1
    Else
      i + 1
    EndIf
  Wend
  ;Last chunk
  If (i<>j)
    ipdf_Cell(l/1000*pdfFontSize, h, Mid(Text$,j,Len(Text$)), 0, 0, "", 0, link)         
  EndIf
EndProcedure    
Procedure ipdf_ActualText(objlink,text$="") ;create new object andpointtext to previous object
   ipdf_NewObj()
   ipdf_Out("<</A "+objlink+" 0 R/ActualText("+text$+")/Alt("+text$+")>>")
   ipdf_Out("endobj")
EndProcedure


Procedure ipdf_Image(FileName$,*Mem,MemSize,x.f,y.f,w.f=0,h.f=0,link.l=0,ActualText$="")
  Protected lbFound = #False
  Protected sx.f,sy.f
  
  ;Put an image on the page
  ForEach Images()
    If Images()\FileName = FileName$
      lbFound = #True
      Break
    EndIf  
  Next
  
  If lbFound = #False
    AddElement(Images())
    Images()\FileName = FileName$
    Images()\pMem = *Mem
    Images()\MemSize = MemSize
    Images()\ImageN = ListSize(Images())  
	images()\ActualText = ActualText$
    If ipdf_ParseImage(FileName$) = #False
      DeleteElement(Images())
      ProcedureReturn #False
    EndIf  
  EndIf 
  
  If Images()\Filter="WMF"
    If w=0 And h=0
      w=Abs(Images()\Width/(20*pdfK))
      h=Abs(Images()\Height/(20*pdfK))
    EndIf
    If w=0
      w=Abs(h*Images()\Width/Images()\Height)
    EndIf
    If h=0
      h=Abs(w*Images()\Height/Images()\Width)
    EndIf
    sx=w*pdfK/Images()\Width
    sy=-h*pdfK/Images()\Height
    ipdf_Out("q " + StrF(sx,6) + " 0 0 " + StrF(sy,6) + " " + StrF(x*pdfK-sx*Images()\x,6) + " " + StrF(((pdfH-y)*pdfK)-sy*Images()\y,6) + " cm /FO" + Str(images()\ImageN) + " Do Q")
  Else
    ;Automatic width And height calculation If needed
    If w=0 And h=0
      ;Put image at 72 dpi
      w=images()\Width/pdfK
      h=images()\Height/pdfK    
    EndIf
    If w=0
      w=h*images()\Width/images()\Height
    EndIf
    If h=0
      h=w*images()\Height/images()\Width
    EndIf
    ipdf_Out("q " + ipdf_StrF(w*pdfK,2) + " 0 0 " + ipdf_StrF(h*pdfK,2) + " " + ipdf_StrF(x*pdfK,2) + " " + ipdf_StrF((pdfH-(y+h))*pdfK,2) + " cm /I" + Str(images()\ImageN) + " Do Q")
  EndIf
  If link
    ipdf_Link(x, y, w, h, link)
  EndIf
EndProcedure

Procedure ipdf_StartPageNums()
  pdfNumbering = #True
  pdfNumberingFooter = #True
EndProcedure

Procedure ipdf_StopPageNums()
  pdfNumbering = #False
EndProcedure

Procedure ipdf_NumPageNum()
  ProcedureReturn pdfNumPageNum
EndProcedure

Procedure ipdf_TOCEntry(Text$, level.l=0)
  AddElement(pdfTOC())
  pdfTOC()\Text$ = Text$
  pdfTOC()\level = level
  pdfTOC()\page = ipdf_NumPageNum()
EndProcedure

Procedure ipdf_InsertTOC(Location.l=1,LabelSize.l=20,Entrysize.l=10,FontFamily$="Times",Label$="Table of Contents")
  Protected TOCStart.l,w.f,h.f,strsize.f,PageCellSize.f,dot.f,nb.f,Level,weight$,String$,Page$,n,n_toc,j,i,*tmp,*second
  
  ;make toc at end
	ipdf_StopPageNums()
	ipdf_AddPage("")
	TOCStart = pdfPage
  ipdf_SetFont(FontFamily$, "B", LabelSize)
  ipdf_Cell(0,5,Label$,0,1,"C")
  ipdf_ln(10)
	
	ForEach pdfTOC()
	  level = pdfTOC()\Level
  	If level > 0
	    w = level * 8
	    ipdf_Cell(w)
  	EndIf
	  weight$ = ""
  	If level = 0
	    weight$="B"
  	EndIf
	  String$ = pdfTOC()\Text$
  	ipdf_SetFont(FontFamily$, weight$, Entrysize)
	  strSize = ipdf_GetStringWidth(String$)
  	
	  w=strSize + 2
  	h=pdfFontSize + 2
  	ipdf_Cell(w,h,String$)
	  
   	;Filling dots
	  ipdf_SetFont(FontFamily$, "", Entrysize)
	  Page$=Str(pdfTOC()\Page)
   	PageCellSize=ipdf_GetStringWidth(Page$)+2
		w=pdfW - pdfLMargin - pdfRMargin - PageCellSize - (level*8)-(strsize+2)
 		ipdf_Cell(w , pdfFontSize + 2 , LSet("",Int(w/ipdf_GetStringWidth(".")),"."), 0, 0, "R")
 	  
    ;Page Number
		ipdf_Cell(PageCellSize , pdfFontSize + 2 , Page$, 0, 1, "R")
	Next
  
 	;grab it and move to selected location
 	n=pdfPage
 	n_toc = n - tocstart + 1
  
  Dim last(n_toc)
  j = 0
  For i = Tocstart To n
    SelectElement(Pages(), i - 1)
    last(j) = @Pages()
    j + 1
  Next
  
  For i = Tocstart - 1 To location Step -1
    SelectElement(Pages(), i - 1)
    *tmp = @Pages()
    SelectElement(Pages(), i + n_toc -1)
    *second = @Pages()
    SwapElements(Pages(),*tmp , *second)
  Next  
  
   For i=0 To n_toc - 1
     SelectElement(Pages(), location + i -1)
     *second = @Pages()
     SwapElements(Pages(), Last(i), *second)
   Next
EndProcedure

Procedure.s ipdf_GetErrorMessage()
  Protected msg$=""
  
  Select pdfError
    Case #PDF_ERROR_16BIT_DEPTH_PNG_NOT_SUPPORTED
      msg$ = "16-bit depth PNG not supported."
    Case #PDF_ERROR_ALPHA_CHANNEL_PNG_NOT_SUPPORTED
      msg$ = "Alpha channel PNG not supported."
    Case #PDF_ERROR_UNKNOWN_COMPRESSION_PNG_METHOD
      msg$ = "Unknown compression PNG method."
    Case #PDF_ERROR_UNKNOWN_FILTER_PNG_METHOD
      msg$ = "Unknown filter PNG method."
    Case #PDF_ERROR_INTERLACING_PNG_NOT_SUPPORTED
      msg$ = "Interlacing PNG not supported."
    Case #PDF_ERROR_MISSING_PALETTE_IN_PNG
      msg$ = "Missing palette in PNG."
    Case #PDF_ERROR_JPEG_FILE_IS_NOT_SUPPORTED
      msg$ = "JPEG file is not supported."
    Case #PDF_ERROR_ERROR_OPENING_IMAGE_FILE
      msg$ = "Error opening image file."
    Case #PDF_ERROR_PROBLEM_READING_IMAGE_FILE_IN_MEMORY
      msg$ = "Problem reading image file in memory."
    Case #PDF_ERROR_JFIF_MARKER_IS_MISSING
      msg$ = "JFIF marker is missing."
    Case #PDF_ERROR_NOT_A_JPEG_FILE
      msg$ = "Not a JPEG file."
    Case #PDF_ERROR_INCORRECT_PNG_FILE
      msg$ = "Incorrect PNG file."
    Case  #PDF_ERROR_INCORRECT_WMF_FILE
      msg$ = "Incorrect WMF file."
    Case #PDF_ERROR_NOT_A_JPEG_OR_PNG_FILE
      msg$ = "Not a JPEG or PNG file."
    Case #PDF_ERROR_FILENAME_IS_NOT_CORRECT
      msg$ = "Filename is not correct."
    Case #PDF_ERROR_ERROR_CREATING_FILE
      msg$ = "Error creating file."
    Case #PDF_ERROR_FILE_OPEN_ERROR
      msg$ = "File open error."
    Case #PDF_ERROR_OUT_OF_MEMORY
      msg$ = "Out of memory." ; luis http://www.purebasic.fr/english/viewtopic.php?p=267158#267158
    Case #PDF_ERROR_BOOKMARK
      msg$ = "Bookmark Error"
    Default
      msg$ = ""
  EndSelect
  
  ProcedureReturn msg$
EndProcedure
  
Procedure.s ipdf_TruncateCell(w.f, h.f=0, Text$="", border.l=0, Ln.f=0, Align$=#PDF_ALIGN_LEFT, Fill.l=0, Link.l=0, trunc$="...")
  Protected wMax.f, TLen.l, short$
  If w <= 0 ; Seitenbreite
    w = pdfW - pdfRMargin - pdfX
  EndIf
  wMax = w - (2 * pdfCMargin)
  If ipdf_GetStringWidth(Text$) <= wMax
    ipdf_Cell(w, h, Text$, border, Ln, Align$, Fill, Link)
  Else
    TLen = Len(Text$)
    While TLen
      TLen - 1
      short$ = Left(Text$, TLen)+trunc$
      If ipdf_GetStringWidth(short$) <= wMax
        Break
      EndIf
    Wend
    If TLen < 1
      short$ = ""
    Else
      ipdf_Cell(w, h, short$, border, Ln, Align$, Fill, Link)
      ProcedureReturn Right(Text$, Len(Text$)-TLen)
    EndIf
  EndIf
  
  ProcedureReturn ""
EndProcedure

Procedure ipdf_ResetBookMark()
  ipdf_ClearProcResources()
  ipdf_ClearProcCatalog()
  ipdf_ClearProcEndDoc()
  ipdf_SetProcPutResources(@ipdf_PutBookMarks())
  ipdf_SetProcPutResources(@ipdf_PutJavaScript())
  ipdf_SetProcPutCatalog(@ipdf_PutCatalogBookMark())
  ipdf_SetProcPutCatalog(@ipdf_PutCatalogDisplay())
  ipdf_SetProcPutCatalog(@ipdf_PutCatalogJavaScript())
  ipdf_SetProcEndDoc(@ipdf_EndDocBookMark())  
EndProcedure

Procedure ipdf_BookMark(Text$, level.l=0, y.f=0,p=-1)
  If y=-1 
    y = ipdf_GetY() 
  EndIf 
  If p=-1
  p=ipdf_GetPageNo()
  EndIf
  AddElement(OutLines()) 
  OutLines()\Text$ = Text$
  OutLines()\Y = y 
  OutLines()\Level = level 
  OutLines()\wPage = p
  OutLines()\lParent = -1   
  OutLines()\lNext = -1  
  OutLines()\lPrev = -1  
  OutLines()\lLast = -1   
  OutLines()\lFirst = -1  
EndProcedure 

Procedure ipdf_PutBookMarks()
  Protected nb,ln,level,i,lParent,lPrev,h.f,k.f,Dest
  
  nb = ListSize(OutLines())
  If nb
    ForEach OutLines()
      If (OutLines()\Level>0)
        If (ListSize(lru())<OutLines()\Level)
          pdfError=#PDF_ERROR_BOOKMARK
          Break
        EndIf
        SelectElement(lru(), OutLines()\Level - 1)
        lparent = lru()
        ;Set Parent And Last Pointers
        OutLines()\lParent = lparent
        SelectElement(OutLines(), lParent)
        OutLines()\lLast = i
        SelectElement(Outlines(), i)
        If (OutLines()\Level > level)
          ;Level increasing: set first pointer
          SelectElement(OutLines(), lParent)
          OutLines()\lFirst=i
        EndIf
        SelectElement(OutLines(),i)
      Else
        OutLines()\lParent = nb
      EndIf
      
      If (OutLines()\Level<=level And i>0)
        ;Set prev And Next pointers
        SelectElement(lru(), OutLines()\Level)
        lprev=lru()
        SelectElement(OutLines(),lprev)
        OutLines()\lNext = i
        SelectElement(OutLines(), i)
        OutLines()\lPrev = lprev
      EndIf
      level = OutLines()\Level
      If ListSize(lru()) <= level
        AddElement(lru())
      EndIf
      SelectElement(lru(), level)
      lru()=i
      i=i+1
    Next
    
    ;Outline items
    ln=ipdf_GetN() + 1
    ForEach OutLines()
      ipdf_NewObj()
      ipdf_Out("<</Title " + ipdf_TextString(OutLines()\Text$))
      ipdf_Out("/Parent " + Str(ln + OutLines()\lParent) + " 0 R")
      If (OutLines()\lPrev <> -1)
        ipdf_Out("/Prev " + Str(ln + OutLines()\lPrev) + " 0 R")
      EndIf
      If (OutLines()\lNext <> -1)
        ipdf_Out("/Next " + Str(ln + OutLines()\lNext) + " 0 R")
      EndIf
      If (OutLines()\lFirst <> -1)
        ipdf_Out("/First " + Str(ln + OutLines()\lFirst) + " 0 R")
      EndIf
      If (OutLines()\lLast <> -1)
        ipdf_Out("/Last " + Str(ln + OutLines()\lLast) + " 0 R")
      EndIf
      h = ipdf_GetH()
      k = ipdf_GetK()
      SelectElement(Pages(),OutLines()\wPage-1)
      Dest=Pages()\pdfN
      ipdf_Out("/Dest [" + Str(Dest) + " 0 R /XYZ 0 " + ipdf_StrF((h-OutLines()\Y)*k,2) + " null]")
      
      ipdf_Out("/Count 0>>")
      ipdf_Out("endobj")
    Next
    
    ;OutLine root
    ipdf_NewObj()
    pdfOutlineRoot = ipdf_GetN()
    ipdf_Out("<</Type /Outlines /First " + Str(ln) + " 0 R")
    If ListSize(lru())
      SelectElement(lru(),0)
      ipdf_Out("/Last " + Str(ln + lru()) + " 0 R>>")
    Else
      ipdf_Out("/Last " + Str(ln) + " 0 R>>")
      pdfError=#PDF_ERROR_BOOKMARK
    EndIf
    ipdf_Out("endobj")
  EndIf
EndProcedure 

Procedure ipdf_PutCatalogBookMark()
  If(ListSize(OutLines()) > 0) 
    ipdf_Out("/Outlines " + Str(pdfOutlineRoot) + " 0 R") 
    ipdf_Out("/PageMode /UseOutlines") 
  EndIf 
EndProcedure

Procedure ipdf_EndDocBookMark()
  ClearList(OutLines())
  ClearList(lru())
EndProcedure

Procedure ipdf_PutCatalogDisplay()
  If FindString(pdfDisplayPreferences$,"FullScreen",1) > 0
    ipdf_Out("/PageMode /FullScreen")  
  EndIf

  If Len(pdfDisplayPreferences$) > 0
    ipdf_Out("/ViewerPreferences<<")
    If FindString(pdfDisplayPreferences$,"HideMenubar",1) > 0
      ipdf_Out("/HideMenubar true")  
    EndIf
    If FindString(pdfDisplayPreferences$,"HideToolbar",1) > 0
      ipdf_Out("/HideToolbar true")  
    EndIf
    If FindString(pdfDisplayPreferences$,"HideWindowUI",1) > 0
      ipdf_Out("/HideWindowUI true")  
    EndIf
    If FindString(pdfDisplayPreferences$,"DisplayDocTitle",1) > 0
      ipdf_Out("/DisplayDocTitle true")  
    EndIf
    If FindString(pdfDisplayPreferences$,"CenterWindow",1) > 0
      ipdf_Out("/CenterWindow true")  
    EndIf
    If FindString(pdfDisplayPreferences$,"FitWindow",1) > 0
      ipdf_Out("/FitWindow true")  
    EndIf
    ipdf_Out(">>")
  EndIf
EndProcedure

Procedure ipdf_IncludeJS(Script$)
  pdfJavaScript$ = Script$
EndProcedure

Procedure ipdf_PutJavascript()
  If pdfJavaScript$<>""
    ipdf_NewObj()
    pdfJSNum = ipdf_GetN()
    ipdf_Out("<<")
    ipdf_Out("/Names [(EmbeddedJS) " + Str(ipdf_GetN() + 1) + " 0 R ]")
    ipdf_Out(">>")
    ipdf_Out("endobj")
    ipdf_NewObj()
    ipdf_Out("<<")
    ipdf_Out("/S /JavaScript")
    ipdf_Out("/JS " + ipdf_TextString(pdfJavaScript$))
    ipdf_Out(">>")
    ipdf_Out("endobj")    
  EndIf  
EndProcedure

Procedure ipdf_PutCatalogJavaScript()
  If pdfJavaScript$ <> ""
    ipdf_Out("/Names <</JavaScript " + Str(pdfJSNum) + " 0 R>>")
  EndIf
EndProcedure

Procedure ipdf_MultiCellBlt(w.f,h.f, blt$,txt$,border.l=0,align$="J",fill.l=-1)
  Protected blt_width.f
  Protected bak_x.f
  Protected cMargin.f
  cMargin = ipdf_GetCMargin()
  ;Get bullet width including margins
  blt_width = ipdf_GetStringWidth(blt$) + cMargin*2
  ;Save x
  bak_x = ipdf_GetX()
  ;Output bullet
  ipdf_Cell(blt_width,h,blt$,0,0,"",fill)
  ;Output text
  ipdf_MultiCell(w - blt_width, h, txt$, border, align$, fill,0)
  ;Restore x
  ipdf_SetX(bak_x)  
EndProcedure

Procedure ipdf_SubWrite(h.f, txt$, link.l=-1,subFontSize.l=12, subOffset.f=0)
  Protected subFontSizeold.l,subX.f,subY.f
  
  subFontSizeold = ipdf_GetFontSizePt()
	
	ipdf_SetFontSize(subFontSize)
	
	pdfK = ipdf_GetK()
	
	subOffset = (((subFontSize - subFontSizeold) / pdfK) * 0.3) + (subOffset / pdfK)
	subX = ipdf_GetX()
	subY = ipdf_GetY()

	ipdf_SetY(subY - subOffset)
	ipdf_SetX(subX)
	
  ipdf_Write(h, txt$, link)

	subX = ipdf_GetX()
	subY = ipdf_GetY()
	ipdf_SetY(subY + subOffset)
	ipdf_SetX(subX)
  
	ipdf_SetFontSize(subFontSizeold)
EndProcedure

Procedure ipdf_angle_endpage()
	If pdfAngle
		pdfAngle=0
		ipdf_Out("Q")
	EndIf
EndProcedure

Procedure ipdf_Rotate(angle.f, x.f=-1, y.f=-1)
  Protected c.f,s.f,cx.f,cy.f
  
  If (x=-1) 
    x=ipdf_GetX()
  EndIf 
  If (y=-1) 
    y=ipdf_GetY()
  EndIf 
  If (pdfAngle <> 0) 
    ipdf_Out("Q") 
  EndIf 
  pdfAngle = angle 
  If (angle<>0) 
    angle=angle*#PI/180 
    c = Cos(angle) 
    s = Sin(angle) 
    cx = x * pdfK
    cy = (pdfH - y) * pdfK
    ipdf_Out("q " + ipdf_StrF(c,5) + " " + ipdf_StrF(s,5) + " " + ipdf_StrF(-s,5) + " " + ipdf_StrF(c,5) + " " + ipdf_StrF(cx,2) + " " + ipdf_StrF(cy,2) + " cm")
    ipdf_Out("1 0 0 1 " + ipdf_StrF(-cx,2) + " " + ipdf_StrF(-cy,2) + " cm")
  EndIf 
EndProcedure 

Procedure ipdf_Arc(x1.f, y1.f, x2.f, y2.f, x3.f, y3.f)
  ipdf_Out(ipdf_StrF(x1*pdfK,2) + " " + ipdf_StrF((pdfH-y1)*pdfK,2) + " " + ipdf_StrF(x2*pdfK,2) + " " + ipdf_StrF((pdfH-y2)*pdfK,2) + " " + ipdf_StrF(x3*pdfK,2) + " " + ipdf_StrF((pdfH-y3)*pdfK,2) + " c")
EndProcedure

Procedure ipdf_PathBegin(X.f,Y.f)
  ipdf_Out(ipdf_StrF(X*pdfK,2) + " " + ipdf_StrF(((pdfH-Y))*pdfK,2) + " m")
EndProcedure

Procedure ipdf_PathEnd(Style$="")
  Select Style$
    Case #PDF_STYLE_DRAW
      ipdf_Out("s") ; Close and stroke the path
    Case #PDF_STYLE_DRAWANDFILL
      ipdf_Out("b") ; Close, fill, and then stroke the path
    Case #PDF_STYLE_FILL
      ipdf_Out("f") ; Fill the path
    Case ""
      ipdf_Out("S") ; Stroke the path
    Default
      ipdf_Out(Style$)
  EndSelect
EndProcedure

Procedure ipdf_Line(X1.f,Y1.f,X2.f,Y2.f)
  ipdf_Out(ipdf_StrF(x1*pdfK,2) + " " + ipdf_StrF((pdfH-y1)*pdfK,2) + " m " + ipdf_StrF(x2 * pdfK,2) + " " + ipdf_StrF((pdfH-y2)*pdfK,2) + " l S")
EndProcedure

Procedure ipdf_PathLine(X.f,Y.f)
  ipdf_Out(ipdf_StrF((X)*pdfK,2) + " " + ipdf_StrF((pdfH-Y)*pdfK,2) + " l")
EndProcedure

Procedure ipdf_RoundRect(X.f,Y.f,W.f,H.f,R.f,Style$="")
  ipdf_PathBegin(X,Y+R)
  ipdf_Arc(X,Y+(R/2),X+(R/2),Y,X+R,Y)
  ipdf_PathLine(X+W-R,Y)
  ipdf_Arc(X+W-(R/2),Y,X+W,Y+(R/2),X+W,Y+R)
  ipdf_PathLine(X+W,Y+H-R)
  ipdf_Arc(X+W,Y+H-(R/2),X+W-(R/2),Y+H,X+W-R,Y+H)
  ipdf_PathLine(X+R,Y+H)
  ipdf_Arc(X+(R/2),Y+H,X,Y+H-(R/2),X,Y+H-R)
  ipdf_PathEnd(Style$)
EndProcedure

Procedure ipdf_Triangle(X1.f,Y1.f,X2.f,Y2.f,X3.f,Y3.f,Style$="")
  ipdf_PathBegin(X1,Y1)
  ipdf_PathLine(X2,Y2)
  ipdf_PathLine(X3,Y3)
  ipdf_PathEnd(Style$)
EndProcedure

Procedure ipdf_Ellipse(x.f, y.f, rx.f, ry.f, Style$)
  Protected lx.f, ly.f
  
  lx = 4/3*(Sqr(2)-1)*rx
  ly = 4/3*(Sqr(2)-1)*ry
  
  ;ipdf_Out(ipdf_StrF((x+rx)*k,2) + " " + ipdf_StrF((h-y)*k,2) + " m " + ipdf_StrF((x+rx)*k,2) + " " + ipdf_StrF((h-y+ly)*k,2) + " " + ipdf_StrF((x+lx)*k,2) + " " + ipdf_StrF((h-y+ry) * k,2) + " " + ipdf_StrF(x*k,2) + " " + ipdf_StrF((h-y+ry)*k,2) + " c")
  ipdf_PathBegin(x+rx,y)
  ipdf_Arc(x+rx,y-ly,x+lx,y-ry,x,y-ry)
  ;ipdf_Out(ipdf_StrF((x-lx)*k,2) + " " + ipdf_StrF((h-y+ry)*k,2) + " " + ipdf_StrF((x-rx)*k,2) + " " + ipdf_StrF((h-y+ly)*k,2) + " " +  ipdf_StrF((x-rx)*k,2) + " " + ipdf_StrF((h-y)*k,2) + " c")
  ipdf_Arc(x-lx,y-ry,x-rx,y-ly,x-rx,y)
  ;ipdf_Out(ipdf_StrF((x-rx)*k,2) + " " + ipdf_StrF((h-y-ly)*k,2) + " " + ipdf_StrF((x-lx)*k,2) + " " + ipdf_StrF((h-y-ry)*k,2) + " " + ipdf_StrF(x*k,2) + " " + ipdf_StrF((h-y-ry) * k,2) + " c")
  ipdf_Arc(x-rx,y+ly,x-lx,y+ry,x,y+ry)
  ;ipdf_Out(ipdf_StrF((x+lx)*k,2) + " " + ipdf_StrF((h-y-ry)*k,2) + " " + ipdf_StrF((x+rx)*k,2) + " " + ipdf_StrF((h-y-ly)*k,2) + " " + ipdf_StrF((x+rx)*k,2) + " " + " " + ipdf_StrF((h-y)*k,2) + " c")
  ipdf_Arc(x+lx,y+ry,x+rx,y+ly,x+rx,y)
  ipdf_PathEnd(Style$)
EndProcedure

Procedure ipdf_Circle(x.f, y.f, r.f, Style$=#PDF_STYLE_DRAW)
  ipdf_Ellipse(x, y, r, r, Style$)
EndProcedure

Procedure ipdf_Sector(xc.f, yc.f, rx.f, ry.f, a.f, b.f, Style$=#PDF_STYLE_DRAWANDFILL, cw.l=#True, o.f=90)
  Protected MyArcX.f,MyArcy.f,af.f,bf.f,d.f
  
  If cw = #True
    d = b
    b = o - a
    a = o - d
  Else
    b = b + o
    a = a + o
  EndIf
  a = (Mod(a,360)) + 360
  b = (Mod(b,360)) + 360
  ;a = (a%360) + 360
  ;b = (b%360) + 360
  
  If a > b
    b = b + 360
  EndIf
  bf = b/360*2*#PI
  af = a/360*2*#PI
  d = bf - af
  
  If d = 0
    d = 2 * #PI
  EndIf
  ;k = ipdf_GetK()
  ;hp = ipdf_GetH()
  If Sin(d/2) 
    MyArcX = 4/3*(1-Cos(d/2))/Sin(d/2)*rx
    MyArcY = 4/3*(1-Cos(d/2))/Sin(d/2)*ry
  EndIf
  ;first put the center
  ;ipdf_Out(ipdf_StrF(xc*k,2) + " " + ipdf_StrF((hp-yc)*k,2) + " m")
  ipdf_PathBegin(xc,yc)
  ;put the first point
  ;ipdf_Out(ipdf_StrF((xc+r*Cos(af))*k,2) + " " + ipdf_StrF((hp-(yc-r*Sin(af)))*k,2) + " l")
  ipdf_PathLine(xc+rx*Cos(af),yc-ry*Sin(af))
  ;draw the arc
  
  If ( d < (#PI/2)) 
    ipdf_arc(xc+rx*Cos(af)+MyArcX*Cos(#PI/2+af), yc-ry*Sin(af)-MyArcY*Sin(#PI/2+af), xc+rx*Cos(bf)+MyArcX*Cos(bf-#PI/2), yc-ry*Sin(bf)-MyArcY*Sin(bf-#PI/2), xc+rx*Cos(bf), yc-ry*Sin(bf))
  Else
    bf = af + d/4
    MyArcX = 4/3*(1-Cos(d/8))/Sin(d/8)*rx
    MyArcY = 4/3*(1-Cos(d/8))/Sin(d/8)*ry
    ipdf_Arc(xc+rx*Cos(af)+MyArcX*Cos(#PI/2+af), yc-ry*Sin(af)-MyArcY*Sin(#PI/2+af), xc+rx*Cos(bf)+MyArcX*Cos(bf-#PI/2), yc-ry*Sin(bf)-MyArcY*Sin(bf-#PI/2), xc+rx*Cos(bf), yc-ry*Sin(bf))
    af = bf
    bf = af + d/4
    ipdf_Arc(xc+rx*Cos(af)+MyArcX*Cos(#PI/2+af), yc-ry*Sin(af)-MyArcY*Sin(#PI/2+af), xc+rx*Cos(bf)+MyArcX*Cos(bf-#PI/2),yc-ry*Sin(bf)-MyArcY*Sin(bf-#PI/2),xc+rx*Cos(bf), yc-ry*Sin(bf))
    af = bf
    bf = af + d/4
    ipdf_Arc(xc+rx*Cos(af)+MyArcX*Cos(#PI/2+af),yc-ry*Sin(af)-MyArcY*Sin(#PI/2+af),xc+rx*Cos(bf)+MyArcX*Cos(bf-#PI/2),yc-ry*Sin(bf)-MyArcY*Sin(bf-#PI/2),xc+rx*Cos(bf),yc-ry*Sin(bf))
    af= bf
    bf = af + d/4
    ipdf_Arc(xc+rx*Cos(af)+MyArcX*Cos(#PI/2+af),yc-ry*Sin(af)-MyArcY*Sin(#PI/2+af),xc+rx*Cos(bf)+MyArcX*Cos(bf-#PI/2),yc-ry*Sin(bf)-MyArcY*Sin(bf-#PI/2),xc+rx*Cos(bf),yc-ry*Sin(bf))
  EndIf  
  ;terminate drawing
  ipdf_PathEnd(Style$)
EndProcedure

Procedure ipdf_Transform(p1.f, p2.f, p3.f, p4.f, p5.f, p6.f)
  ipdf_Out(ipdf_StrF(p1,3) + " " + ipdf_StrF(p2,3) + " " + ipdf_StrF(p3,3) + " " + ipdf_StrF(p4,3) + " " + ipdf_StrF(p5,3) + " " + ipdf_StrF(p6,3) + " cm")  
EndProcedure

Procedure ipdf_Translate(TX.f, TY.f)
  Protected p1.f,p2.f,p3.f,p4.f,p5.f,p6.f
  p1.f = 1
  p2.f = 0
  p3.f = 0
  p4.f = 1
  p5.f = TX
  p6.f = TY
  ipdf_Transform(p1, p2, p3, p4, p5, p6)
EndProcedure

Procedure ipdf_Scale(SX.f, SY.f, X.f, Y.f)
  Protected p1.f,p2.f,p3.f,p4.f,p5.f,p6.f
  
  If (x=-1)
    x=ipdf_GetX()
  EndIf 
  If (y=-1) 
    y=ipdf_GetY()
  EndIf 
  If (x=0) Or (y=0)    
    ProcedureReturn -1
  EndIf
  y = (pdfH - y)*pdfK
  x = x*pdfK
	;Calculate elements of transformation matrix
	SX / 100
	SY / 100  
	p1.f = SX
	p2.f = 0
	p3.f = 0
	p4.f = SY
	p5.f = x*(1-sx)
	p6.f = y*(1-sy)
	;Scale the coordinate system
	ipdf_Transform(p1, p2, p3, p4, p5, p6)
EndProcedure

Procedure ipdf_IncludeFileJS(FileName.s)
  ;Included 17.11.2006 Author : Flype
  ;http://www.purebasic.fr/english/viewtopic.php?p=170879#170879
  Protected file.l, source.s
  
  file = ReadFile(#PB_Any, FileName)
  
  If file
    source = Space(Lof(file))
    If ReadData(file, @source, Lof(file))
      ipdf_IncludeJS(source)
    EndIf
    CloseFile(file)
    ProcedureReturn #True
  EndIf
  
  ProcedureReturn #False
EndProcedure

Procedure ipdf_SetDash(Black.l, White.l)
  If (black <>0) And (white <> 0)
    ipdf_Out("[" + ipdf_StrF(Black*pdfK,3) + " " + ipdf_StrF(White*pdfK,3) + "] 0 d")
  Else
    ipdf_Out("[] 0 d")
  EndIf
EndProcedure

Procedure ipdf_Grid(sizemm=-1)
  Protected i,x,y,tx$,w=ipdf_GetW(),h=ipdf_GetH(),gridr=w-(ipdf_GetRMargin())
  Static gridSize
  Debug "gridr" + Str(gridr)
  ipdf_SetAutoPageBreak(0)
    x=ipdf_getx()
    y=ipdf_gety()
    
  If gridSize = 0 And sizemm = -1
    gridSize=5 ; default 5mm
    sizemm=5
  EndIf
  If sizemm > 0 And sizemm < 100 
    gridSize=sizemm 
  Else
    gridSize = 100
  EndIf
  ipdf_SetDrawColor(204,255,255)
  ipdf_SetLineWidth(0.25)
  For i = 0 To w 
    ipdf_Line(i,0,i,h)
    i=i+gridSize-1
  Next
  For i = 0 To h 
    ipdf_Line(0,i,w,i)
    i=i+gridSize-1
  Next
  ipdf_SetFont("Arial","I",9)
  ipdf_SetTextColor(204,204,204)
  For i=20 To h Step 20
    ipdf_SetXY(1,i-3)
    tx$=Str(i)
    ipdf_Write(5,tx$)
  Next
  For i=20 To gridr Step 20
    ipdf_SetXY(i-1,1)
     tx$=Str(i)
    ipdf_Write(3,tx$)   
  Next
  ipdf_setxy(x,y)
EndProcedure



;{ PurePDF as includefile
CompilerIf Defined(PurePDF_Include,#PB_Constant)
  ;#######################
  ;# Includefile code    #
  ;#######################
  pdf_Init()
  Procedure.l pdf_grid(mm.f=-1) ;Defines the abscissa of the current position.
    ipdf_Grid(mm.f)
  EndProcedure 
  
  Procedure.l pdf_AcceptPageBreak() ;Accept automatic page break or not
    ProcedureReturn ipdf_AcceptPageBreak()
  EndProcedure

  Procedure.l pdf_Addlink() ;Creates a new internal link and returns its identifier.
    ProcedureReturn ipdf_AddLink()
  EndProcedure
  
  Procedure.l pdf_ASCII85_Decode(*InputBuffer,InputLength,*OutputBuffer,*OutputLength)
    ProcedureReturn ipdf_ASCII85_Decode(*InputBuffer,InputLength,*OutputBuffer,*OutputLength)
  EndProcedure
  
  Procedure pdf_AddPage(Orientation$="",Format$="") ;Adds a new page to the document.
    ProcedureReturn ipdf_AddPage(Orientation$,Format$)
  EndProcedure
  
  Procedure.l pdf_ASCII85_Encode(*aData.MEM_DataStructure,WidthP.l=73)
    ProcedureReturn ipdf_ASCII85_Encode(*aData.MEM_DataStructure,WidthP.l)
  EndProcedure
  
  Procedure pdf_ASCII85_Free(*aData.MEM_DataStructure)
    ipdf_ASCII85_Free(*aData)
  EndProcedure
  
  Procedure pdf_BookMark(Text$, Level.l=0, Y.f=0,p.l=-1) ;Add bookmark
    ipdf_BookMark(Text$,level,y,p)
  EndProcedure
  
  Procedure pdf_Cell(W.f ,H.f=0, Text$="", Border.l=0, Ln.f=0, Align$="", Fill.l=0, Link.l=0) ;Prints a cell (rectangular area) with optional borders, background color and character string.
    ipdf_Cell(w,h,Text$,Border,ln,Align$,fill,link)
  EndProcedure
  
  Procedure pdf_Circle(X.f, Y.f, R.f, Style$=#PDF_STYLE_DRAW)
    ipdf_Circle(x, y, r, style$)
  EndProcedure
  
  Procedure pdf_DisplayPreferences(Preferences$) ;Set viewer preferences
    pdfDisplayPreferences$ = Preferences$
  EndProcedure
  
  Procedure pdf_Ellipse(X.f, Y.f, Rx.f, Ry.f, Style$=#PDF_STYLE_DRAW)
    ipdf_Ellipse(x, y, rx, ry, style$)
  EndProcedure
  
  Procedure pdf_GetErrorCode() ;Return the error code.
    ProcedureReturn pdfError
  EndProcedure
  
  Procedure.s pdf_GetErrorMessage() ;Return the error message.
    ProcedureReturn ipdf_GetErrorMessage()
  EndProcedure
  
  Procedure.f pdf_GetFontSize() ;Get current fontsize.
    ProcedureReturn ipdf_GetFontSize()
  EndProcedure
  
  Procedure.l pdf_GetMultiCellNewLines() ;Get the last value of newlines for pdf_MultiCell()
    ProcedureReturn pdfMultiCellNewLines
  EndProcedure
  
  Procedure pdf_GetNumbering()
    ProcedureReturn ipdf_GetNumbering()
  EndProcedure
  
  Procedure pdf_GetNumberingFooter()
    ProcedureReturn ipdf_GetNumberingFooter()
  EndProcedure
  Procedure.f pdf_GetPageWidth() ; get current page width
    ProcedureReturn ipdf_GetPageWidth()
  EndProcedure
  Procedure.f pdf_GetPageHeight() ; get current page height
    ProcedureReturn ipdf_GetPageHeight()
  EndProcedure
  
  Procedure pdf_Image(FileName$, X.f, Y.f, W.f=0, H.f=0, Link.l=0,text$="") ;Puts an image in the page.
    ipdf_Image(FileName$,0,0,x,y,w,h,link,text$)
  EndProcedure
  
  Procedure pdf_ImageMem(Name$,*Mem,MemSize, X.f, Y.f, W.f=0, H.f=0, Link.l=0,text$="") ;Puts an image in the page.
    ipdf_Image(Name$,*Mem,MemSize,x,y,w,h,link,text$)
  EndProcedure
  
  Procedure.l pdf_IncludeFileJS(FileName.s)
    ProcedureReturn ipdf_IncludeFileJS(FileName.s)
  EndProcedure
  
  Procedure pdf_IncludeJS(Script$) ;Add JavaScript
    ProcedureReturn ipdf_IncludeJS(Script$)
  EndProcedure
  
  Procedure pdf_InsertTOC(Location.l=1, LabelSize.l=20, EntrySize.l=10, FontFamily$="Times", Label$="Table of Contents") ;Insert table of contents.
    ipdf_InsertTOC(Location, LabelSize, EntrySize, FontFamily$, Label$)
  EndProcedure
  
  Procedure pdf_Line(X1.f,Y1.f,X2.f,Y2.f) ;Draws a line between two points.
    ipdf_Line(X1,Y1,X2,Y2)
  EndProcedure
  
  Procedure pdf_Link(X.f, Y.f, W.f, H.f, Link.l) ;Puts a link on a rectangular area of the page.
    ipdf_Link(X,Y,W,H,Link)
  EndProcedure
  
  Procedure pdf_Ln(Height.f=-1) ;Performs a line break.
    ipdf_Ln(Height)
  EndProcedure
  
  Procedure.s pdf_MultiCell(W.f, H.f, Text$, Border.l=0,Align$="", Fill.l=0, Indent.l=0, Maxline.l=0) ;This method allows printing text with line breaks.
    ProcedureReturn ipdf_MultiCell(w,h,Text$,border,Align$,Fill,indent,maxline)
  EndProcedure
  
  Procedure pdf_MultiCellBlt(W.f, H.f, Blt$, Txt$, Border.l=0, Align$="J", Fill.l=-1) ;Add multicell with bullet
    ipdf_MultiCellBlt(w,h, blt$,txt$, border, align$, fill)
  EndProcedure
  
  Procedure.l pdf_NumPageNum() ;Get TOC page number
    ProcedureReturn ipdf_NumPageNum()
  EndProcedure

  Procedure pdf_PathArc(x1.f, y1.f, x2.f, y2.f, x3.f, y3.f)
    ipdf_Arc(x1,y1,x2,y2,x3,y3)
  EndProcedure
  
  Procedure pdf_PathBegin(X.f,Y.f)
    ipdf_PathBegin(X,Y)
  EndProcedure
  
  Procedure pdf_PathEnd(Style$="")
    ipdf_PathEnd(Style$)
  EndProcedure
  
  Procedure pdf_PathLine(X.f,Y.f)
    ipdf_PathLine(X,Y)
  EndProcedure
  
  Procedure pdf_PathRect(x.f,y.f,w.f,h.f)
    ipdf_PathRect(x.f,y.f,w.f,h.f)
  EndProcedure
  
  Procedure pdf_Rect(X.f,Y.f,W.f,H.f,Style$="") ;Outputs a rectangle.
    ipdf_Rect(x,y,w,h,Style$)
  EndProcedure
  
  Procedure pdf_ResetBookMark() ;Reset bookmarks for new document
    ipdf_ResetBookMark()
  EndProcedure
  
  Procedure pdf_RoundRect(X.f,Y.f,W.f,H.f,R.f,Style$="")
    ipdf_RoundRect(X.f,Y.f,W.f,H.f,R.f,Style$)
  EndProcedure
  
  Procedure pdf_Rotate(Angle.f, X.f=-1, Y.f=-1)
    ipdf_Rotate(angle.f, x, y)
  EndProcedure
  
  Procedure pdf_Save(FileName$) ;Output PDF to filename.
   ProcedureReturn ipdf_Save(FileName$)
  EndProcedure
  
  Procedure pdf_ScaleX(SX.f=100, X.f=-1, Y.f=-1)
    ipdf_Scale(sx, 100, X, Y)
  EndProcedure
  
  Procedure pdf_ScaleY(SY.f=100, X.f=-1, Y.f=-1)
    ipdf_Scale(100, SY, X, Y)
  EndProcedure
  
  Procedure pdf_ScaleXY(S.f=100, X.f=-1, Y.f=-1)
    ipdf_Scale(S, S, X, Y)
  EndProcedure
  
  Procedure pdf_Sector(Xc.f, Yc.f, R.f, A.f, B.f, Style$=#PDF_STYLE_DRAWANDFILL, Cw.l=#True, O.f=90)
    ipdf_Sector(xc, yc, r, r, a, b, style$, cw, o)
  EndProcedure
  
  Procedure pdf_SetAFile(Link.l, File.l, X.f=-1, Page.l=-1, Text$="", Title$="", w.f=16, h.f=16, DateTime.l=0, Icon$="GraphPushPin", Flags.l=0) ; Defines the page and position for File annotations.
    ipdf_SetAFile(Link,File,X,Page,Text$,Title$,w,h,DateTime,Icon$,Flags)
  EndProcedure
  
  Procedure pdf_SetALaunch(Link.l, Y.f=-1, Page.l=-1, Filename$="", Dir$="", Action$="O", Parameter$="") ; Defines the page and position for a launch action.
    ipdf_SetALaunch(Link,Y,Page,Filename$,Dir$,Action$,Parameter$)
  EndProcedure
  
  Procedure pdf_SetAPopUp(Link.l, Y.f=-1, Page.l=-1, Text$="", Title$="", w.f=200, h.f=200, DateTime.l=0, Icon$="Note", Flags.l=0) ; Defines the page and position for PopUp annotations.
    ipdf_SetAPopUp(Link,Y,Page,Text$,Title$,w,h,DateTime,Icon$,Flags)
  EndProcedure
  
  Procedure pdf_SetAText(Link.l, Y.f, Page.l, Text$, Title$, DateTime.l, Icon$, Flags.l) ; Defines the page and position for text annotations.
    ipdf_SetAText(Link,Y,Page,Text$,Title$,DateTime,Icon$,Flags)
  EndProcedure
  
  Procedure pdf_SetDrawColor(Red.f, Green.f=-1, Blue.f=-1) ;Set color for all stroking operations.
    ipdf_SetDrawColor(Red, Green, Blue)
  EndProcedure
  
  Procedure pdf_SetFillColor(Red.f, Green.f=-1, Blue.f=-1) ;Set color for all filling operations.
    ipdf_SetFillColor(Red, Green, Blue)
  EndProcedure
  
  Procedure pdf_SetLineWidth(Width.f) ;Defines the line width.
    ipdf_SetLineWidth(Width)
  EndProcedure
  
  Procedure pdf_SetLink(Link.l, Y.f=-1, Page.l=-1, Url$="") ;Defines the page and position a link points to.
    ipdf_SetLink(Link,y,page,url$)
  EndProcedure
  
  Procedure pdf_SetDash(Black.l, White.l)
    ipdf_SetDash(Black, White)
  EndProcedure
  
  Procedure pdf_SetFont(Family$, Style$="", Size.l=0) ;Sets the font used to print character strings.
    ipdf_SetFont(Family$, Style$, Size)
  EndProcedure
  
  Procedure pdf_SetFontSize(Size.l) ;Defines the size of the current font.
    ipdf_SetFontSize(Size)
  EndProcedure
  
  Procedure pdf_SetTextColor(Red.f, Green.f=-1, Blue.f=-1) ;Set color for text.
    ipdf_SetTextColor(Red, Green, Blue)
  EndProcedure
  
  Procedure pdf_SetNumberingFooter(Value.l)
    ipdf_SetNumberingFooter(Value)
  EndProcedure
  
  Procedure pdf_SetX(X.f) ;Defines the abscissa of the current position.
    ipdf_SetX(X.f)
  EndProcedure 
  
  Procedure pdf_SetY(Y.f,resetx=#True) ;Moves the current abscissa back to the left margin if (resetx=#True) and sets the ordinate.
    ipdf_SetY(Y,resetx)
  EndProcedure 
  
  Procedure pdf_SetXY(X.f,Y.f) ;Defines the abscissa and ordinate of the current position.
    ipdf_SetXY(X,Y)
  EndProcedure
  
  Procedure pdf_StartPageNums() ;Start TOC page numbering.
    ipdf_StartPageNums()
  EndProcedure
  
  Procedure pdf_StopPageNums() ;Stop TOC page numbering.
    ipdf_StopPageNums()
  EndProcedure	
  
  Procedure pdf_SubWrite(H.f, Txt$, Link.l=-1, SubFontSize.l=12, SubOffSet.f=0) ;write superscripted or supscripted
    ipdf_SubWrite(h, txt$, link, SubFontSize, SubOffSet)
  EndProcedure
  
  Procedure pdf_Text(X.f,Y.f,Text$) ;Prints a character string.
    ipdf_Text(X,Y,Text$)
  EndProcedure
  
  ProcedureDLL pdf_TOCEntry(Text$, Level.l=0) ;Set TOC entry
    ipdf_TOCEntry(Text$, level)
  EndProcedure
  
  Procedure pdf_Triangle(X1.f,Y1.f,X2.f,Y2.f,X3.f,Y3.f,Style$="")
    ipdf_Triangle(X1,Y1,X2,Y2,X3,Y3,Style$)
  EndProcedure
  
  Procedure.s pdf_TruncateCell(w.f,h.f,Text$="",Border.l=0,Ln.f=0,Align$=#PDF_ALIGN_LEFT,Fill.l=0,Link.l=0,Trunc$="...") ; Prints a Cell, if text is too large it will be truncated
    ProcedureReturn ipdf_TruncateCell(w,h,Text$,Border,Ln,Align$,Fill,Link,Trunc$)
  EndProcedure
  
  Procedure pdf_Write(H.f, Text$, Link.l=0) ;This method prints text from the current position.
    ipdf_Write(h,Text$,link)
  EndProcedure
  
  Procedure pdf_SetProcHeader(ProcAddress, StructAddress = #Null) ;Set header procedure.
    ipdf_SetProcHeader(ProcAddress,StructAddress)
  EndProcedure
  
  Procedure pdf_SetProcFooter(ProcAddress, StructAddress = #Null) ;Set footer procedure.
    ipdf_SetProcFooter(ProcAddress,StructAddress)
  EndProcedure
  
  Procedure pdf_SetProcAcceptPageBreak(ProcAddress) ;Set acceptpagebreak procedure.
    ipdf_SetProcAcceptPageBreak(ProcAddress)
  EndProcedure
  
  Procedure pdf_SetProcCompression(ProcAddress) ;Set compression procedure.
    ipdf_SetProcCompression(ProcAddress)
  EndProcedure
  
  Procedure pdf_SetTitle(Title$) ;Defines the title of the document.
    ipdf_SetTitle(Title$)
  EndProcedure
  
  Procedure pdf_SetSubject(Subject$) ;Defines the subject of the document.
    ipdf_SetSubject(Subject$)
  EndProcedure
  
  Procedure pdf_SetAuthor(Author$) ;Defines the author of the document.
    ipdf_SetAuthor(Author$)
  EndProcedure
  
  Procedure pdf_SetKeywords(Keywords$) ;Associates keywords with the document, generally in the form 'keyword1 keyword2 ...'.
    ipdf_SetKeywords(Keywords$)
  EndProcedure
  
  Procedure pdf_SetCreator(Creator$) ; Defines the creator of the document.
    ipdf_SetCreator(Creator$)
  EndProcedure
  
  Procedure pdf_AliasNbPages(Alias$="{nb}") ;Defines an alias for the total number of pages.
    ipdf_AliasNbPages(Alias$)
  EndProcedure
  
  Procedure.l pdf_GetPageNo() ;Returns the current page number.
    ProcedureReturn ipdf_GetPageNo()
  EndProcedure
  
  Procedure.f pdf_GetX() ;Returns the abscissa of the current position.
    ProcedureReturn ipdf_GetX()
  EndProcedure
  
  Procedure.f pdf_GetY() ;Returns the ordinate of the current position.
    ProcedureReturn ipdf_GetY()
  EndProcedure
  
  Procedure pdf_Create(Orientation$="", Unit$="", Format$="") ;Begin document.
    ProcedureReturn ipdf_Create(Orientation$, Unit$, Format$)  
  EndProcedure
  
  Procedure pdf_SetDisplayMode(Zoom.l, Layout$=#PDF_LAYOUT_CONTINUOUS) ;Set display mode in viewer.
    ipdf_SetDisplayMode(Zoom, Layout$)
  EndProcedure
  
  Procedure pdf_SetAutoPageBreak(Auto.l, Margin.f=0) ;Set auto page break mode and triggering margin.
    ipdf_SetAutoPageBreak(Auto, Margin)
  EndProcedure
  
  Procedure pdf_SetMargins(LeftMargin.f, TopMargin.f, RightMargin.f=-1) ;Set left, top and right margins.
    ipdf_SetMargins(LeftMargin, TopMargin, RightMargin)
  EndProcedure
  
  Procedure pdf_SetTopMargin(TopMargin.f) ;Set top margin.
    ipdf_SetTopMargin(TopMargin.f)
  EndProcedure
  
  Procedure pdf_SetRightMargin(RightMargin.f) ;Set right margin.
    ipdf_SetRightMargin(RightMargin.f)
  EndProcedure
  
  Procedure pdf_SetCellMargin(CellMargin.f) ;Set cell margin.
    ipdf_SetCellMargin(CellMargin.f)
  EndProcedure
  
  Procedure pdf_SetLeftMargin(LeftMargin.f) ;Set left margin.
    ipdf_SetLeftMargin(LeftMargin.f)
  EndProcedure
  
  Procedure pdf_EmbedFile(Filename$,Description$="")
    ProcedureReturn ipdf_EmbedFile(Filename$,Description$)
  EndProcedure
  
  Procedure.f pdf_GetStringWidth(String$) ;Get width of a string in the current font.
    ProcedureReturn ipdf_GetStringWidth(String$)
  EndProcedure
  
  Procedure.s pdf_TextString(String$) ;Format a text string.
    ProcedureReturn ipdf_TextString(String$)
  EndProcedure
  
  Procedure.f pdf_GetCMargin() ;Get cell margin.
    ProcedureReturn ipdf_GetCMargin()
  EndProcedure
  
  Procedure.f pdf_GetRMargin() ;Get right margin.
    ProcedureReturn ipdf_GetRMargin()
  EndProcedure
  
  Procedure.f pdf_GetLMargin() ;Get left margin.
    ProcedureReturn ipdf_GetLMargin()
  EndProcedure
  
  Procedure.f pdf_GetWs() ;Get word spacing. 
    ProcedureReturn ipdf_GetWs()
  EndProcedure
  
  Procedure pdf_SetWs(WordSpacing.f) ;Set word spacing. 
    ipdf_SetWs(WordSpacing)
  EndProcedure
  
  Procedure.f pdf_GetW() ;Get current width of page. 
    ProcedureReturn ipdf_GetW()
  EndProcedure
  
  Procedure.f pdf_GetH() ;Get current height of page.
    ProcedureReturn ipdf_GetH()
  EndProcedure
  
  Procedure.f pdf_GetK() ;Get scale factor.
    ProcedureReturn ipdf_GetK()
  EndProcedure
  
  Procedure.l pdf_GetN() ;Get object number
    ProcedureReturn ipdf_GetN()
  EndProcedure
  
  Procedure.l pdf_GetFontSizePt() ;Get current fontsize in points.
    ProcedureReturn ipdf_GetFontSizePt()
  EndProcedure
  
  Procedure pdf_StartTransform()
    ipdf_Out("q")
  EndProcedure
  
  Procedure pdf_StopTransform()
    ipdf_Out("Q")
  EndProcedure
  
  Procedure pdf_Translate(TX.f, TY.f)
    ipdf_Translate(TX, TY)
  EndProcedure
  
  Procedure pdf_TranslateX(TX.f)
    ipdf_Translate(TX,0)
  EndProcedure
  
  Procedure pdf_TranslateY(TY.f)
    ipdf_Translate(0,TY)
  EndProcedure
  
  Procedure pdf_SkewX(AngleX,X.f=-1,Y.f=-1)
    ipdf_Skew(AngleX,0,X,Y)
  EndProcedure
  
  Procedure pdf_SkewY(AngleY,X.f=-1,Y.f=-1)
    ipdf_Skew(0,AngleY,X,Y)
  EndProcedure
  
  Procedure pdf_MirrorH(X.f=-1)
    ipdf_Scale(-100,100,X,-1)
  EndProcedure
  
  Procedure pdf_MirrorV(Y.f=-1)
    ipdf_Scale(100,-100,-1,Y)
  EndProcedure
  
  Procedure pdf_SetLineCap(Style.s)
    ipdf_Out(Style + " J")
  EndProcedure
  
  Procedure pdf_SetLineJoin(Style.s)
    ipdf_Out(Style + " j")
  EndProcedure
  
  Procedure pdf_SetTextColorCMYK(Cyan.f, Magenta.f, Yellow.f, Black.f) ;Set Textcolor CMYK
    ipdf_SetTextColorCMYK(Cyan, Magenta, Yellow, Black)
  EndProcedure
  
  Procedure pdf_SetDrawColorCMYK(Cyan.f, Magenta.f, Yellow.f, Black.f) ;Set Drawcolor CMYK
    ipdf_SetDrawColorCMYK(Cyan, Magenta, Yellow, Black)
  EndProcedure
  
  Procedure pdf_SetFillColorCMYK(Cyan.f, Magenta.f, Yellow.f, Black.f) ;Set Fillcolor CMYK
    ipdf_SetFillColorCMYK(Cyan, Magenta, Yellow, Black)
  EndProcedure
;} PurePDF as includefile
CompilerElse
;{ PurePDF as TailBite-library
  ;#######################
  ;# TailBite / DLL-code #
  ;#######################
  ProcedureDLL.l pdf_AcceptPageBreak() ;Accept automatic page break or not
    ProcedureReturn ipdf_AcceptPageBreak()
  EndProcedure
 
  ProcedureDLL.l pdf_Addlink() ;Creates a new internal link and returns its identifier.
    ProcedureReturn ipdf_AddLink()
  EndProcedure
  
  ProcedureDLL.l pdf_ASCII85_Decode(*InputBuffer,InputLength,*OutputBuffer,*OutputLength)
    ProcedureReturn ipdf_ASCII85_Decode(*InputBuffer,InputLength,*OutputBuffer,*OutputLength)
  EndProcedure
  
  ProcedureDLL pdf_AddPage() ;Adds a new page to the document.
    ProcedureReturn ipdf_AddPage()
  EndProcedure
  
  ProcedureDLL pdf_AddPage2(Orientation$) ;Adds a new page to the document.
    ProcedureReturn ipdf_AddPage(Orientation$)
  EndProcedure
  
  ProcedureDLL pdf_AddPage3(Orientation$,Format$) ;Adds a new page to the document.
    ProcedureReturn ipdf_AddPage(Orientation$,Format$)
  EndProcedure
  
  ProcedureDLL.l pdf_ASCII85_Encode(*aData.MEM_DataStructure)
    ProcedureReturn ipdf_ASCII85_Encode(*aData.MEM_DataStructure)
  EndProcedure
  
  ProcedureDLL.l pdf_ASCII85_Encode2(*aData.MEM_DataStructure,WidthP.l)
    ProcedureReturn ipdf_ASCII85_Encode(*aData.MEM_DataStructure,WidthP.l)
  EndProcedure
  
  ProcedureDLL pdf_ASCII85_Free(*aData.MEM_DataStructure)
    ipdf_ASCII85_Free(*aData)
  EndProcedure
  
  ProcedureDLL pdf_BookMark(Text$) ;Add bookmark
    ipdf_BookMark(Text$)
  EndProcedure 
  
  ProcedureDLL pdf_BookMark2(Text$, Level.l) ;Add bookmark
    ipdf_BookMark(Text$,level)
  EndProcedure
  
  ProcedureDLL pdf_BookMark3(Text$, Level.l, Y.f) ;Add bookmark
    ipdf_BookMark(Text$,level,y)
  EndProcedure
  
   ProcedureDLL pdf_BookMark4(Text$, Level.l, Y.f, p.l) ;Add bookmark
    ipdf_BookMark(Text$,level,y,p)
  EndProcedure 
  
  ProcedureDLL pdf_Cell(W.f) ;Prints a cell (rectangular area) with optional borders, background color and character string.
    ipdf_Cell(w)
  EndProcedure
  
  ProcedureDLL pdf_Cell2(W.f ,H.f ) ;Prints a cell (rectangular area) with optional borders, background color and character string.
    ipdf_Cell(w,h)
  EndProcedure
  
  ProcedureDLL pdf_Cell3(W.f ,H.f, Text$ ) ;Prints a cell (rectangular area) with optional borders, background color and character string.
    ipdf_Cell(w,h,Text$)
  EndProcedure
  
  ProcedureDLL pdf_Cell4(W.f ,H.f ,Text$, Border.l) ;Prints a cell (rectangular area) with optional borders, background color and character string.
    ipdf_Cell(w,h,Text$,border)
  EndProcedure
  
  ProcedureDLL pdf_Cell5(W.f ,H.f ,Text$, Border.l, Ln.f) ;Prints a cell (rectangular area) with optional borders, background color and character string.
    ipdf_Cell(w,h,Text$,border,ln)
  EndProcedure
  
  ProcedureDLL pdf_Cell6(W.f ,H.f ,Text$, Border.l, Ln.f, Align$) ;Prints a cell (rectangular area) with optional borders, background color and character string.
    ipdf_Cell(w,h,Text$,border,ln,Align$)
  EndProcedure
  
  ProcedureDLL pdf_Cell7(W.f ,H.f ,Text$, Border.l, Ln.f, Align$, Fill.l) ;Prints a cell (rectangular area) with optional borders, background color and character string.
    ipdf_Cell(w,h,Text$,border,ln,Align$,fill)
  EndProcedure
  
  ProcedureDLL pdf_Cell8(W.f ,H.f ,Text$, Border.l, Ln.f, Align$, Fill.l, Link.l) ;Prints a cell (rectangular area) with optional borders, background color and character string.
    ipdf_Cell(w,h,Text$,border,ln,Align$,fill,link)
  EndProcedure
  
  ProcedureDLL pdf_Circle(X.f, Y.f, R.f)
    ipdf_Circle(x, y, r, #PDF_STYLE_DRAW)
  EndProcedure
  
  ProcedureDLL pdf_Circle2(X.f, Y.f, R.f, Style$)
    ipdf_Circle(x, y, r, style$)
  EndProcedure
  
  ProcedureDLL pdf_DisplayPreferences(Preferences$) ;Set viewer preferences
    pdfDisplayPreferences$ = Preferences$
  EndProcedure
  
  ProcedureDLL pdf_Ellipse(X.f, Y.f, Rx.f, Ry.f)
    ipdf_Ellipse(x, y, rx, ry, #PDF_STYLE_DRAW)
  EndProcedure
  
  ProcedureDLL pdf_Ellipse2(X.f, Y.f, Rx.f, Ry.f, Style$)
    ipdf_Ellipse(x, y, rx, ry, style$)
  EndProcedure
  
  ProcedureDLL pdf_GetErrorCode() ;Return the error code.
    ProcedureReturn pdfError
  EndProcedure
  
  ProcedureDLL.s pdf_GetErrorMessage() ;Return the error message.
    ProcedureReturn ipdf_GetErrorMessage()
  EndProcedure
  
  ProcedureDLL.f pdf_GetFontSize() ;Get current fontsize in points.
    ProcedureReturn ipdf_GetFontSize()
  EndProcedure
  
  ProcedureDLL.l pdf_GetMultiCellNewLines() ;Get the last value of newlines for pdf_MultiCell()
    ProcedureReturn pdfMultiCellNewLines
  EndProcedure
  
  ProcedureDLL pdf_GetNumbering()
    ProcedureReturn ipdf_GetNumbering()
  EndProcedure
  
  ProcedureDLL pdf_GetNumberingFooter()
    ProcedureReturn ipdf_GetNumberingFooter()
  EndProcedure
  
  ProcedureDLL pdf_Image(FileName$, X.f, Y.f) ;Puts an image in the page.
    ipdf_Image(FileName$,0,0,x,y)
  EndProcedure
  
  ProcedureDLL pdf_Image2(FileName$, X.f, Y.f, W.f) ;Puts an image in the page.
    ipdf_Image(FileName$,0,0,x,y,w)
  EndProcedure
  
  ProcedureDLL pdf_Image3(FileName$, X.f, Y.f, W.f, H.f) ;Puts an image in the page.
    ipdf_Image(FileName$,0,0,x,y,w,h)
  EndProcedure
  
  ProcedureDLL pdf_Image4(FileName$, X.f, Y.f, W.f, H.f, Link.l) ;Puts an image in the page.
    ipdf_Image(FileName$,0,0,x,y,w,h,link)
  EndProcedure
  
  ProcedureDLL pdf_ImageMem(Name$,*Mem,MemSize, X.f, Y.f) ;Puts an image in the page.
    ipdf_Image(Name$,*Mem,MemSize,x,y)
  EndProcedure
  
  ProcedureDLL pdf_ImageMem2(Name$,*Mem,MemSize, X.f, Y.f, W.f) ;Puts an image in the page.
    ipdf_Image(Name$,*Mem,MemSize,x,y,w)
  EndProcedure
  
  ProcedureDLL pdf_ImageMem3(Name$,*Mem,MemSize, X.f, Y.f, W.f, H.f) ;Puts an image in the page.
    ipdf_Image(Name$,*Mem,MemSize,x,y,w,h)
  EndProcedure
  
  ProcedureDLL pdf_ImageMem4(Name$,*Mem,MemSize, X.f, Y.f, W.f, H.f, Link.l) ;Puts an image in the page.
    ipdf_Image(Name$,*Mem,MemSize,x,y,w,h,link)
  EndProcedure
    ProcedureDLL pdf_ImageMem5(Name$,*Mem,MemSize, X.f, Y.f, W.f, H.f, Link.l,text$) ;Puts an image in the page.
    ipdf_Image(Name$,*Mem,MemSize,x,y,w,h,link,text$)
  EndProcedure
  ProcedureDLL.l pdf_IncludeFileJS(FileName.s)
    ProcedureReturn ipdf_IncludeJS(FileName.s)
  EndProcedure
  
  ProcedureDLL pdf_IncludeJS(Script$) ;Add JavaScript
    ProcedureReturn ipdf_IncludeJS(Script$)
  EndProcedure
  
  ProcedureDLL pdf_InsertTOC() ;Insert table of contents.
    ipdf_InsertTOC()
  EndProcedure
  
  ProcedureDLL pdf_InsertTOC2(Location.l) ;Insert table of contents.
    ipdf_InsertTOC(Location, 20, 10, "Times", "Table of Contents")
  EndProcedure
  
  ProcedureDLL pdf_InsertTOC3(Location.l, LabelSize.l) ;Insert table of contents.
    ipdf_InsertTOC(Location, LabelSize, 10, "Times", "Table of Contents")
  EndProcedure
  
  ProcedureDLL pdf_InsertTOC4(Location.l, LabelSize.l, EntrySize.l) ;Insert table of contents.
    ipdf_InsertTOC(Location, LabelSize, EntrySize, "Times", "Table of Contents")
  EndProcedure
  
  ProcedureDLL pdf_InsertTOC5(Location.l, LabelSize.l, EntrySize.l, FontFamily$) ;Insert table of contents.
    ipdf_InsertTOC(Location, LabelSize, EntrySize, FontFamily$, "Table of Contents")
  EndProcedure
  
  ProcedureDLL pdf_InsertTOC6(Location.l, LabelSize.l, EntrySize.l, FontFamily$, Label$) ;Insert table of contents.
    ipdf_InsertTOC(Location, LabelSize, EntrySize, FontFamily$, Label$)
  EndProcedure
  
  ProcedureDLL pdf_Line(X1.f,Y1.f,X2.f,Y2.f) ;Draws a line between two points.
    ipdf_Line(X1,Y1,X2,Y2)
  EndProcedure
  
  ProcedureDLL pdf_Link(X.f, Y.f, W.f, H.f, Link.l) ;Puts a link on a rectangular area of the page.
    ipdf_Link(X,Y,W,H,Link)
  EndProcedure
  
  ProcedureDLL pdf_Ln() ;Performs a line break.
    ipdf_Ln()
  EndProcedure
  
  ProcedureDLL pdf_Ln2(Height.f) ;Performs a line break.
    ipdf_Ln(Height)
  EndProcedure
  
  ProcedureDLL pdf_MirrorH()
    ipdf_Scale(-100,100,-1,-1)
  EndProcedure
  
  ProcedureDLL pdf_MirrorH2(X.f)
    ipdf_Scale(-100,100,X,-1)
  EndProcedure
  
  ProcedureDLL pdf_MirrorV()
    ipdf_Scale(100,-100,-1,-1)
  EndProcedure
  
  ProcedureDLL pdf_MirrorV2(Y.f)
    ipdf_Scale(100,-100,-1,Y)
  EndProcedure
  
  ProcedureDLL.s pdf_MultiCell(W.f, H.f, Text$) ;This method allows printing text with line breaks.
    ProcedureReturn ipdf_MultiCell(w,h,Text$)
  EndProcedure
  
  ProcedureDLL.s pdf_MultiCell2(W.f, H.f, Text$, Border.l) ;This method allows printing text with line breaks.
    ProcedureReturn ipdf_MultiCell(w,h,Text$,border)
  EndProcedure
  
  ProcedureDLL.s pdf_MultiCell3(W.f, H.f, Text$, Border.l,Align$) ;This method allows printing text with line breaks.
    ProcedureReturn ipdf_MultiCell(w,h,Text$,border,Align$)
  EndProcedure
  
  ProcedureDLL.s pdf_MultiCell4(W.f, H.f, Text$, Border.l,Align$, Fill.f) ;This method allows printing text with line breaks.
    ProcedureReturn ipdf_MultiCell(w,h,Text$,border,Align$,Fill)
  EndProcedure
  
  ProcedureDLL.s pdf_MultiCell5(W.f, H.f, Text$, Border.l,Align$, Fill.f, Indent.f) ;This method allows printing text with line breaks.
    ProcedureReturn ipdf_MultiCell(w,h,Text$,border,Align$,Fill,indent)
  EndProcedure
  
  ProcedureDLL.s pdf_MultiCell6(W.f, H.f, Text$, Border.l,Align$, Fill.f, Indent.f, Maxline.l) ;This method allows printing text with line breaks.
    ProcedureReturn ipdf_MultiCell(w,h,Text$,border,Align$,Fill,indent,maxline)
  EndProcedure
  
  ProcedureDLL pdf_MultiCellBlt(W.f, H.f, Blt$, Txt$) ;Add multicell with bullet
    ipdf_MultiCellBlt(w, h, blt$, txt$)
  EndProcedure
  
  ProcedureDLL pdf_MultiCellBlt2(W.f, H.f, Blt$, Txt$, Border.f) ;Add multicell with bullet
    ipdf_MultiCellBlt(w, h, blt$, txt$, border)
  EndProcedure
  
  ProcedureDLL pdf_MultiCellBlt3(W.f, H.f, Blt$, Txt$, Border.f, Align$) ;Add multicell with bullet
    ipdf_MultiCellBlt(w,h, blt$,txt$, border, align$)
  EndProcedure
  
  ProcedureDLL pdf_MultiCellBlt4(W.f, H.f, Blt$, Txt$, Border.f, Align$, Fill.f) ;Add multicell with bullet
    ipdf_MultiCellBlt(w,h, blt$,txt$, border, align$, fill)
  EndProcedure
  
  ProcedureDLL.l pdf_NumPageNum() ;Get TOC page number
    ProcedureReturn ipdf_NumPageNum()
  EndProcedure
  
  ProcedureDLL pdf_PathArc(x1.f, y1.f, x2.f, y2.f, x3.f, y3.f)
    ipdf_Arc(x1,y1,x2,y2,x3,y3)
  EndProcedure
  
  ProcedureDLL pdf_PathBegin(X.f,Y.f)
    ipdf_PathBegin(X,Y)
  EndProcedure
  
  ProcedureDLL pdf_PathEnd()
    ipdf_PathEnd("")
  EndProcedure
  
  ProcedureDLL pdf_PathEnd2(Style$)
    ipdf_PathEnd(Style$)
  EndProcedure
  
  ProcedureDLL pdf_PathLine(X.f,Y.f)
    ipdf_PathLine(X,Y)
  EndProcedure
  
  ProcedureDLL pdf_PathRect(x.f,y.f,w.f,h.f)
    ipdf_PathRect(x.f,y.f,w.f,h.f)
  EndProcedure
  
  ProcedureDLL pdf_Rect(X.f,Y.f,W.f,H.f) ;Outputs a rectangle.
    ipdf_Rect(x,y,w,h)
  EndProcedure
  
  ProcedureDLL pdf_Rect2(X.f,Y.f,W.f,H.f,Style$) ;Outputs a rectangle.
    ipdf_Rect(x,y,w,h,Style$)
  EndProcedure
  
  ProcedureDLL pdf_ResetBookMark() ;Reset bookmarks for new document
    ipdf_ResetBookMark()
  EndProcedure
  
  ProcedureDLL pdf_Rotate(Angle.f)
    ipdf_Rotate(angle)
  EndProcedure 
  
  ProcedureDLL pdf_Rotate2(Angle.f, X.f)
    ipdf_Rotate(angle, x)
  EndProcedure
  
  ProcedureDLL pdf_Rotate3(Angle.f, X.f, Y.f)
    ipdf_Rotate(angle.f, x, y)
  EndProcedure
  
  ProcedureDLL pdf_RoundRect(X.f,Y.f,W.f,H.f,R.f)
    ipdf_RoundRect(X.f,Y.f,W.f,H.f,R.f)
  EndProcedure
  
  ProcedureDLL pdf_RoundRect2(X.f,Y.f,W.f,H.f,R.f,Style$)
    ipdf_RoundRect(X.f,Y.f,W.f,H.f,R.f,Style$)
  EndProcedure
  
  ProcedureDLL pdf_Save(FileName$) ;Output PDF to filename.
    ProcedureReturn ipdf_Save(FileName$)
  EndProcedure
  
  ProcedureDLL pdf_ScaleX(SX.f)
    ipdf_Scale(sx, 100, -1, -1)
  EndProcedure
  
  ProcedureDLL pdf_ScaleX2(SX.f, X.f)
    ipdf_Scale(sx, 100, X, -1)
  EndProcedure
  
  ProcedureDLL pdf_ScaleX3(SX.f, X.f, Y.f)
    ipdf_Scale(sx, 100, X, Y)
  EndProcedure
  
  ProcedureDLL pdf_ScaleY(SY.f)
    ipdf_Scale(100, SY, -1, -1)
  EndProcedure
  
  ProcedureDLL pdf_ScaleY2(SY.f, X.f)
    ipdf_Scale(100, SY, X, -1)
  EndProcedure
  
  ProcedureDLL pdf_ScaleY3(SY.f, X.f, Y.f)
    ipdf_Scale(100, SY, X, Y)
  EndProcedure
  
  ProcedureDLL pdf_ScaleXY(S.f)
    ipdf_Scale(S, S, -1, -1)
  EndProcedure
  
  ProcedureDLL pdf_ScaleXY2(S.f, X.f)
    ipdf_Scale(S, S, X, -1)
  EndProcedure
  
  ProcedureDLL pdf_ScaleXY3(S.f, X.f, Y.f)
    ipdf_Scale(S, S, X, Y)
  EndProcedure
  
  ProcedureDLL pdf_Sector(Xc.f, Yc.f, R.f, A.f, B.f)
    ipdf_Sector(xc, yc, r, r, a, b, #PDF_STYLE_DRAWANDFILL, #True, 90)
  EndProcedure
  
  ProcedureDLL pdf_Sector2(Xc.f, Yc.f, R.f, A.f, B.f, Style$)
    ipdf_Sector(xc, yc, r, r, a, b, style$, #True, 90)
  EndProcedure
  
  ProcedureDLL pdf_Sector3(Xc.f, Yc.f, R.f, A.f, B.f, Style$, Cw.l)
    ipdf_Sector(xc, yc, r, r, a, b, style$, cw, 90)
  EndProcedure
  
  ProcedureDLL pdf_Sector4(Xc.f, Yc.f, R.f, A.f, B.f, Style$, Cw.l, O.f)
    ipdf_Sector(xc, yc, r, r, a, b, style$, cw, o)
  EndProcedure
  
  ProcedureDLL pdf_SetDash(Black.l, White.l)
    ipdf_SetDash(Black, White)
  EndProcedure
  
  ProcedureDLL pdf_SetDrawColor(Red.f) ;Set color for all stroking operations.
    ipdf_SetDrawColor(Red)
  EndProcedure
  
  ProcedureDLL pdf_SetDrawColor2(Red.f, Green.f) ;Set color for all stroking operations.
    ipdf_SetDrawColor(Red)
  EndProcedure
  
  ProcedureDLL pdf_SetDrawColor3(Red.f, Green.f, Blue.f) ;Set color for all stroking operations.
    ipdf_SetDrawColor(Red, Green, Blue)
  EndProcedure
  
  ProcedureDLL pdf_SetFillColor(Red.f) ;Set color for all filling operations.
    ipdf_SetFillColor(Red)
  EndProcedure
  
  ProcedureDLL pdf_SetFillColor2(Red.f, Green.f) ;Set color for all filling operations.
    ipdf_SetFillColor(Red, Green)
  EndProcedure
  
  ProcedureDLL pdf_SetFillColor3(Red.f, Green.f, Blue.f) ;Set color for all filling operations.
    ipdf_SetFillColor(Red, Green, Blue)
  EndProcedure
  
  ProcedureDLL pdf_SetFontSize(Size.l) ;Defines the size of the current font.
    ipdf_SetFontSize(Size)
  EndProcedure
  
  ProcedureDLL pdf_SetLineWidth(Width.f) ;Defines the line width.
    ipdf_SetLineWidth(Width)
  EndProcedure
  
  ProcedureDLL pdf_SetLink(Link.l) ;Defines the page and position a link points to.
    ipdf_SetLink(Link)
  EndProcedure
  
  ProcedureDLL pdf_SetLink2(Link.l, Y.f) ;Defines the page and position a link points to.
    ipdf_SetLink(Link,y)
  EndProcedure
  
  ProcedureDLL pdf_SetLink3(Link.l, Y.f, Page.l) ;Defines the page and position a link points to.
    ipdf_SetLink(Link,y,page,"")
  EndProcedure
  
  ProcedureDLL pdf_SetLink4(Link.l, Y.f, Page.l, Url$) ;Defines the page and position a link points to.
    ipdf_SetLink(Link,y,page,url$)
  EndProcedure
  
  ProcedureDLL pdf_SetAFile(Link.l, File.l, X.f, Page.l, Text$, Title$, w.f, h.f, DateTime.l, Icon$, Flags.l) ; Defines the page and position for File annotations.
    ipdf_SetAFile(Link,File,X,Page,Text$,Title$,w,h,DateTime,Icon$,Flags)
  EndProcedure
  
  ProcedureDLL pdf_SetALaunch(Link.l, Y.f, Page.l, Filename$) ; Defines the page and position for a launch action.
    ipdf_SetALaunch(Link,Y,Page,Filename$)
  EndProcedure
  
  ProcedureDLL pdf_SetALaunch2(Link.l, Y.f, Page.l, Filename$, Dir$) ; Defines the page and position for a launch action.
    ipdf_SetALaunch(Link,Y,Page,Filename$,Dir$)
  EndProcedure
  
  ProcedureDLL pdf_SetALaunch3(Link.l, Y.f, Page.l, Filename$, Dir$, Action$) ; Defines the page and position for a launch action.
    ipdf_SetALaunch(Link,Y,Page,Filename$,Dir$,Action$)
  EndProcedure
  
  ProcedureDLL pdf_SetALaunch4(Link.l, Y.f, Page.l, Filename$, Dir$, Action$, Parameter$) ; Defines the page and position for a launch action.
    ipdf_SetALaunch(Link,Y,Page,Filename$,Dir$,Action$,Parameter$)
  EndProcedure
  
  ProcedureDLL pdf_SetAText(Link.l, Y.f, Page.l, Text$) ; Defines the page and position for text annotations.
    ipdf_SetAText(Link,Y,Page,Text$)
  EndProcedure
  
  ProcedureDLL pdf_SetAText2(Link.l, Y.f, Page.l, Text$, Title$) ; Defines the page and position for text annotations.
    ipdf_SetAText(Link,Y,Page,Text$,Title$)
  EndProcedure
  
  ProcedureDLL pdf_SetAText3(Link.l, Y.f, Page.l, Text$, Title$, DateTime.l) ; Defines the page and position for text annotations.
    ipdf_SetAText(Link,Y,Page,Text$,Title$,DateTime)
  EndProcedure
  
  ProcedureDLL pdf_SetAText4(Link.l, Y.f, Page.l, Text$, Title$, DateTime.l, Icon$) ; Defines the page and position for text annotations.
    ipdf_SetAText(Link,Y,Page,Text$,Title$,DateTime,Icon$)
  EndProcedure
  
  ProcedureDLL pdf_SetAText5(Link.l, Y.f, Page.l, Text$, Title$, DateTime.l, Icon$, Flags.l) ; Defines the page and position for text annotations.
    ipdf_SetAText(Link,Y,Page,Text$,Title$,DateTime,Icon$,Flags)
  EndProcedure
  
  ProcedureDLL pdf_SetAPopUp(Link.l, Y.f, Page.l, Text$) ; Defines the page and position for PopUp annotations.
    ipdf_SetAPopUp(Link,Y,Page,Text$)
  EndProcedure
  
  ProcedureDLL pdf_SetAPopUp2(Link.l, Y.f, Page.l, Text$, Title$) ; Defines the page and position for PopUp annotations.
    ipdf_SetAPopUp(Link,Y,Page,Text$,Title$)
  EndProcedure
  
  ProcedureDLL pdf_SetAPopUp3(Link.l, Y.f, Page.l, Text$, Title$, w.f, h.f) ; Defines the page and position for PopUp annotations.
    ipdf_SetAPopUp(Link,Y,Page,Text$,Title$,w,h)
  EndProcedure
  
  ProcedureDLL pdf_SetAPopUp4(Link.l, Y.f, Page.l, Text$, Title$, w.f, h.f, DateTime.l) ; Defines the page and position for PopUp annotations.
    ipdf_SetAPopUp(Link,Y,Page,Text$,Title$,w,h,DateTime)
  EndProcedure
  
  ProcedureDLL pdf_SetAPopUp5(Link.l, Y.f, Page.l, Text$, Title$, w.f, h.f, DateTime.l, Icon$) ; Defines the page and position for PopUp annotations.
    ipdf_SetAPopUp(Link,Y,Page,Text$,Title$,w,h,DateTime,Icon$)
  EndProcedure
  
  ProcedureDLL pdf_SetAPopUp6(Link.l, Y.f, Page.l, Text$, Title$, w.f, h.f, DateTime.l, Icon$, Flags.l) ; Defines the page and position for PopUp annotations.
    ipdf_SetAPopUp(Link,Y,Page,Text$,Title$,w,h,DateTime,Icon$,Flags)
  EndProcedure
  
  ProcedureDLL pdf_SetFont(Family$) ;Sets the font used to print character strings.
    ipdf_SetFont(Family$)
  EndProcedure
  
  ProcedureDLL pdf_SetFont2(Family$, Style$) ;Sets the font used to print character strings.
    ipdf_SetFont(Family$, Style$)
  EndProcedure
  
  ProcedureDLL pdf_SetFont3(Family$, Style$, Size.l) ;Sets the font used to print character strings.
    ipdf_SetFont(Family$, Style$, Size)
  EndProcedure
  
  ProcedureDLL pdf_SetTextColor(Red.f) ;Set color for text.
    ipdf_SetTextColor(Red)
  EndProcedure
  
  ProcedureDLL pdf_SetTextColor2(Red.f, Green.f) ;Set color for text.
    ipdf_SetTextColor(Red, Green)
  EndProcedure
  
  ProcedureDLL pdf_SetTextColor3(Red.f, Green.f, Blue.f) ;Set color for text.
    ipdf_SetTextColor(Red, Green, Blue)
  EndProcedure
  
  ProcedureDLL pdf_SetNumberingFooter(Value.l)
    ipdf_SetNumberingFooter(Value)
  EndProcedure
  
  ProcedureDLL pdf_SetX(X.f) ;Defines the abscissa of the current position.
    ipdf_SetX(X.f)
  EndProcedure 
  
  ProcedureDLL pdf_SetY(Y.f,resetx=#True) ;Moves the current abscissa back to the left margin if (resetx=#True) and sets the ordinate.
    ipdf_SetY(Y,resetx)
  EndProcedure 
  
  ProcedureDLL pdf_SetXY(X.f,Y.f) ;Defines the abscissa and ordinate of the current position.
    ipdf_SetXY(X,Y)
  EndProcedure
  
  ProcedureDLL pdf_Skew(AngleX.f, AngleY)
    ipdf_Skew(AngleX, AngleY, -1, -1)
  EndProcedure
  
  ProcedureDLL pdf_Skew2(AngleX.f, AngleY, X.f)
    ipdf_Skew(AngleX, AngleY, X, -1)
  EndProcedure
  
  ProcedureDLL pdf_Skew3(AngleX.f, AngleY, X.f, Y.f)
    ipdf_Skew(AngleX, AngleY, X, Y)
  EndProcedure
  
  ProcedureDLL pdf_SkewX(AngleX)
    ipdf_Skew(AngleX,0,-1,-1)
  EndProcedure
  
  ProcedureDLL pdf_SkewX2(AngleX, X.f)
    ipdf_Skew(AngleX,0,X,-1)
  EndProcedure
  
  ProcedureDLL pdf_SkewX3(AngleX, X.f, Y.f)
    ipdf_Skew(AngleX,0,X,Y)
  EndProcedure
  
  ProcedureDLL pdf_SkewY(AngleY)
    ipdf_Skew(0,AngleY,-1,-1)
  EndProcedure
  
  ProcedureDLL pdf_SkewY2(AngleY, X.f)
    ipdf_Skew(0,AngleY,X,-1)
  EndProcedure
  
  ProcedureDLL pdf_SkewY3(AngleY, X.f, Y.f)
    ipdf_Skew(0,AngleY,X,Y)
  EndProcedure
  
  ProcedureDLL pdf_StartPageNums() ;Start TOC page numbering.
    ipdf_StartPageNums()
  EndProcedure
  
  ProcedureDLL pdf_StopPageNums() ;Stop TOC page numbering.
    ipdf_StopPageNums()
  EndProcedure	
  
  ProcedureDLL pdf_SubWrite(H.f, Txt$) ;write superscripted or supscripted
    ipdf_SubWrite(h,txt$)
  EndProcedure
  
  ProcedureDLL pdf_SubWrite2(H.f, Txt$, Link.l) ;write superscripted or supscripted
    ipdf_SubWrite(h, txt$, link)
  EndProcedure
  
  ProcedureDLL pdf_SubWrite3(H.f, Txt$, Link.l, SubFontSize.l) ;write superscripted or supscripted
    ipdf_SubWrite(h, txt$, link, SubFontSize)
  EndProcedure
  
  ProcedureDLL pdf_SubWrite4(H.f, Txt$, Link.l, SubFontSize.l, SubOffSet.f) ;write superscripted or supscripted
    ipdf_SubWrite(h, txt$, link, SubFontSize, SubOffSet)
  EndProcedure
  
  ProcedureDLL pdf_StartTransform()
    ipdf_Out("q")
  EndProcedure
  
  ProcedureDLL pdf_StopTransform()
    ipdf_Out("Q")
  EndProcedure
  
  ProcedureDLL pdf_Text(X.f,Y.f,Text$) ;Prints a character string.
    ipdf_Text(X,Y,Text$)
  EndProcedure
  
  ProcedureDLL pdf_TOCEntry(Text$) ;Set TOC entry
    ipdf_TOCEntry(Text$)
  EndProcedure
  
  ProcedureDLL pdf_TOCEntry2(Text$, Level.l) ;Set TOC entry
    ipdf_TOCEntry(Text$, level)
  EndProcedure
  
  ProcedureDLL pdf_Triangle(X1.f,Y1.f,X2.f,Y2.f,X3.f,Y3.f)
    ipdf_Triangle(X1.f,Y1.f,X2.f,Y2.f,X3.f,Y3.f)
  EndProcedure
  
  ProcedureDLL pdf_Triangle2(X1.f,Y1.f,X2.f,Y2.f,X3.f,Y3.f,Style$)
    ipdf_Triangle(X1.f,Y1.f,X2.f,Y2.f,X3.f,Y3.f,Style$)
  EndProcedure
  
  ProcedureDLL.s pdf_TruncateCell(w.f,h.f,Text$) ; Prints a Cell, if text is too large it will be truncated
    ProcedureReturn ipdf_TruncateCell(w.f,h.f,Text$)
  EndProcedure
  
  ProcedureDLL.s pdf_TruncateCell2(w.f,h.f,Text$,Border.l) ; Prints a Cell, if text is too large it will be truncated
    ProcedureReturn ipdf_TruncateCell(w.f,h.f,Text$,Border)
  EndProcedure
  
  ProcedureDLL.s pdf_TruncateCell3(w.f,h.f,Text$,Border.l,Ln.f) ; Prints a Cell, if text is too large it will be truncated
    ProcedureReturn ipdf_TruncateCell(w.f,h.f,Text$,Border,Ln)
  EndProcedure
  
  ProcedureDLL.s pdf_TruncateCell4(w.f,h.f,Text$,Border.l,Ln.f,Align$) ; Prints a Cell, if text is too large it will be truncated
    ProcedureReturn ipdf_TruncateCell(w.f,h.f,Text$,Border,Ln,Align$)
  EndProcedure
  
  ProcedureDLL.s pdf_TruncateCell5(w.f,h.f,Text$,Border.l,Ln.f,Align$,Fill.f) ; Prints a Cell, if text is too large it will be truncated
    ProcedureReturn ipdf_TruncateCell(w.f,h.f,Text$,Border,Ln,Align$,Fill)
  EndProcedure
  
  ProcedureDLL.s pdf_TruncateCell6(w.f,h.f,Text$,Border.l,Ln.f,Align$,Fill.f,Link.l) ; Prints a Cell, if text is too large it will be truncated
    ProcedureReturn ipdf_TruncateCell(w.f,h.f,Text$,Border,Ln,Align$,Fill,Link)
  EndProcedure
  
  ProcedureDLL.s pdf_TruncateCell7(w.f,h.f,Text$,Border.l,Ln.f,Align$,Fill.f,Link.l,Trunc$) ; Prints a Cell, if text is too large it will be truncated
    ProcedureReturn ipdf_TruncateCell(w.f,h.f,Text$,Border,Ln,Align$,Fill,Link,Trunc$)
  EndProcedure
  
  ProcedureDLL pdf_Translate(TX.f, TY.f)
    ipdf_Translate(TX, TY)
  EndProcedure
  
  ProcedureDLL pdf_TranslateX(TX.f)
    ipdf_Translate(TX,0)
  EndProcedure
  
  ProcedureDLL pdf_TranslateY(TY.f)
    ipdf_Translate(0,TY)
  EndProcedure
  
  ProcedureDLL pdf_Write(H.f, Text$) ;This method prints text from the current position.
    ipdf_Write(h.f, Text$)
  EndProcedure
  
  ProcedureDLL pdf_Write2(H.f, Text$, Link.l) ;This method prints text from the current position.
    ipdf_Write(h,Text$,link)
  EndProcedure
  
  ProcedureDLL pdf_SetProcHeader(ProcAddress) ;Set header procedure.
    ipdf_SetProcHeader(ProcAddress)
  EndProcedure
  
  ProcedureDLL pdf_SetProcHeader2(ProcAddress, StructAddress = #Null) ;Set header procedure.
    ipdf_SetProcHeader(ProcAddress,StructAddress)
  EndProcedure
  
  ProcedureDLL pdf_SetProcFooter(ProcAddress) ;Set footer procedure.
    ipdf_SetProcFooter(ProcAddress)
  EndProcedure
  
  ProcedureDLL pdf_SetProcFooter2(ProcAddress, StructAddress = #Null) ;Set footer procedure.
    ipdf_SetProcFooter(ProcAddress,StructAddress)
  EndProcedure
  
  ProcedureDLL pdf_SetProcAcceptPageBreak(ProcAddress) ;Set acceptpagebreak procedure.
    ipdf_SetProcAcceptPageBreak(ProcAddress)
  EndProcedure
  
  ProcedureDLL pdf_SetProcCompression(ProcAddress) ;Set compression procedure.
    ipdf_SetProcCompression(ProcAddress)
  EndProcedure
  
  ProcedureDLL pdf_SetTitle(Title$) ;Defines the title of the document.
    ipdf_SetTitle(Title$)
  EndProcedure
  
  ProcedureDLL pdf_SetSubject(Subject$) ;Defines the subject of the document.
    ipdf_SetSubject(Subject$)
  EndProcedure
  
  ProcedureDLL pdf_SetAuthor(Author$) ;Defines the author of the document.
    ipdf_SetAuthor(Author$)
  EndProcedure
  
  ProcedureDLL pdf_SetKeywords(Keywords$) ;Associates keywords with the document, generally in the form 'keyword1 keyword2 ...'.
    ipdf_SetKeywords(Keywords$)
  EndProcedure
  
  ProcedureDLL pdf_SetCreator(Creator$) ; Defines the creator of the document.
    ipdf_SetCreator(Creator$)
  EndProcedure
  
  ProcedureDLL pdf_AliasNbPages() ;Defines an alias for the total number of pages.
    ipdf_AliasNbPages()
  EndProcedure
  
  ProcedureDLL pdf_AliasNbPages2(Alias$) ;Defines an alias for the total number of pages.
    ipdf_AliasNbPages(Alias$)
  EndProcedure
  
  ProcedureDLL.l pdf_GetPageNo() ;Returns the current page number.
    ProcedureReturn ipdf_GetPageNo()
  EndProcedure
  
  ProcedureDLL.f pdf_GetX() ;Returns the abscissa of the current position.
    ProcedureReturn ipdf_GetX()
  EndProcedure
  
  ProcedureDLL.f pdf_GetY() ;Returns the ordinate of the current position.
    ProcedureReturn ipdf_GetY()
  EndProcedure
  
  ProcedureDLL pdf_Create() ;Begin document.
    ProcedureReturn ipdf_Create()
  EndProcedure
  
  ProcedureDLL pdf_Create2(Orientation$) ;Begin document.
    ProcedureReturn ipdf_Create(Orientation$)
  EndProcedure
  
  ProcedureDLL pdf_Create3(Orientation$, Unit$) ;Begin document.
    ProcedureReturn ipdf_Create(Orientation$, Unit$)
  EndProcedure
  
  ProcedureDLL pdf_Create4(Orientation$, Unit$, Format$) ;Begin document.
    ProcedureReturn ipdf_Create(Orientation$, Unit$, Format$)  
  EndProcedure
  
  ProcedureDLL pdf_SetDisplayMode(Zoom.l) ;Set display mode in viewer.
    ipdf_SetDisplayMode(Zoom)
  EndProcedure
  
  ProcedureDLL pdf_SetDisplayMode2(Zoom.l, Layout$) ;Set display mode in viewer.
    ipdf_SetDisplayMode(Zoom, Layout$)
  EndProcedure
  
  ProcedureDLL pdf_SetAutoPageBreak(Auto.l) ;Set auto page break mode and triggering margin.
    ipdf_SetAutoPageBreak(Auto)
  EndProcedure
  
  ProcedureDLL pdf_SetAutoPageBreak2(Auto.l, Margin.f) ;Set auto page break mode and triggering margin.
    ipdf_SetAutoPageBreak(Auto, Margin)
  EndProcedure
  
  ProcedureDLL pdf_SetMargins(LeftMargin.f, TopMargin.f) ;Set left, top and right margins.
    ipdf_SetMargins(LeftMargin, TopMargin)
  EndProcedure
  
  ProcedureDLL pdf_SetMargins2(LeftMargin.f, TopMargin.f, RightMargin.f) ;Set left, top and right margins.
    ipdf_SetMargins(LeftMargin, TopMargin, RightMargin)
  EndProcedure
  
  ProcedureDLL pdf_SetTopMargin(TopMargin.f) ;Set top margin.
    ipdf_SetTopMargin(TopMargin.f)
  EndProcedure
  
  ProcedureDLL pdf_SetRightMargin(RightMargin.f) ;Set right margin.
    ipdf_SetRightMargin(RightMargin.f)
  EndProcedure
  
  ProcedureDLL pdf_SetCellMargin(CellMargin.f) ;Set cell margin.
    ipdf_SetCellMargin(CellMargin.f)
  EndProcedure
  
  ProcedureDLL pdf_SetLeftMargin(LeftMargin.f) ;Set left margin.
    ipdf_SetLeftMargin(LeftMargin.f)
  EndProcedure
  
  ProcedureDLL pdf_EmbedFile(Filename$) ;Embed a file.
    ProcedureReturn ipdf_EmbedFile(Filename$)
  EndProcedure
  
  ProcedureDLL pdf_EmbedFile2(Filename$,Description$)
    ProcedureReturn ipdf_EmbedFile(Filename$,Description$)
  EndProcedure
  
  ProcedureDLL.f pdf_GetStringWidth(String$) ;Get width of a string in the current font.
    ProcedureReturn ipdf_GetStringWidth(String$)
  EndProcedure
  
  ProcedureDLL.s pdf_TextString(String$) ;Format a text string.
    ProcedureReturn ipdf_TextString(String$)
  EndProcedure
  
  ProcedureDLL.f pdf_GetCMargin() ;Get cell margin.
    ProcedureReturn ipdf_GetCMargin()
  EndProcedure
  
  ProcedureDLL.f pdf_GetRMargin() ;Get right margin.
    ProcedureReturn ipdf_GetRMargin()
  EndProcedure
  
  ProcedureDLL.f pdf_GetLMargin() ;Get left margin.
    ProcedureReturn ipdf_GetLMargin()
  EndProcedure
  
  ProcedureDLL.f pdf_GetWs() ;Get word spacing. 
    ProcedureReturn ipdf_GetWs()
  EndProcedure
  
  ProcedureDLL pdf_SetWs(WordSpacing.f) ;Set word spacing. 
    ipdf_SetWs(WordSpacing)
  EndProcedure
  
  ProcedureDLL.f pdf_GetW() ;Get current width of page. 
    ProcedureReturn ipdf_GetW()
  EndProcedure
  
  ProcedureDLL.f pdf_GetH() ;Get current height of page.
    ProcedureReturn ipdf_GetH()
  EndProcedure
  
  ProcedureDLL.f pdf_GetK() ;Get scale factor.
    ProcedureReturn ipdf_GetK()
  EndProcedure
  
  ProcedureDLL.l pdf_GetN() ;Get object number
    ProcedureReturn ipdf_GetN()
  EndProcedure
  
  ProcedureDLL.l pdf_GetFontSizePt() ;Get current fontsize in points.
    ProcedureReturn ipdf_GetFontSizePt()
  EndProcedure
  
  ProcedureDLL pdf_SetLineCap(Style.s) ;Set Linecap
    ipdf_Out(Style + " J")
  EndProcedure
  
  ProcedureDLL pdf_SetLineJoin(Style.s) ;Set Linejoin
    ipdf_Out(Style + " j")
  EndProcedure
  
  ProcedureDLL pdf_SetTextColorCMYK(Cyan.f, Magenta.f, Yellow.f, Black.f) ;Set Textcolor CMYK
    ipdf_SetTextColorCMYK(Cyan, Magenta, Yellow, Black)
  EndProcedure
  
  ProcedureDLL pdf_SetDrawColorCMYK(Cyan.f, Magenta.f, Yellow.f, Black.f) ;Set Drawcolor CMYK
    ipdf_SetDrawColorCMYK(Cyan, Magenta, Yellow, Black)
  EndProcedure
  
  ProcedureDLL pdf_SetFillColorCMYK(Cyan.f, Magenta.f, Yellow.f, Black.f) ;Set Fillcolor CMYK
    ipdf_SetFillColorCMYK(Cyan, Magenta, Yellow, Black)
  EndProcedure
CompilerEndIf
;} PurePDF as TailBite-library

CompilerIf #PDF_ENABLE_EXPLICIT = 0
  DisableExplicit
CompilerEndIf


DataSection
Zapfdingbats:
  Data.w    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
  Data.w    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 278, 974, 961, 974
  Data.w  980, 719, 789, 790, 791, 690, 960, 939, 549, 855, 911, 933, 911, 945, 974, 755, 846, 762
  Data.w  761, 571, 677, 763, 760, 759, 754, 494, 552, 537, 577, 692, 786, 788, 788, 790, 793, 794
  Data.w  816, 823, 789, 841, 823, 833, 816, 831, 923, 744, 723, 749, 790, 792, 695, 776, 768, 792
  Data.w  759, 707, 708, 682, 701, 826, 815, 789, 789, 707, 687, 696, 689, 786, 787, 713, 791, 785
  Data.w  791, 873, 761, 762, 762, 759, 759, 892, 892, 788, 784, 438, 138, 277, 415, 392, 392, 668
  Data.w  668,   0, 390, 390, 317, 317, 276, 276, 509, 509, 410, 410, 234, 234, 334, 334,   0,   0
  Data.w    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 732
  Data.w  544, 544, 910, 667, 760, 760, 776, 595, 694, 626, 788, 788, 788, 788, 788, 788, 788, 788
  Data.w  788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788
  Data.w  788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 788, 894, 838,1016, 458
  Data.w  748, 924, 748, 918, 927, 928, 928, 834, 873, 828, 924, 924, 917, 930, 931, 463, 883, 836
  Data.w  836, 867, 867, 696, 696, 874,   0, 874, 760, 946, 771, 865, 771, 888, 967, 888, 831, 873
  Data.w  927, 970, 918,   0
  
Helvetica:
  Data.w  278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278
  Data.w  278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 355, 556
  Data.w  556, 889, 667, 191, 333, 333, 389, 584, 278, 333, 278, 278, 556, 556, 556, 556, 556, 556
  Data.w  556, 556, 556, 556, 278, 278, 584, 584, 584, 556,1015, 667, 667, 722, 722, 667, 611, 778
  Data.w  722, 278, 500, 667, 556, 833, 722, 778, 667, 778, 722, 667, 611, 722, 667, 944, 667, 667
  Data.w  611, 278, 278, 278, 469, 556, 333, 556, 556, 500, 556, 556, 278, 556, 556, 222, 222, 500
  Data.w  222, 833, 556, 556, 556, 556, 333, 500, 278, 556, 500, 722, 500, 500, 500, 334, 260, 334
  Data.w  584, 350, 556, 350, 222, 556, 333,1000, 556, 556, 333,1000, 667, 333,1000, 350, 611, 350
  Data.w  350, 222, 222, 333, 333, 350, 556,1000, 333,1000, 500, 333, 944, 350, 500, 667, 278, 333
  Data.w  556, 556, 556, 556, 260, 556, 333, 737, 370, 556, 584, 333, 737, 333, 400, 584, 333, 333
  Data.w  333, 556, 537, 278, 333, 333, 365, 556, 834, 834, 834, 611, 667, 667, 667, 667, 667, 667
  Data.w 1000, 722, 667, 667, 667, 667, 278, 278, 278, 278, 722, 722, 778, 778, 778, 778, 778, 584
  Data.w  778, 722, 722, 722, 722, 667, 667, 611, 556, 556, 556, 556, 556, 556, 889, 500, 556, 556
  Data.w  556, 556, 278, 278, 278, 278, 556, 556, 556, 556, 556, 556, 556, 584, 611, 556, 556, 556
  Data.w  556, 500, 556, 500
  
HelveticaB:
  Data.w  278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278
  Data.w  278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 333, 474, 556
  Data.w  556, 889, 722, 238, 333, 333, 389, 584, 278, 333, 278, 278, 556, 556, 556, 556, 556, 556
  Data.w  556, 556, 556, 556, 333, 333, 584, 584, 584, 611, 975, 722, 722, 722, 722, 667, 611, 778
  Data.w  722, 278, 556, 722, 611, 833, 722, 778, 667, 778, 722, 667, 611, 722, 667, 944, 667, 667
  Data.w  611, 333, 278, 333, 584, 556, 333, 556, 611, 556, 611, 556, 333, 611, 611, 278, 278, 556
  Data.w  278, 889, 611, 611, 611, 611, 389, 556, 333, 611, 556, 778, 556, 556, 500, 389, 280, 389
  Data.w  584, 350, 556, 350, 278, 556, 500,1000, 556, 556, 333,1000, 667, 333,1000, 350, 611, 350
  Data.w  350, 278, 278, 500, 500, 350, 556,1000, 333,1000, 556, 333, 944, 350, 500, 667, 278, 333
  Data.w  556, 556, 556, 556, 280, 556, 333, 737, 370, 556, 584, 333, 737, 333, 400, 584, 333, 333
  Data.w  333, 611, 556, 278, 333, 333, 365, 556, 834, 834, 834, 611, 722, 722, 722, 722, 722, 722
  Data.w 1000, 722, 667, 667, 667, 667, 278, 278, 278, 278, 722, 722, 778, 778, 778, 778, 778, 584
  Data.w  778, 722, 722, 722, 722, 667, 667, 611, 556, 556, 556, 556, 556, 556, 889, 556, 556, 556
  Data.w  556, 556, 278, 278, 278, 278, 611, 611, 611, 611, 611, 611, 611, 584, 611, 611, 611, 611
  Data.w  611, 556, 611, 556
  
HelveticaI:
  Data.w  278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278
  Data.w  278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 355, 556
  Data.w  556, 889, 667, 191, 333, 333, 389, 584, 278, 333, 278, 278, 556, 556, 556, 556, 556, 556
  Data.w  556, 556, 556, 556, 278, 278, 584, 584, 584, 556,1015, 667, 667, 722, 722, 667, 611, 778
  Data.w  722, 278, 500, 667, 556, 833, 722, 778, 667, 778, 722, 667, 611, 722, 667, 944, 677, 677
  Data.w  611, 278, 278, 278, 469, 556, 333, 556, 556, 500, 556, 556, 278, 556, 556, 222, 222, 500
  Data.w  222, 833, 556, 556, 556, 556, 333, 500, 278, 556, 500, 722, 500, 500, 500, 334, 260, 334
  Data.w  584, 350, 556, 350, 222, 556, 333,1000, 556, 556, 333,1000, 667, 333,1000, 350, 611, 350
  Data.w  350, 222, 222, 333, 333, 350, 556,1000, 333,1000, 500, 333, 944, 350, 500, 667, 278, 333
  Data.w  556, 556, 556, 556, 260, 556, 333, 737, 370, 556, 584, 333, 737, 333, 400, 584, 333, 333
  Data.w  333, 556, 537, 278, 333, 333, 365, 556, 834, 834, 834, 611, 667, 667, 667, 667, 667, 667
  Data.w 1000, 722, 667, 667, 667, 667, 278, 278, 278, 278, 722, 722, 778, 778, 778, 778, 778, 584
  Data.w  778, 722, 722, 722, 722, 667, 667, 611, 556, 556, 556, 556, 556, 556, 889, 500, 556, 556
  Data.w  556, 556, 278, 278, 278, 278, 556, 556, 556, 556, 556, 556, 556, 584, 611, 556, 556, 556
  Data.w  556, 500, 556, 500
  
HelveticaBI:
  Data.w  278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278
  Data.w  278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 333, 474, 556
  Data.w  556, 889, 722, 238, 333, 333, 389, 584, 278, 333, 278, 278, 556, 556, 556, 556, 556, 556
  Data.w  556, 556, 556, 556, 333, 333, 584, 584, 584, 611, 975, 722, 722, 722, 722, 667, 611, 778
  Data.w  722, 278, 556, 722, 611, 833, 722, 778, 667, 778, 722, 667, 611, 722, 667, 944, 667, 667
  Data.w  611, 333, 278, 333, 584, 556, 333, 556, 611, 556, 611, 556, 333, 611, 611, 278, 278, 556
  Data.w  278, 889, 611, 611, 611, 611, 389, 556, 333, 611, 556, 778, 556, 556, 500, 389, 280, 389
  Data.w  584, 350, 556, 350, 278, 556, 500,1000, 556, 556, 333,1000, 667, 333,1000, 350, 611, 350
  Data.w  350, 278, 278, 500, 500, 350, 556,1000, 333,1000, 556, 333, 944, 350, 500, 667, 278, 333
  Data.w  556, 556, 556, 556, 280, 556, 333, 737, 370, 556, 584, 333, 737, 333, 400, 584, 333, 333
  Data.w  333, 611, 556, 278, 333, 333, 365, 556, 834, 834, 834, 611, 722, 722, 722, 722, 722, 722
  Data.w 1000, 722, 667, 667, 667, 667, 278, 278, 278, 278, 722, 722, 778, 778, 778, 778, 778, 584
  Data.w  778, 722, 722, 722, 722, 667, 667, 611, 556, 556, 556, 556, 556, 556, 889, 556, 556, 556
  Data.w  556, 556, 278, 278, 278, 278, 611, 611, 611, 611, 611, 611, 611, 584, 611, 611, 611, 611
  Data.w  611, 556, 611, 556

Times:
  Data.w  250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250
  Data.w  250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 333, 408, 500
  Data.w  500, 833, 778, 180, 333, 333, 500, 564, 250, 333, 250, 278, 500, 500, 500, 500, 500, 500
  Data.w  500, 500, 500, 500, 278, 278, 564, 564, 564, 444, 921, 722, 667, 667, 722, 611, 556, 722
  Data.w  722, 333, 389, 722, 611, 889, 722, 722, 556, 722, 667, 556, 611, 722, 722, 944, 722, 722
  Data.w  611, 333, 278, 333, 469, 500, 333, 444, 500, 444, 500, 444, 333, 500, 500, 278, 278, 500
  Data.w  278, 778, 500, 500, 500, 500, 333, 389, 278, 500, 500, 722, 500, 500, 444, 480, 200, 480
  Data.w  541, 350, 500, 350, 333, 500, 444,1000, 500, 500, 333,1000, 556, 333, 889, 350, 611, 350
  Data.w  350, 333, 333, 444, 444, 350, 500,1000, 333, 980, 389, 333, 722, 350, 444, 722, 250, 333
  Data.w  500, 500, 500, 500, 200, 500, 333, 760, 276, 500, 564, 333, 760, 333, 400, 564, 300, 300
  Data.w  333, 500, 453, 250, 333, 300, 310, 500, 750, 750, 750, 444, 722, 722, 722, 722, 722, 722
  Data.w  889, 667, 611, 611, 611, 611, 333, 333, 333, 333, 722, 722, 722, 722, 722, 722, 722, 564
  Data.w  722, 722, 722, 722, 722, 722, 556, 500, 444, 444, 444, 444, 444, 444, 667, 444, 444, 444
  Data.w  444, 444, 278, 278, 278, 278, 500, 500, 500, 500, 500, 500, 500, 564, 500, 500, 500, 500
  Data.w  500, 500, 500, 500
 
TimesB:
  Data.w  250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250
  Data.w  250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 333, 555, 500
  Data.w  500,1000, 833, 278, 333, 333, 500, 570, 250, 333, 250, 278, 500, 500, 500, 500, 500, 500
  Data.w  500, 500, 500, 500, 333, 333, 570, 570, 570, 500, 930, 722, 667, 722, 722, 667, 611, 778
  Data.w  778, 389, 500, 778, 667, 944, 722, 778, 611, 778, 722, 556, 667, 722, 722,1000, 722, 722
  Data.w  667, 333, 278, 333, 581, 500, 333, 500, 556, 444, 556, 444, 333, 500, 556, 278, 333, 556
  Data.w  278, 833, 556, 500, 556, 556, 444, 389, 333, 556, 500, 722, 500, 500, 444, 394, 220, 394
  Data.w  520, 350, 500, 350, 333, 500, 500,1000, 500, 500, 333,1000, 556, 333,1000, 350, 667, 350
  Data.w  350, 333, 333, 500, 500, 350, 500,1000, 333,1000, 389, 333, 722, 350, 444, 722, 250, 333
  Data.w  500, 500, 500, 500, 220, 500, 333, 747, 300, 500, 570, 333, 747, 333, 400, 570, 300, 300
  Data.w  333, 556, 540, 250, 333, 300, 330, 500, 750, 750, 750, 500, 722, 722, 722, 722, 722, 722
  Data.w 1000, 722, 667, 667, 667, 667, 389, 389, 389, 389, 722, 722, 778, 778, 778, 778, 778, 570
  Data.w  778, 722, 722, 722, 722, 722, 611, 556, 500, 500, 500, 500, 500, 500, 722, 444, 444, 444
  Data.w  444, 444, 278, 278, 278, 278, 500, 556, 500, 500, 500, 500, 500, 570, 500, 556, 556, 556
  Data.w  556, 500, 556, 500 

TimesI:
  Data.w  250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250
  Data.w  250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 333, 420, 500
  Data.w  500, 833, 778, 214, 333, 333, 500, 675, 250, 333, 250, 278, 500, 500, 500, 500, 500, 500
  Data.w  500, 500, 500, 500, 333, 333, 675, 675, 675, 500, 920, 611, 611, 667, 722, 611, 611, 722
  Data.w  722, 333, 444, 667, 556, 833, 667, 722, 611, 722, 611, 500, 556, 722, 611, 833, 611, 556
  Data.w  556, 389, 278, 389, 422, 500, 333, 500, 500, 444, 500, 444, 278, 500, 500, 278, 278, 444
  Data.w  278, 722, 500, 500, 500, 500, 389, 389, 278, 500, 444, 667, 444, 444, 389, 400, 275, 400
  Data.w  541, 350, 500, 350, 333, 500, 556, 889, 500, 500, 333,1000, 500, 333, 944, 350, 556, 350
  Data.w  350, 333, 333, 556, 556, 350, 500, 889, 333, 980, 389, 333, 667, 350, 389, 556, 250, 389
  Data.w  500, 500, 500, 500, 275, 500, 333, 760, 276, 500, 675, 333, 760, 333, 400, 675, 300, 300
  Data.w  333, 500, 523, 250, 333, 300, 310, 500, 750, 750, 750, 500, 611, 611, 611, 611, 611, 611
  Data.w  889, 667, 611, 611, 611, 611, 333, 333, 333, 333, 722, 667, 722, 722, 722, 722, 722, 675
  Data.w  722, 722, 722, 722, 722, 556, 611, 500, 500, 500, 500, 500, 500, 500, 667, 444, 444, 444
  Data.w  444, 444, 278, 278, 278, 278, 500, 500, 500, 500, 500, 500, 500, 675, 500, 500, 500, 500
  Data.w  500, 444, 500, 444

TimesBI:
  Data.w  250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250
  Data.w  250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 389, 555, 500
  Data.w  500, 833, 778, 278, 333, 333, 500, 570, 250, 333, 250, 278, 500, 500, 500, 500, 500, 500
  Data.w  500, 500, 500, 500, 333, 333, 570, 570, 570, 500, 832, 667, 667, 667, 722, 667, 667, 722
  Data.w  778, 389, 500, 667, 611, 889, 722, 722, 611, 722, 667, 556, 611, 722, 667, 889, 667, 611
  Data.w  611, 333, 278, 333, 570, 500, 333, 500, 500, 444, 500, 444, 333, 500, 556, 278, 278, 500
  Data.w  278, 778, 556, 500, 500, 500, 389, 389, 278, 556, 444, 667, 500, 444, 389, 348, 220, 348
  Data.w  570, 350, 500, 350, 333, 500, 500,1000, 500, 500, 333,1000, 556, 333, 944, 350, 611, 350
  Data.w  350, 333, 333, 500, 500, 350, 500,1000, 333,1000, 389, 333, 722, 350, 389, 611, 250, 389
  Data.w  500, 500, 500, 500, 220, 500, 333, 747, 266, 500, 606, 333, 747, 333, 400, 570, 300, 300
  Data.w  333, 576, 500, 250, 333, 300, 300, 500, 750, 750, 750, 500, 667, 667, 667, 667, 667, 667
  Data.w  944, 667, 667, 667, 667, 667, 389, 389, 389, 389, 722, 722, 722, 722, 722, 722, 722, 570
  Data.w  722, 722, 722, 722, 722, 611, 611, 500, 500, 500, 500, 500, 500, 500, 722, 444, 444, 444
  Data.w  444, 444, 278, 278, 278, 278, 500, 556, 500, 500, 500, 500, 500, 570, 500, 556, 556, 556
  Data.w  556, 444, 500, 444

Symbol:
  Data.w  250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250
  Data.w  250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 333, 713, 500
  Data.w  549, 833, 778, 439, 333, 333, 500, 549, 250, 549, 250, 278, 500, 500, 500, 500, 500, 500
  Data.w  500, 500, 500, 500, 278, 278, 549, 549, 549, 444, 549, 722, 667, 722, 612, 611, 763, 603
  Data.w  722, 333, 631, 722, 686, 889, 722, 722, 768, 741, 556, 592, 611, 690, 439, 768, 645, 795
  Data.w  611, 333, 863, 333, 658, 500, 500, 631, 549, 549, 494, 439, 521, 411, 603, 329, 603, 549
  Data.w  549, 576, 521, 549, 549, 521, 549, 603, 439, 576, 713, 686, 493, 686, 494, 480, 200, 480
  Data.w  549,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
  Data.w    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 750, 620
  Data.w  247, 549, 167, 713, 500, 753, 753, 753, 753,1042, 987, 603, 987, 603, 400, 549, 411, 549
  Data.w  549, 713, 494, 460, 549, 549, 549, 549,1000, 603,1000, 658, 823, 686, 795, 987, 768, 768
  Data.w  823, 768, 768, 713, 713, 713, 713, 713, 713, 713, 768, 713, 790, 790, 890, 823, 549, 250
  Data.w  713, 603, 603,1042, 987, 603, 987, 603, 494, 329, 790, 790, 786, 713, 384, 384, 384, 384
  Data.w  384, 384, 494, 494, 494, 494,   0, 329, 274, 686, 686, 686, 384, 384, 384, 384, 384, 384
  Data.w  494, 494, 494,   0
  
EndDataSection

; IDE Options = PureBasic 5.71 beta 2 LTS (Windows - x86)
; CursorPosition = 1043
; FirstLine = 1034
; Folding = -------------------------------------------------------------------------------------------
; EnableXP