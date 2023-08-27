; Tell NASM to we are now compiling 16-bit assembly.
bits 16

; The BIOS will load the drives first sector into memory at address 0x7C00.
; Tell NASM to generate machine code starting at address 0x7c00.
org 0x7c00

; Some BIOS's will load the first sector into memory at address 0x0000:0x7C00.
; Other will load the first sector into memory at address 0x07C0:0x0000.
; Far jump to fix this issue (reload CS to 0x0000).
jmp 0x0000:boot16

; Use NASM to write global descriptor table in memory.
global_descriptor_table_start:
null_segment_descriptor_entry:
    dw 0000000000000000b
    dw 0000000000000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
code_segment_descriptor_entry:
    dw 1111111111111111b
    dw 0000000000000000b
    db 00000000b
    db 10011010b
    db 11001111b
    db 00000000b
data_segment_descriptor_entry:
    dw 1111111111111111b
    dw 0000000000000000b
    db 00000000b
    db 10010010b
    db 11001111b
    db 00000000b
global_descriptor_table_end:

; Have NASM define a few useful values.
TABLE_SIZE equ global_descriptor_table_end - global_descriptor_table_start
TABLE_OFFSET equ global_descriptor_table_start
CODE_ENTRY_OFFSET equ code_segment_descriptor_entry - global_descriptor_table_start
DATA_ENTRY_OFFSET equ data_segment_descriptor_entry - global_descriptor_table_start

; Use NASM to write global descriptor table pointer in memory.
global_descriptor_table_pointer:
    dw TABLE_SIZE
    dd TABLE_OFFSET

; Use MASM to write hello string in memory.
hello_string:
    db "hello",0

boot16:
    ; Use BIOS interrupt to set VGA Test mode 3.
    mov ax, 0x3
    int 0x10

    ; (Config 32-bit Step 1) Disable interrupts.
    cli

    ; (Config 32-bit Step 2) Enable A20 line.
    mov ax, 0x2401
    int 0x15

    ; (Config 32-bit Step 3) load the gdt table.
    lgdt [global_descriptor_table_pointer]

    ; (Config 32-bit Step 4) Set the protected mode bit in cr0 register.
    mov eax, cr0
    or eax,0x1
    mov cr0, eax

    ; (Config 32-bit Step 5) long jump to the code segment.
    jmp CODE_ENTRY_OFFSET:boot32

; Tell NASM to we are now compiling 32-bit assembly.
bits 32

boot32:
    ; (Config 32-bit Step 6) load data segment registers with valid selector
    mov ax, DATA_ENTRY_OFFSET
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Init pointer to hello string.
    mov esi,hello_string

    ; Init pointer to VGA text buffer.
    mov edi,0xb8000

    ; Set in character color to white (second byte of EAX).
    mov ah,0xF

print_character_loop:
    ; load in character (first byte of EAX).
    mov al,[esi]

    ; If character if NULL then exit loop.
    or al,al
    jz halt

    ; Write to character data to VGA text buffer (first two bytes of EAX)
    mov [edi], ax

    ; Increment pointers to next character.
    add edi,0x2
    inc esi

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
