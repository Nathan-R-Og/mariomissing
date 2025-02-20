org $008000

    sei
    clc
    xce
    sep #$20
    rep #$10
    stz $4200
    stz $420c
    stz $420b
    stz $2140
    stz $2141
    stz $2142
    stz $2143
    lda #$8f
    sta $2100
    ldx #$01ff
    txs
    rep #$20
    ldx #$0000
    txa
    d_00802b:
    sta $7e0000, x
    sta $7f0000, x
    inx
    inx
    bne d_00802b
    jsl $808050
    jsl $808453
    jsl $808471
    jsl $80842c
    jsl $808349
    jmp $9a5e

dw 0

incbin "split/banks/bank0.bin":$50..$781

d_808bb7 = $808bb7
d_808506 = $808506
d_808781:
    php
    rep #$20
    sep #$10
    sta $2a
    lda [$5d]
    sta $2c
    ldx #$00
    stx $2e
    lda #$8000
    sta $2f
    ldx #$7f
    stx $31
    inc $5d
    inc $5d
    jsl d_808bb7
    lda #$002a
    sta $18
    ldx #$00
    stx $1a
    jsl d_808506
    plp
    rtl

incbin "split/banks/bank0.bin":$7b0..$c3a



!5d_get_text #= $5d
!60_get_bitmask #= $60
!64_bytes_left #= $64
;these routines work off of the 'header' of text blocks
;using it as a jump table indicie
;i think these are literally just decoding types
d_808c3a:
    lda (!5d_get_text)
    dec
    cmp #3
    ;if a == 0
    bcs .d_808c46
    ;else
    asl
    tax
    jmp (text_jumptable,x)
    .d_808c46:
    plb
    plp
    rtl

d_808c49:
    lda (!5d_get_text)
    dec
    cmp #3
    ;if a == 0
    bcs .d_808c55
    ;else
    asl
    tax
    jmp (text_jumptable2,x)
    .d_808c55:
    plb
    plp
    rtl

text_jumptable:
    dw $8C64
    dw $8D78
    dw d_808e12
text_jumptable2:
    dw $8C64
    dw $8CDE
    dw d_808e12

incbin "split/banks/bank0.bin":$c64..$e12

d_808e12:
    sep #!STATUS_MEMORY
    rep #!STATUS_INDEX
    ;store incs
    lda #8
    sta !64_bytes_left

    ;get first bitmask
    ldy !5d_get_text
    iny
    sty !60_get_bitmask

    ;set 5d start point to the start of the actual data
    iny
    sty !5d_get_text

    ;reset
    ldx #$0001
    ldy #$0000

    .d_808e28:
    lda (!60_get_bitmask)
    .d_808e2a:
    ;shift incrementor byte to test bits
    asl
    ;store
    pha
    ;branch if incrementor_byte.$64 was 0
    bcc .d_808e42

    ;normal case
    lda (!5d_get_text),y
    sta !WMDATA
    iny
    sta $7ff000,x
    rep #!STATUS_MEMORY
    inx
    txa
    and #%0000111111111111
    tax
    bra .d_808e7e



    ;bit was zero
    ;is control code
    .d_808e42:
    rep #!STATUS_MEMORY

    ;get word
    lda (!5d_get_text),y

    ;end if zero
    beq .d_808e96

    ;move 'cursor'
    iny
    iny

    ;store y
    phy

    ;make word big endian :)
    xba

    ;store LOWBYTE(a)
    pha

    ;remove lowermost nybble
    lsr
    lsr
    lsr
    lsr

    ;store into 62
    sta $62

    ;restore LOWBYTE(a)
    pla

    ;GET that lower nybble
    and #%0000000000001111

    ;+= 2
    ;probably because if you are starting a character transplant anyways
    ;its not worth it to do anything less :^)
    inc
    inc
    ;a -> y
    tay

    ;this is definitely a loop lol
    .loop:
    ;load stored $62
    lda $62
    ;get only the actual contents
    and #%0000111111111111

    ;store
    phx
    ;store a in x
    tax
    ;inc 62
    inc
    sta $62
    ;read byte from cpu memory ($7ff000 is a mirror of the written wram+1)
    sep #!STATUS_MEMORY
    lda $7ff000,x
    sta !WMDATA
    ;restore x
    plx

    ;also do the normal write
    sta $7ff000,x

    rep #!STATUS_MEMORY

    ;x++
    inx

    ;clean x
    txa
    and #%0000111111111111
    tax

    ;i--
    dey
    bne .loop

    ply

    .d_808e7e:
    sep #!STATUS_MEMORY
    pla
    ;[$64] > 0, jump
    dec !64_bytes_left
    bne .d_808e2a
    ;else

    ;set new length???
    lda #8
    sta !64_bytes_left

    rep #!STATUS_MEMORY
    clc

    ;y is wram addr
    tya
    ;$5d+y = $60
    ;$60 becomes current??????
    adc !5d_get_text
    sta !60_get_bitmask

    sep #!STATUS_MEMORY

    ;inc y to move one past $60 (skip a byte)
    iny
    ;loop
    bra .d_808e28

    ;end
    .d_808e96:
    sep #!STATUS_MEMORY
    pla
    plb
    plp
    rtl



