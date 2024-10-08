ORG 0X7c00
BITS 16  ;This is used to tell the assembler that we are using 16 bit Code - "Assembler will only assemble instructions in 16 bits"
start:
    mov ah,0eh ; Command to print what is prfesent in present in al register on the screen.
    mov al,'A' ; Character to be printed on the screen should be present in al register
    int 0x10  ; for more info http://www.ctyme.com/intr/rb-0106.htm
    jmp $ ; this always jumps to itself

times 510-($ - $$) db 0 ; This command is used to fill atleast 510 bytes with 0 if our program uses 510 bytes this will not execute in any other case it will fill remaining bytes with 0
dw 0xAA55
; Doubt : if jmp $ jumps to itself creating a infinite loop how does last 2 instructions work.
; Resolution : Last 2 instructions are assembly directive which are executed during assembling so out boot sector would be of 512 bytes in assembling phase and while execution jmp $ would help not to execute last 2 commands