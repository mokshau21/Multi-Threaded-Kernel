ORG 0x7c00
BITS 16
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0:step2

step2:
    cli ; clear interrupts to prevent any issues during boot
    mov ax, 0x00 ; set up the segment registers
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00 ; set up the stack
    sti ; enable interrupts after setup
.load_protected:
    cli
    lgdt[gdt_descriptor] ;load the GDT
    mov eax, cr0
    or eax, 1 ; set the PE bit to enable protected mode
    mov cr0, eax
    jmp CODE_SEG:protected_mode_entry ; far jump to flush the instruction pipeline

;GDT
gdt_start:
gdt_null:
    dd 0x00; null descriptor
    dd 0x00; null descriptor
;offset = 0x08
gdt_code:    ; code segment descriptor
    dw 0xffff ; limit 0-15 bits
    dw 0 ; base 0-15 bits
    db 0 ; base 16-23 bits
    db 0x9a ; access byte: present, ring 0, code segment, executable, readable
    db 11001111b ; flags and high 4 bits of limit
    db 0 ; base 24-31 bits
;offset = 0x10
gdt_data:    ; data segment descriptor shouold be linked to DS, ES, FS, GS, SS
    dw 0xffff ; limit 0-15 bits
    dw 0 ; base 0-15 bits
    db 0 ; base 16-23 bits
    db 0x92 ; access byte: present, ring 0, data segment, writable
    db 11001111b ; flags and high 4 bits of limit
    db 0 ; base 24-31 bits
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size of GDT
    dd gdt_start ; offset of GDT

protyected_mode:
protected_mode_entry:
    mov ax, DATA_SEG ; set up data segment registers
    mov ds,ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax
    mov ebp,0x00200000 ; set up the stack pointer
    mov esp,ebp
    ;Enable the A20 line to access memory above 1MB
    in al, 0x92
    or al, 2
    out 0x92, al
    jmp $ ; infinite loop to prevent the CPU from executing random instructions

times 510 - ($ - $$) db 0
dw 0xAA55