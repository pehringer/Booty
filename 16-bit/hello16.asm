; Tell NASM to we are now compiling 16-bit assembly.
bits 16

; The BIOS will load the drives first sector into memory at address 0x7C00.
; Tell NASM to generate machine code starting at address 0x7c00.
org 0x7c00

; Some BIOS's will load the first sector into memory at address 0x0000:0x7C00.
; Other will load the first sector into memory at address 0x07C0:0x0000.
; Far jump to fix this issue (reload CS to 0x0000).
jmp 0x0000:boot16

; Use MASM to write hello string in memory.
hello_string:
    db "hello",0



; We are going to use the BIOS interrupt 0x10 (video services) to
; print chars to the screen. Like any interrupt we need to first load
; its arguments into a few predetermined locations:
;   - Register ah = Operation.
;   - Register al = ASCII character to print.



boot16:
    ; Use for BIOS interrupt (print ASCII character, second byte of AX).
    mov ah,0x0E

    ; Init pointer to hello string.
    mov si,hello_string

print_character_loop:
    ; load in character (first byte of AX)
    mov al,[si]

    ; If character if NULL then exit loop.
    or al,al
    jz halt

    ; Call BIOS interrupt to wrtie character to screen.
    int 0x10

    ; Increment pointer to next character.
    inc si

    ; Loop again.
    jmp print_character_loop

halt:
    ; Disable interrupts and halt.
    cli
    hlt

; Use NASM to fill in the rest of this 512 byte sector (except for the last 2
; bytes) with zeros.
times 510 - ($-$$) db 0

; Use NASM to write two bytes, this word at the end of the sector marks the
; sector as executable.
dw 0xaa55
