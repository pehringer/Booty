bits 16    ; On startup the cpu is configured like a 16-bit 8086 chip from 1978.
           ; Tell NASM the following lines are 16-bit instructions.


org 0x7c00    ; The BIOS will load the drives first sector (512 bytes) into RAM
              ; at address 0x7C00, The BIOS will then jumping execution to address
              ; 0x7C00. Tell NASM to generate machine code starting at address 0x7c00.


jmp 0x0000:boot16    ; Some BIOS's will load to 0x0000:0x7C00, Other will load load to
                      ; 0x07C0:0x0000. Far jump to fix this issue (reload CS to 0x0000).


boot16:            ; We are going to use the BIOS interrupt 0x10 (video services) to
    mov ah,0x0e     ; print chars to the screen. Like any interrupt we need to first load
    mov si,hello    ; its arguments into a few predetermined locations:
    xor al,al       ;   - Register ah = Operation.
loop:              ;   - Register al = ASCII character to print.
    mov al,[si]
    inc si
    or al,al
    jz halt
    int 0x10
    jmp loop
halt:
    cli
    hlt


hello: db "hello",0    ; Tell NASM to write a string literal and null terminator at this
                       ; location in memory (db = define byte).


times 510 - ($-$$) db 0    ; Tell NASM to fill in the rest of this 512 byte sector (except for
                           ; the last 2 bytes) with zeros (db - define byte).


dw 0xaa55    ; Tell NASM to write two bytes, this word at the end of the sector
             ; marks the sector as executable (dw = define word).
