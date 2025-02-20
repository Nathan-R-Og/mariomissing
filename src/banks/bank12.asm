;this may be more than JUST text but for now.
;technically this can just straight up optimize binary????????????????????

org $128000
incbin "split/banks/Txt_NewYork.bin"
incbin "split/banks/Txt_Cairo.bin"
incbin "split/banks/Txt_Athens.bin"
incbin "split/banks/Txt_Tokyo.bin"
incbin "split/banks/Txt_Rome.bin"
incbin "split/banks/Txt_RiodeJaneiro.bin"

;put in work ram $16c00
;$7ff000 in cpu memory is used as a $1000 range buffer
;id call it the 'working' area but. yeah

;$FF after every 8 bytes?
;bitmasks for control codes??? for some reason???
;if a bit is 0, a control code is there in place of a normal byte
;else, just read the byte there

;control codes are formatted 'big endian' per se
;3 nybbles worth of offset
;1 nybble of amount to copy paste
;ooooooooooooaaaa
;offset is specifically of the CALCULATED output
;


macro Append(offset, amount)
	db HIBYTE((<offset>+1)<<4),LOBYTE((<offset>+1)<<4)|(<amount>-2)
endmacro

incbin "split/banks/Txt_SanFrancisco.bin"
incbin "split/banks/Txt_Sydney.bin"
incbin "split/banks/Txt_Beijing.bin"
incbin "split/banks/Txt_Moscow.bin"
incbin "split/banks/Txt_BuenosAires.bin"
incbin "split/banks/Txt_MexicoCity.bin"
