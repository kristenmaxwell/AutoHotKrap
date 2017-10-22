		
;;;Premiere
#IfWinActive Adobe Premiere

{
;-------------------	
;laptop key bindings
;-------------------
;trying to make up for lack of extended keys and keypad
!=:: Send {NumpadAdd}
!-::Send {NumpadSub}
!1::Send {Numpad1}
!2::Send {Numpad2}
!3::Send {Numpad3}
!4::Send {Numpad4}
!5::Send {Numpad5}
!6::Send {Numpad6}
!7::Send {Numpad7}
!8::Send {Numpad8}
!9::Send {Numpad9}
!0::Send {Numpad0}
!`::Send {NumpadDot}
!Enter::Send {NumpadEnter}


;------------------------------------	
; Play Head and Tail -- keypad method
;------------------------------------
; shows quickly how well an inserted clip matches with surrounding clips, playing just a few seconds around both edges of the clip.
; KNOWN ISSUE: only works with clips with a duration longer than the variable "review_length." I don't know of any way around this
; since we can't get the clip duration from premiere AFAIK.
+Enter::
	review_length := 4 ;  CHANGE THIS AS NEEDED -- set the length of time (in seconds) to review around the edits
	numpad_digit := review_length // 2 ; half of the review duration -- the # of seconds to 'jump back' from edit
	; obsilete? numpad_string := "Numpad" . numpad_digit
	Send {Up} ;jump to prev edit
	WinMenuSelectItem, Adobe Premiere Pro, , Edit, Deselect All ; deselects any clips in the timeline so that they don't get shifted via keypad timecode entry
	Send {NumpadSub}{Numpad%numpad_digit%}{Numpad0}{Numpad0}{NumpadEnter} ; type '-X00' and enter, via numeric keypad
	Sleep 100 ; tiny pause to make sure Premeire is caught up and ready for further commands
	Send {l} ;play
	Sleep %review_length%000 ; wait while premiere plays the portion around the edit
	Send {k} ;pause
	Sleep 2000 ; optional-- two-second breather before jumping ahead to the next edit 
	Send {Down} ; jump to next edit
	Send {NumpadSub}{Numpad%numpad_digit%}{Numpad0}{Numpad0}{NumpadEnter} ; type '-X00' and enter, via numeric keypad
	Sleep 100 ; tiny pause to make sure Premeire is caught up and ready for further commands
	Send {l} ;play
	Sleep %review_length%000 ; wait while premiere plays the portion around the edit
	Send {k} ;pause
Return


;------------------------------------	
; Ripple Cut 
;------------------------------------
; copies the selected clip, then ripple deletes it
+x::
	WinMenuSelectItem, Adobe Premiere Pro, , Edit, Copy ; copies the current clip via menu 
	WinMenuSelectItem, Adobe Premiere Pro, , Edit, Ripple Delete ; ripple deletes the current clip via menu 
return

}