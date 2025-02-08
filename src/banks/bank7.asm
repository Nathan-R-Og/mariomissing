org $078000
incbin "split/banks/bank7.bin":0..$7010
;0A slot?
;04 note length (?)
;08 main instrument data
;02 end?
db $0A,$00
db $04,$01
db $08,$3B
db $02

db $0A,$01,$04,$01,$08,$3C,$02

db $0A,$02,$04,$01,$08,$3D,$02

db $0A,$03,$04,$01,$08,$3E,$02

db $0A,$04,$04,$01,$08,$3F,$02

db $0A,$05,$04,$01,$08,$40,$02
incbin "split/banks/bank7.bin":$703a..$8000
