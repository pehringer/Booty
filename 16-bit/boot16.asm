bits 16
org 0x7c00

jmp 0x0000:.boot16

.boot16:
    cli
    hlt

times 510 - ($-$$) db 0
dw 0xaa55

