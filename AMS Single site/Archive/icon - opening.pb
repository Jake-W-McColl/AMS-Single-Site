CreateImage(0,52,23)
StartVectorDrawing(ImageVectorOutput(0))
VectorSourceColor(RGBA(255,255,255,255))
FillVectorOutput()

VectorSourceColor(RGBA(0,0,0,255))
MovePathCursor(0,4)
AddPathLine(6,4)
AddPathArc(6,4,25,122,90)
AddPathArc(25,122,46,4,90)
AddPathLine(52,4)
StrokePath(1)

MovePathCursor(8,4)
AddPathLine(44,4)
DashPath(0.51,1)

MovePathCursor(26,4)
AddPathLine(26,20)
DashPath(0.51,1)

MovePathCursor(11,1)
AddPathLine(8,4)
AddPathLine(11,7)
StrokePath(1)

MovePathCursor(41,1)
AddPathLine(44,4)
AddPathLine(41,7)
StrokePath(1)

MovePathCursor(23,8)
AddPathLine(26,5)
AddPathLine(29,8)
StrokePath(1)

MovePathCursor(23,18)
AddPathLine(26,21)
AddPathLine(29,18)
StrokePath(1)


StopVectorDrawing()
SaveImage(0,"C:\temp\openingdepth.bmp",#PB_ImagePlugin_BMP)
CallDebugger
; IDE Options = PureBasic 5.71 LTS (Windows - x86)
; CursorPosition = 44
; FirstLine = 9
; EnableXP