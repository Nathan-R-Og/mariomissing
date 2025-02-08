function LOBYTE(label) = label&$00FF
function HIBYTE(label) = (label&$FF00)>>8

function LOWORD(label) = label&$0000FFFF
function HIWORD(label) = (label&$FFFF0000)>>16

!TEXT_NEWLINE = $FF

;TEXT_SET_PALETTE(x) = $F0 | x ?
!TEXT_COLOR_BLUE = $F0
!TEXT_COLOR_YELLOW = $F1
!TEXT_COLOR_GREEN = $F2
!TEXT_COLOR_RED = $F3