ORG 0
BITS 16
_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0x7c0:step2

handle_zero:
    mov ah,0eh
    mov bx,0x00
    mov al,'A'
    int 0x10
    iret
step2:
    cli ; clear interrupts to prevent any issues during boot
    mov ax, 0x7c0 ; set up the segment registers
    mov ds, ax
    mov es, ax
    mov ax,0x00
    mov ss, ax
    mov sp, 0x7c00 ; set up the stack
    sti ; enable interrupts after setup
    mov word[ss:0x00],handle_zero ; set the interrupt handler for interrupt 0
    mov word[ss:0x02],0x7c0 ; set the code segment for the interrupt handler

    mov ax,0x00
    div ax

    mov si, message
    call print
    jmp $
print:
    mov bx,0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    call print_char
    ret
print_char:
    mov ah, 0eh;
    int 0x10
    ret
    message db 'Hello, World!',0    
    times 510 - ($ - $$) db 0
    dw 0xAA55