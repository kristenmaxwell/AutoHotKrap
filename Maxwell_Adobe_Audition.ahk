; welcome to my AHK script for Adobe Audition. I've added the following basic funcionality
; 1. the ability to "nudge" a time selection forward to back, using the keyboard
; 2. the ability to "drag" a time selection around like you would with the mouse, using the keyboard
;
; In AHK, keybindings look like this
; SourceKey:: 
;  <what that key will now do>
; return
;
; you can change which key does what by simply modifying the part before the ::
; see here for a list of all the options: https://autohotkey.com/docs/KeyList.htm
; 
; the symbols BEFORE the SourceKey stand for different modifiers:
; + Shift
; ! Alt
; ^ Ctrl
; # Win


; these lines are just some basic AutoHotKey housekeeping
SetTitleMatchMode, 2
#Persistent
#NoEnv
#SingleInstance Force
#Include %A_ScriptDir% 



; ---------- Adobe Audition --------------------
#IfWinActive Adobe Audition ; important line-- this restricts the following hotkey definitions to ONLY work in Audition.
{
; you probably don't need the following line-- i just use it to make my life easier when on my laptop	
; AppsKey::MouseClick, M ; set apps key to middle mouse click

;--------------------------------------------
; nudge time-selection forward 1 "step"
;--------------------------------------------
!Right:: ; alt right (like, fascists?!) -- WARNING, this will override the default keyboard shortcut for "Move Playhead to Next"
	send +{right} ; Shift Right = nudge in-point right. If your keyboard shortcut is different in Audition, change this command as needed
	send ^+{right} ; Ctrl Shift Right = nudge out-point right. If your keyboard shortcut is different in Audition, change this command as needed
return	

;--------------------------------------------
; nudge time-selection back 1 "step"
;--------------------------------------------
!Left:: ; alt left -- WARNING, this will override the default keyboard shortcut for "Move Playhead to Next"
	send +{left} ; Shift+Left = nudge in-point left. If your keyboard shortcut is different in Audition, change this command as needed
	send ^+{left} ; Ctrl Shift Left = nudge out-point left. If your keyboard shortcut is different in Audition, change this command as needed
return		


;--------------------------------------------
; nudge time-selection forward 10 "frames"
;--------------------------------------------
+!Right:: ; shift alt right
	loop, 10 { ; repeat the commands between these brackets 10 times
		send +{right} ; Shift Right = nudge in-point right. If your keyboard shortcut is different in Audition, change this command as needed
		send ^+{right} ; Ctrl Shift Right = nudge out-point right. If your keyboard shortcut is different in Audition, change this command as needed
		sleep 10 ; very breif delay to keep Audition from freaking out
	}
return	



;--------------------------------------------
; nudge time-selection back 10 "frames"
;--------------------------------------------
+!Left:: ; shift alt left
	loop, 10 { 
		send +{left} ; Shift+Left = nudge in-point left. If your keyboard shortcut is different in Audition, change this command as needed
		send ^+{left} ; Ctrl Shift Left = nudge out-point left. If your keyboard shortcut is different in Audition, change this command as needed
		sleep 10 ; very breif delay to keep Audition from freaking out
	}

return	


;--------------------------------------------
; grab time-selection nub, and drag it around
;
; This simulates using the mouse to grab the handle in the middle of the time selection indicator (what I call the "nub").
; It relies on visually searching for the nub on screen, so it only works with the default color scheme in Audition CC. If you have
; changed your color or brightness settings in Preferences > Appearance, this will likely NOT work for you.
;
; OK here's how it works: press AND HOLD the z key . While it's held down, your mouse will grab the time-selection nub.
; while ` is down, you can press and hold left or right arrow keys to drag the time-election across the editor. It will start off
; moving slowly, then eventually accelerate. If you want to scrub fast from the get-go, you can do so by using SHIFT left and SHIFT right
; while holding down the z key. 
;
;--------------------------------------------

~left:: ; small mouse move left
	if (drag_mode) { ; if z key is held down, we're in mouse-drag mode
		moveleft +=1 ; increment the number of times we've nudged left since we hit the left arrow key
		if (moveleft < 30) { ; if we've nudged left enough times
			left_distance := -1 ; lets nudge just a little
		} 	else  if (moveleft < 140) {
				left_distance := -8 ; let's nudge a little more
			}	else {
					left_distance := -20 ; let's nudge a lot!
				}
		MouseMove, %left_distance%, 0, 0, R ; move the mouse left either a little or a lot
		
	}
return

*~left up:: ; left arrow key released while any or no modifier held
	moveleft := 0 ; reset left move counter
return

~right:: ; small mouse move right
	if (drag_mode) { ; if z key is held down, we're in mouse-drag mode
		moveright +=1 ; increment the number of times we've nudged right since we hit the right arrow key
		if (moveright < 30) { ; if we've nudged right enough times
			right_distance := 1 ; lets nudge just a little
		} 	else  if (moveright < 140) {
				right_distance := 8 ; let's nudge a little more
			}	else {
					right_distance := 20 ; let's nudge a lot!
				}
		MouseMove, %right_distance%, 0, 0, R ; move the mouse right either a little or a lot
		
	}
return

*~right up:: ; right arrow key released while any or no modifier held
	moveright := 0 ; reset right move counter
return

~+left:: ; bigger/faster mouse move left
	if (drag_mode) {
		MouseMove, -25, 0, 0, R
	}
return

~+right:: ; bigger/faster mouse move right
	if (drag_mode) {
		MouseMove, 25, 0, 0, R
	}
return 


z:: ; the z key -- change to another key if you want to use something else. 
	ImageSearch, image_x, image_y, 0, 0, A_ScreenWidth, A_ScreenHeight/4, audition_nub.png ; look for the time selection nub in the top 1/4 of screen. Make sure the file audition_nub.png is in the same directory as this script, or this function will break.
	if ErrorLevel = 2
		MsgBox Could not conduct the search.
	else if ErrorLevel = 1
		MsgBox Image could not be found on the screen.
	else
	{
		MouseGetPos, oldmouse_x, oldmouse_y ; store the current mouse position
		MouseMove image_x+5, image_y+5 ; move mouse to time selection nub (5 px right and down from the top-left corner)
		sleep 100 ; wait for UI to catch up
		Send {Lbutton Down} ; hold down left mouse button
		drag_mode := true ; enable drag mode-- this makes left and right keys move the mouse instead of their natural function
		KeyWait, z ; wait until the z key is released
		drag_mode := false ; disable drag mode 
		Send {Lbutton Up} ; release the mouse button
		MouseMove oldmouse_x, oldmouse_y ; restore the mouse to its previous position
 	}
return
} ; end of hotkeys for use in AUDITION 