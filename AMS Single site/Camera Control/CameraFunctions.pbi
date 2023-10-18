﻿  OpenWindow(#CAMERACONTROL, x, y, 600, 400, "Camera Control", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CameraFrame = FrameGadget(#PB_Any, 11, 7, 578, 383, "")
  ButtonGadget(#BTN_FOCUS_UP, 452, 164, 88, 33, "Focus Up")
  ButtonGadget(#BTN_FOCUS_DOWN, 452, 200, 88, 33, "Focus Down")
  ButtonGadget(#BTN_3DSCAN, 452, 236, 88, 33, "3D Scan")
  SpinGadget(#SPIN_SECTIONS, 452, 94, 88, 22, 1, 5, #PB_Spin_ReadOnly | #PB_Spin_Numeric)
  SpinGadget(#SPIN_SAMPLES, 452, 139, 88, 22, 1, 5, #PB_Spin_ReadOnly | #PB_Spin_Numeric)
  LBL_SECTIONS = TextGadget(#PB_Any, 452, 74, 93, 17, "Sections:")
  LBL_SAMPLES = TextGadget(#PB_Any, 453, 120, 93, 17, "Samples:")
  Text_2 = TextGadget(#PB_Any, 478, 322, 2, 1, "")
  ComboBoxGadget(#CMB_ZOOM_LEVEL, 452, 51, 88, 20)
  ComboBoxGadget(#CMB_LENS, 452, 28, 88, 20)
; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; EnableXP
; DPIAware