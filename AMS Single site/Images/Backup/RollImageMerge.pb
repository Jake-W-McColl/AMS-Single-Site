UsePNGImageEncoder()
UsePNGImageDecoder()

LoadImage(1,"Roll.png")
LoadImage(2,"Pin_Blue.png")
LoadImage(3,"Pin_Red.png")

CreateImage(4,ImageWidth(1),ImageHeight(2)*1.1)

Wid = ImageWidth(1)/6

StartDrawing(ImageOutput(4))
  DrawingMode(#PB_2DDrawing_Transparent)
  
  DrawAlphaImage(ImageID(1),0,0)
  
  For x = 1 To 5
  Col = 1 - Col
  DrawAlphaImage(ImageID(2+Col),(x*Wid)-4,12)
;  DrawAlphaImage(ImageID(3),80,12)
  Next
StopDrawing()

SaveImage(4,"MergedRoll.png",#PB_ImagePlugin_PNG)

; IDE Options = PureBasic 4.60 (Windows - x86)
; CursorPosition = 7
; EnableXP