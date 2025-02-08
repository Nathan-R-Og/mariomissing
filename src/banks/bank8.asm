;safe to call this the 'main' music bank i think
;bank 7 has some more data but . idk man

org $088000

;this is transplanted into spc memory
;$b9bb - $f460
;bank data $0 - $3aa5

base $00B9BB

incbin "split/banks/bank8.bin":0..$17d


;delta centered around $2f??
function Note(int) = int+$2f
macro Wait(arg)
	db $F4,<arg>
endmacro

function Wait(int) = $F4,int

Mus_data_Intro_Inst1:
dw 380 ;detune/pitch ?
db $F2,$1F ;volume
db $F2,$2B ;....
%Wait(255) ;wait frames
%Wait(8)

;adjust delta back to normal?
db Note(12),0
;actual notes
;note delta, length
db Note(8),15
db Note(-3),15
db Note(-4),14
db Note(-1),22
db Note(-2),22
%Wait(255)
%Wait(9)

db Note(0),6
%Wait(8)
db Note(2),6
%Wait(2)
db Note(1),6
%Wait(8)
db Note(2),6
%Wait(15)
db Note(12),2
%Wait(1)
db Note(2),2
%Wait(1)
db Note(-2),13
%Wait(12)
db $F0 ;end?


incbin "split/banks/bank8.bin":$1b4..$18cc

Mus_Intro_Inst1:
;08 XX set instrument
db $08,$0f
;02 XX set music data????
db $02,$3B
db $00

db $08,$20
db $02,$3C,$00,$08,$20,$02,$3D,$00,$08

incbin "split/banks/bank8.bin":$18dc..$3899

Intro_Mus:
dw $A9CB
dw $A9D2
dw $A9D9
dw $A9E0
dw $A9E7
dw $A9EE

Boss_Mus:
dw $A9F5
dw $A9FC
dw $AA03
dw $AA0A
dw $AA11
dw $AA18

incbin "split/banks/bank8.bin":$38b1..$397F

;music data for intromus inst 1
dw Mus_data_Intro_Inst1
dw $BB6F
dw $BBC0
dw $BC11
dw $BC62
dw $BCCD
dw $BD0A
dw $BDA5

incbin "split/banks/bank8.bin":$398F..$3A1F

;music 'header' for intromus inst 1
dw Mus_Intro_Inst1

incbin "split/banks/bank8.bin":$3A21..$3aa5

base off

incbin "split/banks/bank8.bin":$3aa5..$3aa9

;this is transplanted into spc memory
;$17e0
;bank data $3aa9

incbin "split/banks/bank8.bin":$3aa9..$3ab9
dw $F2C4
dw 0
dw 0
dw $F364
dw Intro_Mus-$5a
dw $F3FE
dw 0
dw 0
incbin "split/banks/bank8.bin":$3ac9..$8000