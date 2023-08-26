bits 16
org 0x7c00


jmp 0x0000:boot16


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
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
global_descriptor_table_end:


TABLE_SIZE equ global_descriptor_table_end - global_descriptor_table_start
TABLE_OFFSET equ global_descriptor_table_start
CODE_ENTRY_OFFSET equ code_segment_descriptor_entry - global_descriptor_table_start
DATA_ENTRY_OFFSET equ data_segment_descriptor_entry - global_descriptor_table_start


global_descriptor_table_pointer:
    dw TABLE_SIZE
    dd TABLE_OFFSET


boot16:
    mov ax, 0x3
    int 0x10

    cli                                       ; 1) disable interrupts

    mov ax, 0x2401                            ; 2) enable A20 line
    int 0x15                                  ;

    lgdt [global_descriptor_table_pointer]    ; 3) load the gdt table

    mov eax, cr0                              ; 4) set the protected mode bit on special CPU reg cr0
    or eax,0x1                                ;
    mov cr0, eax                              ;

    jmp CODE_ENTRY_OFFSET:boot32              ; 5) long jump to the code segment


bits 32
boot32:
    mov ax, DATA_ENTRY_OFFSET                 ; 6) load data segment registers with valid selector
    mov ds, ax                                ;
    mov es, ax                                ;
    mov fs, ax                                ;
    mov gs, ax                                ;
    mov ss, ax                                ;

    mov esi,hello_string
    mov ebx,0xb8000
print_character_loop:
    lodsb
    or al,al
    jz halt
    or eax,0x0100
    mov word [ebx], ax
    add ebx,2
    jmp print_character_loop
halt:
    hlt
hello_string: db "Hello world!",0


times 510 - ($-$$) db 0
dw 0xaa55
