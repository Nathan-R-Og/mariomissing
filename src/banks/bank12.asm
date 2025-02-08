org $128000
incbin "split/banks/bank12.bin":0..$41ba

db $03,$FF,$16,$6C,$36,$6D,$31,$6E,$AE,$6F,$FF,$BA,$71,$D4,$73,$86,$75,$0C,$77,$FF,$AE,$78,$A6,$7A,$44,$7C,$25,$6C,$FF,$3D,$6C,$C0,$08,$80,$0C,$03,$5E,$FF,$6C,$9E,$6C,$FB,$6C,$53

;$02,$90
;length, addr?
;everything else that isnt a letter is a marker??
;or at least. something like that
;is it id'd, and THAT id is the addr????

;this is ENTIRELY a guess. all i know is that the result is lsr'd 4 times (>>4)
macro Append(arg, arg2)
;arg is where to go
;arg2 is y???
	db HIBYTE(<arg><<4),LOBYTE(<arg><<4)|<arg2>
endmacro

Text_Start:
db "th",$FF,"e Golden",$6F
%Append($2A, 0)
db "at"
%Append($29, 0)
db "Brid",$E7,"ge",0
%Append($26, $F)
%Append($37, 4)
db " fo",$FF,"g horn",0


incbin "split/banks/bank12.bin":$420f..$8000