incbin "split/banks/bank0.bin":$e9c..$21f0

;system
db "Where am I?",0
db "What is this?",0
db "Why is %n closed today?",0

db "Like the sign says, bud, %a %v stolen and we can't reopen until it gets returned. Here is a pamphlet with more information!",0

db "I want to return %c.",0
db "Never mind!",0

db "Ok, but you'll have to prove your goods are authentic by answering a few questions.",0

db "Sure, ask away.",0
db "Uh, no, I think I'll come back later.",0

db "Sorry, I'm too busy to talk now! Come back a little later...",0
db "%c? I'm not missing %c. Come back when you have what I'm looking for. Goodbye.",0
db "Another fake! Hmmph! Come back when you have your facts straight! Goodbye.",0
db "At last! %a! We've been looking all over town. The Mayor has authorized me to present you with this $%r reward. Thank you, and good luck finding Mario!",0
db "Missing: %a",$0a,"Reward: $%r -- Bonus: $%b",0
db "-- %N --",0

incbin "split/banks/bank0.bin":$24e7..$4118

;locations
db "The Colosseum",0
db "The Sistine Chapel",0
db "The Trevi Fountain",0
db "The Arc de Triomphe",0
db "The Eiffel Tower",0
db "The Cathedral of Notre Dame",0
db "Big Ben",0
db "The Tower of London",0
db "Westminster Abbey",0
db "The Empire State Building",0
db "The Rockefeller Center",0
db "The Statue of Liberty",0
db "The Coit Tower",0
db "The Golden Gate Bridge",0
db "The Transamerica Pyramid",0
db "The Erechtheion Temple",0
db "Hadrian's Arch",0
db "The Parthenon",0
db "The Bondi Beach",0
db "The Taronga Zoo",0
db "The Sydney Opera",0
db "The Great Buddha of Kamakura",0
db "The Sensoji Temple",0
db "The Kokugikan Arena",0
db "Maasai village",0
db "The National Museum of Kenya",0
db "The Nairobi National Park",0
db "The Copacabana beach",0
db "Christ the Redeemer Statue",0
db "The Sugar Loaf Mountain",0
db "The Mosque of Mohammed Ali",0
db "The Great Pyramid",0
db "The Sphinx",0
db "St. Basil's Cathedral",0
db "The Bolshoi Ballet",0
db "The Kremlin",0
db "The Forbidden City",0
db "The Great Wall of China",0
db "The Temple of Heaven",0
db "The Gaucho Museum",0
db "The Obelisk Monument",0
db "The Teatro Colon",0
db "The Angel of Independence",0
db "The National Palace",0
db "The Fine Arts Palace",0

incbin "split/banks/bank0.bin":$44a0..$51c9

db "   CITY SECURED!  ",!TEXT_NEWLINE
db !TEXT_NEWLINE
db !TEXT_NEWLINE
db "CITY SCORE        ",!TEXT_NEWLINE
db !TEXT_NEWLINE
db "TIME BONUS        ",!TEXT_NEWLINE
db !TEXT_NEWLINE
db !TEXT_NEWLINE
db "SCORE             ",!TEXT_NEWLINE
db !TEXT_NEWLINE
db "PASSWORD          "

db $00,$06,$0A

db "THE CITY WAS",!TEXT_NEWLINE
db !TEXT_NEWLINE
db "NOT SECURED!"
db $00

    php
    phb
    phk
    plb
    sep #$20
    rep #$10
    jsl $808453
    stz !BG12NBA
    stz !BG34NBA
    lda #$60
    sta !BG1SC
    sta !BG2SC
    sta !BG3SC
    lda #$01
    sta !BGMODE
    lda #$04
    sta !TM
    rep #$20
    lda #LOWORD(Main_Text_GFX)
    sta $5d
    lda #HIWORD(Main_Text_GFX)+$0080
    sta $5f
    lda #$0800
    jsl $808781
    sep #$20
    ldy #$0000
    ldx #$d482
    lda #$80
    jsl $808f27
    jsl $808249
    jsl $80d18b
    ldx #$d2d6
    jsl $80d11f
    ldx #$d3ca
    stx $18
    lda #$80
    sta $1a
    jsl $808506
    jsl $828da7
    ldx #$0000
d_80d2b6:
    jsl $808249
    cpx #$00f0
    bcc d_80d2c5
    lda $38
    and #$10
    bne d_80d2cb
d_80d2c5:
    inx
    cpx #$01e0
    bcc d_80d2b6
d_80d2cb:
    jsl $8082a7
    jsl $808050
    plb
    plp
    rtl

db $08,$00,$F2

'm' = $5B ;cooler m
'w' = $5C ;cooler w
!COPYRIGHT = $3C,$3D,$3E ;©
db "     THE SOFTwARE TOOLwORKS",!TEXT_NEWLINE
db "            PRESENTS",!TEXT_NEWLINE
db !TEXT_NEWLINE

