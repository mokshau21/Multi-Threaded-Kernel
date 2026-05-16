ORG 0
BITS 16
_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0x7c0:step2

step2:
    cli ; clear interrupts to prevent any issues during boot
    mov ax, 0x7c0 ; set up the segment registers
    mov ds, ax
    mov es, ax
    mov ax,0x00
    mov ss, ax
    mov sp, 0x7c00 ; set up the stack
    sti ; enable interrupts after setup
    mov ah,02h
    mov al,1
    mov ch,0
    mov cl,2
    mov dh,0
    mov bx,buffer
    int 0x13 ; BIOS interrupt to read from disk
    jc .disk_error ; if carry flag is set, there was an error
    mov si, buffer ; point SI to the buffer where the message is stored
    call print ; call the print function to display the message
    jmp $ ; infinite loop to prevent the system from doing anything else
.disk_error:
    mov si, disk_error_msg
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
disk_error_msg db 'Not able to read disk', 0
times 510 - ($ - $$) db 0
dw 0xAA55
buffer: