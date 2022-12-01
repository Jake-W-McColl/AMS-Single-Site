;/ A quick program to create opaque images from Alpha images
;/  - replaces the Alpha Channel With a mix based on provided BackColour
;/ PJ 16/12/2011

Debug Red(16777200)


BackColourR.f = 255
BackColourG.f = 255
BackColourB.f = 255

TintR.f = 255.0
TintG.f = 255.0
TintB.f = 230.0

UsePNGImageDecoder()
UsePNGImageEncoder()
UseJPEGImageEncoder()

Structure Pixel
  R.f
  G.f
  B.f
  A.f
EndStructure
Dim Pixel.pixel(640,480)
NewList Images.s()
AddElement(Images()) : Images() = "Wallwidth.png"
AddElement(Images()) : Images() = "UnifiedRoll2.png"
AddElement(Images()) : Images() = "UnifiedRollPins.png"
AddElement(Images()) : Images() = "Screen.png"
AddElement(Images()) : Images() = "Opening.png"

ForEach Images()
  Debug LoadImage(1,Images())
  File.s = Images()
  Debug File
  Debug GetFilePart(File)
  StartDrawing(ImageOutput(1))
  DrawingMode(#PB_2DDrawing_AlphaBlend)
  Debug ImageWidth(1)
  Debug ImageHeight(1)
  For x = 0 To ImageWidth(1)-1
    For y = 0 To ImageHeight(1)-1
      P = Point(x,y)
      Pixel(x,y)\r = Red(P)
      Pixel(x,y)\g = Green(P)
      Pixel(x,y)\b = Blue(P)
      Pixel(x,y)\a = Alpha(P)

      NP.f = (Alpha(P) / 255)
      PP.f = 1.0 - NP ; positive / negative weights for mix
      
      If Pixel(x,y)\A < 220
        PR.f = ((Pixel(x,y)\r * PP) + (TintR * NP))
        PG.f = ((Pixel(x,y)\G * PP) + (TintG * NP))
        PB.f = ((Pixel(x,y)\B * PP) + (TintB * NP))
      Else
        PR = Pixel(x,y)\R
        PG = Pixel(x,y)\G
        PB = Pixel(x,y)\B
      EndIf
    
      If X = 17 And Y = 2
        Debug "RGB("+Str(Pixel(x,y)\r)+","+Str(Pixel(x,y)\g)+","+Str(Pixel(x,y)\b)+","+Str(Pixel(x,y)\a)+")"
        Debug NP
        Debug PP
        Debug "PR: " + StrF(PR,1)
        Debug "PG: " + StrF(PG,1)
        Debug "PB: " + StrF(PB,1)
      EndIf
      ;P = RGBA(PR,PG,PB,0)
      
      P = RGBA((PR),(PG),(PB),200)
      
      If Pixel(x,y)\a = 0 : P = RGBA((TintR),(TintG),(TintB),255) : EndIf
      

      Plot(x,y,P)
    Next
  Next
  
  StopDrawing()
  SaveImage(1,Left(Images(),Len(Images())-4)+"_Opaque"+".JPG",#PB_ImagePlugin_JPEG,10)
  SaveImage(1,"_"+Left(Images(),Len(Images())-4)+"_Opaque"+".PNG",#PB_ImagePlugin_PNG,10)
  
Next


; IDE Options = PureBasic 4.60 RC 1 (Windows - x86)
; CursorPosition = 24
; Folding = -
; EnableXP