db !TEXT_COLOR_GREEN,"        m",!TEXT_COLOR_BLUE,"A",!TEXT_COLOR_YELLOW,"R",!TEXT_COLOR_RED,"I",!TEXT_COLOR_GREEN,"O "
db !TEXT_COLOR_RED,"I",!TEXT_COLOR_BLUE,"S "
db !TEXT_COLOR_GREEN,"m",!TEXT_COLOR_BLUE,"I",!TEXT_COLOR_YELLOW,"S",!TEXT_COLOR_RED,"S",!TEXT_COLOR_BLUE,"I",!TEXT_COLOR_GREEN,"N",!TEXT_COLOR_RED,"G",!TEXT_COLOR_YELLOW,"!",!TEXT_NEWLINE

db !TEXT_NEWLINE
db !TEXT_NEWLINE
db !TEXT_COLOR_YELLOW," TM & COPYRIGHT",!COPYRIGHT,"1993 NINTENDO",!TEXT_NEWLINE
db !TEXT_NEWLINE
db !TEXT_COLOR_GREEN,"        COPYRIGHT",!COPYRIGHT,"1993",!TEXT_NEWLINE
db "  THE SOFTwARE TOOLwORKS, INC.",!TEXT_NEWLINE
db "       ALL RIGHTS RESERVED",!TEXT_NEWLINE
db !TEXT_NEWLINE
db !TEXT_COLOR_RED,"       LICENSED BY NINTENDO"
db $00

incbin "split/banks/bank0.bin":$53ca..$542e

;  y , x
db 18, 8
db !TEXT_COLOR_GREEN,"SEARCH FOR mARIO",!TEXT_NEWLINE
db !TEXT_NEWLINE
db !TEXT_COLOR_YELLOW,"CONTINUE SEARCH"
db $00

db 18, 8
db !TEXT_COLOR_YELLOW,"SEARCH FOR mARIO",!TEXT_NEWLINE
db !TEXT_NEWLINE
db !TEXT_COLOR_GREEN,"CONTINUE SEARCH"
db $00

incbin "split/banks/bank0.bin":$547a..$78a0

db "SOFTWARE DESIGN"
db !TEXT_NEWLINE
db !TEXT_NEWLINE
db "ANDREW IVERSON"
db !TEXT_NEWLINE
db "HENRIK MARKARIAN"
db $00,$04
db "TECHNICAL"
db !TEXT_NEWLINE
db "PRODUCER"
db !TEXT_NEWLINE
db !TEXT_NEWLINE
db "DAVE BRINGHURST"
db $00,$03
db "ART DIRECTOR"
db !TEXT_NEWLINE
db !TEXT_NEWLINE
db "VICKI SIDLEY"
db $00,$08
db "ARTISTS"
db !TEXT_NEWLINE
db !TEXT_NEWLINE
db "ERICA BENSON"
db !TEXT_NEWLINE
db "TANSY BROOKS"
db !TEXT_NEWLINE
db "JEFF GRIFFEATH"
db !TEXT_NEWLINE
db "DAN GUERRA"
db !TEXT_NEWLINE
db "WES JENKINS"
db !TEXT_NEWLINE
db "CHRIS KOSEL"
db $00,$07
db "PRODUCT DESIGN"
db !TEXT_NEWLINE
db !TEXT_NEWLINE
db "JON MANDEL"
db !TEXT_NEWLINE
db "DON LAABS"
db !TEXT_NEWLINE
db "GENE PORTWOOD"
db !TEXT_NEWLINE
db "LAUREN ELLIOTT"
db !TEXT_NEWLINE
db "JEFF CHASEN"
db $00,$03
db "TITLE SEQUENCE"
db !TEXT_NEWLINE
db !TEXT_NEWLINE
db "DAVE SULLIVAN"
db $00,$04
db "WRITING AND"
db !TEXT_NEWLINE
db "RESEARCH"
db !TEXT_NEWLINE
db !TEXT_NEWLINE
db "VALERIE SINGER"
db $00,$04
db "MUSIC AND EFFECTS"
db !TEXT_NEWLINE
db !TEXT_NEWLINE
db "SAM POWELL"
db !TEXT_NEWLINE
db "ROB WALLACE"
db $00,$01
db "THE END"
db 0

incbin "split/banks/bank0.bin":$7a30..$7f5b

fillbyte $FF
fill $65

db "Mario is Missing     "

;001smmmm
;   |++++- Map mode
;   +----- Speed: 0=Slow, 1=Fast
db %00100000|!SPEEDMODE_FAST|!MODE_LOROM

db !COPROCESSOR_DSP|!ROM_ROM_ONLY

db 10 ; 1<<10 kilobytes (1024kb) ROM
db 0 ; 1<<0 kilobytes (2kb) RAM
db 1 ;Country (Implies NTSC/PAL)
db $5A ;Developer ID
db 0 ; ROM version (0 = first)
dw $F562 ;Checksum Compliment  ^ $FFFF
dw $0A9D ;Checksum

dw $4040
dw $4040
dw $FFE0
dw $FFE1
dw $FFE2
dw $819D
dw $FFE3
dw $818A
dw $5754
dw $5852
dw $FFE0
dw $FFE3
dw $FFE2
dw $819D
dw $8000
dw $818A