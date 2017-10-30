welcome to my AHK script for Adobe Audition. I've created the following basic funcionality:

  1. the ability to "nudge" a time selection forward or back, using the keyboard
  2. the ability to "drag" a time selection around like you would with the mouse, using only the keyboard
  
  You'll need AutoHotKey in order to run this script. Get it here: https://autohotkey.com/

If you have that up and running, then download all the files in this folder, put them in your scripts folder, and run the included .ahk file. 

edit the .ahk file if you wanna change the bound keys for these functions

list of keys defined in this script:
------------------------------------
Alt Right Arrow : nudge time-selection forward 1 "step"

Shift Alt Right Arrow : nudge time-selection forward 10 "steps"

Alt Left Arrow : nudge time-selection back 1 "step"

Shift Alt Left Arrow : nudge time-selection back 10 "steps"

Z (hold) : grabs time-selection handle. Use left and right arrows while holding Z to drag time-selection forward/back. Holding down left/right arrow gradually accelerates the drag speed.
