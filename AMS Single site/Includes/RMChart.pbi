CompilerIf Defined(RMChart_Include,#PB_Constant)
  ;IncludePath #PB_Compiler_FilePath
  XIncludeFile "RMChart_res.pb"
  ;IncludePath ""
CompilerEndIf

;################################################################################################
;# 
;# Object:       RMCHART Library
;# Version:      4.12 (01/2008)
;# 
;# Author:       Rainer Morgen
;# Contact:      mailto:RM@RMChart.com
;# Homepage:     http://www.rmchart.com
;# 
;# Author:       Wrapper written by flype 
;# Contact:      mailto:flype44@gmail.com
;# 
;# Compiler:     PureBasic 4.10 for Microsoft Windows
;# Description:  Generates nice and interactive charts using the GDI+ rendering engine.
;# 
;################################################################################################
;# 
;# Wrapper History:
;# 
;# 23-JUL-2006: First Release
;# 14-DEC-2006: Removed procedures RMC_INIT() and RMC_FREE()
;#              Modified sField.c[n] to sField.s{n} in structures
;# 18-DEC-2006: Some optional parameters were missing.
;# 06-FEB-2008: rebuild for DLL-Version 4.1.2.0 (by ABBKlaus)
;# 09-APR-2008: fixed missing parameter 'ExportOnly' in RMC_CreateChartOnDC
;################################################################################################

EnableExplicit 

#RMCDLL = "RMCHART.DLL"
#RMC_VERSION = "4.12"

;{ Global variable definitions
Global RMC_DLL.l
Global F_RMC_AddBarSeries
Global F_RMC_AddBarSeriesI
Global F_RMC_AddCaption
Global F_RMC_AddCaptionI
Global F_RMC_AddDataAxis
Global F_RMC_AddDataAxisI
Global F_RMC_AddGrid
Global F_RMC_AddGridI
Global F_RMC_AddGridlessSeries
Global F_RMC_AddGridlessSeriesI
Global F_RMC_AddHighLowSeries
Global F_RMC_AddLabelAxis
Global F_RMC_AddLabelAxisI
Global F_RMC_AddLegend
Global F_RMC_AddLegendI
Global F_RMC_AddLineSeries
Global F_RMC_AddLineSeriesI
Global F_RMC_AddRegion
Global F_RMC_AddRegionI
Global F_RMC_AddToolTips
Global F_RMC_AddVolumeBarSeries
Global F_RMC_AddXAxis
Global F_RMC_AddXAxisI
Global F_RMC_AddXYSeries
Global F_RMC_AddXYSeriesI
Global F_RMC_AddYAxis
Global F_RMC_AddYAxisI
Global F_RMC_CalcAverage
Global F_RMC_CalcTrend
Global F_RMC_COBox
Global F_RMC_COCircle
Global F_RMC_CODash
Global F_RMC_CODelete
Global F_RMC_COGetTextWH
Global F_RMC_COImage
Global F_RMC_COLine
Global F_RMC_COPolygon
Global F_RMC_COSymbol
Global F_RMC_COText
Global F_RMC_COVisible
Global F_RMC_CreateChart
Global F_RMC_CreateChartFromFile
Global F_RMC_CreateChartFromFileOnDC
;Global F_RMC_CreateChartFromFileOnDC_PB8
Global F_RMC_CreateChartI
Global F_RMC_CreateChartOnDC
Global F_RMC_CreateChartOnDCI
;Global F_RMC_CreateChartOnDCI_PB8
;Global F_RMC_CreateChartOnDC_PB8
Global F_RMC_DeleteChart
Global F_RMC_Draw
Global F_RMC_Draw2Clipboard
Global F_RMC_Draw2File
Global F_RMC_Draw2Printer
Global F_RMC_GetChartsizeFromFile
Global F_RMC_GetCtrlHeight
Global F_RMC_GetCtrlLeft
Global F_RMC_GetCtrlTop
Global F_RMC_GetCtrlWidth
Global F_RMC_GetData
Global F_RMC_GetDataCount
Global F_RMC_GetDataLocation
Global F_RMC_GetDataLocationXY
Global F_RMC_GetGridLocation
Global F_RMC_GetHighPart
Global F_RMC_GetImageSizeFromFile
Global F_RMC_GetINFO
Global F_RMC_GetINFOXY
Global F_RMC_GetLowPart
Global F_RMC_GetSeriesDataRange
Global F_RMC_GetVersion
Global F_RMC_Magnifier
Global F_RMC_Paint
Global F_RMC_ReadDataFromFile
Global F_RMC_ReadStringFromFile
Global F_RMC_Reset
Global F_RMC_RND
Global F_RMC_SaveBMP
Global F_RMC_SetCaptionBGColor
Global F_RMC_SetCaptionFontBold
Global F_RMC_SetCaptionFontSize
Global F_RMC_SetCaptionText
Global F_RMC_SetCaptionTextColor
Global F_RMC_SetCtrlBGColor
Global F_RMC_SetCtrlBGImage
Global F_RMC_SetCtrlFont
Global F_RMC_SetCtrlPos
Global F_RMC_SetCtrlSize
Global F_RMC_SetCtrlStyle
Global F_RMC_SetCustomToolTipText
Global F_RMC_SetDAXAlignment
Global F_RMC_SetDAXDecimalDigits
Global F_RMC_SetDAXFontSize
Global F_RMC_SetDAXLabelAlignment
Global F_RMC_SetDAXLabels
Global F_RMC_SetDAXLineColor
Global F_RMC_SetDAXLineStyle
Global F_RMC_SetDAXMaxValue
Global F_RMC_SetDAXMinValue
Global F_RMC_SetDAXText
Global F_RMC_SetDAXTextColor
Global F_RMC_SetDAXTickcount
Global F_RMC_SetDAXUnit
Global F_RMC_SetGridBGColor
Global F_RMC_SetGridBiColor
Global F_RMC_SetGridGradient
Global F_RMC_SetGridMargin
Global F_RMC_SetHelpingGrid
Global F_RMC_SetLAXAlignment
Global F_RMC_SetLAXCount
Global F_RMC_SetLAXFontSize
Global F_RMC_SetLAXLabelAlignment
Global F_RMC_SetLAXLabels
Global F_RMC_SetLAXLabelsFile
Global F_RMC_SetLAXLabelsRange
Global F_RMC_SetLAXLineColor
Global F_RMC_SetLAXLineStyle
Global F_RMC_SetLAXText
Global F_RMC_SetLAXTextColor
Global F_RMC_SetLAXTickCount
Global F_RMC_SetLegendAlignment
Global F_RMC_SetLegendBGColor
Global F_RMC_SetLegendFontBold
Global F_RMC_SetLegendFontSize
Global F_RMC_SetLegendHide
Global F_RMC_SetLegendStyle
Global F_RMC_SetLegendText
Global F_RMC_SetLegendTextColor
Global F_RMC_SetMouseClick
Global F_RMC_SetRegionBorder
Global F_RMC_SetRegionFooter
Global F_RMC_SetRegionMargin
Global F_RMC_SetRMCFile
Global F_RMC_SetSeriesColor
Global F_RMC_SetSeriesData
Global F_RMC_SetSeriesDataAxis
Global F_RMC_SetSeriesDataFile
Global F_RMC_SetSeriesDataRange
Global F_RMC_SetSeriesExplodeMode
Global F_RMC_SetSeriesHatchMode
Global F_RMC_SetSeriesHide
Global F_RMC_SetSeriesHighLowColor
Global F_RMC_SetSeriesLinestyle
Global F_RMC_SetSeriesLucent
Global F_RMC_SetSeriesPPColumn
Global F_RMC_SetSeriesPPColumnArray
Global F_RMC_SetSeriesSingleData
Global F_RMC_SetSeriesStartAngle
Global F_RMC_SetSeriesStyle
Global F_RMC_SetSeriesSymbol
Global F_RMC_SetSeriesValuelabel
Global F_RMC_SetSeriesVertical
Global F_RMC_SetSeriesXAxis
Global F_RMC_SetSeriesYAxis
Global F_RMC_SetSingleBarColors
Global F_RMC_SetToolTipWidth
Global F_RMC_SetWatermark
Global F_RMC_SetXAXAlignment
Global F_RMC_SetXAXDecimalDigits
Global F_RMC_SetXAXFontSize
Global F_RMC_SetXAXLabelAlignment
Global F_RMC_SetXAXLabels
Global F_RMC_SetXAXLineColor
Global F_RMC_SetXAXLineStyle
Global F_RMC_SetXAXMaxValue
Global F_RMC_SetXAXMinValue
Global F_RMC_SetXAXText
Global F_RMC_SetXAXTextColor
Global F_RMC_SetXAXTickcount
Global F_RMC_SetXAXUnit
Global F_RMC_SetYAXAlignment
Global F_RMC_SetYAXDecimalDigits
Global F_RMC_SetYAXFontSize
Global F_RMC_SetYAXLabelAlignment
Global F_RMC_SetYAXLabels
Global F_RMC_SetYAXLineColor
Global F_RMC_SetYAXLineStyle
Global F_RMC_SetYAXMaxValue
Global F_RMC_SetYAXMinValue
Global F_RMC_SetYAXText
Global F_RMC_SetYAXTextColor
Global F_RMC_SetYAXTickcount
Global F_RMC_SetYAXUnit
Global F_RMC_ShowToolTips
Global F_RMC_WriteRMCFile
Global F_RMC_Zoom
;Global F_RMC_Split
;Global F_RMC_Split2Double
;Global F_RMC_Split2Long
;}
;{ Prototype P_RMC_Add
Prototype.l P_RMC_AddBarSeries(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,Type.l=0,Style.l=0,IsLucent.l=0,Color.l=0,nIsHorizontal.l=0,WhichDataAxis.l=0,ValuelabelOn.l=0,PointsPerColumn.l=0,HatchMode.l=0)
Prototype.l P_RMC_AddBarSeriesI(CtrlId.l,Region.l,*FirstDataValue,nDataValuesCount.l,*t.RMC_BARSERIES)
Prototype.l P_RMC_AddCaption(CtrlId.l,Region.l,sCaption.p-ascii=0,nTitelBackColor.l=0,nTitelTextColor.l=0,nTitelFontSize.l=0,nTitelIsBold.l=0)
Prototype.l P_RMC_AddCaptionI(CtrlId.l,Region.l,*t.RMC_CAPTION)
Prototype.l P_RMC_AddDataAxis(CtrlId.l,Region.l,Alignment.l=0,MinValue.d=0,MaxValue.d=0,TickCount.l=0,FontSize.l=0,TextColor.l=0,LineColor.l=0,LineStyle.l=0,nDecimalDigits.l=0,sUnit.p-ascii=0,sText.p-ascii=0,Labels.p-ascii=0,LabelAlignment.l=0)
Prototype.l P_RMC_AddDataAxisI(CtrlId.l,Region.l,*t.RMC_DATAAXIS)
Prototype.l P_RMC_AddGrid(CtrlId.l,Region.l,BackColor.l=0,nAsGradient.l=0,Left.l=0,Top.l=0,Width.l=0,Height.l=0,BiColor.l=0)
Prototype.l P_RMC_AddGridI(CtrlId.l,Region.l,*t.RMC_GRID)
Prototype.l P_RMC_AddGridlessSeries(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,*FirstColorValue=0,ColorValuesCount.l=0,Style.l=0,Alignment.l=0,Explodemode.l=0,IsLucent.l=0,ValuelabelOn.l=0,HatchMode.l=0,StartAngle.l=0)
Prototype.l P_RMC_AddGridlessSeriesI(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,*FirstColorValue=0,ColorValuesCount.l=0,*t.RMC_GRIDLESSSERIES=0)
Prototype.l P_RMC_AddHighLowSeries(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,*FirstPPCValue=0,PPCValuesCount.l=0,Style.l=0,WhichDataAxis.l=0,ColorLow.l=0,ColorHigh.l=0)
Prototype.l P_RMC_AddLabelAxis(CtrlId.l,Region.l,Labels.p-ascii=0,nAxisCount.l=0,TickCount.l=0,Alignment.l=0,FontSize.l=0,TextColor.l=0,nTextAlignment.l=0,LineColor.l=0,LineStyle.l=0,sText.p-ascii=0)
Prototype.l P_RMC_AddLabelAxisI(CtrlId.l,Region.l,Labels.p-ascii,*t.RMC_LABELAXIS)
Prototype.l P_RMC_AddLegend(CtrlId.l,Region.l,sLegendtext.p-ascii,nLegendAlign.l=0,nLegendBackColor.l=0,nLegendStyle.l=0,nLegendTextColor.l=0,nLegendFontSize.l=0,nLegendIsBold.l=0)
Prototype.l P_RMC_AddLegendI(CtrlId.l,Region.l,sLegendtext.p-ascii,*t.RMC_LEGEND)
Prototype.l P_RMC_AddLineSeries(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,*FirstPPCValue=0,PPCValuesCount.l=0,Type.l=0,Style.l=0,LineStyle.l=0,IsLucent.l=0,Color.l=0,ChartSymbol.l=0,WhichDataAxis.l=0,ValuelabelOn.l=0,HatchMode.l=0)
Prototype.l P_RMC_AddLineSeriesI(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,*t.RMC_LINESERIES)
Prototype.l P_RMC_AddRegion(CtrlId.l,Left.l=0,Top.l=0,Width.l=0,Height.l=0,sFooter.p-ascii=0,ShowBorder.l=0)
Prototype.l P_RMC_AddRegionI(CtrlId.l,*t.RMC_REGION)
Prototype.l P_RMC_AddToolTips(CtrlId.l,hWnd.l,ToolTipWidth.l=0)
Prototype.l P_RMC_AddVolumeBarSeries(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,*FirstPPCValue=0,PPCValuesCount.l=0,Color.l=0,WhichDataAxis.l=0)
Prototype.l P_RMC_AddXAxis(CtrlId.l,Region.l,Alignment.l=0,MinValue.d=0,MaxValue.d=0,TickCount.l=0,FontSize.l=0,TextColor.l=0,LineColor.l=0,LineStyle.l=0,nDecimalDigits.l=0,sUnit.p-ascii=0,sText.p-ascii=0,Labels.p-ascii=0,LabelAlignment.l=0)
Prototype.l P_RMC_AddXAxisI(CtrlId.l,Region.l,*t.RMC_XYAXIS)
Prototype.l P_RMC_AddYAxis(CtrlId.l,Region.l,Alignment.l=0,MinValue.d=0,MaxValue.d=0,TickCount.l=0,FontSize.l=0,TextColor.l=0,LineColor.l=0,LineStyle.l=0,nDecimalDigits.l=0,sUnit.p-ascii=0,sText.p-ascii=0,Labels.p-ascii=0,LabelAlignment.l=0)
Prototype.l P_RMC_AddYAxisI(CtrlId.l,Region.l,*t.RMC_XYAXIS)
Prototype.l P_RMC_AddXYSeries(CtrlId.l,Region.l,*FirstXDataValue=0,nDataXValuesCount.l=0,*FirstYDataValue=0,DataYValuesCount.l=0,Color.l=0,Style.l=0,LineStyle.l=0,Symbol.l=0,WhichXAxis.l=0,WhichYAxis.l=0,ValuelabelOn.l=0)
Prototype.l P_RMC_AddXYSeriesI(CtrlId.l,Region.l,*FirstXDataValue,DataXValuesCount.l,*FirstYDataValue,DataYValuesCount.l,*t.RMC_XYSERIES)
;}
;{ Prototype P_RMC_Create
Prototype.l P_RMC_CreateChart(ParentHndl.l,CtrlId.l,X.l,Y.l,Width.l,Height.l,BackColor.l=0,CtrlStyle.l=0,ExportOnly.l=0,BgImage.p-ascii=0,FontName.p-ascii=0,ToolTipWidth.l=0,nBitmapBKColor.l=0)
Prototype.l P_RMC_CreateChartI(ParentHndl.l,CtrlId.l,*t.RMC_CHART)
Prototype.l P_RMC_CreateChartFromFile(ParentHndl.l,CtrlId.l,X.l,Y.l,ExportOnly.l,RMCFile.p-ascii)
Prototype.l P_RMC_CreateChartFromFileOnDC(ParentDC.l,CtrlId.l,X.l,Y.l,ExportOnly.l,RMCFile.p-ascii)
Prototype.l P_RMC_CreateChartOnDC(ParentDC.l,CtrlId.l,X.l,Y.l,Width.l,Height.l,BackColor.l=0,CtrlStyle.l=0,ExportOnly.l=0,BgImage.p-ascii=0,FontName.p-ascii=0,nBitmapBKColor.l=0)
Prototype.l P_RMC_CreateChartOnDCI(ParentDC.l,CtrlId.l,*t.RMC_CHART)
Prototype.l P_RMC_CreateChartOnDC_PB8(ParentDC.l,CtrlId.l,X.l,Y.l,Width.l,Height.l,BackColor.l=0,CtrlStyle.l=0,ExportOnly.l=0,BgImage.p-ascii=0,FontName.p-ascii=0)
Prototype.l P_RMC_CreateChartFromFileOnDC_PB8(ParentDC.l,CtrlId.l,X.l,Y.l,ExportOnly.l,RMCFile.p-ascii)
Prototype.l P_RMC_CreateChartOnDCI_PB8(ParentDC.l,CtrlId.l,*t.RMC_CHART)
;}
;{ Prototype P_RMC_Draw
Prototype.l P_RMC_Draw(CtrlId.l)
Prototype.l P_RMC_Draw2Clipboard(CtrlId.l,Type.l)
Prototype.l P_RMC_Draw2File(CtrlId.l,FileName.p-ascii,Width.l=0,Height.l=0,JPGQualityLevel.l=0)
Prototype.l P_RMC_Draw2Printer(CtrlId.l,PrinterDC.l=0,Left.l=0,Top.l=0,Width.l=0,Height.l=0,Type.l=0)
;}
;{ Prototype P_RMC_Misc
Prototype.l P_RMC_CalcAverage(CtrlId.l,Region.l,SeriesIndex.l,*Average,*XStart,*YStart,*XEnd,*YEnd,HighLowIndex.p-ascii=0)
Prototype.l P_RMC_CalcTrend(CtrlId.l,Region.l,SeriesIndex.l,*FirstValue,*LastValue,*XStart,*YStart,*XEnd,*YEnd,HighLowIndex.p-ascii=0)
Prototype.l P_RMC_COBox(CtrlId.l,Index.l,Left.l,Top.l,Width.l,Height.l,Style.l=0,BGColor.l=0,LineColor.l=0,Transparency.l=0)
Prototype.l P_RMC_COCircle(CtrlId.l,Index.l,XCenter.l,YCenter.l,Width.l,Style.l=0,BGColor.l=0,LineColor.l=0,Transparency.l=0)
Prototype.l P_RMC_CODash(CtrlId.l,COIndex.l,XStart.l,YStart.l,XEnd.l,YEnd.l,Style.l=0,Color.l=0,AsSpline.l=0,LineWidth.l=0,StartCap.l=0,EndCap.l=0)
Prototype.l P_RMC_CODelete(CtrlId.l,Index.l)
Prototype.l P_RMC_COGetTextWH(CtrlId.l,Index.l,WH.l)
Prototype.l P_RMC_COImage(CtrlId.l,Index.l,ImagePath.p-ascii,Left.l,Top.l,Width.l=0,Height.l=0)
Prototype.l P_RMC_COLine(CtrlId.l,Index.l,*XPoints,*YPoints,PointsCount.l,Style.l=0,Color.l=0,AsSpline.l=0,LineWidth.l=0,StartCap.l=0,EndCap.l=0)
Prototype.l P_RMC_COPolygon(CtrlId.l,Index.l,*XPoints,*YPoints,PointsCount.l,BGColor.l=0,LineColor.l=0,AsSpline.l=0,Transparency.l=0)
Prototype.l P_RMC_COSymbol(CtrlId.l,Index.l,XCenter.l,YCenter.l,Style.l,Color.l)
Prototype.l P_RMC_COText(CtrlId.l,Index.l,Text.p-ascii,Left.l,Top.l,Width.l=0,Height.l=0,Style.l=0,BGColor.l=0,LineColor.l=0,Transparency.l=0,LineAlignment.l=0,TextColor.l=0,TextProperties.p-ascii=0)
Prototype.l P_RMC_COVisible(CtrlId.l,Index.l,Hide.l)
Prototype.l P_RMC_DeleteChart(CtrlId.l)
Prototype.l P_RMC_Magnifier(CtrlId.l,Enable.l,Size.l=0,Color.l=0,LineColor.l=0,Transparency.l=0)
Prototype.l P_RMC_Paint(CtrlId.l)
Prototype.l P_RMC_ReadDataFromFile(*aData,FileName.p-ascii,sLines.p-ascii=0,Fields.p-ascii=0,FieldDelimiter.p-ascii=0,Reverse.l=0)
Prototype.l P_RMC_ReadStringFromFile(*sValue,FileName.p-ascii,sLines.p-ascii=0,Fields.p-ascii=0,FieldDelimiter.p-ascii=0,Reverse.l=0)
Prototype.l P_RMC_Reset(CtrlId.l)
Prototype.l P_RMC_RND(n1.l,n2.l)
Prototype.l P_RMC_SaveBMP(hBmp.l,sFileName.p-ascii)
Prototype.l P_RMC_ShowToolTips(CtrlId.l,X.l,Y.l)
;Prototype.l P_RMC_Split(sData.p-ascii,*asData.s())
;Prototype.l P_RMC_Split2Double(*sData.l,*aData)
;Prototype.l P_RMC_Split2Long(*sData.l,*aData)
Prototype.l P_RMC_WriteRMCFile(CtrlId.l,sFileName.p-ascii)
Prototype.l P_RMC_Zoom(CtrlId.l,Mode.l,Color.l=0,LineColor.l=0,Transparency.l=0)
;}
;{ Prototype P_RMC_Get
Prototype.l P_RMC_GetChartsizeFromFile(RMCFile.p-ascii,*Width,*Height)
Prototype.l P_RMC_GetCtrlLeft(CtrlId.l)
Prototype.l P_RMC_GetCtrlTop(CtrlId.l)
Prototype.l P_RMC_GetCtrlWidth(CtrlId.l)
Prototype.l P_RMC_GetCtrlHeight(CtrlId.l)
Prototype.l P_RMC_GetINFO(CtrlId.l,*t.RMC_INFO,Region.l,Series.l,Index.l)
Prototype.l P_RMC_GetINFOXY(CtrlId.l,*t.RMC_INFO,X.l,Y.l)
Prototype.d P_RMC_GetVersion()
Prototype.l P_RMC_GetData(CtrlId.l,Region.l,SeriesIndex.l,DataIndex.l,*nData,YData.l=0)
Prototype.l P_RMC_GetDataCount(CtrlId.l,Region.l,SeriesIndex.l,*DataCount)
Prototype.l P_RMC_GetDataLocation(CtrlId.l,Region.l,SeriesIndex.l,nData.d,*XYPos)
Prototype.l P_RMC_GetDataLocationXY(CtrlId.l,Region.l,SeriesIndex.l,DataX.d,DataY.d,*XPos,*YPos)
Prototype.l P_RMC_GetSeriesDataRange(CtrlId.l,Region.l,Series.l,*First,*Last)
Prototype.l P_RMC_GetGridLocation(CtrlId.l,Region.l,*Left,*Top,*Right,*Bottom)
Prototype.l P_RMC_GetImageSizeFromFile(ImagePath.p-ascii,*Width,*Height)
Prototype.l P_RMC_GetLowPart(Param.d)
Prototype.l P_RMC_GetHighPart(Param.d)
;}
;{ Prototype P_RMC_Set
Prototype.l P_RMC_SetCaptionBGColor(CtrlId.l,Region.l,Color.l)
Prototype.l P_RMC_SetCaptionFontSize(CtrlId.l,Region.l,Fontbold.l)
Prototype.l P_RMC_SetCaptionFontBold(CtrlId.l,Region.l,FontSize.l)
Prototype.l P_RMC_SetCaptionText(CtrlId.l,Region.l,sText.p-ascii)
Prototype.l P_RMC_SetCaptionTextColor(CtrlId.l,Region.l,Color.l)
Prototype.l P_RMC_SetCtrlBGColor(CtrlId.l,Color.l)
Prototype.l P_RMC_SetCtrlBGImage(CtrlId.l,BgImage.p-ascii)
Prototype.l P_RMC_SetCtrlFont(CtrlId.l,FontName.p-ascii)
Prototype.l P_RMC_SetCtrlPos(CtrlId.l,Left.l,Top.l,Relative.l=0)
Prototype.l P_RMC_SetCtrlSize(CtrlId.l,Width.l,Height.l,Relative.l=0,RecalcMode=0)
Prototype.l P_RMC_SetCtrlStyle(CtrlId.l,Style.l)
Prototype.l P_RMC_SetDAXAlignment(CtrlId.l,Region.l,Alignment.l)
Prototype.l P_RMC_SetDAXDecimalDigits(CtrlId.l,Region.l,DecimalDigits.l,AxisIndex.l=0)
Prototype.l P_RMC_SetDAXFontSize(CtrlId.l,Region.l,FontSize.l)
Prototype.l P_RMC_SetDAXLineColor(CtrlId.l,Region.l,Color.l)
Prototype.l P_RMC_SetDAXLabelAlignment(CtrlId.l,Region.l,LabelAlignment.l,AxisIndex.l=0)
Prototype.l P_RMC_SetDAXLabels(CtrlId.l,Region.l,Labels.p-ascii,AxisIndex.l=0)
Prototype.l P_RMC_SetDAXLineStyle(CtrlId.l,Region.l,Style.l)
Prototype.l P_RMC_SetDAXMaxValue(CtrlId.l,Region.l,MaxValue.d,AxisIndex.l=0)
Prototype.l P_RMC_SetDAXMinValue(CtrlId.l,Region.l,MinValue.d,AxisIndex.l=0)
Prototype.l P_RMC_SetDAXText(CtrlId.l,Region.l,Text.p-ascii,AxisIndex.l=0)
Prototype.l P_RMC_SetDAXTextColor(CtrlId.l,Region.l,Color.l)
Prototype.l P_RMC_SetDAXTickcount(CtrlId.l,Region.l,TickCount.l)
Prototype.l P_RMC_SetDAXUnit(CtrlId.l,Region.l,Unit.p-ascii,AxisIndex.l=0)
Prototype.l P_RMC_SetGridBGColor(CtrlId.l,Region.l,Color.l)
Prototype.l P_RMC_SetGridGradient(CtrlId.l,Region.l,HasGradient.l)
Prototype.l P_RMC_SetGridMargin(CtrlId.l,Region.l,Left.l,Top.l,Width.l,Height.l)
Prototype.l P_RMC_SetLAXAlignment(CtrlId.l,Region.l,Alignment.l)
Prototype.l P_RMC_SetLAXCount(CtrlId.l,Region.l,LabelAxisCount.l)
Prototype.l P_RMC_SetLAXFontSize(CtrlId.l,Region.l,FontSize.l)
Prototype.l P_RMC_SetLAXLabelAlignment(CtrlId.l,Region.l,Alignment.l)
Prototype.l P_RMC_SetLAXLabels(CtrlId.l,Region.l,Labels.p-ascii)
Prototype.l P_RMC_SetLAXLineColor(CtrlId.l,Region.l,Color.l)
Prototype.l P_RMC_SetLAXLineStyle(CtrlId.l,Region.l,Style.l)
Prototype.l P_RMC_SetLAXText(CtrlId.l,Region.l,sText.p-ascii)
Prototype.l P_RMC_SetLAXTextColor(CtrlId.l,Region.l,Color.l)
Prototype.l P_RMC_SetLAXTickCount(CtrlId.l,Region.l,TickCount.l)
Prototype.l P_RMC_SetLegendAlignment(CtrlId.l,Region.l,Alignment.l)
Prototype.l P_RMC_SetLegendBGColor(CtrlId.l,Region.l,Color.l)
Prototype.l P_RMC_SetLegendFontBold(CtrlId.l,Region.l,Fontbold.l)
Prototype.l P_RMC_SetLegendFontSize(CtrlId.l,Region.l,FontSize.l)
Prototype.l P_RMC_SetLegendStyle(CtrlId.l,Region.l,Style.l)
Prototype.l P_RMC_SetLegendText(CtrlId.l,Region.l,sText.p-ascii)
Prototype.l P_RMC_SetLegendTextColor(CtrlId.l,Region.l,Color.l)
Prototype.l P_RMC_SetMouseClick(CtrlId.l,Button.l,X.l,Y.l,*t.RMC_INFO)
Prototype.l P_RMC_SetRegionBorder(CtrlId.l,Region.l,ShowBorder.l)
Prototype.l P_RMC_SetRegionFooter(CtrlId.l,Region.l,sFooter.p-ascii)
Prototype.l P_RMC_SetRegionMargin(CtrlId.l,Region.l,Left.l,Top.l,Width.l,Height.l)
Prototype.l P_RMC_SetRMCFile(CtrlId.l,RMCFile.p-ascii)
Prototype.l P_RMC_SetSeriesColor(CtrlId.l,Region.l,Series.l,Color.l,Index.l=0)
Prototype.l P_RMC_SetSeriesData(CtrlId.l,Region.l,Series.l,*nData,DataCount.l,YData.l=0)
Prototype.l P_RMC_SetSeriesDataAxis(CtrlId.l,Region.l,Series.l,WhichAxis.l)
Prototype.l P_RMC_SetSeriesDataFile(CtrlId.l,Region.l,Series.l,FileName.p-ascii,Lines.p-ascii=0,Fields.p-ascii=0,FieldDelimiter.p-ascii=0,YData.l=0)
Prototype.l P_RMC_SetSeriesExplodeMode(CtrlId.l,Region.l,Series.l,Explodemode.l)
Prototype.l P_RMC_SetSeriesHatchMode(CtrlId.l,Region.l,Series.l,HatchMode.l)
Prototype.l P_RMC_SetSeriesHide(CtrlId.l,Region.l,Series.l,Hide.l)
Prototype.l P_RMC_SetSeriesLinestyle(CtrlId.l,Region.l,Series.l,LineStyle.l)
Prototype.l P_RMC_SetSeriesLucent(CtrlId.l,Region.l,Series.l,Lucent.l)
Prototype.l P_RMC_SetSeriesSingleData(CtrlId.l,Region.l,Series.l,nData.d,DataIndex.l,YData.l=0)
Prototype.l P_RMC_SetSeriesStartAngle(CtrlId.l,Region.l,Series.l,StartAngle.l)
Prototype.l P_RMC_SetSeriesStyle(CtrlId.l,Region.l,Series.l,Style.l)
Prototype.l P_RMC_SetSeriesSymbol(CtrlId.l,Region.l,Series.l,Symbol.l)
Prototype.l P_RMC_SetSeriesValuelabel(CtrlId.l,Region.l,Series.l,Valuelabel.l)
Prototype.l P_RMC_SetSeriesVertical(CtrlId.l,Region.l,Series.l,Vertical.l)
Prototype.l P_RMC_SetSeriesXAxis(CtrlId.l,Region.l,Series.l,WhichXAxis.l)
Prototype.l P_RMC_SetSeriesYAxis(CtrlId.l,Region.l,Series.l,WhichYAxis.l)
Prototype.l P_RMC_SetSingleBarColors(CtrlId.l,Region.l,*FirstColorElement,ColorElementsCount.l)
Prototype.l P_RMC_SetWatermark(Watermark.p-ascii,WMColor.l=0,WMLucentValue.l=0,Alignment.l=0,FontSize.l=0)
Prototype.l P_RMC_SetXAXAlignment(CtrlId.l,Region.l,Alignment.l,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXDecimalDigits(CtrlId.l,Region.l,DecimalDigits.l,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXFontSize(CtrlId.l,Region.l,FontSize.l,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXLabels(CtrlId.l,Region.l,Labels.p-ascii,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXLabelAlignment(CtrlId.l,Region.l,LabelAlignment.l,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXLineColor(CtrlId.l,Region.l,Color.l,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXLineStyle(CtrlId.l,Region.l,Style.l,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXMaxValue(CtrlId.l,Region.l,MaxValue.d,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXMinValue(CtrlId.l,Region.l,MinValue.d,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXText(CtrlId.l,Region.l,Text.p-ascii,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXTextColor(CtrlId.l,Region.l,Color.l,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXTickcount(CtrlId.l,Region.l,TickCount.l,AxisIndex.l=0)
Prototype.l P_RMC_SetXAXUnit(CtrlId.l,Region.l,Unit.p-ascii,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXAlignment(CtrlId.l,Region.l,Alignment.l,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXDecimalDigits(CtrlId.l,Region.l,DecimalDigits.l,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXFontSize(CtrlId.l,Region.l,FontSize.l,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXLabels(CtrlId.l,Region.l,Labels.p-ascii,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXLabelAlignment(CtrlId.l,Region.l,LabelAlignment.l,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXLineColor(CtrlId.l,Region.l,Color.l,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXLineStyle(CtrlId.l,Region.l,Style.l,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXMaxValue(CtrlId.l,Region.l,MaxValue.d,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXMinValue(CtrlId.l,Region.l,MinValue.d,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXText(CtrlId.l,Region.l,Text.p-ascii,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXTextColor(CtrlId.l,Region.l,Color.l,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXTickcount(CtrlId.l,Region.l,TickCount.l,AxisIndex.l=0)
Prototype.l P_RMC_SetYAXUnit(CtrlId.l,Region.l,Unit.p-ascii,AxisIndex.l=0)
Prototype.l P_RMC_SetCustomToolTipText(CtrlId.l,Region.l,Series.l,DataIndex.l,Text.p-ascii)
Prototype.l P_RMC_SetGridBiColor(CtrlId.l,Region.l,BiColor.l)
Prototype.l P_RMC_SetHelpingGrid(CtrlId.l,Size.l,GridColor.l=0)
Prototype.l P_RMC_SetLAXLabelsFile(CtrlId.l,Region.l,FileName.p-ascii,Lines.p-ascii=0,Fields.p-ascii=0,FieldDelimiter.p-ascii=0)
Prototype.l P_RMC_SetLAXLabelsRange(CtrlId.l,Region.l,First.l,Last.l)
Prototype.l P_RMC_SetLegendHide(CtrlId.l,Region.l,Hide.l)
Prototype.l P_RMC_SetSeriesDataRange(CtrlId.l,Region.l,Series.l,First.l,Last.l)
Prototype.l P_RMC_SetSeriesHighLowColor(CtrlId.l,Region.l,Series.l,ColorLow.l,ColorHigh.l)
Prototype.l P_RMC_SetSeriesPPColumn(CtrlId.l,Region.l,Series.l,PointsPerColumn.l)
Prototype.l P_RMC_SetSeriesPPColumnArray(CtrlId.l,Region.l,Series.l,*FirstPPCValue,PPCValuesCount.l)
Prototype.l P_RMC_SetToolTipWidth(CtrlId.l,Width.l)
;}
;{ Internal Procedures
Procedure.s RMC_GetLastError(Error.l)
  Protected buffer.l,ferr.l,errormsg$
  If Error=0
    Error=GetLastError_()
  EndIf
  buffer.l=0
  ferr=FormatMessage_(#FORMAT_MESSAGE_ALLOCATE_BUFFER|#FORMAT_MESSAGE_FROM_SYSTEM,0,Error,GetUserDefaultLangID_(),@buffer,0,0)
  If buffer<>0
    errormsg$=PeekS(buffer)
    LocalFree_(buffer)
    errormsg$=RemoveString(errormsg$,Chr(13)+Chr(10))
    ProcedureReturn errormsg$
  EndIf
EndProcedure
;}
;{ Init / End functions
ProcedureDLL RMC_Init()
  Protected *MSGText.String
  Protected Text$
  Protected Version$
  
  RMC_DLL.l = OpenLibrary(#PB_Any,#RMCDLL)
  
  If RMC_DLL
    ;{ GetFunction Add...
    F_RMC_AddBarSeries.P_RMC_AddBarSeries                       = GetFunction(RMC_DLL,"RMC_ADDBARSERIES")
    F_RMC_AddBarSeriesI.P_RMC_AddBarSeriesI                     = GetFunction(RMC_DLL,"RMC_ADDBARSERIESI")
    F_RMC_AddCaption.P_RMC_AddCaption                           = GetFunction(RMC_DLL,"RMC_ADDCAPTION")
    F_RMC_AddCaptionI.P_RMC_AddCaptionI                         = GetFunction(RMC_DLL,"RMC_ADDCAPTIONI")
    F_RMC_AddDataAxis.P_RMC_AddDataAxis                         = GetFunction(RMC_DLL,"RMC_ADDDATAAXIS")
    F_RMC_AddDataAxisI.P_RMC_AddDataAxisI                       = GetFunction(RMC_DLL,"RMC_ADDDATAAXISI")
    F_RMC_AddGrid.P_RMC_AddGrid                                 = GetFunction(RMC_DLL,"RMC_ADDGRID")
    F_RMC_AddGridI.P_RMC_AddGridI                               = GetFunction(RMC_DLL,"RMC_ADDGRIDI")
    F_RMC_AddGridlessSeries.P_RMC_AddGridlessSeries             = GetFunction(RMC_DLL,"RMC_ADDGRIDLESSSERIES")
    F_RMC_AddGridlessSeriesI.P_RMC_AddGridlessSeriesI           = GetFunction(RMC_DLL,"RMC_ADDGRIDLESSSERIESI")
    F_RMC_AddHighLowSeries.P_RMC_AddHighLowSeries               = GetFunction(RMC_DLL,"RMC_ADDHIGHLOWSERIES")
    F_RMC_AddLabelAxis.P_RMC_AddLabelAxis                       = GetFunction(RMC_DLL,"RMC_ADDLABELAXIS")
    F_RMC_AddLabelAxisI.P_RMC_AddLabelAxisI                     = GetFunction(RMC_DLL,"RMC_ADDLABELAXISI")
    F_RMC_AddLegend.P_RMC_AddLegend                             = GetFunction(RMC_DLL,"RMC_ADDLEGEND")
    F_RMC_AddLegendI.P_RMC_AddLegendI                           = GetFunction(RMC_DLL,"RMC_ADDLEGENDI")
    F_RMC_AddLineSeries.P_RMC_AddLineSeries                     = GetFunction(RMC_DLL,"RMC_ADDLINESERIES")
    F_RMC_AddLineSeriesI.P_RMC_AddLineSeriesI                   = GetFunction(RMC_DLL,"RMC_ADDLINESERIESI")
    F_RMC_AddRegion.P_RMC_AddRegion                             = GetFunction(RMC_DLL,"RMC_ADDREGION")
    F_RMC_AddRegionI.P_RMC_AddRegionI                           = GetFunction(RMC_DLL,"RMC_ADDREGIONI")
    F_RMC_AddToolTips.P_RMC_AddToolTips                         = GetFunction(RMC_DLL,"RMC_ADDTOOLTIPS")
    F_RMC_AddVolumeBarSeries.P_RMC_AddVolumeBarSeries           = GetFunction(RMC_DLL,"RMC_ADDVOLUMEBARSERIES")
    F_RMC_AddXAxis.P_RMC_AddXAxis                               = GetFunction(RMC_DLL,"RMC_ADDXAXIS")
    F_RMC_AddXAxisI.P_RMC_AddXAxisI                             = GetFunction(RMC_DLL,"RMC_ADDXAXISI")
    F_RMC_AddYAxis.P_RMC_AddYAxis                               = GetFunction(RMC_DLL,"RMC_ADDYAXIS")
    F_RMC_AddYAxisI.P_RMC_AddYAxisI                             = GetFunction(RMC_DLL,"RMC_ADDYAXISI")
    F_RMC_AddXYSeries.P_RMC_AddXYSeries                         = GetFunction(RMC_DLL,"RMC_ADDXYSERIES")
    F_RMC_AddXYSeriesI.P_RMC_AddXYSeriesI                       = GetFunction(RMC_DLL,"RMC_ADDXYSERIESI")
    ;}
    ;{ GetFunction Misc...
    F_RMC_CalcAverage.P_RMC_CalcAverage                         = GetFunction(RMC_DLL,"RMC_CALCAVERAGE")
    F_RMC_CalcTrend.P_RMC_CalcTrend                             = GetFunction(RMC_DLL,"RMC_CALCTREND")
    F_RMC_COBox.P_RMC_COBox                                     = GetFunction(RMC_DLL,"RMC_COBOX")
    F_RMC_COCircle.P_RMC_COCircle                               = GetFunction(RMC_DLL,"RMC_COCIRCLE")
    F_RMC_CODash.P_RMC_CODash                                   = GetFunction(RMC_DLL,"RMC_CODASH")
    F_RMC_CODelete.P_RMC_CODelete                               = GetFunction(RMC_DLL,"RMC_CODELETE")
    F_RMC_COGetTextWH.P_RMC_COGetTextWH                         = GetFunction(RMC_DLL,"RMC_COGETTEXTWH")
    F_RMC_COImage.P_RMC_COImage                                 = GetFunction(RMC_DLL,"RMC_COIMAGE")
    F_RMC_COLine.P_RMC_COLine                                   = GetFunction(RMC_DLL,"RMC_COLINE")
    F_RMC_COPolygon.P_RMC_COPolygon                             = GetFunction(RMC_DLL,"RMC_COPOLYGON")
    F_RMC_COSymbol.P_RMC_COSymbol                               = GetFunction(RMC_DLL,"RMC_COSYMBOL")
    F_RMC_COText.P_RMC_COText                                   = GetFunction(RMC_DLL,"RMC_COTEXT")
    F_RMC_COVisible.P_RMC_COVisible                             = GetFunction(RMC_DLL,"RMC_COVISIBLE")
    F_RMC_DeleteChart.P_RMC_DeleteChart                         = GetFunction(RMC_DLL,"RMC_DELETECHART")
    F_RMC_Paint.P_RMC_Paint                                     = GetFunction(RMC_DLL,"RMC_PAINT")
    F_RMC_ReadDataFromFile.P_RMC_ReadDataFromFile               = GetFunction(RMC_DLL,"RMC_READDATAFROMFILE")
    F_RMC_ReadStringFromFile.P_RMC_ReadStringFromFile           = GetFunction(RMC_DLL,"RMC_READSTRINGFROMFILE") ; Help is missing
    F_RMC_Reset.P_RMC_Reset                                     = GetFunction(RMC_DLL,"RMC_RESET")
    F_RMC_RND.P_RMC_RND                                         = GetFunction(RMC_DLL,"RMC_RND") ; Help is missing
    F_RMC_SaveBMP.P_RMC_SaveBMP                                 = GetFunction(RMC_DLL,"RMC_SAVEBMP")
    F_RMC_ShowToolTips.P_RMC_ShowToolTips                       = GetFunction(RMC_DLL,"RMC_SHOWTOOLTIPS")
;    F_RMC_Split.P_RMC_SPlit                                     = GetFunction(RMC_DLL,"RMC_SPLIT") ; Help is missing
;    F_RMC_Split2Double.P_RMC_Split2Double                       = GetFunction(RMC_DLL,"RMC_SPLIT2DOUBLE") ; Help is missing
;    F_RMC_Split2Long.P_RMC_Split2Long                           = GetFunction(RMC_DLL,"RMC_SPLIT2LONG") ; Help is missing
    F_RMC_WriteRMCFile.P_RMC_WriteRMCFile                       = GetFunction(RMC_DLL,"RMC_WRITERMCFILE")
    F_RMC_Zoom.P_RMC_Zoom                                       = GetFunction(RMC_DLL,"RMC_ZOOM")
    F_RMC_Magnifier.P_RMC_Magnifier                             = GetFunction(RMC_DLL,"RMC_MAGNIFIER")
    ;}
    ;{ GetFunction Create...
    F_RMC_CreateChart.P_RMC_CreateChart                         = GetFunction(RMC_DLL,"RMC_CREATECHART")
    F_RMC_CreateChartI.P_RMC_CreateChartI                       = GetFunction(RMC_DLL,"RMC_CREATECHARTI")
    F_RMC_CreateChartFromFile.P_RMC_CreateChartFromFile         = GetFunction(RMC_DLL,"RMC_CREATECHARTFROMFILE")
    F_RMC_CreateChartOnDC.P_RMC_CreateChartOnDC                 = GetFunction(RMC_DLL,"RMC_CREATECHARTONDC")
    ; F_RMC_CreateChartOnDC_PB8.P_RMC_CreateChartOnDC_PB8         = GetFunction(RMC_DLL,"RMC_CREATECHARTONDC_PB8")
    F_RMC_CreateChartOnDCI.P_RMC_CreateChartOnDCI               = GetFunction(RMC_DLL,"RMC_CREATECHARTONDCI")
    ; F_RMC_CreateChartOnDCI_PB8.P_RMC_CreateChartOnDCI_PB8       = GetFunction(RMC_DLL,"RMC_CREATECHARTONDCI_PB8")
    F_RMC_CreateChartFromFileOnDC.P_RMC_CreateChartFromFileOnDC = GetFunction(RMC_DLL,"RMC_CREATECHARTFROMFILEONDC")
    ; F_RMC_CreateChartFromFileOnDC_PB8.P_RMC_CreateChartFromFileOnDC_PB8 = GetFunction(RMC_DLL,"RMC_CREATECHARTFROMFILEONDC_PB8")
    ;}
    ;{ GetFunction Draw...
    F_RMC_Draw.P_RMC_Draw                                       = GetFunction(RMC_DLL,"RMC_DRAW")
    F_RMC_Draw2Clipboard.P_RMC_Draw2Clipboard                   = GetFunction(RMC_DLL,"RMC_DRAW2CLIPBOARD")
    F_RMC_Draw2File.P_RMC_Draw2File                             = GetFunction(RMC_DLL,"RMC_DRAW2FILE")
    F_RMC_Draw2Printer.P_RMC_Draw2Printer                       = GetFunction(RMC_DLL,"RMC_DRAW2PRINTER")
    ;}
    ;{ GetFunction Get...
    F_RMC_GetChartsizeFromFile.P_RMC_GetChartsizeFromFile       = GetFunction(RMC_DLL,"RMC_GETCHARTSIZEFROMFILE")
    F_RMC_GetCtrlLeft.P_RMC_GetCtrlLeft                         = GetFunction(RMC_DLL,"RMC_GETCTRLLEFT") ; Help is missing
    F_RMC_GetCtrlTop.P_RMC_GetCtrlTop                           = GetFunction(RMC_DLL,"RMC_GETCTRLTOP") ; Help is missing
    F_RMC_GetCtrlWidth.P_RMC_GetCtrlWidth                       = GetFunction(RMC_DLL,"RMC_GETCTRLWIDTH") ; Help is missing
    F_RMC_GetCtrlHeight.P_RMC_GetCtrlHeight                     = GetFunction(RMC_DLL,"RMC_GETCTRLHEIGHT") ; Help is missing
    F_RMC_GetData.P_RMC_GetData                                 = GetFunction(RMC_DLL,"RMC_GETDATA")
    F_RMC_GetDataCount.P_RMC_GetDataCount                       = GetFunction(RMC_DLL,"RMC_GETDATACOUNT")
    F_RMC_GetDataLocation.P_RMC_GetDataLocation                 = GetFunction(RMC_DLL,"RMC_GETDATALOCATION")
    F_RMC_GetDataLocationXY.P_RMC_GetDataLocationXY             = GetFunction(RMC_DLL,"RMC_GETDATALOCATIONXY")
    F_RMC_GetGridLocation.P_RMC_GetGridLocation                 = GetFunction(RMC_DLL,"RMC_GETGRIDLOCATION")
    F_RMC_GetHighPart.P_RMC_GetHighPart                         = GetFunction(RMC_DLL,"RMC_GETHIGHPART")
    F_RMC_GetImageSizeFromFile.P_RMC_GetImageSizeFromFile       = GetFunction(RMC_DLL,"RMC_GETIMAGESIZEFROMFILE")
    F_RMC_GetINFO.P_RMC_GetINFO                                 = GetFunction(RMC_DLL,"RMC_GETINFO")
    F_RMC_GetINFOXY.P_RMC_GetINFOXY                             = GetFunction(RMC_DLL,"RMC_GETINFOXY")
    F_RMC_GetLowPart.P_RMC_GetLowPart                           = GetFunction(RMC_DLL,"RMC_GETLOWPART")
    F_RMC_GetSeriesDataRange.P_RMC_GetSeriesDataRange           = GetFunction(RMC_DLL,"RMC_GETSERIESDATARANGE") ; Help is missing
    F_RMC_GetVersion.P_RMC_GetVersion                           = GetFunction(RMC_DLL,"RMC_GETVERSION") ; Help is missing
    ;}
    ;{ GetFunction Set...
    F_RMC_SetCaptionBGColor.P_RMC_SetCaptionBGColor             = GetFunction(RMC_DLL,"RMC_SETCAPTIONBGCOLOR")
    F_RMC_SetCaptionFontSize.P_RMC_SetCaptionFontSize           = GetFunction(RMC_DLL,"RMC_SETCAPTIONFONTSIZE")
    F_RMC_SetCaptionFontBold.P_RMC_SetCaptionFontBold           = GetFunction(RMC_DLL,"RMC_SETCAPTIONFONTBOLD")
    F_RMC_SetCaptionText.P_RMC_SetCaptionText                   = GetFunction(RMC_DLL,"RMC_SETCAPTIONTEXT")
    F_RMC_SetCaptionTextColor.P_RMC_SetCaptionTextColor         = GetFunction(RMC_DLL,"RMC_SETCAPTIONTEXTCOLOR")
    F_RMC_SetCtrlBGColor.P_RMC_SetCtrlBGColor                   = GetFunction(RMC_DLL,"RMC_SETCTRLBGCOLOR")
    F_RMC_SetCtrlBGImage.P_RMC_SetCtrlBGImage                   = GetFunction(RMC_DLL,"RMC_SETCTRLBGIMAGE")
    F_RMC_SetCtrlFont.P_RMC_SetCtrlFont                         = GetFunction(RMC_DLL,"RMC_SETCTRLFONT")
    F_RMC_SetCtrlPos.P_RMC_SetCtrlPos                           = GetFunction(RMC_DLL,"RMC_SETCTRLPOS")
    F_RMC_SetCtrlSize.P_RMC_SetCtrlSize                         = GetFunction(RMC_DLL,"RMC_SETCTRLSIZE")
    F_RMC_SetCtrlStyle.P_RMC_SetCtrlStyle                       = GetFunction(RMC_DLL,"RMC_SETCTRLSTYLE")
    F_RMC_SetCustomToolTipText.P_RMC_SetCustomToolTipText       = GetFunction(RMC_DLL,"RMC_SETCUSTOMTOOLTIPTEXT")
    F_RMC_SetDAXAlignment.P_RMC_SetDAXAlignment                 = GetFunction(RMC_DLL,"RMC_SETDAXALIGNMENT")
    F_RMC_SetDAXDecimalDigits.P_RMC_SetDAXDecimalDigits         = GetFunction(RMC_DLL,"RMC_SETDAXDECIMALDIGITS")
    F_RMC_SetDAXFontSize.P_RMC_SetDAXFontSize                   = GetFunction(RMC_DLL,"RMC_SETDAXFONTSIZE")
    F_RMC_SetDAXLineColor.P_RMC_SetDAXLineColor                 = GetFunction(RMC_DLL,"RMC_SETDAXLINECOLOR")
    F_RMC_SetDAXLabelAlignment.P_RMC_SetDAXLabelAlignment       = GetFunction(RMC_DLL,"RMC_SETDAXLABELALIGNMENT")
    F_RMC_SetDAXLabels.P_RMC_SetDAXLabels                       = GetFunction(RMC_DLL,"RMC_SETDAXLABELS")
    F_RMC_SetDAXLineStyle.P_RMC_SetDAXLineStyle                 = GetFunction(RMC_DLL,"RMC_SETDAXLINESTYLE")
    F_RMC_SetDAXMaxValue.P_RMC_SetDAXMaxValue                   = GetFunction(RMC_DLL,"RMC_SETDAXMAXVALUE")
    F_RMC_SetDAXMinValue.P_RMC_SetDAXMinValue                   = GetFunction(RMC_DLL,"RMC_SETDAXMINVALUE")
    F_RMC_SetDAXText.P_RMC_SetDAXText                           = GetFunction(RMC_DLL,"RMC_SETDAXTEXT")
    F_RMC_SetDAXTextColor.P_RMC_SetDAXTextColor                 = GetFunction(RMC_DLL,"RMC_SETDAXTEXTCOLOR")
    F_RMC_SetDAXTickcount.P_RMC_SetDAXTickcount                 = GetFunction(RMC_DLL,"RMC_SETDAXTICKCOUNT")
    F_RMC_SetDAXUnit.P_RMC_SetDAXUnit                           = GetFunction(RMC_DLL,"RMC_SETDAXUNIT")
    F_RMC_SetGridBGColor.P_RMC_SetGridBGColor                   = GetFunction(RMC_DLL,"RMC_SETGRIDBGCOLOR")
    F_RMC_SetGridBiColor.P_RMC_SetGridBiColor                   = GetFunction(RMC_DLL,"RMC_SETGRIDBICOLOR") ; Help is missing
    F_RMC_SetGridGradient.P_RMC_SetGridGradient                 = GetFunction(RMC_DLL,"RMC_SETGRIDGRADIENT")
    F_RMC_SetGridMargin.P_RMC_SetGridMargin                     = GetFunction(RMC_DLL,"RMC_SETGRIDMARGIN") ; Help is missing
    F_RMC_SetHelpingGrid.P_RMC_SetHelpingGrid                   = GetFunction(RMC_DLL,"RMC_SETHELPINGGRID")
    F_RMC_SetLAXAlignment.P_RMC_SetLAXAlignment                 = GetFunction(RMC_DLL,"RMC_SETLAXALIGNMENT")
    F_RMC_SetLAXCount.P_RMC_SetLAXCount                         = GetFunction(RMC_DLL,"RMC_SETLAXCOUNT")
    F_RMC_SetLAXFontSize.P_RMC_SetLAXFontSize                   = GetFunction(RMC_DLL,"RMC_SETLAXFONTSIZE")
    F_RMC_SetLAXLabelAlignment.P_RMC_SetLAXLabelAlignment       = GetFunction(RMC_DLL,"RMC_SETLAXLABELALIGNMENT")
    F_RMC_SetLAXLabels.P_RMC_SetLAXLabels                       = GetFunction(RMC_DLL,"RMC_SETLAXLABELS")
    F_RMC_SetLAXLabelsFile.P_RMC_SetLAXLabelsFile               = GetFunction(RMC_DLL,"RMC_SETLAXLABELSFILE")
    F_RMC_SetLAXLabelsRange.P_RMC_SetLAXLabelsRange             = GetFunction(RMC_DLL,"RMC_SETLAXLABELSRANGE")
    F_RMC_SetLAXLineColor.P_RMC_SetLAXLineColor                 = GetFunction(RMC_DLL,"RMC_SETLAXLINECOLOR")
    F_RMC_SetLAXLineStyle.P_RMC_SetLAXLineStyle                 = GetFunction(RMC_DLL,"RMC_SETLAXLINESTYLE")
    F_RMC_SetLAXText.P_RMC_SetLAXText                           = GetFunction(RMC_DLL,"RMC_SETLAXTEXT")
    F_RMC_SetLAXTextColor.P_RMC_SetLAXTextColor                 = GetFunction(RMC_DLL,"RMC_SETLAXTEXTCOLOR")
    F_RMC_SetLAXTickCount.P_RMC_SetLAXTickCount                 = GetFunction(RMC_DLL,"RMC_SETLAXTICKCOUNT")
    F_RMC_SetLegendAlignment.P_RMC_SetLegendAlignment           = GetFunction(RMC_DLL,"RMC_SETLEGENDALIGNMENT")
    F_RMC_SetLegendBGColor.P_RMC_SetLegendBGColor               = GetFunction(RMC_DLL,"RMC_SETLEGENDBGCOLOR")
    F_RMC_SetLegendFontBold.P_RMC_SetLegendFontBold             = GetFunction(RMC_DLL,"RMC_SETLEGENDFONTBOLD")
    F_RMC_SetLegendFontSize.P_RMC_SetLegendFontSize             = GetFunction(RMC_DLL,"RMC_SETLEGENDFONTSIZE")
    F_RMC_SetLegendHide.P_RMC_SetLegendHide                     = GetFunction(RMC_DLL,"RMC_SETLEGENDHIDE")
    F_RMC_SetLegendStyle.P_RMC_SetLegendStyle                   = GetFunction(RMC_DLL,"RMC_SETLEGENDSTYLE")
    F_RMC_SetLegendText.P_RMC_SetLegendText                     = GetFunction(RMC_DLL,"RMC_SETLEGENDTEXT")
    F_RMC_SetLegendTextColor.P_RMC_SetLegendTextColor           = GetFunction(RMC_DLL,"RMC_SETLEGENDTEXTCOLOR")
    F_RMC_SetMouseClick.P_RMC_SetMouseClick                     = GetFunction(RMC_DLL,"RMC_SETMOUSECLICK")
    F_RMC_SetRegionBorder.P_RMC_SetRegionBorder                 = GetFunction(RMC_DLL,"RMC_SETREGIONBORDER")
    F_RMC_SetRegionFooter.P_RMC_SetRegionFooter                 = GetFunction(RMC_DLL,"RMC_SETREGIONFOOTER")
    F_RMC_SetRegionMargin.P_RMC_SetRegionMargin                 = GetFunction(RMC_DLL,"RMC_SETREGIONMARGIN")
    F_RMC_SetRMCFile.P_RMC_SetRMCFile                           = GetFunction(RMC_DLL,"RMC_SETRMCFILE")
    F_RMC_SetSeriesColor.P_RMC_SetSeriesColor                   = GetFunction(RMC_DLL,"RMC_SETSERIESCOLOR")
    F_RMC_SetSeriesData.P_RMC_SetSeriesData                     = GetFunction(RMC_DLL,"RMC_SETSERIESDATA")
    F_RMC_SetSeriesDataAxis.P_RMC_SetSeriesDataAxis             = GetFunction(RMC_DLL,"RMC_SETSERIESDATAAXIS")
    F_RMC_SetSeriesDataFile.P_RMC_SetSeriesDataFile             = GetFunction(RMC_DLL,"RMC_SETSERIESDATAFILE")
    F_RMC_SetSeriesDataRange.P_RMC_SetSeriesDataRange           = GetFunction(RMC_DLL,"RMC_SETSERIESDATARANGE")
    F_RMC_SetSeriesExplodeMode.P_RMC_SetSeriesExplodeMode       = GetFunction(RMC_DLL,"RMC_SETSERIESEXPLODEMODE")
    F_RMC_SetSeriesHatchMode.P_RMC_SetSeriesHatchMode           = GetFunction(RMC_DLL,"RMC_SETSERIESHATCHMODE")
    F_RMC_SetSeriesHide.P_RMC_SetSeriesHide                     = GetFunction(RMC_DLL,"RMC_SETSERIESHIDE")
    F_RMC_SetSeriesHighLowColor.P_RMC_SetSeriesHighLowColor     = GetFunction(RMC_DLL,"RMC_SETSERIESHIGHLOWCOLOR") ; Help is missing
    F_RMC_SetSeriesLinestyle.P_RMC_SetSeriesLinestyle           = GetFunction(RMC_DLL,"RMC_SETSERIESLINESTYLE")
    F_RMC_SetSeriesLucent.P_RMC_SetSeriesLucent                 = GetFunction(RMC_DLL,"RMC_SETSERIESLUCENT")
    F_RMC_SetSeriesPPColumn.P_RMC_SetSeriesPPColumn             = GetFunction(RMC_DLL,"RMC_SETSERIESPPCOLUMN")
    F_RMC_SetSeriesPPColumnArray.P_RMC_SetSeriesPPColumnArray   = GetFunction(RMC_DLL,"RMC_SETSERIESPPCOLUMNARRAY")
    F_RMC_SetSeriesSingleData.P_RMC_SetSeriesSingleData         = GetFunction(RMC_DLL,"RMC_SETSERIESSINGLEDATA")
    F_RMC_SetSeriesStartAngle.P_RMC_SetSeriesStartAngle         = GetFunction(RMC_DLL,"RMC_SETSERIESSTARTANGLE")
    F_RMC_SetSeriesStyle.P_RMC_SetSeriesStyle                   = GetFunction(RMC_DLL,"RMC_SETSERIESSTYLE")
    F_RMC_SetSeriesSymbol.P_RMC_SetSeriesSymbol                 = GetFunction(RMC_DLL,"RMC_SETSERIESSYMBOL")
    F_RMC_SetSeriesValuelabel.P_RMC_SetSeriesValuelabel         = GetFunction(RMC_DLL,"RMC_SETSERIESVALUELABEL")
    F_RMC_SetSeriesVertical.P_RMC_SetSeriesVertical             = GetFunction(RMC_DLL,"RMC_SETSERIESVERTICAL")
    F_RMC_SetSeriesXAxis.P_RMC_SetSeriesXAxis                   = GetFunction(RMC_DLL,"RMC_SETSERIESXAXIS")
    F_RMC_SetSeriesYAxis.P_RMC_SetSeriesYAxis                   = GetFunction(RMC_DLL,"RMC_SETSERIESYAXIS")
    F_RMC_SetSingleBarColors.P_RMC_SetSingleBarColors           = GetFunction(RMC_DLL,"RMC_SETSINGLEBARCOLORS")
    F_RMC_SetToolTipWidth.P_RMC_SetToolTipWidth                 = GetFunction(RMC_DLL,"RMC_SETTOOLTIPWIDTH")
    F_RMC_SetWatermark.P_RMC_SetWatermark                       = GetFunction(RMC_DLL,"RMC_SETWATERMARK")
    F_RMC_SetXAXAlignment.P_RMC_SetXAXAlignment                 = GetFunction(RMC_DLL,"RMC_SETXAXALIGNMENT")
    F_RMC_SetXAXDecimalDigits.P_RMC_SetXAXDecimalDigits         = GetFunction(RMC_DLL,"RMC_SETXAXDECIMALDIGITS")
    F_RMC_SetXAXFontSize.P_RMC_SetXAXFontSize                   = GetFunction(RMC_DLL,"RMC_SETXAXFONTSIZE")
    F_RMC_SetXAXLabels.P_RMC_SetXAXLabels                       = GetFunction(RMC_DLL,"RMC_SETXAXLABELS")
    F_RMC_SetXAXLabelAlignment.P_RMC_SetXAXLabelAlignment       = GetFunction(RMC_DLL,"RMC_SETXAXLABELALIGNMENT")
    F_RMC_SetXAXLineColor.P_RMC_SetXAXLineColor                 = GetFunction(RMC_DLL,"RMC_SETXAXLINECOLOR")
    F_RMC_SetXAXLineStyle.P_RMC_SetXAXLineStyle                 = GetFunction(RMC_DLL,"RMC_SETXAXLINESTYLE")
    F_RMC_SetXAXMaxValue.P_RMC_SetXAXMaxValue                   = GetFunction(RMC_DLL,"RMC_SETXAXMAXVALUE")
    F_RMC_SetXAXMinValue.P_RMC_SetXAXMinValue                   = GetFunction(RMC_DLL,"RMC_SETXAXMINVALUE")
    F_RMC_SetXAXText.P_RMC_SetXAXText                           = GetFunction(RMC_DLL,"RMC_SETXAXTEXT")
    F_RMC_SetXAXTextColor.P_RMC_SetXAXTextColor                 = GetFunction(RMC_DLL,"RMC_SETXAXTEXTCOLOR")
    F_RMC_SetXAXTickcount.P_RMC_SetXAXTickcount                 = GetFunction(RMC_DLL,"RMC_SETXAXTICKCOUNT")
    F_RMC_SetXAXUnit.P_RMC_SetXAXUnit                           = GetFunction(RMC_DLL,"RMC_SETXAXUNIT")
    F_RMC_SetYAXAlignment.P_RMC_SetYAXAlignment                 = GetFunction(RMC_DLL,"RMC_SETYAXALIGNMENT")
    F_RMC_SetYAXDecimalDigits.P_RMC_SetYAXDecimalDigits         = GetFunction(RMC_DLL,"RMC_SETYAXDECIMALDIGITS")
    F_RMC_SetYAXFontSize.P_RMC_SetYAXFontSize                   = GetFunction(RMC_DLL,"RMC_SETYAXFONTSIZE")
    F_RMC_SetYAXLabels.P_RMC_SetYAXLabels                       = GetFunction(RMC_DLL,"RMC_SETYAXLABELS")
    F_RMC_SetYAXLabelAlignment.P_RMC_SetYAXLabelAlignment       = GetFunction(RMC_DLL,"RMC_SETYAXLABELALIGNMENT")
    F_RMC_SetYAXLineColor.P_RMC_SetYAXLineColor                 = GetFunction(RMC_DLL,"RMC_SETYAXLINECOLOR")
    F_RMC_SetYAXLineStyle.P_RMC_SetYAXLineStyle                 = GetFunction(RMC_DLL,"RMC_SETYAXLINESTYLE")
    F_RMC_SetYAXMaxValue.P_RMC_SetYAXMaxValue                   = GetFunction(RMC_DLL,"RMC_SETYAXMAXVALUE")
    F_RMC_SetYAXMinValue.P_RMC_SetYAXMinValue                   = GetFunction(RMC_DLL,"RMC_SETYAXMINVALUE")
    F_RMC_SetYAXText.P_RMC_SetYAXText                           = GetFunction(RMC_DLL,"RMC_SETYAXTEXT")
    F_RMC_SetYAXTextColor.P_RMC_SetYAXTextColor                 = GetFunction(RMC_DLL,"RMC_SETYAXTEXTCOLOR")
    F_RMC_SetYAXTickcount.P_RMC_SetYAXTickcount                 = GetFunction(RMC_DLL,"RMC_SETYAXTICKCOUNT")
    F_RMC_SetYAXUnit.P_RMC_SetYAXUnit                           = GetFunction(RMC_DLL,"RMC_SETYAXUNIT")
    ;}
    Version$=StrD(F_RMC_GetVERSION(),2)
    If Version$<>#RMC_VERSION
      Text$="Warning : Version "+Version$+" <> "+#RMC_VERSION+" of "+#RMCDLL
      MessageRequester(*MSGText\s,Text$,#MB_ICONWARNING) ; *MSGText=0 If this parameter is NULL,the default title Error is used.
    EndIf
  Else
    Text$="Warning : DLL is Missing"+Chr(13)+#RMCDLL
    MessageRequester(*MSGText\s,Text$,#MB_ICONWARNING) ; *MSGText=0 If this parameter is NULL,the default title Error is used.
  EndIf
EndProcedure

ProcedureDLL RMC_End()
  If RMC_DLL And IsLibrary(RMC_DLL)
    CloseLibrary(RMC_DLL)
    RMC_DLL=0
  EndIf
EndProcedure
;}

;- Compile as Include
;{
CompilerIf Defined(RMChart_Include,#PB_Constant)
  RMC_Init()
  ;{ RMC_Add
  Procedure.l RMC_AddBarSeries(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,Type.l=0,Style.l=0,IsLucent.l=0,Color.l=0,IsHorizontal.l=0,WhichDataAxis.l=0,ValueLabelOn.l=0,PointsPerColumn.l=0,HatchMode.l=0)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,Type,Style,IsLucent,Color,IsHorizontal,WhichDataAxis,ValueLabelOn,PointsPerColumn,HatchMode)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddBarSeriesI(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*t.RMC_BARSERIES)
    If F_RMC_AddBarSeriesI
      ProcedureReturn F_RMC_AddBarSeriesI(CtrlId,Region,*FirstDataValue,DataValuesCount,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddCaption(CtrlId.l,Region.l,Caption.s="",TitelBackColor.l=0,TitelTextColor.l=0,TitelFontSize.l=0,TitelIsBold.l=0)
    If F_RMC_AddCaption
      ProcedureReturn F_RMC_AddCaption(CtrlId,Region,Caption,TitelBackColor,TitelTextColor,TitelFontSize,TitelIsBold)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddCaptionI(CtrlId.l,Region.l,*t.RMC_CAPTION)
    If F_RMC_AddCaptionI
      ProcedureReturn F_RMC_AddCaptionI(CtrlId,Region,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddDataAxis(CtrlId.l,Region.l,Alignment.l=0,MinValue.d=0,MaxValue.d=0,TickCount.l=0,FontSize.l=0,TextColor.l=0,LineColor.l=0,LineStyle.l=0,DecimalDigits.l=0,Unit.s="",Text.s="",Labels.s="",LabelAlignment.l=0)
    If F_RMC_AddDataAxis
      ProcedureReturn F_RMC_AddDataAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit,Text,Labels,LabelAlignment.l)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddDataAxisI(CtrlId.l,Region.l,*t.RMC_DATAAXIS)
    If F_RMC_AddDataAxisI
      ProcedureReturn F_RMC_AddDataAxisI(CtrlId,Region,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddGrid(CtrlId.l,Region.l,BackColor.l=0,AsGradient.l=0,Left.l=0,Top.l=0,Width.l=0,Height.l=0,Bicolor.l=0)
    If F_RMC_AddGrid
      ProcedureReturn F_RMC_AddGrid(CtrlId,Region,BackColor,AsGradient,Left,Top,Width,Height,Bicolor)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddGridI(CtrlId.l,Region.l,*t.RMC_GRID)
    If F_RMC_AddGridI
      ProcedureReturn F_RMC_AddGridI(CtrlId,Region,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddGridlessSeries(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,*FirstColorValue=0,ColorValuesCount.l=0,Style.l=0,Alignment.l=0,Explodemode.l=0,IsLucent.l=0,ValueLabelOn.l=0,HatchMode.l=0,StartAngle.l=0)
    If F_RMC_AddGridlessSeries
      ProcedureReturn F_RMC_AddGridlessSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstColorValue,ColorValuesCount,Style,Alignment,Explodemode,IsLucent,ValueLabelOn,HatchMode,StartAngle)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddGridlessSeriesI(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,*FirstColorValue=0,ColorValuesCount.l=0,*t.RMC_GRIDLESSSERIES=0)
    If F_RMC_AddGridlessSeriesI
      ProcedureReturn F_RMC_AddGridlessSeriesI(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstColorValue,ColorValuesCount,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddHighLowSeries(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,*FirstPPCValue=0,PPCValuesCount.l=0,Style.l=0,WhichDataAxis.l=0,ColorLow.l=0,ColorHigh.l=0)
    If F_RMC_AddHighLowSeries
      ProcedureReturn F_RMC_AddHighLowSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstPPCValue,PPCValuesCount,Style,WhichDataAxis,ColorLow,ColorHigh)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddLabelAxis(CtrlId.l,Region.l,Labels.s="",AxisCount.l=0,TickCount.l=0,Alignment.l=0,FontSize.l=0,TextColor.l=0,TextAlignment.l=0,LineColor.l=0,LineStyle.l=0,Text.s="")
    If F_RMC_AddLabelAxis
      ProcedureReturn F_RMC_AddLabelAxis(CtrlId,Region,Labels,AxisCount,TickCount,Alignment,FontSize,TextColor,TextAlignment,LineColor,LineStyle,Text)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddLabelAxisI(CtrlId.l,Region.l,Labels.s,*t.RMC_LABELAXIS)
    If F_RMC_AddLabelAxisI
      ProcedureReturn F_RMC_AddLabelAxisI(CtrlId,Region,Labels,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddLegend(CtrlId.l,Region.l,sLegendtext.s,LegendAlign.l=0,LegendBackColor.l=0,LegendStyle.l=0,LegendTextColor.l=0,LegendFontSize.l=0,LegendIsBold.l=0)
    If F_RMC_AddLegend
      ProcedureReturn F_RMC_AddLegend(CtrlId,Region,sLegendtext,LegendAlign,LegendBackColor,LegendStyle,LegendTextColor,LegendFontSize,LegendIsBold)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddLegendI(CtrlId.l,Region.l,Legendtext.s,*t.RMC_LEGEND)
    If F_RMC_AddLegendI
      ProcedureReturn F_RMC_AddLegendI(CtrlId,Region,Legendtext,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddLineSeries(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,*FirstPPCValue=0,PPCValuesCount.l=0,Type.l=0,Style.l=0,LineStyle.l=0,IsLucent.l=0,Color.l=0,ChartSymbol.l=0,WhichDataAxis.l=0,ValuelabelOn.l=0,HatchMode.l=0)
    If F_RMC_AddLineSeries
      ProcedureReturn F_RMC_AddLineSeries(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Type.l,Style.l,LineStyle.l,IsLucent.l,Color.l,ChartSymbol.l,WhichDataAxis.l,ValuelabelOn.l,HatchMode.l)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddLineSeriesI(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,*t.RMC_LINESERIES)
    If F_RMC_AddLineSeriesI
      ProcedureReturn F_RMC_AddLineSeriesI(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstPPCValue,PPCValuesCount,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddRegion(CtrlId.l,Left.l=0,Top.l=0,Width.l=0,Height.l=0,Footer.s="",ShowBorder.l=0)
    If F_RMC_AddRegion
      ProcedureReturn F_RMC_AddRegion(CtrlId,Left,Top,Width,Height,Footer,ShowBorder)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddRegionI(CtrlId.l,*t.RMC_REGION)
    If F_RMC_AddRegionI
      ProcedureReturn F_RMC_AddRegionI(CtrlId,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddToolTips(CtrlId.l,hWnd.l,ToolTipWidth.l=0)
    If F_RMC_AddToolTips
      ProcedureReturn F_RMC_AddToolTips(CtrlId,hWnd,ToolTipWidth)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddVolumeBarSeries(CtrlId.l,Region.l,*FirstDataValue=0,DataValuesCount.l=0,*FirstPPCValue=0,PPCValuesCount.l=0,Color.l=0,WhichDataAxis.l=0)
    If F_RMC_AddVolumeBarSeries
      ProcedureReturn F_RMC_AddVolumeBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstPPCValue,PPCValuesCount,Color,WhichDataAxis)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddXAxis(CtrlId.l,Region.l,Alignment.l=0,MinValue.d=0,MaxValue.d=0,TickCount.l=0,FontSize.l=0,TextColor.l=0,LineColor.l=0,LineStyle.l=0,DecimalDigits.l=0,Unit.s="",Text.s="",Labels.s="",LabelAlignment.l=0)
    If F_RMC_AddXAxis
      ProcedureReturn F_RMC_AddXAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit,Text,Labels,LabelAlignment)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddXAxisI(CtrlId.l,Region.l,*t.RMC_XYAXIS)
    If F_RMC_AddXAxisI
      ProcedureReturn F_RMC_AddXAxisI(CtrlId,Region,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddYAxis(CtrlId.l,Region.l,Alignment.l=0,MinValue.d=0,MaxValue.d=0,TickCount.l=0,FontSize.l=0,TextColor.l=0,LineColor.l=0,LineStyle.l=0,DecimalDigits.l=0,Unit.s="",Text.s="",Labels.s="",LabelAlignment.l=0)
    If F_RMC_AddYAxis
      ProcedureReturn F_RMC_AddYAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit,Text,Labels,LabelAlignment)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddYAxisI(CtrlId.l,Region.l,*t.RMC_XYAXIS)
    If F_RMC_AddYAxisI
      ProcedureReturn F_RMC_AddYAxisI(CtrlId,Region,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddXYSeries(CtrlId.l,Region.l,*FirstXDataValue=0,DataXValuesCount.l=0,*FirstYDataValue=0,DataYValuesCount.l=0,Color.l=0,Style.l=0,LineStyle.l=0,Symbol.l=0,WhichXAxis.l=0,WhichYAxis.l=0,ValueLabelOn.l=0)
    If F_RMC_AddXYSeries
      ProcedureReturn F_RMC_AddXYSeries(CtrlId,Region,*FirstXDataValue,DataXValuesCount,*FirstYDataValue,DataYValuesCount,Color,Style,LineStyle,Symbol,WhichXAxis,WhichYAxis,ValueLabelOn)
    EndIf
  EndProcedure
  
  Procedure.l RMC_AddXYSeriesI(CtrlId.l,Region.l,*FirstXDataValue,DataXValuesCount.l,*FirstYDataValue,nDataYValuesCount.l,*t.RMC_XYSERIES)
    If F_RMC_AddXYSeriesI
      ProcedureReturn F_RMC_AddXYSeriesI(CtrlId,Region,*FirstXDataValue,DataXValuesCount,*FirstYDataValue,nDataYValuesCount,*t)
    EndIf
  EndProcedure
  ;}
  ;{ RMC_Misc
  Procedure.l RMC_CalcAverage(CtrlId.l,Region.l,SeriesIndex.l,*Average,*XStart,*YStart,*XEnd,*YEnd,HighLowIndex.s="")
    If F_RMC_CalcAverage
      ProcedureReturn F_RMC_CalcAverage(CtrlId,Region,SeriesIndex,*Average,*XStart,*YStart,*XEnd,*YEnd,HighLowIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_CalcTrend(CtrlId.l,Region.l,SeriesIndex.l,*FirstValue,*LastValue,*XStart,*YStart,*XEnd,*YEnd,HighLowIndex.s="")
    If F_RMC_CalcTrend
      ProcedureReturn F_RMC_CalcTrend(CtrlId,Region,SeriesIndex,*FirstValue,*LastValue,*XStart,*YStart,*XEnd,*YEnd,HighLowIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_COBox(CtrlId.l,Index.l,Left.l,Top.l,Width.l,Height.l,Style.l=0,BGColor.l=0,LineColor.l=0,Transparency.l=0)
    If F_RMC_COBox
      ProcedureReturn F_RMC_COBox(CtrlId,Index.l,Left.l,Top.l,Width.l,Height.l,Style.l,BGColor.l,LineColor.l,Transparency.l)
    EndIf
  EndProcedure
  
  Procedure.l RMC_COCircle(CtrlId.l,Index.l,XCenter.l,YCenter.l,Width.l,Style.l=0,BGColor.l=0,LineColor.l=0,Transparency.l=0)
    If F_RMC_COCircle
      ProcedureReturn F_RMC_COCircle(CtrlId,Index,XCenter,YCenter,Width,Style,BGColor,LineColor,Transparency)
    EndIf
  EndProcedure
  
  Procedure.l RMC_CODash(CtrlId.l,COIndex.l,XStart.l,YStart.l,XEnd.l,YEnd.l,Style.l=0,Color.l=0,AsSpline.l=0,LineWidth.l=0,StartCap.l=0,EndCap.l=0)
    If F_RMC_CODash
      ProcedureReturn F_RMC_CODash(CtrlId,COIndex,XStart,YStart,XEnd,YEnd,Style,Color,AsSpline,LineWidth,StartCap,EndCap)
    EndIf
  EndProcedure
  
  Procedure.l RMC_CODelete(CtrlId.l,Index.l)
    If F_RMC_CODelete
      ProcedureReturn F_RMC_CODelete(CtrlId,Index)
    EndIf
  EndProcedure
  
  Procedure.l RMC_COGetTextWH(CtrlId.l,Index.l,WH.l)
    If F_RMC_COGetTextWH
      ProcedureReturn F_RMC_COGetTextWH(CtrlId,Index,WH)
    EndIf
  EndProcedure
  
  Procedure.l RMC_COImage(CtrlId.l,Index.l,ImagePath.s,Left.l,Top.l,Width.l=0,Height.l=0)
    If F_RMC_COImage
      ProcedureReturn F_RMC_COImage(CtrlId,Index,ImagePath,Left,Top,Width,Height)
    EndIf
  EndProcedure
  
  Procedure.l RMC_COLine(CtrlId.l,Index.l,*XPoints,*YPoints,PointsCount.l,Style.l=0,Color.l=0,AsSpline.l=0,LineWidth.l=0,StartCap.l=0,EndCap.l=0)
    If F_RMC_COLine
      ProcedureReturn F_RMC_COLine(CtrlId,Index,*XPoints,*YPoints,PointsCount,Style,Color,AsSpline,LineWidth,StartCap,EndCap)
    EndIf
  EndProcedure
  
  Procedure.l RMC_COPolygon(CtrlId.l,Index.l,*XPoints,*YPoints,PointsCount.l,BGColor.l=0,LineColor.l=0,AsSpline.l=0,Transparency.l=0)
    If F_RMC_COPolygon
      ProcedureReturn F_RMC_COPolygon(CtrlId,Index,*XPoints,*YPoints,PointsCount,BGColor,LineColor,AsSpline,Transparency)
    EndIf
  EndProcedure
  
  Procedure.l RMC_COSymbol(CtrlId.l,Index.l,XCenter.l,YCenter.l,Style.l,Color.l)
    If F_RMC_COSymbol
      ProcedureReturn F_RMC_COSymbol(CtrlId,Index,XCenter.l,YCenter.l,Style.l,Color.l)
    EndIf
  EndProcedure
  
  Procedure.l RMC_COText(CtrlId.l,Index.l,Text.s,Left.l,Top.l,Width.l=0,Height.l=0,Style.l=0,BGColor.l=0,LineColor.l=0,Transparency.l=0,LineAlignment.l=0,TextColor.l=0,TextProperties.s="")
    If F_RMC_COText
      ProcedureReturn F_RMC_COText(CtrlId,Index,Text,Left,Top,Width,Height,Style,BGColor,LineColor,Transparency,LineAlignment,TextColor,TextProperties)
    EndIf
  EndProcedure
  
  Procedure.l RMC_COVisible(CtrlId.l,Index.l,Hide.l)
    If F_RMC_COVisible
      ProcedureReturn F_RMC_COVisible(CtrlId,Index,Hide.l)
    EndIf
  EndProcedure
  
  Procedure.l RMC_DeleteChart(CtrlId.l)
    If F_RMC_DeleteChart
      ProcedureReturn F_RMC_DeleteChart(CtrlId)
    EndIf
  EndProcedure
  
  Procedure.l RMC_Magnifier(CtrlId.l,Enable.l,Size.l=0,Color.l=0,LineColor.l=0,Transparency.l=0)
    If F_RMC_Magnifier
      ProcedureReturn F_RMC_Magnifier(CtrlId,Enable.l,Size,Color,LineColor,Transparency)
    EndIf
  EndProcedure
  
  Procedure.l RMC_Paint(CtrlId.l)
    If F_RMC_Paint
      ProcedureReturn F_RMC_Paint(CtrlId)
    EndIf
  EndProcedure
  
  Procedure.l RMC_ReadDataFromFile(*aData,FileName.s,Lines.s="",Fields.s="",FieldDelimiter.s="",Reverse.l=0)
    If F_RMC_ReadDataFromFile
      ProcedureReturn F_RMC_ReadDataFromFile(*aData,FileName,Lines,Fields,FieldDelimiter,Reverse)
    EndIf
  EndProcedure
  
  Procedure.l RMC_ReadStringFromFile(*sValue,FileName.s,Lines.s="",Fields.s="",FieldDelimiter.s="",Reverse.l=0)
    If F_RMC_ReadStringFromFile
      ProcedureReturn F_RMC_ReadStringFromFile(*sValue,FileName,Lines,Fields,FieldDelimiter,Reverse)
    EndIf
  EndProcedure
  
  Procedure.l RMC_Reset(CtrlId.l)
    If F_RMC_Reset
      ProcedureReturn F_RMC_Reset(CtrlId)
    EndIf
  EndProcedure
  
  Procedure.l RMC_RND(n1.l,n2.l)
    If F_RMC_RND
      ProcedureReturn F_RMC_RND(n1,n2)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SaveBMP(hBmp.l,FileName.s)
    If F_RMC_SaveBMP
      ProcedureReturn F_RMC_SaveBMP(hBmp,FileName)
    EndIf
  EndProcedure
  
  Procedure.l RMC_ShowToolTips(CtrlId.l,X.l,Y.l)
    If F_RMC_ShowToolTips
      ProcedureReturn F_RMC_ShowToolTips(CtrlId,X,Y)
    EndIf
  EndProcedure
  
  Procedure.l RMC_Split(sData.s,Array asData.s(1))
    Protected nc.l=1,temp.s=" "
    
    While temp<>""
      temp=StringField(sData,nc,"*")
      If temp<>""
        asData(nc-1)=temp
        nc+1
      EndIf
    Wend
    
    ProcedureReturn nc-1
  EndProcedure
  
  Procedure.l RMC_Split2Double(sData.s,*aData)
    Protected nc.l=1,temp.s=" "
    
    While temp<>""
      temp=Trim(StringField(sData,nc,"*"))
      If temp<>""
        PokeD(*aData+((nc-1)*8),ValD(temp))
        ;aData(nc-1)=ValD(temp)
        nc+1
      EndIf
    Wend
    
    ProcedureReturn nc-1
  EndProcedure
  
  Procedure.l RMC_Split2Long(sData.s,*aData)
    Protected nc.l=1,temp.s=" "
    
    While temp<>""
      temp=Trim(StringField(sData,nc,"*"))
      If temp<>""
        PokeL(*aData+((nc-1)*4),Val(temp))
        ;aData(nc-1)=Val(temp)
        nc+1
      EndIf
    Wend
    
    ProcedureReturn nc-1
  EndProcedure
  
  Procedure.l RMC_WriteRMCFile(CtrlId.l,FileName.s)
    If F_RMC_WriteRMCFile
      ProcedureReturn F_RMC_WriteRMCFile(CtrlId,FileName)
    EndIf
  EndProcedure
  
  Procedure.l RMC_Zoom(CtrlId.l,Mode.l,Color.l=0,LineColor.l=0,Transparency.l=0)
    If F_RMC_Zoom
      ProcedureReturn F_RMC_Zoom(CtrlId,Mode.l,Color.l,LineColor.l,Transparency.l)
    EndIf
  EndProcedure
  ;}
  ;{ RMC_Create
  Procedure.l RMC_CreateChart(ParentHndl.l,CtrlId.l,X.l,Y.l,Width.l,Height.l,BackColor.l=0,CtrlStyle.l=0,ExportOnly.l=0,BgImage.s="",FontName.s="",ToolTipWidth.l=0,BitmapBKColor.l=0)
    If F_RMC_CreateChart
      ProcedureReturn F_RMC_CreateChart(ParentHndl,CtrlId,X,Y,Width,Height,BackColor,CtrlStyle,ExportOnly,BgImage,FontName,ToolTipWidth,BitmapBKColor)
    EndIf
  EndProcedure
  
  Procedure.l RMC_CreateChartI(ParentHndl.l,CtrlId.l,*t.RMC_CHART)
    If F_RMC_CreateChartI
      ProcedureReturn F_RMC_CreateChartI(ParentHndl,CtrlId,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_CreateChartFromFile(ParentHndl.l,CtrlId.l,X.l,Y.l,ExportOnly.l,RMCFile.s)
    If F_RMC_CreateChartFromFile
      ProcedureReturn F_RMC_CreateChartFromFile(ParentHndl,CtrlId,X,Y,ExportOnly,RMCFile)
    EndIf
  EndProcedure
  
  Procedure.l RMC_CreateChartFromFileOnDC(ParentDC.l,CtrlId.l,X.l,Y.l,ExportOnly.l,RMCFile.s)
    If F_RMC_CreateChartFromFileOnDC
      ProcedureReturn F_RMC_CreateChartFromFileOnDC(ParentDC,CtrlId,X,Y,ExportOnly,RMCFile)
    EndIf
  EndProcedure
  
  Procedure.l RMC_CreateChartOnDC(ParentDC.l,CtrlId.l,X.l,Y.l,Width.l,Height.l,BackColor.l=0,CtrlStyle.l=0,ExportOnly.l=0,BgImage.s="",FontName.s="",BitmapBKColor.l=0)
    If F_RMC_CreateChartOnDC
      ProcedureReturn F_RMC_CreateChartOnDC(ParentDC,CtrlId,X,Y,Width,Height,BackColor,CtrlStyle,ExportOnly,BgImage,FontName,BitmapBKColor)
    EndIf
  EndProcedure
  
  Procedure.l RMC_CreateChartOnDCI(ParentDC.l,CtrlId.l,*t.RMC_CHART)
    If F_RMC_CreateChartOnDCI
      ProcedureReturn F_RMC_CreateChartOnDCI(ParentDC,CtrlId,*t)
    EndIf
  EndProcedure
  ;}
  ;{ RMC_Draw
  Procedure.l RMC_Draw(CtrlId.l)
    If F_RMC_Draw
      ProcedureReturn F_RMC_Draw(CtrlId)
    EndIf
  EndProcedure
  
  Procedure.l RMC_Draw2Clipboard(CtrlId.l,Type.l)
    If F_RMC_Draw2Clipboard
      ProcedureReturn F_RMC_Draw2Clipboard(CtrlId,Type)
    EndIf
  EndProcedure
  
  Procedure.l RMC_Draw2File(CtrlId.l,FileName.s,Width.l=0,Height.l=0,JPGQualityLevel.l=0)
    If F_RMC_Draw2File
      ProcedureReturn F_RMC_Draw2File(CtrlId,FileName,Width,Height,JPGQualityLevel.l)
    EndIf
  EndProcedure
  
  Procedure.l RMC_Draw2Printer(CtrlId.l,PrinterDC.l=0,Left.l=0,Top.l=0,Width.l=0,Height.l=0,Type.l=0)
    If F_RMC_Draw2Printer
      ProcedureReturn F_RMC_Draw2Printer(CtrlId,PrinterDC,Left,Top,Width,Height,Type)
    EndIf
  EndProcedure
  ;}
  ;{ RMC_Get
  Procedure.l RMC_GetChartsizeFromFile(RMCFile.s,*Width,*Height)
    If F_RMC_GetChartsizeFromFile
      ProcedureReturn F_RMC_GetChartsizeFromFile(RMCFile,*Width,*Height)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetCtrlLeft(CtrlId.l)
    If F_RMC_GetCtrlLeft
      ProcedureReturn F_RMC_GetCtrlLeft(CtrlId)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetCtrlTop(CtrlId.l)
    If F_RMC_GetCtrlTop
      ProcedureReturn F_RMC_GetCtrlTop(CtrlId)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetCtrlWidth(CtrlId.l)
    If F_RMC_GetCtrlWidth
      ProcedureReturn F_RMC_GetCtrlWidth(CtrlId)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetCtrlHeight(CtrlId.l)
    If F_RMC_GetCtrlHeight
      ProcedureReturn F_RMC_GetCtrlHeight(CtrlId)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetINFO(CtrlId.l,*t.RMC_INFO,Region.l,Series.l,Index.l)
    If F_RMC_GetINFO
      ProcedureReturn F_RMC_GetINFO(CtrlId,*t,Region,Series,Index)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetINFOXY(CtrlId.l,*t.RMC_INFO,X.l,Y.l)
    If F_RMC_GetINFOXY
      ProcedureReturn F_RMC_GetINFOXY(CtrlId,*t,X,Y)
    EndIf
  EndProcedure
  
  Procedure.d RMC_GetVersion()
    If F_RMC_GetVersion
      ProcedureReturn F_RMC_GetVersion()
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetData(CtrlId.l,Region.l,SeriesIndex.l,DataIndex.l,*nData,YData.l=0)
    If F_RMC_GetData
      ProcedureReturn F_RMC_GetData(CtrlId,Region,SeriesIndex,DataIndex,*nData,YData)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetDataCount(CtrlId.l,Region.l,SeriesIndex.l,*DataCount)
    If F_RMC_GetDataCount
      ProcedureReturn F_RMC_GetDataCount(CtrlId,Region,SeriesIndex,*DataCount)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetDataLocation(CtrlId.l,Region.l,SeriesIndex.l,nData.d,*XYPos)
    If F_RMC_GetDataLocation
      ProcedureReturn F_RMC_GetDataLocation(CtrlId,Region,SeriesIndex,nData,*XYPos)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetDataLocationXY(CtrlId.l,Region.l,SeriesIndex.l,DataX.d,DataY.d,*XPos,*YPos)
    If F_RMC_GetDataLocationXY
      ProcedureReturn F_RMC_GetDataLocationXY(CtrlId,Region,SeriesIndex,DataX,DataY,*XPos,*YPos)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetSeriesDataRange(CtrlId.l,Region.l,Series.l,*First,*Last)
    If F_RMC_GetSeriesDataRange
      ProcedureReturn F_RMC_GetSeriesDataRange(CtrlId,Region,Series,*First,*Last)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetGridLocation(CtrlId.l,Region.l,*Left,*Top,*Right,*Bottom)
    If F_RMC_GetGridLocation
      ProcedureReturn F_RMC_GetGridLocation(CtrlId,Region,*Left,*Top,*Right,*Bottom)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetImageSizeFromFile(ImagePath.s,*Width,*Height)
    If F_RMC_GetImageSizeFromFile
      ProcedureReturn F_RMC_GetImageSizeFromFile(ImagePath,*Width,*Height)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetLowPart(Param.d)
    If F_RMC_GetLowPart
      ProcedureReturn F_RMC_GetLowPart(Param)
    EndIf
  EndProcedure
  
  Procedure.l RMC_GetHighPart(Param.d)
    If F_RMC_GetHighPart
      ProcedureReturn F_RMC_GetHighPart(Param)
    EndIf
  EndProcedure
  ;}
  ;{ RMC_Set
  
  Procedure.l RMC_SetCaptionBGColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetCaptionBGColor
      ProcedureReturn F_RMC_SetCaptionBGColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetCaptionFontSize(CtrlId.l,Region.l,Fontbold.l)
    If F_RMC_SetCaptionFontSize
      ProcedureReturn F_RMC_SetCaptionFontSize(CtrlId,Region,Fontbold)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetCaptionFontBold(CtrlId.l,Region.l,FontSize.l)
    If F_RMC_SetCaptionFontBold
      ProcedureReturn F_RMC_SetCaptionFontBold(CtrlId,Region,FontSize)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetCaptionText(CtrlId.l,Region.l,Text.s)
    If F_RMC_SetCaptionText
      ProcedureReturn F_RMC_SetCaptionText(CtrlId,Region,Text)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetCaptionTextColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetCaptionTextColor
      ProcedureReturn F_RMC_SetCaptionTextColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetCtrlBGColor(CtrlId.l,Color.l)
    If F_RMC_SetCtrlBGColor
      ProcedureReturn F_RMC_SetCtrlBGColor(CtrlId,Color)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetCtrlBGImage(CtrlId.l,BgImage.s)
    If F_RMC_SetCtrlBGImage
      ProcedureReturn F_RMC_SetCtrlBGImage(CtrlId,BgImage)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetCtrlFont(CtrlId.l,FontName.s)
    If F_RMC_SetCtrlFont
      ProcedureReturn F_RMC_SetCtrlFont(CtrlId,FontName)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetCtrlPos(CtrlId.l,Left.l,Top.l,Relative.l=0)
    If F_RMC_SetCtrlPos
      ProcedureReturn F_RMC_SetCtrlPos(CtrlId,Left,Top,Relative)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetCtrlSize(CtrlId.l,Width.l,Height.l,Relative.l=0,RecalcMode.l=0)
    If F_RMC_SetCtrlSize
      ProcedureReturn F_RMC_SetCtrlSize(CtrlId,Width,Height,Relative,RecalcMode)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetCtrlStyle(CtrlId.l,Style.l)
    If F_RMC_SetCtrlStyle
      ProcedureReturn F_RMC_SetCtrlStyle(CtrlId,Style)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXAlignment(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_SetDAXAlignment
      ProcedureReturn F_RMC_SetDAXAlignment(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXDecimalDigits(CtrlId.l,Region.l,DecimalDigits.l,AxisIndex.l=0)
    If F_RMC_SetDAXDecimalDigits
      ProcedureReturn F_RMC_SetDAXDecimalDigits(CtrlId,Region,DecimalDigits,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXFontSize(CtrlId.l,Region.l,FontSize.l)
    If F_RMC_SetDAXFontSize
      ProcedureReturn F_RMC_SetDAXFontSize(CtrlId,Region,FontSize)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXLineColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetDAXLineColor
      ProcedureReturn F_RMC_SetDAXLineColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXLabelAlignment(CtrlId.l,Region.l,LabelAlignment.l,AxisIndex.l=0)
    If F_RMC_SetDAXLabelAlignment
      ProcedureReturn F_RMC_SetDAXLabelAlignment(CtrlId,Region,LabelAlignment,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXLabels(CtrlId.l,Region.l,Labels.s,AxisIndex.l=0)
    If F_RMC_SetDAXLabels
      ProcedureReturn F_RMC_SetDAXLabels(CtrlId,Region,Labels,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXLineStyle(CtrlId.l,Region.l,Style.l)
    If F_RMC_SetDAXLineStyle
      ProcedureReturn F_RMC_SetDAXLineStyle(CtrlId,Region,Style)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXMaxValue(CtrlId.l,Region.l,MaxValue.d,AxisIndex.l=0)
    If F_RMC_SetDAXMaxValue
      ProcedureReturn F_RMC_SetDAXMaxValue(CtrlId,Region,MaxValue,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXMinValue(CtrlId.l,Region.l,MinValue.d,AxisIndex.l=0)
    If F_RMC_SetDAXMinValue
      ProcedureReturn F_RMC_SetDAXMinValue(CtrlId,Region,MinValue,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXText(CtrlId.l,Region.l,Text.s,AxisIndex.l=0)
    If F_RMC_SetDAXText
      ProcedureReturn F_RMC_SetDAXText(CtrlId,Region,Text,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXTextColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetDAXTextColor
      ProcedureReturn F_RMC_SetDAXTextColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXTickcount(CtrlId.l,Region.l,TickCount.l)
    If F_RMC_SetDAXTickcount
      ProcedureReturn F_RMC_SetDAXTickcount(CtrlId,Region,TickCount)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetDAXUnit(CtrlId.l,Region.l,Unit.s,AxisIndex.l)
    If F_RMC_SetDAXUnit
      ProcedureReturn F_RMC_SetDAXUnit(CtrlId,Region,Unit,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetGridBGColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetGridBGColor
      ProcedureReturn F_RMC_SetGridBGColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetGridGradient(CtrlId.l,Region.l,HasGradient.l)
    If F_RMC_SetGridGradient
      ProcedureReturn F_RMC_SetGridGradient(CtrlId,Region,HasGradient)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetGridMargin(CtrlId.l,Region.l,Left.l,Top.l,Width.l,Height.l)
    If F_RMC_SetGridMargin
      ProcedureReturn F_RMC_SetGridMargin(CtrlId,Region,Left,Top,Width,Height)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXAlignment(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_SetLAXAlignment
      ProcedureReturn F_RMC_SetLAXAlignment(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXCount(CtrlId.l,Region.l,LabelAxisCount.l)
    If F_RMC_SetLAXCount
      ProcedureReturn F_RMC_SetLAXCount(CtrlId,Region,LabelAxisCount)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXFontSize(CtrlId.l,Region.l,FontSize.l)
    If F_RMC_SetLAXFontSize
      ProcedureReturn F_RMC_SetLAXFontSize(CtrlId,Region,FontSize)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXLabelAlignment(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_SetLAXLabelAlignment
      ProcedureReturn F_RMC_SetLAXLabelAlignment(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXLabels(CtrlId.l,Region.l,Labels.s)
    If F_RMC_SetLAXLabels
      ProcedureReturn F_RMC_SetLAXLabels(CtrlId,Region,Labels)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXLineColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetLAXLineColor
      ProcedureReturn F_RMC_SetLAXLineColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXLineStyle(CtrlId.l,Region.l,Style.l)
    If F_RMC_SetLAXLineStyle
      ProcedureReturn F_RMC_SetLAXLineStyle(CtrlId,Region,Style)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXText(CtrlId.l,Region.l,Text.s)
    If F_RMC_SetLAXText
      ProcedureReturn F_RMC_SetLAXText(CtrlId,Region,Text)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXTextColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetLAXTextColor
      ProcedureReturn F_RMC_SetLAXTextColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXTickCount(CtrlId.l,Region.l,TickCount.l)
    If F_RMC_SetLAXTickCount
      ProcedureReturn F_RMC_SetLAXTickCount(CtrlId,Region,TickCount)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLegendAlignment(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_SetLegendAlignment
      ProcedureReturn F_RMC_SetLegendAlignment(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLegendBGColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetLegendBGColor
      ProcedureReturn F_RMC_SetLegendBGColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLegendFontBold(CtrlId.l,Region.l,Fontbold.l)
    If F_RMC_SetLegendFontBold
      ProcedureReturn F_RMC_SetLegendFontBold(CtrlId,Region,Fontbold)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLegendFontSize(CtrlId.l,Region.l,FontSize.l)
    If F_RMC_SetLegendFontSize
      ProcedureReturn F_RMC_SetLegendFontSize(CtrlId,Region,FontSize)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLegendStyle(CtrlId.l,Region.l,Style.l)
    If F_RMC_SetLegendStyle
      ProcedureReturn F_RMC_SetLegendStyle(CtrlId,Region,Style)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLegendText(CtrlId.l,Region.l,Text.s)
    If F_RMC_SetLegendText
      ProcedureReturn F_RMC_SetLegendText(CtrlId,Region,Text)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLegendTextColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetLegendTextColor
      ProcedureReturn F_RMC_SetLegendTextColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetMouseClick(CtrlId.l,Button.l,X.l,Y.l,*t.RMC_INFO)
    If F_RMC_SetMouseClick
      ProcedureReturn F_RMC_SetMouseClick(CtrlId,Button,X,Y,*t)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetRegionBorder(CtrlId.l,Region.l,ShowBorder.l)
    If F_RMC_SetRegionBorder
      ProcedureReturn F_RMC_SetRegionBorder(CtrlId,Region,ShowBorder)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetRegionFooter(CtrlId.l,Region.l,Footer.s)
    If F_RMC_SetRegionFooter
      ProcedureReturn F_RMC_SetRegionFooter(CtrlId,Region,Footer)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetRegionMargin(CtrlId.l,Region.l,Left.l,Top.l,Width.l,Height.l)
    If F_RMC_SetRegionMargin
      ProcedureReturn F_RMC_SetRegionMargin(CtrlId,Region,Left,Top,Width,Height)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetRMCFile(CtrlId.l,RMCFile.s)
    If F_RMC_SetRMCFile
      ProcedureReturn F_RMC_SetRMCFile(CtrlId,RMCFile)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesColor(CtrlId.l,Region.l,Series.l,Color.l,Index.l=0)
    If F_RMC_SetSeriesColor
      ProcedureReturn F_RMC_SetSeriesColor(CtrlId,Region,Series,Color,Index)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesData(CtrlId.l,Region.l,Series.l,*nData,DataCount.l,YData.l=0)
    If F_RMC_SetSeriesData
      ProcedureReturn F_RMC_SetSeriesData(CtrlId,Region,Series,*nData,DataCount,YData)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesDataAxis(CtrlId.l,Region.l,Series.l,WhichAxis.l)
    If F_RMC_SetSeriesDataAxis
      ProcedureReturn F_RMC_SetSeriesDataAxis(CtrlId,Region,Series,WhichAxis)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesDataFile(CtrlId.l,Region.l,Series.l,FileName.s,Lines.s="",Fields.s="",FieldDelimiter.s="",YData.l=0)
    If F_RMC_SetSeriesDataFile
      ProcedureReturn F_RMC_SetSeriesDataFile(CtrlId,Region,Series,FileName,Lines,Fields,FieldDelimiter,YData)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesExplodeMode(CtrlId.l,Region.l,Series.l,Explodemode.l)
    If F_RMC_SetSeriesExplodeMode
      ProcedureReturn F_RMC_SetSeriesExplodeMode(CtrlId,Region,Series,Explodemode)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesHatchMode(CtrlId.l,Region.l,Series.l,HatchMode.l)
    If F_RMC_SetSeriesHatchMode
      ProcedureReturn F_RMC_SetSeriesHatchMode(CtrlId,Region,Series,HatchMode)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesHide(CtrlId.l,Region.l,Series.l,Hide.l)
    If F_RMC_SetSeriesHide
      ProcedureReturn F_RMC_SetSeriesHide(CtrlId,Region,Series,Hide)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesLinestyle(CtrlId.l,Region.l,Series.l,LineStyle.l)
    If F_RMC_SetSeriesLinestyle
      ProcedureReturn F_RMC_SetSeriesLinestyle(CtrlId,Region,Series,LineStyle)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesLucent(CtrlId.l,Region.l,Series.l,Lucent.l)
    If F_RMC_SetSeriesLucent
      ProcedureReturn F_RMC_SetSeriesLucent(CtrlId,Region,Series,Lucent)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesSingleData(CtrlId.l,Region.l,Series.l,nData.d,DataIndex.l,YData.l=0)
    If F_RMC_SetSeriesSingleData
      ProcedureReturn F_RMC_SetSeriesSingleData(CtrlId,Region,Series,nData,DataIndex,YData)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesStartAngle(CtrlId.l,Region.l,Series.l,StartAngle.l)
    If F_RMC_SetSeriesStartAngle
      ProcedureReturn F_RMC_SetSeriesStartAngle(CtrlId,Region,Series,StartAngle)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesStyle(CtrlId.l,Region.l,Series.l,Style.l)
    If F_RMC_SetSeriesStyle
      ProcedureReturn F_RMC_SetSeriesStyle(CtrlId,Region,Series,Style)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesSymbol(CtrlId.l,Region.l,Series.l,Symbol.l)
    If F_RMC_SetSeriesSymbol
      ProcedureReturn F_RMC_SetSeriesSymbol(CtrlId,Region,Series,Symbol)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesValuelabel(CtrlId.l,Region.l,Series.l,Valuelabel.l)
    If F_RMC_SetSeriesValuelabel
      ProcedureReturn F_RMC_SetSeriesValuelabel(CtrlId,Region,Series,Valuelabel)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesVertical(CtrlId.l,Region.l,Series.l,Vertical.l)
    If F_RMC_SetSeriesVertical
      ProcedureReturn F_RMC_SetSeriesVertical(CtrlId,Region,Series,Vertical)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesXAxis(CtrlId.l,Region.l,Series.l,WhichXAxis.l)
    If F_RMC_SetSeriesXAxis
      ProcedureReturn F_RMC_SetSeriesXAxis(CtrlId,Region,Series,WhichXAxis)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesYAxis(CtrlId.l,Region.l,Series.l,WhichYAxis.l)
    If F_RMC_SetSeriesYAxis
      ProcedureReturn F_RMC_SetSeriesYAxis(CtrlId,Region,Series,WhichYAxis)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSingleBarColors(CtrlId.l,Region.l,*FirstColorElement,ColorElementsCount.l)
    If F_RMC_SetSingleBarColors
      ProcedureReturn F_RMC_SetSingleBarColors(CtrlId,Region,*FirstColorElement,ColorElementsCount)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetWatermark(Watermark.s,WMColor.l=0,WMLucentValue.l=0,Alignment.l=0,FontSize.l=0)
    If F_RMC_SetWatermark
      ProcedureReturn F_RMC_SetWatermark(Watermark,WMColor,WMLucentValue,Alignment,FontSize)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXAlignment(CtrlId.l,Region.l,Alignment.l,AxisIndex.l=0)
    If F_RMC_SetXAXAlignment
      ProcedureReturn F_RMC_SetXAXAlignment(CtrlId,Region,Alignment,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXDecimalDigits(CtrlId.l,Region.l,DecimalDigits.l,AxisIndex.l=0)
    If F_RMC_SetXAXDecimalDigits
      ProcedureReturn F_RMC_SetXAXDecimalDigits(CtrlId,Region,DecimalDigits,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXFontSize(CtrlId.l,Region.l,FontSize.l,AxisIndex.l=0)
    If F_RMC_SetXAXFontSize
      ProcedureReturn F_RMC_SetXAXFontSize(CtrlId,Region,FontSize,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXLabels(CtrlId.l,Region.l,Labels.s,AxisIndex.l=0)
    If F_RMC_SetXAXLabels
      ProcedureReturn F_RMC_SetXAXLabels(CtrlId,Region,Labels,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXLabelAlignment(CtrlId.l,Region.l,LabelAlignment.l,AxisIndex.l=0)
    If F_RMC_SetXAXLabelAlignment
      ProcedureReturn F_RMC_SetXAXLabelAlignment(CtrlId,Region,LabelAlignment,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXLineColor(CtrlId.l,Region.l,Color.l,AxisIndex.l=0)
    If F_RMC_SetXAXLineColor
      ProcedureReturn F_RMC_SetXAXLineColor(CtrlId,Region,Color,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXLineStyle(CtrlId.l,Region.l,Style.l,AxisIndex.l=0)
    If F_RMC_SetXAXLineStyle
      ProcedureReturn F_RMC_SetXAXLineStyle(CtrlId,Region,Style,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXMaxValue(CtrlId.l,Region.l,MaxValue.d,AxisIndex.l=0)
    If F_RMC_SetXAXMaxValue
      ProcedureReturn F_RMC_SetXAXMaxValue(CtrlId,Region,MaxValue,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXMinValue(CtrlId.l,Region.l,MinValue.d,AxisIndex.l=0)
    If F_RMC_SetXAXMinValue
      ProcedureReturn F_RMC_SetXAXMinValue(CtrlId,Region,MinValue,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXText(CtrlId.l,Region.l,Text.s,AxisIndex.l=0)
    If F_RMC_SetXAXText
      ProcedureReturn F_RMC_SetXAXText(CtrlId,Region,Text,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXTextColor(CtrlId.l,Region.l,Color.l,AxisIndex.l=0)
    If F_RMC_SetXAXTextColor
      ProcedureReturn F_RMC_SetXAXTextColor(CtrlId,Region,Color,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXTickcount(CtrlId.l,Region.l,TickCount.l,AxisIndex.l=0)
    If F_RMC_SetXAXTickcount
      ProcedureReturn F_RMC_SetXAXTickcount(CtrlId,Region,TickCount,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetXAXUnit(CtrlId.l,Region.l,Unit.s,AxisIndex.l=0)
    If F_RMC_SetXAXUnit
      ProcedureReturn F_RMC_SetXAXUnit(CtrlId,Region,Unit,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXAlignment(CtrlId.l,Region.l,Alignment.l,AxisIndex.l=0)
    If F_RMC_SetYAXAlignment
      ProcedureReturn F_RMC_SetYAXAlignment(CtrlId,Region,Alignment,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXDecimalDigits(CtrlId.l,Region.l,DecimalDigits.l,AxisIndex.l=0)
    If F_RMC_SetYAXDecimalDigits
      ProcedureReturn F_RMC_SetYAXDecimalDigits(CtrlId,Region,DecimalDigits,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXFontSize(CtrlId.l,Region.l,FontSize.l,AxisIndex.l=0)
    If F_RMC_SetYAXFontSize
      ProcedureReturn F_RMC_SetYAXFontSize(CtrlId,Region,FontSize,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXLabels(CtrlId.l,Region.l,Labels.s,AxisIndex.l=0)
    If F_RMC_SetYAXLabels
      ProcedureReturn F_RMC_SetYAXLabels(CtrlId,Region,Labels,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXLabelAlignment(CtrlId.l,Region.l,LabelAlignment.l,AxisIndex.l=0)
    If F_RMC_SetYAXLabelAlignment
      ProcedureReturn F_RMC_SetYAXLabelAlignment(CtrlId,Region,LabelAlignment,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXLineColor(CtrlId.l,Region.l,Color.l,AxisIndex.l=0)
    If F_RMC_SetYAXLineColor
      ProcedureReturn F_RMC_SetYAXLineColor(CtrlId,Region,Color,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXLineStyle(CtrlId.l,Region.l,Style.l,AxisIndex.l=0)
    If F_RMC_SetYAXLineStyle
      ProcedureReturn F_RMC_SetYAXLineStyle(CtrlId,Region,Style,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXMaxValue(CtrlId.l,Region.l,MaxValue.d,AxisIndex.l=0)
    If F_RMC_SetYAXMaxValue
      ProcedureReturn F_RMC_SetYAXMaxValue(CtrlId,Region,MaxValue,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXMinValue(CtrlId.l,Region.l,MinValue.d,AxisIndex.l=0)
    If F_RMC_SetYAXMinValue
      ProcedureReturn F_RMC_SetYAXMinValue(CtrlId,Region,MinValue,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXText(CtrlId.l,Region.l,Text.s,AxisIndex.l=0)
    If F_RMC_SetYAXText
      ProcedureReturn F_RMC_SetYAXText(CtrlId,Region,Text,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXTextColor(CtrlId.l,Region.l,Color.l,AxisIndex.l=0)
    If F_RMC_SetYAXTextColor
      ProcedureReturn F_RMC_SetYAXTextColor(CtrlId,Region,Color,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXTickcount(CtrlId.l,Region.l,TickCount.l,AxisIndex.l=0)
    If F_RMC_SetYAXTickcount
      ProcedureReturn F_RMC_SetYAXTickcount(CtrlId,Region,TickCount,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetYAXUnit(CtrlId.l,Region.l,Unit.s,AxisIndex.l=0)
    If F_RMC_SetYAXUnit
      ProcedureReturn F_RMC_SetYAXUnit(CtrlId,Region,Unit,AxisIndex)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetCustomToolTipText(CtrlId.l,Region.l,Series.l,DataIndex.l,Text.s)
    If F_RMC_SetCustomToolTipText
      ProcedureReturn F_RMC_SetCustomToolTipText(CtrlId,Region,Series,DataIndex,Text)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetGridBiColor(CtrlId.l,Region.l,BiColor.l)
    If F_RMC_SetGridBiColor
      ProcedureReturn F_RMC_SetGridBiColor(CtrlId,Region,BiColor)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetHelpingGrid(CtrlId.l,Size.l,GridColor.l)
    If F_RMC_SetHelpingGrid
      ProcedureReturn F_RMC_SetHelpingGrid(CtrlId,Size,GridColor)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXLabelsFile(CtrlId.l,Region.l,FileName.s,Lines.s="",Fields.s="",FieldDelimiter.s="")
    If F_RMC_SetLAXLabelsFile
      ProcedureReturn F_RMC_SetLAXLabelsFile(CtrlId,Region,FileName,Lines,Fields,FieldDelimiter)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLAXLabelsRange(CtrlId.l,Region.l,First.l,Last.l)
    If F_RMC_SetLAXLabelsRange
      ProcedureReturn F_RMC_SetLAXLabelsRange(CtrlId,Region,First,Last)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetLegendHide(CtrlId.l,Region.l,Hide.l)
    If F_RMC_SetLegendHide
      ProcedureReturn F_RMC_SetLegendHide(CtrlId,Region,Hide)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesDataRange(CtrlId.l,Region.l,Series.l,First.l,Last.l)
    If F_RMC_SetSeriesDataRange
      ProcedureReturn F_RMC_SetSeriesDataRange(CtrlId,Region,Series,First,Last)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesHighLowColor(CtrlId.l,Region.l,Series.l,ColorLow.l,ColorHigh.l)
    If F_RMC_SetSeriesHighLowColor
      ProcedureReturn F_RMC_SetSeriesHighLowColor(CtrlId,Region,Series,ColorLow,ColorHigh)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesPPColumn(CtrlId.l,Region.l,Series.l,PointsPerColumn.l)
    If F_RMC_SetSeriesPPColumn
      ProcedureReturn F_RMC_SetSeriesPPColumn(CtrlId,Region,Series,PointsPerColumn)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetSeriesPPColumnArray(CtrlId.l,Region.l,Series.l,*FirstPPCValue,PPCValuesCount.l)
    If F_RMC_SetSeriesPPColumnArray
      ProcedureReturn F_RMC_SetSeriesPPColumnArray(CtrlId,Region,Series,*FirstPPCValue,PPCValuesCount)
    EndIf
  EndProcedure
  
  Procedure.l RMC_SetToolTipWidth(CtrlId.l,Width.l)
    If F_RMC_SetToolTipWidth
      ProcedureReturn F_RMC_SetToolTipWidth(CtrlId,Width)
    EndIf
  EndProcedure
  ;}
  ;}
CompilerElse
  ;- Compile as Lib
  ;{
  ;{ RMC_Add
  ProcedureDLL.l RMC_AddBarSeries(CtrlId.l,Region.l)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddBarSeries2(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddBarSeries3(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,Type.l)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,Type)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddBarSeries4(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,Type.l,Style.l)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,Type,Style)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddBarSeries5(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,Type.l,Style.l,IsLucent.l)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,Type,Style,IsLucent)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddBarSeries6(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,Type.l,Style.l,IsLucent.l,Color.l)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,Type,Style,IsLucent,Color)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddBarSeries7(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,Type.l,Style.l,IsLucent.l,Color.l,IsHorizontal.l)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,Type,Style,IsLucent,Color,IsHorizontal)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddBarSeries8(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,Type.l,Style.l,IsLucent.l,Color.l,IsHorizontal.l,WhichDataAxis.l)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,Type,Style,IsLucent,Color,IsHorizontal,WhichDataAxis)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddBarSeries9(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,Type.l,Style.l,IsLucent.l,Color.l,IsHorizontal.l,WhichDataAxis.l,ValueLabelOn.l)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,Type,Style,IsLucent,Color,IsHorizontal,WhichDataAxis,ValueLabelOn)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddBarSeries10(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,Type.l,Style.l,IsLucent.l,Color.l,IsHorizontal.l,WhichDataAxis.l,ValueLabelOn.l,PointsPerColumn.l)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,Type,Style,IsLucent,Color,IsHorizontal,WhichDataAxis,ValueLabelOn,PointsPerColumn)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddBarSeries11(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,Type.l,Style.l,IsLucent.l,Color.l,IsHorizontal.l,WhichDataAxis.l,ValueLabelOn.l,PointsPerColumn.l,HatchMode.l)
    If F_RMC_AddBarSeries
      ProcedureReturn F_RMC_AddBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,Type,Style,IsLucent,Color,IsHorizontal,WhichDataAxis,ValueLabelOn,PointsPerColumn,HatchMode)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddBarSeriesI(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*t.RMC_BARSERIES)
    If F_RMC_AddBarSeriesI
      ProcedureReturn F_RMC_AddBarSeriesI(CtrlId,Region,*FirstDataValue,DataValuesCount,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddCaption(CtrlId.l,Region.l)
    If F_RMC_AddCaption
      ProcedureReturn F_RMC_AddCaption(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddCaption2(CtrlId.l,Region.l,Caption.s)
    If F_RMC_AddCaption
      ProcedureReturn F_RMC_AddCaption(CtrlId,Region,Caption)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddCaption3(CtrlId.l,Region.l,Caption.s,TitelBackColor.l,TitelTextColor.l)
    If F_RMC_AddCaption
      ProcedureReturn F_RMC_AddCaption(CtrlId,Region,Caption,TitelBackColor,TitelTextColor)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddCaption4(CtrlId.l,Region.l,Caption.s,TitelBackColor.l,TitelTextColor.l,TitelFontSize.l)
    If F_RMC_AddCaption
      ProcedureReturn F_RMC_AddCaption(CtrlId,Region,Caption,TitelBackColor,TitelTextColor,TitelFontSize)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddCaption5(CtrlId.l,Region.l,Caption.s,TitelBackColor.l,TitelTextColor.l,TitelFontSize.l,TitelIsBold.l)
    If F_RMC_AddCaption
      ProcedureReturn F_RMC_AddCaption(CtrlId,Region,Caption,TitelBackColor,TitelTextColor,TitelFontSize,TitelIsBold)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddCaptionI(CtrlId.l,Region.l,*t.RMC_CAPTION)
    If F_RMC_AddCaptionI
      ProcedureReturn F_RMC_AddCaptionI(CtrlId,Region,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddDataAxis(CtrlId.l,Region.l)
    If F_RMC_AddDataAxis
      ProcedureReturn F_RMC_AddDataAxis(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddDataAxis2(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l)
    If F_RMC_AddDataAxis
      ProcedureReturn F_RMC_AddDataAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddDataAxis3(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l)
    If F_RMC_AddDataAxis
      ProcedureReturn F_RMC_AddDataAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddDataAxis4(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l)
    If F_RMC_AddDataAxis
      ProcedureReturn F_RMC_AddDataAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddDataAxis5(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l,DecimalDigits.l,Unit.s,Text.s)
    If F_RMC_AddDataAxis
      ProcedureReturn F_RMC_AddDataAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit,Text)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddDataAxis6(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l,DecimalDigits.l,Unit.s,Text.s,Labels.s)
    If F_RMC_AddDataAxis
      ProcedureReturn F_RMC_AddDataAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit,Text,Labels)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddDataAxis7(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l,DecimalDigits.l,Unit.s,Text.s,Labels.s,LabelAlignment.l)
    If F_RMC_AddDataAxis
      ProcedureReturn F_RMC_AddDataAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit,Text,Labels,LabelAlignment.l)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddDataAxisI(CtrlId.l,Region.l,*t.RMC_DATAAXIS)
    If F_RMC_AddDataAxisI
      ProcedureReturn F_RMC_AddDataAxisI(CtrlId,Region,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddGrid(CtrlId.l,Region.l)
    If F_RMC_AddGrid
      ProcedureReturn F_RMC_AddGrid(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGrid2(CtrlId.l,Region.l,BackColor.l)
    If F_RMC_AddGrid
      ProcedureReturn F_RMC_AddGrid(CtrlId,Region,BackColor)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGrid3(CtrlId.l,Region.l,BackColor.l,AsGradient.l)
    If F_RMC_AddGrid
      ProcedureReturn F_RMC_AddGrid(CtrlId,Region,BackColor,AsGradient)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGrid4(CtrlId.l,Region.l,BackColor.l,AsGradient.l,Left.l,Top.l,Width.l,Height.l)
    If F_RMC_AddGrid
      ProcedureReturn F_RMC_AddGrid(CtrlId,Region,BackColor,AsGradient,Left,Top,Width,Height)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGrid5(CtrlId.l,Region.l,BackColor.l,AsGradient.l,Left.l,Top.l,Width.l,Height.l,Bicolor.l)
    If F_RMC_AddGrid
      ProcedureReturn F_RMC_AddGrid(CtrlId,Region,BackColor,AsGradient,Left,Top,Width,Height,Bicolor)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddGridI(CtrlId.l,Region.l,*t.RMC_GRID)
    If F_RMC_AddGridI
      ProcedureReturn F_RMC_AddGridI(CtrlId,Region,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddGridlessSeries(CtrlId.l,Region.l)
    If F_RMC_AddGridlessSeries
      ProcedureReturn F_RMC_AddGridlessSeries(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGridlessSeries2(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l)
    If F_RMC_AddGridlessSeries
      ProcedureReturn F_RMC_AddGridlessSeries(CtrlId,Region,*FirstDataValue,DataValuesCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGridlessSeries3(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstColorValue,ColorValuesCount.l)
    If F_RMC_AddGridlessSeries
      ProcedureReturn F_RMC_AddGridlessSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstColorValue,ColorValuesCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGridlessSeries4(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstColorValue,ColorValuesCount.l,Style.l,Alignment.l)
    If F_RMC_AddGridlessSeries
      ProcedureReturn F_RMC_AddGridlessSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstColorValue,ColorValuesCount,Style,Alignment)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGridlessSeries5(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstColorValue,ColorValuesCount.l,Style.l,Alignment.l,Explodemode.l,IsLucent.l,ValueLabelOn.l,HatchMode.l)
    If F_RMC_AddGridlessSeries
      ProcedureReturn F_RMC_AddGridlessSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstColorValue,ColorValuesCount,Style,Alignment,Explodemode,IsLucent,ValueLabelOn,HatchMode)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGridlessSeries6(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstColorValue,ColorValuesCount.l,Style.l,Alignment.l,Explodemode.l,IsLucent.l,ValueLabelOn.l,HatchMode.l,StartAngle.l)
    If F_RMC_AddGridlessSeries
      ProcedureReturn F_RMC_AddGridlessSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstColorValue,ColorValuesCount,Style,Alignment,Explodemode,IsLucent,ValueLabelOn,HatchMode,StartAngle)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddGridlessSeriesI(CtrlId.l,Region.l)
    If F_RMC_AddGridlessSeriesI
      ProcedureReturn F_RMC_AddGridlessSeriesI(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGridlessSeriesI2(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l)
    If F_RMC_AddGridlessSeriesI
      ProcedureReturn F_RMC_AddGridlessSeriesI(CtrlId,Region,*FirstDataValue,DataValuesCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGridlessSeriesI3(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstColorValue,ColorValuesCount.l)
    If F_RMC_AddGridlessSeriesI
      ProcedureReturn F_RMC_AddGridlessSeriesI(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstColorValue,ColorValuesCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddGridlessSeriesI4(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstColorValue,ColorValuesCount.l,*t.RMC_GRIDLESSSERIES)
    If F_RMC_AddGridlessSeriesI
      ProcedureReturn F_RMC_AddGridlessSeriesI(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstColorValue,ColorValuesCount,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddHighLowSeries(CtrlId.l,Region.l)
    If F_RMC_AddHighLowSeries
      ProcedureReturn F_RMC_AddHighLowSeries(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddHighLowSeries2(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l)
    If F_RMC_AddHighLowSeries
      ProcedureReturn F_RMC_AddHighLowSeries(CtrlId,Region,*FirstDataValue,DataValuesCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddHighLowSeries3(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l)
    If F_RMC_AddHighLowSeries
      ProcedureReturn F_RMC_AddHighLowSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstPPCValue,PPCValuesCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddHighLowSeries4(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Style.l)
    If F_RMC_AddHighLowSeries
      ProcedureReturn F_RMC_AddHighLowSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstPPCValue,PPCValuesCount,Style)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddHighLowSeries5(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Style.l,WhichDataAxis.l)
    If F_RMC_AddHighLowSeries
      ProcedureReturn F_RMC_AddHighLowSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstPPCValue,PPCValuesCount,Style,WhichDataAxis)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddHighLowSeries6(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Style.l,WhichDataAxis.l,ColorLow.l,ColorHigh.l)
    If F_RMC_AddHighLowSeries
      ProcedureReturn F_RMC_AddHighLowSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstPPCValue,PPCValuesCount,Style,WhichDataAxis,ColorLow,ColorHigh)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddLabelAxis(CtrlId.l,Region.l)
    If F_RMC_AddLabelAxis
      ProcedureReturn F_RMC_AddLabelAxis(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLabelAxis2(CtrlId.l,Region.l,Labels.s)
    If F_RMC_AddLabelAxis
      ProcedureReturn F_RMC_AddLabelAxis(CtrlId,Region,Labels)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLabelAxis3(CtrlId.l,Region.l,Labels.s,AxisCount.l)
    If F_RMC_AddLabelAxis
      ProcedureReturn F_RMC_AddLabelAxis(CtrlId,Region,Labels,AxisCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLabelAxis4(CtrlId.l,Region.l,Labels.s,AxisCount.l,TickCount.l)
    If F_RMC_AddLabelAxis
      ProcedureReturn F_RMC_AddLabelAxis(CtrlId,Region,Labels,AxisCount,TickCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLabelAxis5(CtrlId.l,Region.l,Labels.s,AxisCount.l,TickCount.l,Alignment.l,FontSize.l,TextColor.l,TextAlignment.l)
    If F_RMC_AddLabelAxis
      ProcedureReturn F_RMC_AddLabelAxis(CtrlId,Region,Labels,AxisCount,TickCount,Alignment,FontSize,TextColor,TextAlignment)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLabelAxis6(CtrlId.l,Region.l,Labels.s,AxisCount.l,TickCount.l,Alignment.l,FontSize.l,TextColor.l,TextAlignment.l,LineColor.l,LineStyle.l,Text.s)
    If F_RMC_AddLabelAxis
      ProcedureReturn F_RMC_AddLabelAxis(CtrlId,Region,Labels,AxisCount,TickCount,Alignment,FontSize,TextColor,TextAlignment,LineColor,LineStyle,Text)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddLabelAxisI(CtrlId.l,Region.l,Labels.s,*t.RMC_LABELAXIS)
    If F_RMC_AddLabelAxisI
      ProcedureReturn F_RMC_AddLabelAxisI(CtrlId,Region,Labels,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddLegend(CtrlId.l,Region.l,Legendtext.s)
    If F_RMC_AddLegend
      ProcedureReturn F_RMC_AddLegend(CtrlId,Region,Legendtext)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLegend2(CtrlId.l,Region.l,sLegendtext.s,LegendAlign.l)
    If F_RMC_AddLegend
      ProcedureReturn F_RMC_AddLegend(CtrlId,Region,sLegendtext,LegendAlign)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLegend3(CtrlId.l,Region.l,sLegendtext.s,LegendAlign.l,LegendBackColor.l,LegendStyle.l,LegendTextColor.l)
    If F_RMC_AddLegend
      ProcedureReturn F_RMC_AddLegend(CtrlId,Region,sLegendtext,LegendAlign,LegendBackColor,LegendStyle,LegendTextColor)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLegend4(CtrlId.l,Region.l,sLegendtext.s,LegendAlign.l,LegendBackColor.l,LegendStyle.l,LegendTextColor.l,LegendFontSize.l,LegendIsBold.l)
    If F_RMC_AddLegend
      ProcedureReturn F_RMC_AddLegend(CtrlId,Region,sLegendtext,LegendAlign,LegendBackColor,LegendStyle,LegendTextColor,LegendFontSize,LegendIsBold)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddLegendI(CtrlId.l,Region.l,Legendtext.s,*t.RMC_LEGEND)
    If F_RMC_AddLegendI
      ProcedureReturn F_RMC_AddLegendI(CtrlId,Region,Legendtext,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddLineSeries(CtrlId.l,Region.l)
    If F_RMC_AddLineSeries
      ProcedureReturn F_RMC_AddLineSeries(CtrlId.l,Region.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLineSeries2(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l)
    If F_RMC_AddLineSeries
      ProcedureReturn F_RMC_AddLineSeries(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLineSeries3(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l)
    If F_RMC_AddLineSeries
      ProcedureReturn F_RMC_AddLineSeries(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLineSeries4(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Type.l,Style.l)
    If F_RMC_AddLineSeries
      ProcedureReturn F_RMC_AddLineSeries(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Type.l,Style.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLineSeries5(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Type.l,Style.l,LineStyle.l)
    If F_RMC_AddLineSeries
      ProcedureReturn F_RMC_AddLineSeries(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Type.l,Style.l,LineStyle.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLineSeries6(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Type.l,Style.l,LineStyle.l,IsLucent.l)
    If F_RMC_AddLineSeries
      ProcedureReturn F_RMC_AddLineSeries(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Type.l,Style.l,LineStyle.l,IsLucent.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLineSeries7(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Type.l,Style.l,LineStyle.l,IsLucent.l,Color.l)
    If F_RMC_AddLineSeries
      ProcedureReturn F_RMC_AddLineSeries(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Type.l,Style.l,LineStyle.l,IsLucent.l,Color.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddLineSeries8(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Type.l,Style.l,LineStyle.l,IsLucent.l,Color.l,ChartSymbol.l,WhichDataAxis.l,ValuelabelOn.l,HatchMode.l)
    If F_RMC_AddLineSeries
      ProcedureReturn F_RMC_AddLineSeries(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Type.l,Style.l,LineStyle.l,IsLucent.l,Color.l,ChartSymbol.l,WhichDataAxis.l,ValuelabelOn.l,HatchMode.l)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddLineSeriesI(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,*t.RMC_LINESERIES)
    If F_RMC_AddLineSeriesI
      ProcedureReturn F_RMC_AddLineSeriesI(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstPPCValue,PPCValuesCount,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddRegion(CtrlId.l)
    If F_RMC_AddRegion
      ProcedureReturn F_RMC_AddRegion(CtrlId)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddRegion2(CtrlId.l,Left.l,Top.l,Width.l,Height.l)
    If F_RMC_AddRegion
      ProcedureReturn F_RMC_AddRegion(CtrlId,Left,Top,Width,Height)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddRegion3(CtrlId.l,Left.l,Top.l,Width.l,Height.l,Footer.s)
    If F_RMC_AddRegion
      ProcedureReturn F_RMC_AddRegion(CtrlId,Left,Top,Width,Height,Footer)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddRegion4(CtrlId.l,Left.l,Top.l,Width.l,Height.l,Footer.s,ShowBorder.l)
    If F_RMC_AddRegion
      ProcedureReturn F_RMC_AddRegion(CtrlId,Left,Top,Width,Height,Footer,ShowBorder)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddRegionI(CtrlId.l,*t.RMC_REGION)
    If F_RMC_AddRegionI
      ProcedureReturn F_RMC_AddRegionI(CtrlId,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddToolTips(CtrlId.l,hWnd.l)
    If F_RMC_AddToolTips
      ProcedureReturn F_RMC_AddToolTips(CtrlId,hWnd)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddToolTips2(CtrlId.l,hWnd.l,ToolTipWidth.l)
    If F_RMC_AddToolTips
      ProcedureReturn F_RMC_AddToolTips(CtrlId,hWnd,ToolTipWidth)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddVolumeBarSeries(CtrlId.l,Region.l)
    If F_RMC_AddVolumeBarSeries
      ProcedureReturn F_RMC_AddVolumeBarSeries(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddVolumeBarSeries2(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l)
    If F_RMC_AddVolumeBarSeries
      ProcedureReturn F_RMC_AddVolumeBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddVolumeBarSeries3(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l)
    If F_RMC_AddVolumeBarSeries
      ProcedureReturn F_RMC_AddVolumeBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstPPCValue,PPCValuesCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddVolumeBarSeries4(CtrlId.l,Region.l,*FirstDataValue,DataValuesCount.l,*FirstPPCValue,PPCValuesCount.l,Color.l,WhichDataAxis.l)
    If F_RMC_AddVolumeBarSeries
      ProcedureReturn F_RMC_AddVolumeBarSeries(CtrlId,Region,*FirstDataValue,DataValuesCount,*FirstPPCValue,PPCValuesCount,Color,WhichDataAxis)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddXAxis(CtrlId.l,Region.l)
    If F_RMC_AddXAxis
      ProcedureReturn F_RMC_AddXAxis(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddXAxis2(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_AddXAxis
      ProcedureReturn F_RMC_AddXAxis(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddXAxis3(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l)
    If F_RMC_AddXAxis
      ProcedureReturn F_RMC_AddXAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddXAxis4(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l)
    If F_RMC_AddXAxis
      ProcedureReturn F_RMC_AddXAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddXAxis5(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l,DecimalDigits.l,Unit.s)
    If F_RMC_AddXAxis
      ProcedureReturn F_RMC_AddXAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddXAxis6(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l,DecimalDigits.l,Unit.s,Text.s,Labels.s)
    If F_RMC_AddXAxis
      ProcedureReturn F_RMC_AddXAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit,Text,Labels)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddXAxis7(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l,DecimalDigits.l,Unit.s,Text.s,Labels.s,LabelAlignment.l)
    If F_RMC_AddXAxis
      ProcedureReturn F_RMC_AddXAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit,Text,Labels,LabelAlignment)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddXAxisI(CtrlId.l,Region.l,*t.RMC_XYAXIS)
    If F_RMC_AddXAxisI
      ProcedureReturn F_RMC_AddXAxisI(CtrlId,Region,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddYAxis(CtrlId.l,Region.l)
    If F_RMC_AddYAxis
      ProcedureReturn F_RMC_AddYAxis(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddYAxis2(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_AddYAxis
      ProcedureReturn F_RMC_AddYAxis(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddYAxis3(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l)
    If F_RMC_AddYAxis
      ProcedureReturn F_RMC_AddYAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddYAxis4(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l)
    If F_RMC_AddYAxis
      ProcedureReturn F_RMC_AddYAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddYAxis5(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l,DecimalDigits.l,Unit.s)
    If F_RMC_AddYAxis
      ProcedureReturn F_RMC_AddYAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddYAxis6(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l,DecimalDigits.l,Unit.s,Text.s,Labels.s)
    If F_RMC_AddYAxis
      ProcedureReturn F_RMC_AddYAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit,Text,Labels)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddYAxis7(CtrlId.l,Region.l,Alignment.l,MinValue.d,MaxValue.d,TickCount.l,FontSize.l,TextColor.l,LineColor.l,LineStyle.l,DecimalDigits.l,Unit.s,Text.s,Labels.s,LabelAlignment.l)
    If F_RMC_AddYAxis
      ProcedureReturn F_RMC_AddYAxis(CtrlId,Region,Alignment,MinValue,MaxValue,TickCount,FontSize,TextColor,LineColor,LineStyle,DecimalDigits,Unit,Text,Labels,LabelAlignment)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddYAxisI(CtrlId.l,Region.l,*t.RMC_XYAXIS)
    If F_RMC_AddYAxisI
      ProcedureReturn F_RMC_AddYAxisI(CtrlId,Region,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddXYSeries(CtrlId.l,Region.l)
    If F_RMC_AddXYSeries
      ProcedureReturn F_RMC_AddXYSeries(CtrlId,Region)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddXYSeries2(CtrlId.l,Region.l,*FirstXDataValue,DataXValuesCount.l,*FirstYDataValue,DataYValuesCount.l,Color.l,Style.l,LineStyle.l)
    If F_RMC_AddXYSeries
      ProcedureReturn F_RMC_AddXYSeries(CtrlId,Region,*FirstXDataValue,DataXValuesCount,*FirstYDataValue,DataYValuesCount,Color,Style,LineStyle)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddXYSeries3(CtrlId.l,Region.l,*FirstXDataValue,DataXValuesCount.l,*FirstYDataValue,DataYValuesCount.l,Color.l,Style.l,LineStyle.l,Symbol.l,WhichXAxis.l,WhichYAxis.l)
    If F_RMC_AddXYSeries
      ProcedureReturn F_RMC_AddXYSeries(CtrlId,Region,*FirstXDataValue,DataXValuesCount,*FirstYDataValue,DataYValuesCount,Color,Style,LineStyle,Symbol,WhichXAxis,WhichYAxis)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_AddXYSeries4(CtrlId.l,Region.l,*FirstXDataValue,DataXValuesCount.l,*FirstYDataValue,DataYValuesCount.l,Color.l,Style.l,LineStyle.l,Symbol.l,WhichXAxis.l,WhichYAxis.l,ValueLabelOn.l)
    If F_RMC_AddXYSeries
      ProcedureReturn F_RMC_AddXYSeries(CtrlId,Region,*FirstXDataValue,DataXValuesCount,*FirstYDataValue,DataYValuesCount,Color,Style,LineStyle,Symbol,WhichXAxis,WhichYAxis,ValueLabelOn)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_AddXYSeriesI(CtrlId.l,Region.l,*FirstXDataValue,DataXValuesCount.l,*FirstYDataValue,nDataYValuesCount.l,*t.RMC_XYSERIES)
    If F_RMC_AddXYSeriesI
      ProcedureReturn F_RMC_AddXYSeriesI(CtrlId,Region,*FirstXDataValue,DataXValuesCount,*FirstYDataValue,nDataYValuesCount,*t)
    EndIf
  EndProcedure
  ;}
  ;{ RMC_Misc
  ProcedureDLL.l RMC_CalcAverage(CtrlId.l,Region.l,SeriesIndex.l,*Average,*XStart,*YStart,*XEnd,*YEnd)
    If F_RMC_CalcAverage
      ProcedureReturn F_RMC_CalcAverage(CtrlId,Region,SeriesIndex,*Average,*XStart,*YStart,*XEnd,*YEnd)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_CalcAverage2(CtrlId.l,Region.l,SeriesIndex.l,*Average,*XStart,*YStart,*XEnd,*YEnd,HighLowIndex.s)
    If F_RMC_CalcAverage
      ProcedureReturn F_RMC_CalcAverage(CtrlId,Region,SeriesIndex,*Average,*XStart,*YStart,*XEnd,*YEnd,HighLowIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_CalcTrend(CtrlId.l,Region.l,SeriesIndex.l,*FirstValue,*LastValue,*XStart,*YStart,*XEnd,*YEnd)
    If F_RMC_CalcTrend
      ProcedureReturn F_RMC_CalcTrend(CtrlId,Region,SeriesIndex,*FirstValue,*LastValue,*XStart,*YStart,*XEnd,*YEnd)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_CalcTrend2(CtrlId.l,Region.l,SeriesIndex.l,*FirstValue,*LastValue,*XStart,*YStart,*XEnd,*YEnd,HighLowIndex.s)
    If F_RMC_CalcTrend
      ProcedureReturn F_RMC_CalcTrend(CtrlId,Region,SeriesIndex,*FirstValue,*LastValue,*XStart,*YStart,*XEnd,*YEnd,HighLowIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_COBox(CtrlId.l,Index.l,Left.l,Top.l,Width.l,Height.l)
    If F_RMC_COBox
      ProcedureReturn F_RMC_COBox(CtrlId,Index.l,Left.l,Top.l,Width.l,Height.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_COBox2(CtrlId.l,Index.l,Left.l,Top.l,Width.l,Height.l,Style.l,BGColor.l,LineColor.l,Transparency.l)
    If F_RMC_COBox
      ProcedureReturn F_RMC_COBox(CtrlId,Index.l,Left.l,Top.l,Width.l,Height.l,Style.l,BGColor.l,LineColor.l,Transparency.l)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_COCircle(CtrlId.l,Index.l,XCenter.l,YCenter.l,Width.l)
    If F_RMC_COCircle
      ProcedureReturn F_RMC_COCircle(CtrlId,Index,XCenter,YCenter,Width)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_COCircle2(CtrlId.l,Index.l,XCenter.l,YCenter.l,Width.l,Style.l,BGColor.l,LineColor.l,Transparency.l)
    If F_RMC_COCircle
      ProcedureReturn F_RMC_COCircle(CtrlId,Index,XCenter,YCenter,Width,Style,BGColor,LineColor,Transparency)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_CODash(CtrlId.l,COIndex.l,XStart.l,YStart.l,XEnd.l,YEnd.l)
    If F_RMC_CODash
      ProcedureReturn F_RMC_CODash(CtrlId,COIndex,XStart,YStart,XEnd,YEnd)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_CODash2(CtrlId.l,COIndex.l,XStart.l,YStart.l,XEnd.l,YEnd.l,Style.l)
    If F_RMC_CODash
      ProcedureReturn F_RMC_CODash(CtrlId,COIndex,XStart,YStart,XEnd,YEnd,Style)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_CODash3(CtrlId.l,COIndex.l,XStart.l,YStart.l,XEnd.l,YEnd.l,Style.l,Color.l,AsSpline.l,LineWidth.l)
    If F_RMC_CODash
      ProcedureReturn F_RMC_CODash(CtrlId,COIndex,XStart,YStart,XEnd,YEnd,Style,Color,AsSpline,LineWidth)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_CODash4(CtrlId.l,COIndex.l,XStart.l,YStart.l,XEnd.l,YEnd.l,Style.l,Color.l,AsSpline.l,LineWidth.l,StartCap.l,EndCap.l)
    If F_RMC_CODash
      ProcedureReturn F_RMC_CODash(CtrlId,COIndex,XStart,YStart,XEnd,YEnd,Style,Color,AsSpline,LineWidth,StartCap,EndCap)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_CODelete(CtrlId.l,Index.l)
    If F_RMC_CODelete
      ProcedureReturn F_RMC_CODelete(CtrlId,Index)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_COGetTextWH(CtrlId.l,Index.l,WH.l)
    If F_RMC_COGetTextWH
      ProcedureReturn F_RMC_COGetTextWH(CtrlId,Index,WH)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_COImage(CtrlId.l,Index.l,ImagePath.s,Left.l,Top.l)
    If F_RMC_COImage
      ProcedureReturn F_RMC_COImage(CtrlId,Index,ImagePath,Left,Top)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_COImage2(CtrlId.l,Index.l,ImagePath.s,Left.l,Top.l,Width.l,Height.l)
    If F_RMC_COImage
      ProcedureReturn F_RMC_COImage(CtrlId,Index,ImagePath,Left,Top,Width,Height)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_COLine(CtrlId.l,Index.l,*XPoints,*YPoints,PointsCount.l)
    If F_RMC_COLine
      ProcedureReturn F_RMC_COLine(CtrlId,Index,*XPoints,*YPoints,PointsCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_COLine2(CtrlId.l,Index.l,*XPoints,*YPoints,PointsCount.l,Style.l,Color.l,AsSpline.l,LineWidth.l,StartCap.l,EndCap.l)
    If F_RMC_COLine
      ProcedureReturn F_RMC_COLine(CtrlId,Index,*XPoints,*YPoints,PointsCount,Style,Color,AsSpline,LineWidth,StartCap,EndCap)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_COPolygon(CtrlId.l,Index.l,*XPoints,*YPoints,PointsCount.l)
    If F_RMC_COPolygon
      ProcedureReturn F_RMC_COPolygon(CtrlId,Index,*XPoints,*YPoints,PointsCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_COPolygon2(CtrlId.l,Index.l,*XPoints,*YPoints,PointsCount.l,BGColor.l,LineColor.l,AsSpline.l,Transparency.l)
    If F_RMC_COPolygon
      ProcedureReturn F_RMC_COPolygon(CtrlId,Index,*XPoints,*YPoints,PointsCount,BGColor,LineColor,AsSpline,Transparency)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_COSymbol(CtrlId.l,Index.l,XCenter.l,YCenter.l,Style.l,Color.l)
    If F_RMC_COSymbol
      ProcedureReturn F_RMC_COSymbol(CtrlId,Index,XCenter.l,YCenter.l,Style.l,Color.l)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_COText(CtrlId.l,Index.l,Text.s,Left.l,Top.l)
    If F_RMC_COText
      ProcedureReturn F_RMC_COText(CtrlId,Index,Text,Left,Top)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_COText2(CtrlId.l,Index.l,Text.s,Left.l,Top.l,Width.l,Height.l)
    If F_RMC_COText
      ProcedureReturn F_RMC_COText(CtrlId,Index,Text,Left,Top,Width,Height)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_COText3(CtrlId.l,Index.l,Text.s,Left.l,Top.l,Width.l,Height.l,Style.l)
    If F_RMC_COText
      ProcedureReturn F_RMC_COText(CtrlId,Index,Text,Left,Top,Width,Height,Style)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_COText4(CtrlId.l,Index.l,Text.s,Left.l,Top.l,Width.l,Height.l,Style.l,BGColor.l,LineColor.l,Transparency.l,LineAlignment.l,TextColor.l,TextProperties.s)
    If F_RMC_COText
      ProcedureReturn F_RMC_COText(CtrlId,Index,Text,Left,Top,Width,Height,Style,BGColor,LineColor,Transparency,LineAlignment,TextColor,TextProperties)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_COVisible(CtrlId.l,Index.l,Hide.l)
    If F_RMC_COVisible
      ProcedureReturn F_RMC_COVisible(CtrlId,Index,Hide.l)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_DeleteChart(CtrlId.l)
    If F_RMC_DeleteChart
      ProcedureReturn F_RMC_DeleteChart(CtrlId)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_Magnifier(CtrlId.l,Enable.l)
    If F_RMC_Magnifier
      ProcedureReturn F_RMC_Magnifier(CtrlId,Enable.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_Magnifier2(CtrlId.l,Enable.l,Size.l,Color.l,LineColor.l,Transparency.l)
    If F_RMC_Magnifier
      ProcedureReturn F_RMC_Magnifier(CtrlId,Enable.l,Size,Color,LineColor,Transparency)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_Paint(CtrlId.l)
    If F_RMC_Paint
      ProcedureReturn F_RMC_Paint(CtrlId)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_ReadDataFromFile(*aData,FileName.s)
    If F_RMC_ReadDataFromFile
      ProcedureReturn F_RMC_ReadDataFromFile(*aData,FileName)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_ReadDataFromFile2(*aData,FileName.s,Lines.s,Fields.s,FieldDelimiter.s,Reverse.l)
    If F_RMC_ReadDataFromFile
      ProcedureReturn F_RMC_ReadDataFromFile(*aData,FileName,Lines,Fields,FieldDelimiter,Reverse)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_ReadStringFromFile(*sValue,FileName.s)
    If F_RMC_ReadStringFromFile
      ProcedureReturn F_RMC_ReadStringFromFile(*sValue,FileName)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_ReadStringFromFile2(*sValue,FileName.s,Lines.s,Fields.s,FieldDelimiter.s,Reverse.l)
    If F_RMC_ReadStringFromFile
      ProcedureReturn F_RMC_ReadStringFromFile(*sValue,FileName,Lines,Fields,FieldDelimiter,Reverse)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_Reset(CtrlId.l)
    If F_RMC_Reset
      ProcedureReturn F_RMC_Reset(CtrlId)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_RND(n1.l,n2.l)
    If F_RMC_RND
      ProcedureReturn F_RMC_RND(n1,n2)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SaveBMP(hBmp.l,FileName.s)
    If F_RMC_SaveBMP
      ProcedureReturn F_RMC_SaveBMP(hBmp,FileName)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_ShowToolTips(CtrlId.l,X.l,Y.l)
    If F_RMC_ShowToolTips
      ProcedureReturn F_RMC_ShowToolTips(CtrlId,X,Y)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_Split(sData.s,Array asData.s(1))
    Protected nc.l=1,temp.s=" "
    
    While temp<>""
      temp=StringField(sData,nc,"*")
      If temp<>""
        asData(nc-1)=temp
        nc+1
      EndIf
    Wend
    
    ProcedureReturn nc-1
  EndProcedure
  
  ProcedureDLL.l RMC_Split2Double(sData.s,*aData)
    Protected nc.l=1,temp.s=" "
    
    While temp<>""
      temp=Trim(StringField(sData,nc,"*"))
      If temp<>""
        PokeD(*aData+((nc-1)*8),ValD(temp))
        ;aData(nc-1)=ValD(temp)
        nc+1
      EndIf
    Wend
    
    ProcedureReturn nc-1
  EndProcedure
  
  ProcedureDLL.l RMC_Split2Long(sData.s,*aData)
    Protected nc.l=1,temp.s=" "
    
    While temp<>""
      temp=Trim(StringField(sData,nc,"*"))
      If temp<>""
        PokeL(*aData+((nc-1)*4),Val(temp))
        ;aData(nc-1)=Val(temp)
        nc+1
      EndIf
    Wend
    
    ProcedureReturn nc-1
  EndProcedure
  
  ProcedureDLL.l RMC_WriteRMCFile(CtrlId.l,FileName.s)
    If F_RMC_WriteRMCFile
      ProcedureReturn F_RMC_WriteRMCFile(CtrlId,FileName)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_Zoom(CtrlId.l,Mode.l)
    If F_RMC_Zoom
      ProcedureReturn F_RMC_Zoom(CtrlId,Mode.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_Zoom2(CtrlId.l,Mode.l,Color.l)
    If F_RMC_Zoom
      ProcedureReturn F_RMC_Zoom(CtrlId,Mode.l,Color.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_Zoom3(CtrlId.l,Mode.l,Color.l,LineColor.l)
    If F_RMC_Zoom
      ProcedureReturn F_RMC_Zoom(CtrlId,Mode.l,Color.l,LineColor.l)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_Zoom4(CtrlId.l,Mode.l,Color.l,LineColor.l,Transparency.l)
    If F_RMC_Zoom
      ProcedureReturn F_RMC_Zoom(CtrlId,Mode.l,Color.l,LineColor.l,Transparency.l)
    EndIf
  EndProcedure
  ;}
  ;{ RMC_Create
  ProcedureDLL.l RMC_CreateChart(ParentHndl.l,CtrlId.l,X.l,Y.l,Width.l,Height.l)
    If F_RMC_CreateChart
      ProcedureReturn F_RMC_CreateChart(ParentHndl,CtrlId,X,Y,Width,Height)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_CreateChart2(ParentHndl.l,CtrlId.l,X.l,Y.l,Width.l,Height.l,BackColor.l)
    If F_RMC_CreateChart
      ProcedureReturn F_RMC_CreateChart(ParentHndl,CtrlId,X,Y,Width,Height,BackColor)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_CreateChart3(ParentHndl.l,CtrlId.l,X.l,Y.l,Width.l,Height.l,BackColor.l,CtrlStyle.l,ExportOnly.l)
    If F_RMC_CreateChart
      ProcedureReturn F_RMC_CreateChart(ParentHndl,CtrlId,X,Y,Width,Height,BackColor,CtrlStyle,ExportOnly)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_CreateChart4(ParentHndl.l,CtrlId.l,X.l,Y.l,Width.l,Height.l,BackColor.l,CtrlStyle.l,ExportOnly.l,BgImage.s,FontName.s)
    If F_RMC_CreateChart
      ProcedureReturn F_RMC_CreateChart(ParentHndl,CtrlId,X,Y,Width,Height,BackColor,CtrlStyle,ExportOnly,BgImage,FontName)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_CreateChart5(ParentHndl.l,CtrlId.l,X.l,Y.l,Width.l,Height.l,BackColor.l,CtrlStyle.l,ExportOnly.l,BgImage.s,FontName.s,ToolTipWidth.l)
    If F_RMC_CreateChart
      ProcedureReturn F_RMC_CreateChart(ParentHndl,CtrlId,X,Y,Width,Height,BackColor,CtrlStyle,ExportOnly,BgImage,FontName,ToolTipWidth)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_CreateChart6(ParentHndl.l,CtrlId.l,X.l,Y.l,Width.l,Height.l,BackColor.l,CtrlStyle.l,ExportOnly.l,BgImage.s,FontName.s,ToolTipWidth.l,BitmapBKColor.l)
    If F_RMC_CreateChart
      ProcedureReturn F_RMC_CreateChart(ParentHndl,CtrlId,X,Y,Width,Height,BackColor,CtrlStyle,ExportOnly,BgImage,FontName,ToolTipWidth,BitmapBKColor)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_CreateChartI(ParentHndl.l,CtrlId.l,*t.RMC_CHART)
    If F_RMC_CreateChartI
      ProcedureReturn F_RMC_CreateChartI(ParentHndl,CtrlId,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_CreateChartFromFile(ParentHndl.l,CtrlId.l,X.l,Y.l,ExportOnly.l,RMCFile.s)
    If F_RMC_CreateChartFromFile
      ProcedureReturn F_RMC_CreateChartFromFile(ParentHndl,CtrlId,X,Y,ExportOnly,RMCFile)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_CreateChartFromFileOnDC(ParentDC.l,CtrlId.l,X.l,Y.l,ExportOnly.l,RMCFile.s)
    If F_RMC_CreateChartFromFileOnDC
      ProcedureReturn F_RMC_CreateChartFromFileOnDC(ParentDC,CtrlId,X,Y,ExportOnly,RMCFile)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_CreateChartOnDC(ParentDC.l,CtrlId.l,X.l,Y.l,Width.l,Height.l)
    If F_RMC_CreateChartOnDC
      ProcedureReturn F_RMC_CreateChartOnDC(ParentDC,CtrlId,X,Y,Width,Height)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_CreateChartOnDC2(ParentDC.l,CtrlId.l,X.l,Y.l,Width.l,Height.l,BackColor.l,CtrlStyle.l,ExportOnly.l,BgImage.s,FontName.s,BitmapBKColor.l)
    If F_RMC_CreateChartOnDC
      ProcedureReturn F_RMC_CreateChartOnDC(ParentDC,CtrlId,X,Y,Width,Height,BackColor,CtrlStyle,ExportOnly,BgImage,FontName,BitmapBKColor)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_CreateChartOnDCI(ParentDC.l,CtrlId.l,*t.RMC_CHART)
    If F_RMC_CreateChartOnDCI
      ProcedureReturn F_RMC_CreateChartOnDCI(ParentDC,CtrlId,*t)
    EndIf
  EndProcedure
  ;}
  ;{ RMC_Draw
  ProcedureDLL.l RMC_Draw(CtrlId.l)
    If F_RMC_Draw
      ProcedureReturn F_RMC_Draw(CtrlId)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_Draw2Clipboard(CtrlId.l,Type.l)
    If F_RMC_Draw2Clipboard
      ProcedureReturn F_RMC_Draw2Clipboard(CtrlId,Type)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_Draw2File(CtrlId.l,FileName.s)
    If F_RMC_Draw2File
      ProcedureReturn F_RMC_Draw2File(CtrlId,FileName)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_Draw2File2(CtrlId.l,FileName.s,Width.l,Height.l)
    If F_RMC_Draw2File
      ProcedureReturn F_RMC_Draw2File(CtrlId,FileName,Width,Height)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_Draw2File3(CtrlId.l,FileName.s,Width.l,Height.l,JPGQualityLevel.l)
    If F_RMC_Draw2File
      ProcedureReturn F_RMC_Draw2File(CtrlId,FileName,Width,Height,JPGQualityLevel.l)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_Draw2Printer(CtrlId.l)
    If F_RMC_Draw2Printer
      ProcedureReturn F_RMC_Draw2Printer(CtrlId)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_Draw2Printer2(CtrlId.l,PrinterDC.l)
    If F_RMC_Draw2Printer
      ProcedureReturn F_RMC_Draw2Printer(CtrlId,PrinterDC)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_Draw2Printer3(CtrlId.l,PrinterDC.l,Left.l,Top.l,Width.l,Height.l)
    If F_RMC_Draw2Printer
      ProcedureReturn F_RMC_Draw2Printer(CtrlId,PrinterDC,Left,Top,Width,Height)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_Draw2Printer4(CtrlId.l,PrinterDC.l,Left.l,Top.l,Width.l,Height.l,Type.l)
    If F_RMC_Draw2Printer
      ProcedureReturn F_RMC_Draw2Printer(CtrlId,PrinterDC,Left,Top,Width,Height,Type)
    EndIf
  EndProcedure
  ;}
  ;{ RMC_Get
  ProcedureDLL.l RMC_GetChartsizeFromFile(RMCFile.s,*Width,*Height)
    If F_RMC_GetChartsizeFromFile
      ProcedureReturn F_RMC_GetChartsizeFromFile(RMCFile,*Width,*Height)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetCtrlLeft(CtrlId.l)
    If F_RMC_GetCtrlLeft
      ProcedureReturn F_RMC_GetCtrlLeft(CtrlId)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetCtrlTop(CtrlId.l)
    If F_RMC_GetCtrlTop
      ProcedureReturn F_RMC_GetCtrlTop(CtrlId)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetCtrlWidth(CtrlId.l)
    If F_RMC_GetCtrlWidth
      ProcedureReturn F_RMC_GetCtrlWidth(CtrlId)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetCtrlHeight(CtrlId.l)
    If F_RMC_GetCtrlHeight
      ProcedureReturn F_RMC_GetCtrlHeight(CtrlId)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetINFO(CtrlId.l,*t.RMC_INFO,Region.l,Series.l,Index.l)
    If F_RMC_GetINFO
      ProcedureReturn F_RMC_GetINFO(CtrlId,*t,Region,Series,Index)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetINFOXY(CtrlId.l,*t.RMC_INFO,X.l,Y.l)
    If F_RMC_GetINFOXY
      ProcedureReturn F_RMC_GetINFOXY(CtrlId,*t,X,Y)
    EndIf
  EndProcedure
  
  ProcedureDLL.d RMC_GetVersion()
    If F_RMC_GetVersion
      ProcedureReturn F_RMC_GetVersion()
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetData(CtrlId.l,Region.l,SeriesIndex.l,DataIndex.l,*nData)
    If F_RMC_GetData
      ProcedureReturn F_RMC_GetData(CtrlId,Region,SeriesIndex,DataIndex,*nData)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_GetData2(CtrlId.l,Region.l,SeriesIndex.l,DataIndex.l,*nData,YData.l)
    If F_RMC_GetData
      ProcedureReturn F_RMC_GetData(CtrlId,Region,SeriesIndex,DataIndex,*nData,YData)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetDataCount(CtrlId.l,Region.l,SeriesIndex.l,*DataCount)
    If F_RMC_GetDataCount
      ProcedureReturn F_RMC_GetDataCount(CtrlId,Region,SeriesIndex,*DataCount)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetDataLocation(CtrlId.l,Region.l,SeriesIndex.l,nData.d,*XYPos)
    If F_RMC_GetDataLocation
      ProcedureReturn F_RMC_GetDataLocation(CtrlId,Region,SeriesIndex,nData,*XYPos)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetDataLocationXY(CtrlId.l,Region.l,SeriesIndex.l,DataX.d,DataY.d,*XPos,*YPos)
    If F_RMC_GetDataLocationXY
      ProcedureReturn F_RMC_GetDataLocationXY(CtrlId,Region,SeriesIndex,DataX,DataY,*XPos,*YPos)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetSeriesDataRange(CtrlId.l,Region.l,Series.l,*First,*Last)
    If F_RMC_GetSeriesDataRange
      ProcedureReturn F_RMC_GetSeriesDataRange(CtrlId,Region,Series,*First,*Last)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetGridLocation(CtrlId.l,Region.l,*Left,*Top,*Right,*Bottom)
    If F_RMC_GetGridLocation
      ProcedureReturn F_RMC_GetGridLocation(CtrlId,Region,*Left,*Top,*Right,*Bottom)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetImageSizeFromFile(ImagePath.s,*Width,*Height)
    If F_RMC_GetImageSizeFromFile
      ProcedureReturn F_RMC_GetImageSizeFromFile(ImagePath,*Width,*Height)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetLowPart(Param.d)
    If F_RMC_GetLowPart
      ProcedureReturn F_RMC_GetLowPart(Param)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_GetHighPart(Param.d)
    If F_RMC_GetHighPart
      ProcedureReturn F_RMC_GetHighPart(Param)
    EndIf
  EndProcedure
  ;}
  ;{ RMC_Set
  ProcedureDLL.l RMC_SetCaptionBGColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetCaptionBGColor
      ProcedureReturn F_RMC_SetCaptionBGColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetCaptionFontSize(CtrlId.l,Region.l,Fontbold.l)
    If F_RMC_SetCaptionFontSize
      ProcedureReturn F_RMC_SetCaptionFontSize(CtrlId,Region,Fontbold)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetCaptionFontBold(CtrlId.l,Region.l,FontSize.l)
    If F_RMC_SetCaptionFontBold
      ProcedureReturn F_RMC_SetCaptionFontBold(CtrlId,Region,FontSize)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetCaptionText(CtrlId.l,Region.l,Text.s)
    If F_RMC_SetCaptionText
      ProcedureReturn F_RMC_SetCaptionText(CtrlId,Region,Text)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetCaptionTextColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetCaptionTextColor
      ProcedureReturn F_RMC_SetCaptionTextColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetCtrlBGColor(CtrlId.l,Color.l)
    If F_RMC_SetCtrlBGColor
      ProcedureReturn F_RMC_SetCtrlBGColor(CtrlId,Color)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetCtrlBGImage(CtrlId.l,BgImage.s)
    If F_RMC_SetCtrlBGImage
      ProcedureReturn F_RMC_SetCtrlBGImage(CtrlId,BgImage)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetCtrlFont(CtrlId.l,FontName.s)
    If F_RMC_SetCtrlFont
      ProcedureReturn F_RMC_SetCtrlFont(CtrlId,FontName)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetCtrlPos(CtrlId.l,Left.l,Top.l)
    If F_RMC_SetCtrlPos
      ProcedureReturn F_RMC_SetCtrlPos(CtrlId,Left,Top)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetCtrlPos2(CtrlId.l,Left.l,Top.l,Relative.l)
    If F_RMC_SetCtrlPos
      ProcedureReturn F_RMC_SetCtrlPos(CtrlId,Left,Top,Relative)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetCtrlSize(CtrlId.l,Width.l,Height.l)
    If F_RMC_SetCtrlSize
      ProcedureReturn F_RMC_SetCtrlSize(CtrlId,Width,Height)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetCtrlSize2(CtrlId.l,Width.l,Height.l,Relative.l,RecalcMode)
    If F_RMC_SetCtrlSize
      ProcedureReturn F_RMC_SetCtrlSize(CtrlId,Width,Height,Relative,RecalcMode)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetCtrlStyle(CtrlId.l,Style.l)
    If F_RMC_SetCtrlStyle
      ProcedureReturn F_RMC_SetCtrlStyle(CtrlId,Style)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXAlignment(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_SetDAXAlignment
      ProcedureReturn F_RMC_SetDAXAlignment(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXDecimalDigits(CtrlId.l,Region.l,DecimalDigits.l)
    If F_RMC_SetDAXDecimalDigits
      ProcedureReturn F_RMC_SetDAXDecimalDigits(CtrlId,Region,DecimalDigits)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetDAXDecimalDigits2(CtrlId.l,Region.l,DecimalDigits.l,AxisIndex.l)
    If F_RMC_SetDAXDecimalDigits
      ProcedureReturn F_RMC_SetDAXDecimalDigits(CtrlId,Region,DecimalDigits,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXFontSize(CtrlId.l,Region.l,FontSize.l)
    If F_RMC_SetDAXFontSize
      ProcedureReturn F_RMC_SetDAXFontSize(CtrlId,Region,FontSize)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXLineColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetDAXLineColor
      ProcedureReturn F_RMC_SetDAXLineColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXLabelAlignment(CtrlId.l,Region.l,LabelAlignment.l)
    If F_RMC_SetDAXLabelAlignment
      ProcedureReturn F_RMC_SetDAXLabelAlignment(CtrlId,Region,LabelAlignment)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetDAXLabelAlignment2(CtrlId.l,Region.l,LabelAlignment.l,AxisIndex.l)
    If F_RMC_SetDAXLabelAlignment
      ProcedureReturn F_RMC_SetDAXLabelAlignment(CtrlId,Region,LabelAlignment,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXLabels(CtrlId.l,Region.l,Labels.s)
    If F_RMC_SetDAXLabels
      ProcedureReturn F_RMC_SetDAXLabels(CtrlId,Region,Labels)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetDAXLabels2(CtrlId.l,Region.l,Labels.s,AxisIndex.l)
    If F_RMC_SetDAXLabels
      ProcedureReturn F_RMC_SetDAXLabels(CtrlId,Region,Labels,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXLineStyle(CtrlId.l,Region.l,Style.l)
    If F_RMC_SetDAXLineStyle
      ProcedureReturn F_RMC_SetDAXLineStyle(CtrlId,Region,Style)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXMaxValue(CtrlId.l,Region.l,MaxValue.d)
    If F_RMC_SetDAXMaxValue
      ProcedureReturn F_RMC_SetDAXMaxValue(CtrlId,Region,MaxValue)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetDAXMaxValue2(CtrlId.l,Region.l,MaxValue.d,AxisIndex.l)
    If F_RMC_SetDAXMaxValue
      ProcedureReturn F_RMC_SetDAXMaxValue(CtrlId,Region,MaxValue,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXMinValue(CtrlId.l,Region.l,MinValue.d)
    If F_RMC_SetDAXMinValue
      ProcedureReturn F_RMC_SetDAXMinValue(CtrlId,Region,MinValue)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetDAXMinValue2(CtrlId.l,Region.l,MinValue.d,AxisIndex.l)
    If F_RMC_SetDAXMinValue
      ProcedureReturn F_RMC_SetDAXMinValue(CtrlId,Region,MinValue,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXText(CtrlId.l,Region.l,Text.s)
    If F_RMC_SetDAXText
      ProcedureReturn F_RMC_SetDAXText(CtrlId,Region,Text)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetDAXText2(CtrlId.l,Region.l,Text.s,AxisIndex.l)
    If F_RMC_SetDAXText
      ProcedureReturn F_RMC_SetDAXText(CtrlId,Region,Text,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXTextColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetDAXTextColor
      ProcedureReturn F_RMC_SetDAXTextColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXTickcount(CtrlId.l,Region.l,TickCount.l)
    If F_RMC_SetDAXTickcount
      ProcedureReturn F_RMC_SetDAXTickcount(CtrlId,Region,TickCount)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetDAXUnit(CtrlId.l,Region.l,Unit.s)
    If F_RMC_SetDAXUnit
      ProcedureReturn F_RMC_SetDAXUnit(CtrlId,Region,Unit)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetDAXUnit2(CtrlId.l,Region.l,Unit.s,AxisIndex.l)
    If F_RMC_SetDAXUnit
      ProcedureReturn F_RMC_SetDAXUnit(CtrlId,Region,Unit,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetGridBGColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetGridBGColor
      ProcedureReturn F_RMC_SetGridBGColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetGridGradient(CtrlId.l,Region.l,HasGradient.l)
    If F_RMC_SetGridGradient
      ProcedureReturn F_RMC_SetGridGradient(CtrlId,Region,HasGradient)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetGridMargin(CtrlId.l,Region.l,Left.l,Top.l,Width.l,Height.l)
    If F_RMC_SetGridMargin
      ProcedureReturn F_RMC_SetGridMargin(CtrlId,Region,Left,Top,Width,Height)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXAlignment(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_SetLAXAlignment
      ProcedureReturn F_RMC_SetLAXAlignment(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXCount(CtrlId.l,Region.l,LabelAxisCount.l)
    If F_RMC_SetLAXCount
      ProcedureReturn F_RMC_SetLAXCount(CtrlId,Region,LabelAxisCount)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXFontSize(CtrlId.l,Region.l,FontSize.l)
    If F_RMC_SetLAXFontSize
      ProcedureReturn F_RMC_SetLAXFontSize(CtrlId,Region,FontSize)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXLabelAlignment(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_SetLAXLabelAlignment
      ProcedureReturn F_RMC_SetLAXLabelAlignment(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXLabels(CtrlId.l,Region.l,Labels.s)
    If F_RMC_SetLAXLabels
      ProcedureReturn F_RMC_SetLAXLabels(CtrlId,Region,Labels)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXLineColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetLAXLineColor
      ProcedureReturn F_RMC_SetLAXLineColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXLineStyle(CtrlId.l,Region.l,Style.l)
    If F_RMC_SetLAXLineStyle
      ProcedureReturn F_RMC_SetLAXLineStyle(CtrlId,Region,Style)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXText(CtrlId.l,Region.l,Text.s)
    If F_RMC_SetLAXText
      ProcedureReturn F_RMC_SetLAXText(CtrlId,Region,Text)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXTextColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetLAXTextColor
      ProcedureReturn F_RMC_SetLAXTextColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXTickCount(CtrlId.l,Region.l,TickCount.l)
    If F_RMC_SetLAXTickCount
      ProcedureReturn F_RMC_SetLAXTickCount(CtrlId,Region,TickCount)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLegendAlignment(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_SetLegendAlignment
      ProcedureReturn F_RMC_SetLegendAlignment(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLegendBGColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetLegendBGColor
      ProcedureReturn F_RMC_SetLegendBGColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLegendFontBold(CtrlId.l,Region.l,Fontbold.l)
    If F_RMC_SetLegendFontBold
      ProcedureReturn F_RMC_SetLegendFontBold(CtrlId,Region,Fontbold)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLegendFontSize(CtrlId.l,Region.l,FontSize.l)
    If F_RMC_SetLegendFontSize
      ProcedureReturn F_RMC_SetLegendFontSize(CtrlId,Region,FontSize)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLegendStyle(CtrlId.l,Region.l,Style.l)
    If F_RMC_SetLegendStyle
      ProcedureReturn F_RMC_SetLegendStyle(CtrlId,Region,Style)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLegendText(CtrlId.l,Region.l,Text.s)
    If F_RMC_SetLegendText
      ProcedureReturn F_RMC_SetLegendText(CtrlId,Region,Text)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLegendTextColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetLegendTextColor
      ProcedureReturn F_RMC_SetLegendTextColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetMouseClick(CtrlId.l,Button.l,X.l,Y.l,*t.RMC_INFO)
    If F_RMC_SetMouseClick
      ProcedureReturn F_RMC_SetMouseClick(CtrlId,Button,X,Y,*t)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetRegionBorder(CtrlId.l,Region.l,ShowBorder.l)
    If F_RMC_SetRegionBorder
      ProcedureReturn F_RMC_SetRegionBorder(CtrlId,Region,ShowBorder)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetRegionFooter(CtrlId.l,Region.l,Footer.s)
    If F_RMC_SetRegionFooter
      ProcedureReturn F_RMC_SetRegionFooter(CtrlId,Region,Footer)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetRegionMargin(CtrlId.l,Region.l,Left.l,Top.l,Width.l,Height.l)
    If F_RMC_SetRegionMargin
      ProcedureReturn F_RMC_SetRegionMargin(CtrlId,Region,Left,Top,Width,Height)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetRMCFile(CtrlId.l,RMCFile.s)
    If F_RMC_SetRMCFile
      ProcedureReturn F_RMC_SetRMCFile(CtrlId,RMCFile)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesColor(CtrlId.l,Region.l,Series.l,Color.l)
    If F_RMC_SetSeriesColor
      ProcedureReturn F_RMC_SetSeriesColor(CtrlId,Region,Series,Color)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetSeriesColor2(CtrlId.l,Region.l,Series.l,Color.l,Index.l)
    If F_RMC_SetSeriesColor
      ProcedureReturn F_RMC_SetSeriesColor(CtrlId,Region,Series,Color,Index)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesData(CtrlId.l,Region.l,Series.l,*nData,DataCount.l)
    If F_RMC_SetSeriesData
      ProcedureReturn F_RMC_SetSeriesData(CtrlId,Region,Series,*nData,DataCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetSeriesData2(CtrlId.l,Region.l,Series.l,*nData,DataCount.l,YData.l)
    If F_RMC_SetSeriesData
      ProcedureReturn F_RMC_SetSeriesData(CtrlId,Region,Series,*nData,DataCount,YData)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesDataAxis(CtrlId.l,Region.l,Series.l,WhichAxis.l)
    If F_RMC_SetSeriesDataAxis
      ProcedureReturn F_RMC_SetSeriesDataAxis(CtrlId,Region,Series,WhichAxis)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesDataFile(CtrlId.l,Region.l,Series.l,FileName.s)
    If F_RMC_SetSeriesDataFile
      ProcedureReturn F_RMC_SetSeriesDataFile(CtrlId,Region,Series,FileName)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetSeriesDataFile2(CtrlId.l,Region.l,Series.l,FileName.s,Lines.s)
    If F_RMC_SetSeriesDataFile
      ProcedureReturn F_RMC_SetSeriesDataFile(CtrlId,Region,Series,FileName,Lines)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetSeriesDataFile3(CtrlId.l,Region.l,Series.l,FileName.s,Lines.s,Fields.s)
    If F_RMC_SetSeriesDataFile
      ProcedureReturn F_RMC_SetSeriesDataFile(CtrlId,Region,Series,FileName,Lines,Fields)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetSeriesDataFile4(CtrlId.l,Region.l,Series.l,FileName.s,Lines.s,Fields.s,FieldDelimiter.s)
    If F_RMC_SetSeriesDataFile
      ProcedureReturn F_RMC_SetSeriesDataFile(CtrlId,Region,Series,FileName,Lines,Fields,FieldDelimiter)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetSeriesDataFile5(CtrlId.l,Region.l,Series.l,FileName.s,Lines.s,Fields.s,FieldDelimiter.s,YData.l)
    If F_RMC_SetSeriesDataFile
      ProcedureReturn F_RMC_SetSeriesDataFile(CtrlId,Region,Series,FileName,Lines,Fields,FieldDelimiter,YData)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesExplodeMode(CtrlId.l,Region.l,Series.l,Explodemode.l)
    If F_RMC_SetSeriesExplodeMode
      ProcedureReturn F_RMC_SetSeriesExplodeMode(CtrlId,Region,Series,Explodemode)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesHatchMode(CtrlId.l,Region.l,Series.l,HatchMode.l)
    If F_RMC_SetSeriesHatchMode
      ProcedureReturn F_RMC_SetSeriesHatchMode(CtrlId,Region,Series,HatchMode)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesHide(CtrlId.l,Region.l,Series.l,Hide.l)
    If F_RMC_SetSeriesHide
      ProcedureReturn F_RMC_SetSeriesHide(CtrlId,Region,Series,Hide)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesLinestyle(CtrlId.l,Region.l,Series.l,LineStyle.l)
    If F_RMC_SetSeriesLinestyle
      ProcedureReturn F_RMC_SetSeriesLinestyle(CtrlId,Region,Series,LineStyle)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesLucent(CtrlId.l,Region.l,Series.l,Lucent.l)
    If F_RMC_SetSeriesLucent
      ProcedureReturn F_RMC_SetSeriesLucent(CtrlId,Region,Series,Lucent)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesSingleData(CtrlId.l,Region.l,Series.l,nData.d,DataIndex.l)
    If F_RMC_SetSeriesSingleData
      ProcedureReturn F_RMC_SetSeriesSingleData(CtrlId,Region,Series,nData,DataIndex)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetSeriesSingleData2(CtrlId.l,Region.l,Series.l,nData.d,DataIndex.l,YData.l)
    If F_RMC_SetSeriesSingleData
      ProcedureReturn F_RMC_SetSeriesSingleData(CtrlId,Region,Series,nData,DataIndex,YData)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesStartAngle(CtrlId.l,Region.l,Series.l,StartAngle.l)
    If F_RMC_SetSeriesStartAngle
      ProcedureReturn F_RMC_SetSeriesStartAngle(CtrlId,Region,Series,StartAngle)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesStyle(CtrlId.l,Region.l,Series.l,Style.l)
    If F_RMC_SetSeriesStyle
      ProcedureReturn F_RMC_SetSeriesStyle(CtrlId,Region,Series,Style)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesSymbol(CtrlId.l,Region.l,Series.l,Symbol.l)
    If F_RMC_SetSeriesSymbol
      ProcedureReturn F_RMC_SetSeriesSymbol(CtrlId,Region,Series,Symbol)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesValuelabel(CtrlId.l,Region.l,Series.l,Valuelabel.l)
    If F_RMC_SetSeriesValuelabel
      ProcedureReturn F_RMC_SetSeriesValuelabel(CtrlId,Region,Series,Valuelabel)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesVertical(CtrlId.l,Region.l,Series.l,Vertical.l)
    If F_RMC_SetSeriesVertical
      ProcedureReturn F_RMC_SetSeriesVertical(CtrlId,Region,Series,Vertical)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesXAxis(CtrlId.l,Region.l,Series.l,WhichXAxis.l)
    If F_RMC_SetSeriesXAxis
      ProcedureReturn F_RMC_SetSeriesXAxis(CtrlId,Region,Series,WhichXAxis)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesYAxis(CtrlId.l,Region.l,Series.l,WhichYAxis.l)
    If F_RMC_SetSeriesYAxis
      ProcedureReturn F_RMC_SetSeriesYAxis(CtrlId,Region,Series,WhichYAxis)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSingleBarColors(CtrlId.l,Region.l,*FirstColorElement,ColorElementsCount.l)
    If F_RMC_SetSingleBarColors
      ProcedureReturn F_RMC_SetSingleBarColors(CtrlId,Region,*FirstColorElement,ColorElementsCount)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetWatermark(Watermark.s)
    If F_RMC_SetWatermark
      ProcedureReturn F_RMC_SetWatermark(Watermark)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetWatermark2(Watermark.s,WMColor.l)
    If F_RMC_SetWatermark
      ProcedureReturn F_RMC_SetWatermark(Watermark,WMColor)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetWatermark3(Watermark.s,WMColor.l,WMLucentValue.l)
    If F_RMC_SetWatermark
      ProcedureReturn F_RMC_SetWatermark(Watermark,WMColor,WMLucentValue)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetWatermark4(Watermark.s,WMColor.l,WMLucentValue.l,Alignment.l)
    If F_RMC_SetWatermark
      ProcedureReturn F_RMC_SetWatermark(Watermark,WMColor,WMLucentValue,Alignment)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetWatermark5(Watermark.s,WMColor.l,WMLucentValue.l,Alignment.l,FontSize.l)
    If F_RMC_SetWatermark
      ProcedureReturn F_RMC_SetWatermark(Watermark,WMColor,WMLucentValue,Alignment,FontSize)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXAlignment(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_SetXAXAlignment
      ProcedureReturn F_RMC_SetXAXAlignment(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXAlignment2(CtrlId.l,Region.l,Alignment.l,AxisIndex.l)
    If F_RMC_SetXAXAlignment
      ProcedureReturn F_RMC_SetXAXAlignment(CtrlId,Region,Alignment,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXDecimalDigits(CtrlId.l,Region.l,DecimalDigits.l)
    If F_RMC_SetXAXDecimalDigits
      ProcedureReturn F_RMC_SetXAXDecimalDigits(CtrlId,Region,DecimalDigits)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXDecimalDigits2(CtrlId.l,Region.l,DecimalDigits.l,AxisIndex.l)
    If F_RMC_SetXAXDecimalDigits
      ProcedureReturn F_RMC_SetXAXDecimalDigits(CtrlId,Region,DecimalDigits,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXFontSize(CtrlId.l,Region.l,FontSize.l)
    If F_RMC_SetXAXFontSize
      ProcedureReturn F_RMC_SetXAXFontSize(CtrlId,Region,FontSize)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXFontSize2(CtrlId.l,Region.l,FontSize.l,AxisIndex.l)
    If F_RMC_SetXAXFontSize
      ProcedureReturn F_RMC_SetXAXFontSize(CtrlId,Region,FontSize,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXLabels(CtrlId.l,Region.l,Labels.s)
    If F_RMC_SetXAXLabels
      ProcedureReturn F_RMC_SetXAXLabels(CtrlId,Region,Labels)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXLabels2(CtrlId.l,Region.l,Labels.s,AxisIndex.l)
    If F_RMC_SetXAXLabels
      ProcedureReturn F_RMC_SetXAXLabels(CtrlId,Region,Labels,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXLabelAlignment(CtrlId.l,Region.l,LabelAlignment.l)
    If F_RMC_SetXAXLabelAlignment
      ProcedureReturn F_RMC_SetXAXLabelAlignment(CtrlId,Region,LabelAlignment)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXLabelAlignment2(CtrlId.l,Region.l,LabelAlignment.l,AxisIndex.l)
    If F_RMC_SetXAXLabelAlignment
      ProcedureReturn F_RMC_SetXAXLabelAlignment(CtrlId,Region,LabelAlignment,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXLineColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetXAXLineColor
      ProcedureReturn F_RMC_SetXAXLineColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXLineColor2(CtrlId.l,Region.l,Color.l,AxisIndex.l)
    If F_RMC_SetXAXLineColor
      ProcedureReturn F_RMC_SetXAXLineColor(CtrlId,Region,Color,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXLineStyle(CtrlId.l,Region.l,Style.l)
    If F_RMC_SetXAXLineStyle
      ProcedureReturn F_RMC_SetXAXLineStyle(CtrlId,Region,Style)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXLineStyle2(CtrlId.l,Region.l,Style.l,AxisIndex.l)
    If F_RMC_SetXAXLineStyle
      ProcedureReturn F_RMC_SetXAXLineStyle(CtrlId,Region,Style,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXMaxValue(CtrlId.l,Region.l,MaxValue.d)
    If F_RMC_SetXAXMaxValue
      ProcedureReturn F_RMC_SetXAXMaxValue(CtrlId,Region,MaxValue)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXMaxValue2(CtrlId.l,Region.l,MaxValue.d,AxisIndex.l)
    If F_RMC_SetXAXMaxValue
      ProcedureReturn F_RMC_SetXAXMaxValue(CtrlId,Region,MaxValue,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXMinValue(CtrlId.l,Region.l,MinValue.d)
    If F_RMC_SetXAXMinValue
      ProcedureReturn F_RMC_SetXAXMinValue(CtrlId,Region,MinValue)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXMinValue2(CtrlId.l,Region.l,MinValue.d,AxisIndex.l)
    If F_RMC_SetXAXMinValue
      ProcedureReturn F_RMC_SetXAXMinValue(CtrlId,Region,MinValue,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXText(CtrlId.l,Region.l,Text.s)
    If F_RMC_SetXAXText
      ProcedureReturn F_RMC_SetXAXText(CtrlId,Region,Text)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXText2(CtrlId.l,Region.l,Text.s,AxisIndex.l)
    If F_RMC_SetXAXText
      ProcedureReturn F_RMC_SetXAXText(CtrlId,Region,Text,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXTextColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetXAXTextColor
      ProcedureReturn F_RMC_SetXAXTextColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXTextColor2(CtrlId.l,Region.l,Color.l,AxisIndex.l)
    If F_RMC_SetXAXTextColor
      ProcedureReturn F_RMC_SetXAXTextColor(CtrlId,Region,Color,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXTickcount(CtrlId.l,Region.l,TickCount.l)
    If F_RMC_SetXAXTickcount
      ProcedureReturn F_RMC_SetXAXTickcount(CtrlId,Region,TickCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXTickcount2(CtrlId.l,Region.l,TickCount.l,AxisIndex.l)
    If F_RMC_SetXAXTickcount
      ProcedureReturn F_RMC_SetXAXTickcount(CtrlId,Region,TickCount,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetXAXUnit(CtrlId.l,Region.l,Unit.s)
    If F_RMC_SetXAXUnit
      ProcedureReturn F_RMC_SetXAXUnit(CtrlId,Region,Unit)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetXAXUnit2(CtrlId.l,Region.l,Unit.s,AxisIndex.l)
    If F_RMC_SetXAXUnit
      ProcedureReturn F_RMC_SetXAXUnit(CtrlId,Region,Unit,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXAlignment(CtrlId.l,Region.l,Alignment.l)
    If F_RMC_SetYAXAlignment
      ProcedureReturn F_RMC_SetYAXAlignment(CtrlId,Region,Alignment)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXAlignment2(CtrlId.l,Region.l,Alignment.l,AxisIndex.l)
    If F_RMC_SetYAXAlignment
      ProcedureReturn F_RMC_SetYAXAlignment(CtrlId,Region,Alignment,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXDecimalDigits(CtrlId.l,Region.l,DecimalDigits.l)
    If F_RMC_SetYAXDecimalDigits
      ProcedureReturn F_RMC_SetYAXDecimalDigits(CtrlId,Region,DecimalDigits)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXDecimalDigits2(CtrlId.l,Region.l,DecimalDigits.l,AxisIndex.l)
    If F_RMC_SetYAXDecimalDigits
      ProcedureReturn F_RMC_SetYAXDecimalDigits(CtrlId,Region,DecimalDigits,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXFontSize(CtrlId.l,Region.l,FontSize.l)
    If F_RMC_SetYAXFontSize
      ProcedureReturn F_RMC_SetYAXFontSize(CtrlId,Region,FontSize)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXFontSize2(CtrlId.l,Region.l,FontSize.l,AxisIndex.l)
    If F_RMC_SetYAXFontSize
      ProcedureReturn F_RMC_SetYAXFontSize(CtrlId,Region,FontSize,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXLabels(CtrlId.l,Region.l,Labels.s)
    If F_RMC_SetYAXLabels
      ProcedureReturn F_RMC_SetYAXLabels(CtrlId,Region,Labels)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXLabels2(CtrlId.l,Region.l,Labels.s,AxisIndex.l)
    If F_RMC_SetYAXLabels
      ProcedureReturn F_RMC_SetYAXLabels(CtrlId,Region,Labels,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXLabelAlignment(CtrlId.l,Region.l,LabelAlignment.l)
    If F_RMC_SetYAXLabelAlignment
      ProcedureReturn F_RMC_SetYAXLabelAlignment(CtrlId,Region,LabelAlignment)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXLabelAlignment2(CtrlId.l,Region.l,LabelAlignment.l,AxisIndex.l)
    If F_RMC_SetYAXLabelAlignment
      ProcedureReturn F_RMC_SetYAXLabelAlignment(CtrlId,Region,LabelAlignment,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXLineColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetYAXLineColor
      ProcedureReturn F_RMC_SetYAXLineColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXLineColor2(CtrlId.l,Region.l,Color.l,AxisIndex.l)
    If F_RMC_SetYAXLineColor
      ProcedureReturn F_RMC_SetYAXLineColor(CtrlId,Region,Color,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXLineStyle(CtrlId.l,Region.l,Style.l)
    If F_RMC_SetYAXLineStyle
      ProcedureReturn F_RMC_SetYAXLineStyle(CtrlId,Region,Style)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXLineStyle2(CtrlId.l,Region.l,Style.l,AxisIndex.l)
    If F_RMC_SetYAXLineStyle
      ProcedureReturn F_RMC_SetYAXLineStyle(CtrlId,Region,Style,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXMaxValue(CtrlId.l,Region.l,MaxValue.d)
    If F_RMC_SetYAXMaxValue
      ProcedureReturn F_RMC_SetYAXMaxValue(CtrlId,Region,MaxValue)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXMaxValue2(CtrlId.l,Region.l,MaxValue.d,AxisIndex.l)
    If F_RMC_SetYAXMaxValue
      ProcedureReturn F_RMC_SetYAXMaxValue(CtrlId,Region,MaxValue,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXMinValue(CtrlId.l,Region.l,MinValue.d)
    If F_RMC_SetYAXMinValue
      ProcedureReturn F_RMC_SetYAXMinValue(CtrlId,Region,MinValue)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXMinValue2(CtrlId.l,Region.l,MinValue.d,AxisIndex.l)
    If F_RMC_SetYAXMinValue
      ProcedureReturn F_RMC_SetYAXMinValue(CtrlId,Region,MinValue,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXText(CtrlId.l,Region.l,Text.s)
    If F_RMC_SetYAXText
      ProcedureReturn F_RMC_SetYAXText(CtrlId,Region,Text)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXText2(CtrlId.l,Region.l,Text.s,AxisIndex.l)
    If F_RMC_SetYAXText
      ProcedureReturn F_RMC_SetYAXText(CtrlId,Region,Text,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXTextColor(CtrlId.l,Region.l,Color.l)
    If F_RMC_SetYAXTextColor
      ProcedureReturn F_RMC_SetYAXTextColor(CtrlId,Region,Color)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXTextColor2(CtrlId.l,Region.l,Color.l,AxisIndex.l)
    If F_RMC_SetYAXTextColor
      ProcedureReturn F_RMC_SetYAXTextColor(CtrlId,Region,Color,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXTickcount(CtrlId.l,Region.l,TickCount.l)
    If F_RMC_SetYAXTickcount
      ProcedureReturn F_RMC_SetYAXTickcount(CtrlId,Region,TickCount)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXTickcount2(CtrlId.l,Region.l,TickCount.l,AxisIndex.l)
    If F_RMC_SetYAXTickcount
      ProcedureReturn F_RMC_SetYAXTickcount(CtrlId,Region,TickCount,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetYAXUnit(CtrlId.l,Region.l,Unit.s)
    If F_RMC_SetYAXUnit
      ProcedureReturn F_RMC_SetYAXUnit(CtrlId,Region,Unit)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetYAXUnit2(CtrlId.l,Region.l,Unit.s,AxisIndex.l)
    If F_RMC_SetYAXUnit
      ProcedureReturn F_RMC_SetYAXUnit(CtrlId,Region,Unit,AxisIndex)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetCustomToolTipText(CtrlId.l,Region.l,Series.l,DataIndex.l,Text.s)
    If F_RMC_SetCustomToolTipText
      ProcedureReturn F_RMC_SetCustomToolTipText(CtrlId,Region,Series,DataIndex,Text)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetGridBiColor(CtrlId.l,Region.l,BiColor.l)
    If F_RMC_SetGridBiColor
      ProcedureReturn F_RMC_SetGridBiColor(CtrlId,Region,BiColor)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetHelpingGrid(CtrlId.l,Size.l)
    If F_RMC_SetHelpingGrid
      ProcedureReturn F_RMC_SetHelpingGrid(CtrlId,Size)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetHelpingGrid2(CtrlId.l,Size.l,GridColor.l)
    If F_RMC_SetHelpingGrid
      ProcedureReturn F_RMC_SetHelpingGrid(CtrlId,Size,GridColor)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXLabelsFile(CtrlId.l,Region.l,FileName.s)
    If F_RMC_SetLAXLabelsFile
      ProcedureReturn F_RMC_SetLAXLabelsFile(CtrlId,Region,FileName)
    EndIf
  EndProcedure
  ProcedureDLL.l RMC_SetLAXLabelsFile2(CtrlId.l,Region.l,FileName.s,Lines.s,Fields.s,FieldDelimiter.s)
    If F_RMC_SetLAXLabelsFile
      ProcedureReturn F_RMC_SetLAXLabelsFile(CtrlId,Region,FileName,Lines,Fields,FieldDelimiter)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLAXLabelsRange(CtrlId.l,Region.l,First.l,Last.l)
    If F_RMC_SetLAXLabelsRange
      ProcedureReturn F_RMC_SetLAXLabelsRange(CtrlId,Region,First,Last)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetLegendHide(CtrlId.l,Region.l,Hide.l)
    If F_RMC_SetLegendHide
      ProcedureReturn F_RMC_SetLegendHide(CtrlId,Region,Hide)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesDataRange(CtrlId.l,Region.l,Series.l,First.l,Last.l)
    If F_RMC_SetSeriesDataRange
      ProcedureReturn F_RMC_SetSeriesDataRange(CtrlId,Region,Series,First,Last)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesHighLowColor(CtrlId.l,Region.l,Series.l,ColorLow.l,ColorHigh.l)
    If F_RMC_SetSeriesHighLowColor
      ProcedureReturn F_RMC_SetSeriesHighLowColor(CtrlId,Region,Series,ColorLow,ColorHigh)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesPPColumn(CtrlId.l,Region.l,Series.l,PointsPerColumn.l)
    If F_RMC_SetSeriesPPColumn
      ProcedureReturn F_RMC_SetSeriesPPColumn(CtrlId,Region,Series,PointsPerColumn)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetSeriesPPColumnArray(CtrlId.l,Region.l,Series.l,*FirstPPCValue,PPCValuesCount.l)
    If F_RMC_SetSeriesPPColumnArray
      ProcedureReturn F_RMC_SetSeriesPPColumnArray(CtrlId,Region,Series,*FirstPPCValue,PPCValuesCount)
    EndIf
  EndProcedure
  
  ProcedureDLL.l RMC_SetToolTipWidth(CtrlId.l,Width.l)
    If F_RMC_SetToolTipWidth
      ProcedureReturn F_RMC_SetToolTipWidth(CtrlId,Width)
    EndIf
  EndProcedure
  ;}
CompilerEndIf
;}
; IDE Options = PureBasic 5.71 beta 2 LTS (Windows - x86)
; CursorPosition = 274
; FirstLine = 249
; Folding = ---------------------------------------------------------------------------------------------