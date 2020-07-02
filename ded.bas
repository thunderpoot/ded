   10  color 9,9
   20  version$ = "0.5a"
   30  if argv$(1) = "?" then goto 1030
   40  if argv$(1) = "" then funam$ = "[new file]"
   50  if argv$(1) <> "" then funam$ = "[" + argv$(1) + "]"
   60  if argv$(1) <> "" and instr(dir$, " " + argv$(1) + " ") = -1 then print "%error: file not found" : end
   70  print " [dEd] : Opening " + funam$ + "..." : sleep 2
   80  tmsg$ = "dEd v" + version$ + " " + funam$
   90  esc$ = chr$(27)
  100  inv$ = str$(esc$ + "[7m") : nor$ = str$(esc$ + "[m")
  110  cls
  120  mywidth = width : myheight = height
  130  l = 2 : p = 1
  140  gosub 450
  150  if instr(dir$, " " + argv$(1) + " " ) <> -1 then goto 920
  160  rem main event loop
  170  gosub 450
  180  if p = 0 then p = 1
  190  locate l,p
  200  if p > len(line$(l))+1 then p = len(line$(l))+1
  210  in$ = inkey$
  220  if in$ = chr$(127) and p < 2 and len(line$(l)) > 0 then beep : message$ = "error: cannot modify buffer" : msgtime = timer : goto 160
  230  if in$ = chr$(13) then if l < maxl or p < len(line$(l)) then beep : message$ = "error: cannot modify buffer" : msgtime = timer : goto 160
  240  if l > maxl then maxl = l
  250  if timer - msgtime > 2 then message$ = ""
  260  if in$ = chr$(26) then gosub 750 : goto 160
  270  if in$ = esc$ then escbrac$ = inkey$ : if escbrac$ = chr$(91) then gosub 570 : goto 160
  280  if in$ <> chr$(8) and in$ <> chr$(127) then line$(l) = left$(line$(l), p-1) + in$ + mid$(line$(l), p)
  290  if mywidth <> width or myheight <> height then gosub 450
  300  if in$ = chr$(4) then gosub 410 : goto 160
  310  if in$ = chr$(127) and p = 1 and l < maxl then beep : message$ = "error: cannot modify buffer" : msgtime = timer : goto 160
  320  if in$ = chr$(127) and p < 2 and l > 2 and len(line$(l)) = 0 then l = l - 1 : maxl = maxl - 1 : p = len(line$(l)) : goto 160
  330  if in$ = chr$(127) and p > 1 then print esc$ + "[1D " + esc$ + "[1D" ; : gosub 540 : goto 160
  340  if in$ = chr$(8) and p > 1 then print " " + esc$ + "[1D" ; : gosub 540 : goto 160
  350  if in$ = chr$(13) then if p <> len(line$(l)) then beep : message$ = "error: cannot modify buffer, punk" : msgtime = timer : goto 160
  360  if in$ = chr$(13) and l = height-1 then beep : message$ = "error: cannot modify buffer" : msgtime = timer : goto 160
  370  if in$ = chr$(13) and p = len(line$(l)) then l = l + 1 : p = 1 : goto 160
  380  if in$ = chr$(13) then goto 160
  390  if in$ <> "" then if in$ <> chr$(127) and in$ <> chr$(8) then p = p + 1
  400  goto 160
  410  rem ^D
  420  locate height-1,1 : print esc$ + "[7m "; : input "save file as? ", finam$ : print esc$ + "[m" + esc$ + "M" + esc$ + "M";
  430  goto 690
  440  return
  450  rem redraw
  460  mywidth = width : myheight = height
  470  print esc$ + "[H" + esc$ + "[J" ;
  480  locate 1,1 : print esc$ + "[7m " + esc$ + "[2m" + tmsg$ + esc$ + "[22m" ; : for i = 1 to width-len(tmsg$)-1 : print " " ; : next i : print esc$ + "[m"
  490  locate height,1 : print esc$ + "[7m" ; : for i = 1 to width : print " " ; : next i : locate 2,1 : print esc$ + "[m";
  500  locate height,1 : print esc$ + "[7m LINE " + STR$(l-1) + " COL " + STR$(p) + "    " + esc$ + "[2m" + "^Z for help" + esc$ + "[22m" + esc$ + "[m"; : locate 1,len(tmsg$)+3 : print esc$ "[7m" + message$ + esc$ + "[m"
  510  for r = 1 to maxl : if r < height-1 then locate r,1 : if asc(right$(line$(l), 1)) = 13 or asc(right$(line$(l), 1)) = 127 then line$(l) = left$(line$(l), len(line$(l))-1)
  520  print line$(r) ; : sleep 0 : next r
  530  return
  540  rem hacky string manipulation
  550  p = p - 1 : line$(l) = left$(line$(l), p-1) + mid$(line$(l), p+1)
  560  return
  570  rem directional key escape sequences
  580  eschar$ = inkey$
  590  if eschar$ = "A" then if l > 2 and p < len(line$(l-1)) then l = l - 1 : if p > len(line$(l)) then p = len(line$(l)) : if p < 1 then p = 1 : rem up
  600  if eschar$ = "A" and l > 2 and p > len(line$(l-1)) then p = len(line$(l-1)) : l = l - 1 : return rem up on line longer than line above it
  610  if eschar$ = "A" and l = 2 and p > 1 then p = 1 : return rem up at top line
  620  if eschar$ = "b" and l = maxl and p < len(line$(l)) then p = len(line$(l))+1 : return : rem down on final line
  630  if eschar$ = "b" and l < height-1 and l < maxl then l = l + 1 : if p > len(line$(l)) then p = len(line$(l)) : if p < 1 then p = 1 : rem down
  640  if eschar$ = "d" and p < 2 and l > 2 then p = len(line$(l-1))+1 : l = l - 1 : goto 160 : rem left at beginning of line
  650  if eschar$ = "d" then if p > 1 then p = p - 1 : rem left
  660  if eschar$ = "c" and p > len(line$(l)) and l < maxl then p = 1 : l = l + 1 : goto 160 : rem right at end of line
  670  if eschar$ = "c" then if p < width then if p < len(line$(l))+1 then p = p + 1 : rem right
  680  return
  690  rem save file
  700  if instr(dir$, " " + finam$ + " ") <> -1 then beep : message$ = "error: file already exists, cannot overwrite!" : msgtime = timer : goto 160
  710  open finam$, as #1
  720  for wr = 2 to maxl : print# 1, line$(wr) : next wr
  730  close #1
  740  print "saved to " + chr$(34) + finam$ + chr$(34) : end
  750  rem help
  760  cls
  770  print esc$ + "[?25l" : rem hide cursor
  780  locate int(height/2)-5,int(width/2)-21
  790  print inv$ + esc$ + "[1m" + "     dEd - A Simple Text Editor          " + nor$
  800  locate int(height/2)-4,int(width/2)-21 : print inv$ + "                                         " + nor$ ; : color 7,6 : print " " : color 9,9
  810  locate int(height/2)-3,int(width/2)-21 : print inv$ + "      ^D - save file and quit            " + nor$ ; : color 7,6 : print " " : color 9,9
  820  locate int(height/2)-2,int(width/2)-21 : print inv$ + "      ^Z - show this information         " + nor$ ; : color 7,6 : print " " : color 9,9
  830  locate int(height/2)-1,int(width/2)-21 : print inv$ + "      ^C - quit without saving           " + nor$ ; : color 7,6 : print " " : color 9,9
  840  locate int(height/2)+0,int(width/2)-21 : print inv$ + "                                         " + nor$ ; : color 7,6 : print " " : color 9,9
  850  locate int(height/2)+1,int(width/2)-21 : print inv$ + "    run `ded ?` for more information     " + nor$ ; : color 7,6 : print " " : color 9,9
  860  locate int(height/2)+2,int(width/2)-21 : print inv$ + "                                         " + nor$ ; : color 7,6 : print " " : color 9,9
  870  locate int(height/2)+3,int(width/2)-21 : print inv$ + esc$ + "[2m" + "     press any key to continue...        " + nor$ ; : color 7,6 : print " " : color 9,9
  880  locate int(height/2)+4,int(width/2)-20 : color 7,6 : print "                                         " : color 9,9
  890  foo$ = inkey$
  900  print esc$ + "[?25h" : rem show cursor
  910  return
  920  rem load file
  930  lm = 2
  940  open argv$(1), as #1
  950  if eof(1) = -1 then goto 990
  960  input# 1, mf$
  970  line$(lm) = mf$ : lm = lm + 1
  980  goto 950
  990  close #1
 1000  maxl = lm
 1010  if maxl > height-1 then maxl = height-1
 1020  goto 160
 1030  rem usage
 1040  print " %usage: "
 1050  print "  ded [file]     open a file or start a blank file in dEd"
 1060  print : print " dEd has some limitations:"
 1070  print " - Paste does not work due to how dEd implements polkey$"
 1080  print " - You cannot insert new lines in the file except for at the end of the file"
 1090  print " - You cannot delete lines in the middle of the file, only the last line"
 1100  print " - Lines must be empty before deleting them"
 1110  print " - Files can only be as long as your window is high"
 1120  print : print " Current version: " + version$
 1130  end
