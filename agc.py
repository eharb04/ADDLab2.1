

def hatchH(f):
  print("hatchH <=	'1' when (", file=f)
  print(f"\t\t\t\t\t\t(pixelVert > T_EDGE + BORDER_LINE_WIDTH + 295) and --Upper and lower bounds", file=f)
  print(f"\t\t\t\t\t\t(pixelVert < T_EDGE + BORDER_LINE_WIDTH + 305)", file=f)
  print(f"\t\t\t\t\t\t) and (", file=f)
  for i in range(1, 49):
    print(f"\t\t\t\t\t\t(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + {20 * i}) or", file=f)
  print(f"\t\t\t\t\t\t(pixelHorz = L_EDGE + BORDER_LINE_WIDTH + 980) --Each individual hatch", file=f)
  print(f"\t\t\t\t\t\t)", file=f)
  print(f"\t\t\t\t\t\t else '0';", file=f)

def hatchV(f):
  print("hatchV <=	'1' when (", file=f)
  print(f"\t\t\t\t\t\t(pixelHorz > L_EDGE + BORDER_LINE_WIDTH + 495) and --Left and right bounds", file=f)
  print(f"\t\t\t\t\t\t(pixelHorz < L_EDGE + BORDER_LINE_WIDTH + 505)", file=f)
  print(f"\t\t\t\t\t\t) and (", file=f)
  for i in range(1, 29):
    print(f"\t\t\t\t\t\t(pixelVert = T_EDGE + BORDER_LINE_WIDTH + {12 * i}) or", file=f)
  print(f"\t\t\t\t\t\t(pixelVert = T_EDGE + BORDER_LINE_WIDTH + 588) --Each individual hatch", file=f)
  print(f"\t\t\t\t\t\t)", file=f)
  print(f"\t\t\t\t\t\t else '0';", file=f)
  
def gridH(f):
  print("gridH <= '1' when (((pixelHorz > L_EDGE + BORDER_LINE_WIDTH) and", file=f)
  print(f"\t\t\t\tpixelHorz < R_EDGE - BORDER_LINE_WIDTH)) and(", file=f)
  for i in range (1,9):
    print(f"\t\t\t\tpixelVert = T_EDGE + BORDER_LINE_WIDTH + {600/10*i} or",file = f)
  print(f"\t\t\t\tpixelVert = T_EDGE + BORDER_LINE_WIDTH + {600/10*(i+1)}) else '0';",file = f)

def gridV(f):
  print("gridV <= '1' when (((pixelVert > T_EDGE + BORDER_LINE_WIDTH) and", file=f)
  print(f"\t\t\t\tpixelVert < T_EDGE - BORDER_LINE_WIDTH)) and(", file=f)
  for i in range (1,9):
    print(f"\t\t\t\tpixelHorz = L_EDGE + BORDER_LINE_WIDTH + {100*i} or",file = f)
  print(f"\t\t\t\tpixelHorz = L_EDGE + BORDER_LINE_WIDTH + {100*(i+1)}) else '0';",file = f)

def triggerTime(f):
  print("triggerTimeMarker <= '1' when (", file = f)
  for i in range(1,5):
    print(f"\t\t\t\t((pixelVert = (T_EDGE + {2*i-1}) or",file=f)
    print(f"\t\t\t\tpixelVert = (T_EDGE + {2*i}) ) and",file=f)
    print(f"\t\t\t\t(pixelHorz > (triggerTime - std_logic_vector(to_unsigned({6-i}, VIDEO_WIDTH_IN_BITS))) and",file = f)
    print(f"\t\t\t\tpixelHorz < (triggerTime + std_logic_vector(to_unsigned({6-i}, VIDEO_WIDTH_IN_BITS))))) or ", file=f)
  print(f"\t\t\t\t((pixelVert = (T_EDGE + {2*i+1}) or",file=f)
  print(f"\t\t\t\tpixelVert = (T_EDGE + {2*(i+1)})) and",file=f)
  print(f"\t\t\t\tpixelHorz = triggerTime)) else '0';",file = f)

def triggerVolt(f):
  print("triggerVoltMarker <= '1' when (", file = f)
  for i in range(1,5):
    print(f"\t\t\t\t((pixelHorz = (L_EDGE + {2*i-1}) or",file=f)
    print(f"\t\t\t\tpixelHorz = (L_EDGE + {2*i}) ) and",file=f)
    print(f"\t\t\t\t(pixelVert > (triggerVolt - std_logic_vector(to_unsigned({6-i}, VIDEO_WIDTH_IN_BITS))) and",file = f)
    print(f"\t\t\t\tpixelVert < (triggerVolt + std_logic_vector(to_unsigned({6-i}, VIDEO_WIDTH_IN_BITS))))) or ", file=f)
  print(f"\t\t\t\t((pixelHorz = (L_EDGE +{2*i+1}) or",file=f)
  print(f"\t\t\t\tpixelHorz = (L_EDGE +{2*(i+1)})) and",file=f)
  print(f"\t\t\t\tpixelVert = triggerVolt)) else '0';",file = f)
                      
if __name__ == "__main__":
    with open("hatch.txt", "w") as f:
        hatchH(f)
        hatchV(f)
    with open("trigger.txt", "w") as f:
       triggerTime(f)
       triggerVolt(f)

    with open("grid.txt", "w") as f:
        gridH(f)
        gridV(f)
